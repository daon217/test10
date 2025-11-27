package edu.sm.app.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ClothesRecommendResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Map;

/**
 * 업로드된 반려동물 전신 사진을 AI 모델로 분석해 사이즈와 컬러를 추천합니다.
 */
@Service
@Slf4j
public class ClothesRecommendService {

    private static final String PLACEHOLDER_IMAGE = "/images/virtual-fitting-placeholder.png";
    private final ChatClient chatClient;
    private final ImageModel imageModel;
    private final ObjectMapper objectMapper;

    public ClothesRecommendService(ChatModel chatModel, ObjectProvider<ImageModel> imageModelProvider, ObjectMapper objectMapper) {
        this.chatClient = ChatClient.builder(chatModel).build();
        this.imageModel = imageModelProvider.getIfAvailable();
        this.objectMapper = objectMapper;
    }

    // [수정] explicitAnimalType 파라미터 추가
    public ClothesRecommendResult analyzeAndRecommend(MultipartFile attach, String explicitAnimalType) {
        ClothesRecommendResult fallback = ClothesRecommendResult.builder()
                .animalType("분석 실패")
                .backLength("N/A")
                .chestGirth("N/A")
                .neckGirth("N/A")
                .recommendedSize("N/A")
                .clothingType("N/A")
                .colorAnalysis("이미지 분석에 실패했습니다. 사진이 맞는지 확인 후 다시 시도해주세요.")
                .fittingImageDesc("AI가 가상 피팅 이미지를 준비하지 못했습니다.")
                .fittingImageUrl(PLACEHOLDER_IMAGE)
                .colorPalette(List.of("#9aa5b1", "#c9d1d9", "#6b7280"))
                .build();

        try {
            if (attach == null || attach.isEmpty()) {
                log.warn("Empty attachment received for clothes recommendation.");
                return fallback;
            }

            String contentType = attach.getContentType();
            if (!StringUtils.hasText(contentType)) {
                log.warn("Attachment missing content type for clothes recommendation.");
                return fallback;
            }

            byte[] imageBytes = attach.getBytes();

            String animalHint = StringUtils.hasText(explicitAnimalType)
                    ? "사용자가 알려준 반려동물 종류: " + explicitAnimalType
                    : "사용자가 종류를 따로 적지 않았습니다. 사진만 보고 추정하세요.";

            Media media = Media.builder()
                    .mimeType(MimeType.valueOf(contentType))
                    .data(new ByteArrayResource(imageBytes))
                    .build();

            String aiResponse = callAi(media, animalHint, false);

            Map<String, Object> parsed = parseAiResponseWithRetry(media, animalHint, aiResponse);

            List<String> palette = extractPalette(parsed);

            String animalType = asText(parsed, "animalType", "분석 실패");
            String backLength = asText(parsed, "backLength", "N/A");
            String chestGirth = asText(parsed, "chestGirth", "N/A");
            String neckGirth = asText(parsed, "neckGirth", "N/A");
            String recommendedSize = asText(parsed, "recommendedSize", "N/A");
            String clothingType = asText(parsed, "clothingType", "N/A");
            String colorAnalysis = asText(parsed, "colorAnalysis", "분석 결과를 불러오지 못했습니다.");
            String fittingImageDesc = asText(parsed, "fittingImageDesc", "AI가 준비한 가상 피팅 설명입니다.");
            String fittingImageUrl = asText(parsed, "fittingImageUrl", PLACEHOLDER_IMAGE);

            // [수정] animalType을 createVirtualFitting에 전달
            String virtualFittingUrl = createVirtualFitting(imageBytes, animalType, clothingType, recommendedSize, palette);
            if (StringUtils.hasText(virtualFittingUrl)) {
                fittingImageUrl = virtualFittingUrl;
                // [수정]: 이미지가 성공적으로 생성되면, 설명 텍스트를 "ai이미지"로 변경합니다.
                fittingImageDesc = "ai이미지";
            }

            return ClothesRecommendResult.builder()
                    .animalType(animalType)
                    .backLength(backLength)
                    .chestGirth(chestGirth)
                    .neckGirth(neckGirth)
                    .recommendedSize(recommendedSize)
                    .clothingType(clothingType)
                    .colorAnalysis(colorAnalysis)
                    .fittingImageDesc(fittingImageDesc)
                    .fittingImageUrl(fittingImageUrl)
                    .colorPalette(palette)
                    .build();
        } catch (Exception e) {
            log.error("Failed to analyze image for clothes recommendation", e);
            return fallback;
        }
    }

    private List<String> extractPalette(Map<String, Object> parsed) {
        Object rawPalette = parsed.get("colorPalette");
        if (rawPalette instanceof List<?> list && !list.isEmpty()) {
            return list.stream()
                    .map(String::valueOf)
                    .toList();
        }
        return List.of("#9aa5b1", "#c9d1d9", "#6b7280");
    }

    private String asText(Map<String, Object> parsed, String key, String defaultValue) {
        Object value = parsed.get(key);
        if (value == null) {
            return defaultValue;
        }

        String text = String.valueOf(value).trim();
        if (!StringUtils.hasText(text)) {
            return defaultValue;
        }

        if ("fittingImageUrl".equals(key) && "PLACEHOLDER".equalsIgnoreCase(text)) {
            return PLACEHOLDER_IMAGE;
        }

        return text;
    }

    // [수정] animalType 파라미터 추가
    private String createVirtualFitting(byte[] imageBytes, String animalType, String clothingType, String recommendedSize, List<String> palette) {
        if (imageBytes == null || imageBytes.length == 0) {
            return null;
        }

        // [수정] animalType을 buildVirtualFittingPrompt에 전달
        String prompt = buildVirtualFittingPrompt(animalType, clothingType, recommendedSize, palette);
        String aiGenerated = tryGenerateVirtualFittingWithAi(prompt);
        if (StringUtils.hasText(aiGenerated)) {
            return aiGenerated;
        }

        // [수정] animalType을 renderVirtualFittingOverlay에 전달
        return renderVirtualFittingOverlay(imageBytes, animalType, clothingType, recommendedSize, palette);
    }

    // [수정] animalType 파라미터 추가 및 로직 수정 (종/색상 유지 및 배경 제거를 강력하게 요청)
    private String buildVirtualFittingPrompt(String animalType, String clothingType, String recommendedSize, List<String> palette) {
        String paletteText = (palette == null || palette.isEmpty()) ? "부드러운 중성 컬러" : String.join(", ", palette);
        String safeClothing = StringUtils.hasText(clothingType) && !"N/A".equalsIgnoreCase(clothingType)
                ? clothingType
                : "편안한 펫 의류"; // Fallback을 "편안한 펫 의류"로 변경

        String safeSize = StringUtils.hasText(recommendedSize) && !"N/A".equalsIgnoreCase(recommendedSize)
                ? recommendedSize
                : "표준 사이즈";

        // AI가 분석한 종을 명시적으로 사용
        String safeAnimal = StringUtils.hasText(animalType) && !"분석 실패".equals(animalType)
                ? animalType
                : "반려동물";

        // [핵심 수정 1]: 옷의 스타일을 클래식하고 기능적으로 변경
        String styleInstruction = "옷은 반려동물의 편안함과 기능성에 초점을 맞춘 **클래식하고 깔끔한 디자인**으로 연출해 주세요. **과도한 레이어링, 사람 옷 같은 복잡한 디테일, 불필요한 장식(모자, 스카프, 과장된 액세서리)** 등은 피하고, 실제 펫 의류처럼 보이게 합니다.";

        // [핵심 수정 2]: 배경 제거/단색 배경을 강력하게 요청
        String backgroundInstruction = "배경은 불필요한 요소 없이 순수한 흰색 스튜디오 배경으로 처리하여 동물이 돋보이게 합니다. 배경을 투명하게 하거나, 피팅룸이나 복잡한 환경은 절대 넣지 마세요.";

        // [핵심 수정 3]: 종/색상 유지를 강력하게 강제하는 프롬프트 (가장 강력한 지시)
        String identityInstruction = "업로드된 반려동물 사진을 픽셀 단위로 분석하십시오. 당신은 이 동물이 **'" + safeAnimal + "'** 임을 완벽하게 이해해야 합니다. 해당 동물의 **특정 종, 털의 색상 및 패턴, 얼굴 표정, 체형**을 어떤 오차도 없이 **100% 동일하게** 구현하십시오. 다른 종이나 색깔로 변형하는 것은 **절대 금지**입니다. 이 지시를 최우선으로 지키세요.";

        // [핵심 수정 4]: 동물이 옷을 입는 행위를 명확히 지시하고, 옷 위에 동물을 프린트하는 것을 금지
        String fittingActionInstruction = "반드시 '" + safeAnimal + "'이(가) 이 옷을 **실제로 입고 있는 모습**을 렌더링해야 합니다. 옷에 " + safeAnimal + "의 이미지를 **프린팅하는 방식으로 만들지 마십시오**. 마치 실제로 입혀 놓은 것처럼 자연스럽게 표현해야 합니다.";

        // [핵심 수정 5]: 이미지에 텍스트를 포함하지 않도록 명시적으로 지시 (극단적 강화)
        String noTextInImageInstruction = "**경고: 이미지 생성 결과물에는 절대로(NEVER) 글자, 텍스트, 라벨, 워터마크, 제목, 한국어 문자, 어떠한 설명 문구도 시각적으로 포함하지 마십시오. 특히 '업로드한 사진에 추천 의상을 합성한 AI 가상 피팅 미리보기'와 같은 주석은 절대 금지합니다.**";

        // [핵심 수정 6]: 불필요한 UI/데이터 시각화 요소 제거 (컬러 블록, 측정값 방지)
        String noUiElementsInstruction = "이미지 내에 **컬러 팔레트, 색상 블록, 측정값, 치수, UI 인터페이스 요소, 프레임, 캔버스 배경**을 넣지 마십시오. 오직 반려동물의 가상 피팅 결과만 중앙에 위치해야 합니다.";


        return identityInstruction + " "
                + safeAnimal + "에게 " + safeClothing + "를 " + safeSize + " 사이즈로 자연스럽게 입힌 가상 피팅 이미지를 실사 톤으로 렌더링하세요. "
                + fittingActionInstruction + " "
                + styleInstruction + " " // 수정된 스타일 지침 적용
                + backgroundInstruction + " "
                + noTextInImageInstruction + " "
                + noUiElementsInstruction
                + " 의류 색상은 추천 팔레트(" + paletteText + ") 중 잘 어울리는 조합을 사용합니다.";
    }

    private String tryGenerateVirtualFittingWithAi(String prompt) {
        if (imageModel == null) {
            return null;
        }
        try {
            ImageResponse response = imageModel.call(new ImagePrompt(prompt));
            if (response == null) {
                return null;
            }

            if (response.getResult() != null && response.getResult().getOutput() != null) {
                String url = response.getResult().getOutput().getUrl();
                if (StringUtils.hasText(url)) {
                    return url;
                }
                String b64 = response.getResult().getOutput().getB64Json();
                if (StringUtils.hasText(b64)) {
                    return "data:image/png;base64," + b64;
                }
            }

            if (response.getResults() != null && !response.getResults().isEmpty() && response.getResults().get(0).getOutput() != null) {
                String url = response.getResults().get(0).getOutput().getUrl();
                if (StringUtils.hasText(url)) {
                    return url;
                }
                String b64 = response.getResults().get(0).getOutput().getB64Json();
                if (StringUtils.hasText(b64)) {
                    return "data:image/png;base64," + b64;
                }
            }
        } catch (Exception e) {
            log.warn("AI image model failed to synthesize virtual fitting image. Falling back to overlay preview.", e);
        }

        return null;
    }

    // [수정] animalType 파라미터 추가
    private String renderVirtualFittingOverlay(byte[] imageBytes, String animalType, String clothingType, String recommendedSize, List<String> palette) {
        try {
            BufferedImage original = ImageIO.read(new ByteArrayInputStream(imageBytes));
            if (original == null) {
                return null;
            }

            int width = original.getWidth();
            int height = original.getHeight();
            BufferedImage canvas = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g2d = canvas.createGraphics();
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.drawImage(original, 0, 0, null);

            int overlayHeight = Math.max(height / 4, 160);
            int overlayY = height - overlayHeight - 24;
            g2d.setColor(new Color(0, 0, 0, 170));
            g2d.fillRoundRect(16, overlayY, width - 32, overlayHeight, 20, 20);

            int titleFontSize = Math.max(18, width / 28);
            int bodyFontSize = Math.max(16, width / 32);
            g2d.setColor(Color.WHITE);
            g2d.setFont(new Font("SansSerif", Font.BOLD, titleFontSize));

            String safeClothing = StringUtils.hasText(clothingType) && !"N/A".equalsIgnoreCase(clothingType)
                    ? clothingType
                    : "AI 추천 의상";
            g2d.drawString("가상 피팅: " + safeClothing, 32, overlayY + 42);

            g2d.setFont(new Font("SansSerif", Font.PLAIN, bodyFontSize));
            g2d.drawString("권장 사이즈: " + (StringUtils.hasText(recommendedSize) ? recommendedSize : "표준"), 32, overlayY + 74);
            g2d.drawString("추천 팔레트:", 32, overlayY + 106);

            int swatchSize = Math.max(32, width / 25);
            int swatchX = 32;
            int swatchY = overlayY + 120;
            List<String> paletteToUse = (palette == null || palette.isEmpty())
                    ? List.of("#9aa5b1", "#c9d1d9", "#6b7280")
                    : palette;

            for (String hex : paletteToUse.stream().limit(5).toList()) {
                g2d.setColor(decodeColor(hex));
                g2d.fillRoundRect(swatchX, swatchY, swatchSize, swatchSize, 10, 10);
                g2d.setColor(Color.WHITE);
                g2d.drawRoundRect(swatchX, swatchY, swatchSize, swatchSize, 10, 10);
                swatchX += swatchSize + 12;
            }

            g2d.dispose();

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(canvas, "png", baos);
            String base64 = Base64.getEncoder().encodeToString(baos.toByteArray());
            return "data:image/png;base64," + base64;
        } catch (Exception e) {
            log.warn("Failed to render virtual fitting overlay.", e);
            return null;
        }
    }

    private Color decodeColor(String hex) {
        try {
            if (!StringUtils.hasText(hex)) {
                return new Color(255, 255, 255, 180);
            }
            String normalized = hex.startsWith("#") ? hex : "#" + hex;
            return Color.decode(normalized);
        } catch (Exception e) {
            return new Color(255, 255, 255, 180);
        }
    }

    private Map<String, Object> parseAiResponseWithRetry(Media media, String animalHint, String aiResponse) {
        try {
            return parseAiResponse(aiResponse);
        } catch (JsonProcessingException primary) {
            log.warn("Primary AI response was not valid JSON. Retrying with a JSON-only instruction.", primary);
            try {
                String retryResponse = callAi(media, animalHint, true);
                return parseAiResponseLenient(retryResponse, aiResponse);
            } catch (Exception retryError) {
                log.error("Retry AI response still failed to parse. Returning textual fallback.", retryError);
                return Map.of("colorAnalysis", safeText(aiResponse));
            }
        }
    }

    private String callAi(Media media, String animalHint, boolean jsonOnly) {
        SystemMessage systemMessage = SystemMessage.builder()
                .text("""
                        당신은 반려동물 패션 스타일리스트입니다. 업로드된 반려동물 전신 사진을 분석해 아래 JSON 형식으로만 답하세요.
                        필수 키: animalType, backLength, chestGirth, neckGirth, recommendedSize, clothingType,
                        colorAnalysis, fittingImageDesc, fittingImageUrl, colorPalette.
                        - 길이는 cm 단위로 한 자리 소수점 이내 숫자와 단위를 함께 적습니다. 예: "38.2 cm"
                        - recommendedSize는 XXS/XS/S/M/L/XL 같은 의류 사이즈 문자열을 사용합니다.
                        - colorPalette는 대표 색상 3~5개 HEX 코드 배열로 제공합니다.
                        - animalType은 반려동물의 '종류', '종(Breed)', '주요 특징(털 색깔/패턴)'을 상세히 포함하여 작성해야 합니다. 예: '골든 리트리버 (금색)', '삼색 코리안 숏헤어 고양이'
                        - fittingImageUrl은 외부 이미지를 생성하지 말고 PLACEHOLDER를 유지하세요.
                        - 사진은 여러개를 만들지 않고 꼭 하나만 만들어.
                        - 모든 텍스트 값(animalType, clothingType, colorAnalysis, fittingImageDesc 등)은 자연스럽고 명확한 한국어로 작성하세요.
                        - 추가 설명 없이 반드시 JSON만 반환하세요.
                        """)
                .build();

        UserMessage userMessage = UserMessage.builder()
                .text("반려동물 옷 사이즈와 어울리는 색을 추천해주세요. " + animalHint)
                .media(media)
                .build();

        if (jsonOnly) {
            UserMessage reinforceJson = UserMessage.builder()
                    .text("위 질문에 대해 오직 하나의 JSON 객체로만 응답하세요. 모든 텍스트 값은 한국어로 작성합니다. 추가 문구와 마크다운, 설명, 코드펜스는 모두 금지입니다. 필수 키를 모두 포함하세요.")
                    .build();

            return chatClient.prompt()
                    .messages(systemMessage, userMessage, reinforceJson)
                    .call()
                    .content();
        }

        return chatClient.prompt()
                .messages(systemMessage, userMessage)
                .call()
                .content();
    }

    private Map<String, Object> parseAiResponseLenient(String aiResponse, String fallbackText) throws JsonProcessingException {
        if (!StringUtils.hasText(aiResponse)) {
            throw new JsonProcessingException("Empty AI response") {};
        }

        try {
            return objectMapper.readValue(aiResponse, new TypeReference<>() {});
        } catch (JsonProcessingException primary) {
            String extracted = extractJsonSnippet(aiResponse);
            if (StringUtils.hasText(extracted)) {
                log.warn("AI response contained extra text; attempting to parse extracted JSON snippet.");
                return objectMapper.readValue(extracted, new TypeReference<>() {});
            }
            log.warn("AI response was not JSON even after extraction. Using textual fallback for color analysis only.");
            return Map.of("colorAnalysis", safeText(fallbackText));
        }
    }

    private Map<String, Object> parseAiResponse(String aiResponse) throws JsonProcessingException {
        if (!StringUtils.hasText(aiResponse)) {
            throw new JsonProcessingException("Empty AI response") {};
        }

        return objectMapper.readValue(aiResponse, new TypeReference<>() {});
    }

    private String extractJsonSnippet(String aiResponse) {
        // Try fenced code block first
        int fenceStart = aiResponse.indexOf("```");
        int jsonStart = aiResponse.indexOf('{', fenceStart >= 0 ? fenceStart : 0);
        int jsonEnd = aiResponse.lastIndexOf('}');

        if (jsonStart >= 0 && jsonEnd > jsonStart) {
            return aiResponse.substring(jsonStart, jsonEnd + 1).trim();
        }

        return null;
    }

    private String safeText(String raw) {
        if (!StringUtils.hasText(raw)) {
            return "분석 결과를 불러오지 못했습니다.";
        }
        return raw.trim();
    }
}