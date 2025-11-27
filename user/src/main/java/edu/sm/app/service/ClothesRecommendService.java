package edu.sm.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.aallam.openai.api.image.ImageCreation; // <-- 새로운 라이브러리
import com.aallam.openai.api.image.ImageSize;
import com.aallam.openai.client.OpenAI;
import com.aallam.openai.api.image.ImageURL;
import com.aallam.openai.api.image.Image;
import edu.sm.app.dto.ClothesRecommendResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.beans.factory.annotation.Value; // @Value를 사용하기 위해 추가
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import org.springframework.web.multipart.MultipartFile;
import java.util.List; // List import 추가

/**
 * Service that analyzes pet photo for sizing and clothing recommendations using AI.
 */
@Service
@Slf4j
public class ClothesRecommendService {

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final OpenAI openAiClient; // <-- 새로운 공식 OpenAI 클라이언트

    // application-dev.yml에서 OpenAI API 키를 직접 주입받습니다.
    public ClothesRecommendService(
            ChatModel chatModel,
            @Value("${spring.ai.openai.api-key}") String apiKey // API 키를 직접 주입
    ) {
        this.chatClient = ChatClient.builder(chatModel).build();
        // 새로운 OpenAI 클라이언트를 수동으로 초기화
        this.openAiClient = new OpenAI(apiKey);
    }

    public ClothesRecommendResult analyzeAndRecommend(MultipartFile attach) {
        // Fallback Result 정의
        ClothesRecommendResult fallback = ClothesRecommendResult.builder()
                .animalType("분석 실패")
                .backLength("N/A")
                .chestGirth("N/A")
                .neckGirth("N/A")
                .recommendedSize("N/A")
                .clothingType("N/A")
                .colorAnalysis("분석에 실패했습니다. (OpenAI API 키, JSON 형식 확인 필요)")
                .fittingImageDesc("분석 실패")
                .fittingImageUrl("/images/virtual-fitting-placeholder.png")
                .build();

        // 1. 이미지 분석 (GPT-4o)
        try {
            SystemMessage systemMessage = SystemMessage.builder()
                    .text("""
                        당신은 반려동물의 옷 사이즈를 추천하는 전문 AI 컨설턴트입니다.
                        
                        [핵심 임무]
                        1. **반려동물 식별**: 사진 속 동물의 종류(예: 강아지/고양이), 품종을 식별하세요.
                        2. **신체 치수 추정**: 사진을 보고 다음 3가지 핵심 치수를 **반드시 한국어**로 추정하세요.
                           - 등 길이 (Back Length): 목선부터 꼬리 시작점까지의 길이
                           - 가슴 둘레 (Chest Girth): 앞다리 바로 뒤, 가장 두꺼운 부분의 둘레
                           - 목 둘레 (Neck Girth)
                        3. **사이즈 추천**: 추정된 치수를 기반으로 가장 적합한 의류 사이즈(S, M, L, XL 등)와 유형을 추천하세요.
                        4. **컬러 추천**: 반려동물의 털 색상과 분위기에 어울리는 컬러 계열을 100자 이내로 한국어로 추천하세요.
                        5. **가상 피팅 설명**: 추천된 의류를 입은 가상 피팅 이미지에 대한 상세한 설명 (DALL-E 프롬프트 스타일)을 **영어**로 100자 이내로 작성하세요. 원본 사진의 반려동물과 비슷한 품종/색상의 이미지를 생성하도록 자세히 묘사하며, 배경은 심플하게 처리해야 합니다.
                        
                        [중요 규칙]
                        - 사진에 측정 비교 대상이 없는 경우, AI는 해당 품종의 **평균적인 신체 사이즈 범위**를 고려하여 합리적으로 추정해야 합니다.
                        - 최종 답변은 JSON 형식으로만 반환해야 합니다. 응답 필드는 다음과 같습니다.
                        """)
                    .text(String.format("""
                        ```json
                        {
                            "animalType": "품종 이름",
                            "backLength": "등 길이 (예: 40 cm)",
                            "chestGirth": "가슴 둘레 (예: 55 cm)",
                            "neckGirth": "목 둘레 (예: 35 cm)",
                            "recommendedSize": "추천 사이즈 (예: L)",
                            "clothingType": "권장 의류 유형 (예: 가벼운 티셔츠)",
                            "colorAnalysis": "컬러 추천 분석 결과",
                            "fittingImageDesc": "Generated English Prompt for DALL-E",
                            "fittingImageUrl": "%s" 
                        }
                        ```
                        """, "/images/virtual-fitting-result.jpg"))
                    .build();

            Media media = Media.builder()
                    .mimeType(MimeType.valueOf(attach.getContentType()))
                    .data(new ByteArrayResource(attach.getBytes()))
                    .build();

            UserMessage userMessage = UserMessage.builder()
                    .text("첨부된 반려동물 사진을 분석하여 옷 사이즈를 추천해줘. JSON 형식으로만 응답해. 가상 피팅 설명은 DALL-E용 영어 프롬프트로 생성해.")
                    .media(media)
                    .build();

            String rawResponse = chatClient.prompt()
                    .messages(systemMessage, userMessage)
                    .call()
                    .content();

            // JSON 추출 로직
            int start = rawResponse.indexOf('{');
            int end = rawResponse.lastIndexOf('}');
            if (start == -1 || end == -1 || start > end) {
                log.error("Failed to extract JSON from AI response: {}", rawResponse);
                fallback.setColorAnalysis("AI가 유효한 JSON을 반환하지 않았습니다. 프롬프트나 응답을 확인하세요.");
                return fallback;
            }
            String jsonResponse = rawResponse.substring(start, end + 1);

            ClothesRecommendResult analysisResult = objectMapper.readValue(jsonResponse, ClothesRecommendResult.class);

            // 2. 가상 피팅 이미지 생성 (DALL-E 3 - 수동 호출)
            String imagePrompt = analysisResult.getFittingImageDesc();
            if (imagePrompt == null || imagePrompt.isEmpty()) {
                log.warn("Image prompt is empty. Skipping DALL-E call.");
                return analysisResult;
            }

            log.info("Generating DALL-E image with prompt: {}", imagePrompt);

            // DALL-E API 호출: 코루틴을 사용하지 않고 동기적으로 호출하기 위해 .execute() 사용
            ImageCreation imageCreation = new ImageCreation(
                    imagePrompt,
                    "dall-e-3",
                    ImageSize.S1024x1024,
                    1,
                    "url"
            );

            // Image URL 생성
            Image image = openAiClient.images(imageCreation).execute();
            List<ImageURL> imageResults = image.getImages();

            // 3. 결과 URL 추출 및 DTO 업데이트
            if (imageResults != null && !imageResults.isEmpty()) {
                String imageUrl = imageResults.get(0).getUrl();
                log.info("Generated image URL: {}", imageUrl);

                return ClothesRecommendResult.builder()
                        .animalType(analysisResult.getAnimalType())
                        .backLength(analysisResult.getBackLength())
                        .chestGirth(analysisResult.getChestGirth())
                        .neckGirth(analysisResult.getNeckGirth())
                        .recommendedSize(analysisResult.getRecommendedSize())
                        .clothingType(analysisResult.getClothingType())
                        .colorAnalysis(analysisResult.getColorAnalysis())
                        .fittingImageDesc("AI(DALL-E 3)가 생성한 가상 피팅 이미지입니다. (임시 URL)")
                        .fittingImageUrl(imageUrl) // **실제 DALL-E URL**
                        .build();
            }

            return analysisResult;

        } catch (Exception e) {
            log.error("AI Clothes Recommend Analysis (Chat or Image) Failed: {}", e.getMessage());
            return fallback;
        }
    }
}