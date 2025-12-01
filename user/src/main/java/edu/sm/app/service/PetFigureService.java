package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class PetFigureService {

    private final RestTemplate restTemplate;

    @Value("${spring.ai.nanobanana.api-key}")
    private String nanoBananaApiKey;

    @Value("${spring.ai.nanobanana.base-url}")
    private String nanoBananaBaseUrl;

    @Value("${spring.ai.nanobanana.model}")
    private String nanoBananaModel;

    public PetFigureService() {
        this.restTemplate = new RestTemplate();
    }

    public String generateFigure(MultipartFile attach, String customPrompt) {
        try {
            if (attach == null || attach.isEmpty()) {
                return "ERROR: Empty file";
            }

            byte[] imageBytes = attach.getBytes();

            if (!StringUtils.hasText(nanoBananaApiKey)) {
                return "ERROR: API Key is missing";
            }

            // 1. Validate if it's an animal
            if (!isAnimal(imageBytes)) {
                return "ERROR: 반려동물 사진이 아닙니다. 강아지, 고양이 등의 동물 사진을 올려주세요.";
            }

            // 2. Generate Figure
            String baseUrl = StringUtils.hasText(nanoBananaBaseUrl) && !nanoBananaBaseUrl.contains("nanobanana.ai")
                    ? nanoBananaBaseUrl
                    : "https://generativelanguage.googleapis.com";

            String modelName = StringUtils.hasText(nanoBananaModel) ? nanoBananaModel : "gemini-2.5-flash-image";

            String url = baseUrl + "/v1beta/models/" + modelName + ":generateContent?key=" + nanoBananaApiKey;

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // Prompt for creating a figure/cutout
            StringBuilder promptBuilder = new StringBuilder();
            promptBuilder.append("이 반려동물 사진을 바탕으로 '2D 피규어' 스타일의 이미지를 생성해주세요. ");
            promptBuilder.append("배경은 투명하거나 아주 깔끔한 흰색이어야 하며, 나중에 오려내기 쉽도록 외곽선이 뚜렷하면 좋습니다. ");
            promptBuilder.append("반려동물의 특징(털 색, 무늬, 표정)을 그대로 유지하면서, 귀엽고 약간은 장난감 같은 느낌의 2D 아트워크로 변환해주세요. ");
            promptBuilder.append("전신이 다 나와야 하며, 발판이나 스탠드 없이 캐릭터만 깔끔하게 생성해주세요. ");

            if (StringUtils.hasText(customPrompt)) {
                promptBuilder.append("\n\n[사용자 추가 요청사항]: ").append(customPrompt);
                promptBuilder.append("\n위 사용자 요청사항을 최대한 반영하여 피규어를 디자인해주세요.");
            }

            String prompt = promptBuilder.toString();

            Map<String, Object> textPart = new HashMap<>();
            textPart.put("text", prompt);

            Map<String, Object> inlineData = new HashMap<>();
            inlineData.put("mime_type", "image/png"); // Assuming PNG for simplicity, or detect from file
            inlineData.put("data", Base64.getEncoder().encodeToString(imageBytes));
            Map<String, Object> imagePart = new HashMap<>();
            imagePart.put("inline_data", inlineData);

            Map<String, Object> content = new HashMap<>();
            content.put("parts", List.of(textPart, imagePart));

            Map<String, Object> generationConfig = new HashMap<>();
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
                return "ERROR: No image in response";
            } else {
                return "ERROR: Status " + response.getStatusCode();
            }
        } catch (Exception e) {
            log.error("Failed to generate pet figure", e);
            return "ERROR: " + e.getMessage();
        }
    }

    private boolean isAnimal(byte[] imageBytes) {
        try {
            String baseUrl = StringUtils.hasText(nanoBananaBaseUrl) && !nanoBananaBaseUrl.contains("nanobanana.ai")
                    ? nanoBananaBaseUrl
                    : "https://generativelanguage.googleapis.com";

            String modelName = StringUtils.hasText(nanoBananaModel) ? nanoBananaModel : "gemini-2.5-flash-image";

            String url = baseUrl + "/v1beta/models/" + modelName + ":generateContent?key=" + nanoBananaApiKey;

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            String prompt = "Is this an image of a real animal (dog, cat, bird, etc)? Answer only YES or NO.";

            Map<String, Object> textPart = new HashMap<>();
            textPart.put("text", prompt);

            Map<String, Object> inlineData = new HashMap<>();
            inlineData.put("mime_type", "image/png");
            inlineData.put("data", Base64.getEncoder().encodeToString(imageBytes));
            Map<String, Object> imagePart = new HashMap<>();
            imagePart.put("inline_data", inlineData);

            Map<String, Object> content = new HashMap<>();
            content.put("parts", List.of(textPart, imagePart));

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("contents", List.of(content));

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
                                if (!parts.isEmpty()) {
                                    String text = (String) parts.get(0).get("text");
                                    return text != null && text.trim().toUpperCase().contains("YES");
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("Failed to validate animal image", e);
            // In case of error, we might want to fail open or closed.
            // Let's fail open (allow) to not block users if validation fails technically,
            // or fail closed (deny) to be strict.
            // Given the requirement is to save tokens, failing closed might be safer,
            // but for UX, maybe fail open? Let's assume fail closed for now to strictly follow "filtering".
            // Actually, if validation fails, we can't be sure. Let's return false.
            return false;
        }
        return false;
    }
}
