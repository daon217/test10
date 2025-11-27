package edu.sm.app.service;

import edu.sm.app.dto.FigurineResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Objects;

@Service
@Slf4j
public class FigurineService {

    private final ImageModel imageModel;

    public FigurineService(ObjectProvider<ImageModel> imageModelProvider) {
        // ImageModel이 Spring 설정에 따라 주입되지 않았을 경우를 대비하여 처리
        this.imageModel = imageModelProvider.getIfAvailable();
    }

    public FigurineResult generateFigurine(MultipartFile attach) throws IOException {
        if (imageModel == null) {
            log.error("ImageModel (DALL-E) is not available. Cannot generate figurine.");
            return FigurineResult.builder()
                    .figurineImageUrl("/images/virtual-fitting-placeholder.png")
                    .description("AI 이미지 생성 모델이 준비되지 않았습니다. 설정을 확인해주세요.")
                    .build();
        }

        // 사용자가 업로드한 파일 이름을 기반으로 반려동물 종류를 추정 (프롬프트 생성에 사용)
        String prompt = buildFigurinePrompt(Objects.requireNonNull(attach.getOriginalFilename()));
        String figurineUrl = tryGenerateImageWithAi(prompt);

        String finalUrl = StringUtils.hasText(figurineUrl) ? figurineUrl : "/images/virtual-fitting-placeholder.png";
        String description = StringUtils.hasText(figurineUrl)
                ? "업로드한 반려동물 사진을 기반으로 AI가 생성한 귀여운 3D 피규어 이미지입니다."
                : "AI 이미지 생성에 실패했습니다. 기본 이미지를 표시합니다.";

        return FigurineResult.builder()
                .figurineImageUrl(finalUrl)
                .description(description)
                .build();
    }

    /**
     * DALL-E용 프롬프트를 생성합니다.
     */
    private String buildFigurinePrompt(String filename) {
        String petType = "반려동물";
        if (filename.toLowerCase().contains("dog") || filename.toLowerCase().contains("강아지")) {
            petType = "귀여운 강아지";
        } else if (filename.toLowerCase().contains("cat") || filename.toLowerCase().contains("고양이")) {
            petType = "사랑스러운 고양이";
        }

        return String.format(
                "귀여운 %s를 기반으로 한 3D 스타일 피규어. 밝고 선명한 색감, 깨끗한 흰색 배경, 고화질, 배경이 없는 누끼 이미지, 스튜디오 조명, 블렌더 렌더링 스타일. Cute 3D style figurine based on a %s, bright colors, clean white background, high detail, no background (transparent/cutout), studio lighting, blender render.",
                petType,
                petType
        );
    }


    /**
     * AI 이미지 모델을 호출하여 이미지를 생성하고 URL 또는 Base64 URL을 반환합니다.
     */
    private String tryGenerateImageWithAi(String prompt) {
        try {
            ImageResponse response = imageModel.call(new ImagePrompt(prompt));
            if (response == null || response.getResults() == null || response.getResults().isEmpty()) {
                return null;
            }

            // [수정] ImageResponse.ImageResponseResult -> ImageResponse.Result로 변경
            ImageResponse.Result result = response.getResults().get(0);

            if (result.getOutput() != null) {
                // 외부 URL이 있다면 반환
                String url = result.getOutput().getUrl();
                if (StringUtils.hasText(url)) {
                    return url;
                }
                // Base64 문자열이 있다면 데이터 URL 형식으로 반환
                String b64 = result.getOutput().getB64Json();
                if (StringUtils.hasText(b64)) {
                    return "data:image/png;base64," + b64;
                }
            }
        } catch (Exception e) {
            log.warn("AI image model failed to generate figurine image.", e);
        }

        return null;
    }
}