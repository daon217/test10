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

            String virtualFittingUrl = createVirtualFitting(imageBytes, clothingType, recommendedSize, palette);
            if (StringUtils.hasText(virtualFittingUrl)) {
                fittingImageUrl = virtualFittingUrl;
                fittingImageDesc = "업로드한 사진에 추천 의상을 합성한 AI 가상 피팅 미리보기입니다.";
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

    private String createVirtualFitting(byte[] imageBytes, String clothingType, String recommendedSize, List<String> palette) {
        if (imageBytes == null || imageBytes.length == 0) {
            return null;
        }

        String prompt = buildVirtualFittingPrompt(clothingType, recommendedSize, palette);
        String aiGenerated = tryGenerateVirtualFittingWithAi(prompt);
        if (StringUtils.hasText(aiGenerated)) {
            return aiGenerated;
        }

        return renderVirtualFittingOverlay(imageBytes, clothingType, recommendedSize, palette);
    }

    private String buildVirtualFittingPrompt(String clothingType, String recommendedSize, List<String> palette) {
        String paletteText = (palette == null || palette.isEmpty()) ? "부드러운 중성 컬러" : String.join(", ", palette);
        String safeClothing = StringUtils.hasText(clothingType) && !"N/A".equalsIgnoreCase(clothingType)
                ? clothingType
                : "편안한 기본 의상";
        String safeSize = StringUtils.hasText(recommendedSize) && !"N/A".equalsIgnoreCase(recommendedSize)
                ? recommendedSize
                : "표준 사이즈";

        return "업로드된 반려동물 전신 사진을 기준으로, " + safeClothing + "를 " + safeSize
                + " 사이즈로 자연스럽게 입힌 가상 피팅 이미지를 만들어주세요. "
                + " 업로드된 사진을 분석해서 강아지면 강아지 고양이면 고양이 사진으로 만들어줘. 꼭 무슨 종인지 판단하고 만들어줘. "
                + " 업로드된 사진을 분석했을때 고양이면 고양이 사진만 만들고 다른 동물의 사진은 만들지 마. "
                + " 업로드된 사진을 분석했을때 강아지면 강아지 사진만 만들고 다른 동물의 사진은 만들지 마."
                + " 업로드 된 사진에 동물의 색을 분석해서 같은색 동물의 이미지를 만들어줘. "
                + "동물의 표정, 체형, 털색을 원본과 동일하게 유지하고, 실사 톤으로 렌더링하세요. "
                + "의류 색상은 추천 팔레트(" + paletteText + ") 중 잘 어울리는 조합을 사용합니다. 배경은 원본과 유사하게 깔끔하게 유지합니다.";
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

    private String renderVirtualFittingOverlay(byte[] imageBytes, String clothingType, String recommendedSize, List<String> palette) {
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
                        - 길이는 cm 단위로 한 자리 소수점 이내 숫자와 단위를 함께 적습니다. 예) "38.2 cm"
                        - recommendedSize는 XXS/XS/S/M/L/XL 같은 의류 사이즈 문자열을 사용합니다.
                        - colorPalette는 대표 색상 3~5개 HEX 코드 배열로 제공합니다.
                        - 사진의 동물의 종과 색을 구분해서 이미지를 만들때 종과 색을 맞춰서 만들어.
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