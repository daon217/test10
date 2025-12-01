package edu.sm.app.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ClothesRecommendResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service that analyzes a pet image and recommends clothing size, type, and
 * generates a virtual fitting image.
 */
@Service
@Slf4j
public class ClothesRecommendService {

    private static final String PLACEHOLDER_IMAGE = "/images/virtual-fitting-placeholder.png";
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final RestTemplate restTemplate;

    @Value("${spring.ai.nanobanana.api-key}")
    private String nanoBananaApiKey;

    @Value("${spring.ai.nanobanana.base-url}")
    private String nanoBananaBaseUrl;

    @Value("${spring.ai.nanobanana.model}")
    private String nanoBananaModel;

    public ClothesRecommendService(ChatModel chatModel, ObjectMapper objectMapper) {
        this.chatClient = ChatClient.builder(chatModel).build();
        this.objectMapper = objectMapper;
        this.restTemplate = new RestTemplate();
    }

    /**
     * Main entry point: analyze image, extract data, and generate virtual fitting.
     */
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
                log.warn("Attachment missing content type.");
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
            // Call text AI
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
            String visualFeatures = asText(parsed, "visualFeatures", "");

            // Generate virtual fitting image
            String virtualFittingUrl = tryGenerateVirtualFittingWithNanoBanana(animalType, clothingType,
                    recommendedSize, visualFeatures, palette, imageBytes);

            if (StringUtils.hasText(virtualFittingUrl)) {
                fittingImageUrl = virtualFittingUrl;
                if (virtualFittingUrl.startsWith("data:image")) {
                    fittingImageDesc = "AI 가상 피팅 이미지";
                } else if (virtualFittingUrl.startsWith("ERROR:")) {
                    fittingImageDesc = virtualFittingUrl; // 에러 메시지를 설명에 잠시 노출 (디버깅용)
                    fittingImageUrl = PLACEHOLDER_IMAGE;
                } else {
                    fittingImageDesc = "AI 생성 가상 피팅 (유사 이미지)";
                }
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

    /**
     * Extract color palette from parsed JSON
     */
    private List<String> extractPalette(Map<String, Object> parsed) {
        Object raw = parsed.get("colorPalette");
        if (raw instanceof List<?> list && !list.isEmpty()) {
            return list.stream().map(Object::toString).toList();
        }
        return List.of("#9aa5b1", "#c9d1d9", "#6b7280");
    }

    /**
     * Helper to safely get a string value from map
     */
    private String asText(Map<String, Object> map, String key, String defaultValue) {
        Object val = map.get(key);
        if (val == null)
            return defaultValue;
        String txt = String.valueOf(val).trim();
        if (!StringUtils.hasText(txt))
            return defaultValue;
        return txt;
    }

    /**
     * Parse AI response with retry on JSON errors
     */
    private Map<String, Object> parseAiResponseWithRetry(Media media, String animalHint, String aiResponse) {
        try {
            return parseAiResponse(aiResponse);
        } catch (JsonProcessingException e) {
            log.warn("Failed to parse AI response, retrying with lenient prompt.", e);
            String retryResponse = callAi(media, animalHint, true);
            return parseAiResponseLenient(retryResponse, aiResponse);
        }
    }

    /**
     * Call the text AI model
     */
    private String callAi(Media media, String animalHint, boolean lenient) {
        String system = lenient
                ? "당신은 반려동물 의류 스타일리스트입니다. 이미지를 분석하여 한국어로 상세한 추천 결과를 제공하세요. 응답은 반드시 JSON 형식이어야 하며, 필드 이름과 값은 정확히 지켜주세요. JSON 파싱 오류를 최소화하기 위해 간결하게 답변해주세요."
                : "당신은 반려동물 의류 스타일리스트입니다. 이미지를 분석하여 한국어로 상세한 추천 결과를 제공하세요.";
        String user = animalHint + " 이 반려동물 사진을 정밀하게 분석해주세요. 다음 키를 가진 JSON 객체를 반환하세요: "
                + "animalType(반려동물 품종, 예: '말티즈', '골든 리트리버' 등 구체적인 한국어 명칭), "
                + "backLength(등길이, cm 단위, 예: '약 20cm'), "
                + "chestGirth(가슴둘레, cm 단위, 예: '약 30cm'), "
                + "neckGirth(목둘레, cm 단위, 예: '약 20cm'), "
                + "recommendedSize(권장 사이즈, 예: XS, S, M, L, XL), "
                + "clothingType(추천 의류 종류, 예: '스웨터', '패딩', '티셔츠' 등 한국어), "
                + "colorAnalysis(퍼스널 컬러 분석, 한국어 서술), "
                + "colorPalette(어울리는 색상 코드 리스트, 예: ['#FF0000', '#00FF00']), "
                + "visualFeatures(외모 특징에 대한 상세한 한국어 묘사). "
                + "모든 텍스트 값은 반드시 **한국어**로 작성되어야 합니다.";
        return chatClient.prompt()
                .system(system)
                .user(u -> u.text(user).media(media))
                .call()
                .content();
    }

    /**
     * Parse JSON response into a typed map
     */
    private Map<String, Object> parseAiResponse(String response) throws JsonProcessingException {
        String json = response.trim();
        if (json.startsWith("```json"))
            json = json.substring(7);
        if (json.startsWith("```"))
            json = json.substring(3);
        if (json.endsWith("```"))
            json = json.substring(0, json.length() - 3);
        return objectMapper.readValue(json, new TypeReference<Map<String, Object>>() {
        });
    }

    /**
     * Lenient parsing fallback
     */
    private Map<String, Object> parseAiResponseLenient(String retryResponse, String originalResponse) {
        try {
            return parseAiResponse(retryResponse);
        } catch (JsonProcessingException e) {
            return Map.of("colorAnalysis", safeText(originalResponse));
        }
    }

    private String safeText(String text) {
        return text != null ? text : "";
    }

    /**
     * Generate virtual fitting image via NanoBanana API (Modified for Fix)
     */
    private String tryGenerateVirtualFittingWithNanoBanana(String animalType, String clothingType,
                                                           String recommendedSize,
                                                           String visualFeatures, List<String> palette, byte[] imageBytes) {
        try {
            if (!StringUtils.hasText(nanoBananaApiKey)) {
                return "ERROR: API Key is missing";
            }
            String baseUrl = StringUtils.hasText(nanoBananaBaseUrl) && !nanoBananaBaseUrl.contains("nanobanana.ai")
                    ? nanoBananaBaseUrl
                    : "[https://generativelanguage.googleapis.com](https://generativelanguage.googleapis.com)";

            // Default model fallback if not specified
            String modelName = StringUtils.hasText(nanoBananaModel) ? nanoBananaModel : "gemini-2.5-flash-image";

            // [Fix 1] Use v1beta instead of v1
            String url = baseUrl + "/v1beta/models/" + modelName + ":generateContent?key=" + nanoBananaApiKey;

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // Build prompt
            String prompt = buildVirtualFittingPrompt(animalType, visualFeatures, clothingType, recommendedSize,
                    palette);

            Map<String, Object> textPart = new HashMap<>();
            textPart.put("text", prompt);

            Map<String, Object> inlineData = new HashMap<>();
            inlineData.put("mime_type", "image/png");
            inlineData.put("data", Base64.getEncoder().encodeToString(imageBytes));
            Map<String, Object> imagePart = new HashMap<>();
            imagePart.put("inline_data", inlineData);

            Map<String, Object> content = new HashMap<>();
            content.put("parts", List.of(textPart, imagePart));

            Map<String, Object> generationConfig = new HashMap<>();
            // [Fix 2] Remove responseMimeType (caused 400 error)
            // generationConfig.put("responseMimeType", "image/png");

            // [Fix 3] Add responseModalities to request IMAGE output
            generationConfig.put("responseModalities", List.of("IMAGE"));

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("contents", List.of(content));
            requestBody.put("generationConfig", generationConfig);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Map<String, Object> body = response.getBody();
                if (body.containsKey("candidates")) {
                    List<Map<String, Object>> candidates = (List<Map<String, Object>>) body.get("candidates");
                    if (!candidates.isEmpty()) {
                        Map<String, Object> candidate = candidates.get(0);
                        if (candidate.containsKey("content")) {
                            Map<String, Object> contentResp = (Map<String, Object>) candidate.get("content");
                            if (contentResp.containsKey("parts")) {
                                List<Map<String, Object>> parts = (List<Map<String, Object>>) contentResp.get("parts");
                                for (Map<String, Object> part : parts) {
                                    Map<String, Object> inline = null;
                                    // Handle both snake_case and camelCase keys just in case
                                    if (part.containsKey("inline_data")) {
                                        inline = (Map<String, Object>) part.get("inline_data");
                                    } else if (part.containsKey("inlineData")) {
                                        inline = (Map<String, Object>) part.get("inlineData");
                                    }

                                    if (inline != null) {
                                        String b64 = (String) inline.get("data");
                                        if (StringUtils.hasText(b64)) {
                                            return "data:image/png;base64," + b64;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                return "ERROR: No image in response: " + body;
            } else {
                return "ERROR: Status " + response.getStatusCode() + " Body: " + response.getBody();
            }
        } catch (Exception e) {
            return "ERROR: API Call Failed: " + e.getMessage();
        }
    }

    /**
     * Build the prompt for virtual fitting generation
     */
    private String buildVirtualFittingPrompt(String animalType, String visualFeatures, String clothingType,
                                             String recommendedSize, List<String> palette) {
        String paletteText = (palette == null || palette.isEmpty()) ? "부드러운 중성 컬러" : String.join(", ", palette);
        String safeClothing = StringUtils.hasText(clothingType) && !"N/A".equalsIgnoreCase(clothingType) ? clothingType
                : "편안한 펫 의류";
        String safeSize = StringUtils.hasText(recommendedSize) && !"N/A".equalsIgnoreCase(recommendedSize)
                ? recommendedSize
                : "표준 사이즈";
        String safeAnimal = StringUtils.hasText(animalType) && !"분석 실패".equals(animalType) ? animalType : "반려동물";
        String identityInstruction = "**제공된 이미지 속 반려동물**이 이 옷을 입고 있는 모습을 생성하세요. "
                + "반려동물의 얼굴, 표정, 자세, 털 무늬, 체형은 **원본 이미지와 100% 동일하게** 유지되어야 합니다. "
                + "새로운 동물을 생성하지 말고, 원본 이미지의 동물을 그대로 사용하세요.";
        String fittingInstruction = safeAnimal + "에게 " + safeClothing + "(사이즈: " + safeSize + ")를 입혀주세요. "
                + "옷은 반려동물의 몸에 자연스럽게 맞아야 하며, " + paletteText + " 계열의 색상을 사용하세요.";
        String backgroundInstruction = "배경은 원본 이미지의 분위기를 유지하거나, 깔끔한 흰색 배경으로 처리하세요.";
        String noTextInstruction = "**이미지 내에 글자, 텍스트, 라벨, 워터마크를 절대 포함하지 마십시오.**";
        return identityInstruction + " " + fittingInstruction + " " + backgroundInstruction + " " + noTextInstruction;
    }
}