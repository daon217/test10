package edu.sm.controller;

import edu.sm.app.dto.ClothesRecommendResult;
import edu.sm.app.service.ClothesRecommendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/clothes-recommend")
@RequiredArgsConstructor
@Slf4j
public class ClothesRecommendController {

    private final ClothesRecommendService clothesRecommendService;

    // CORS 정책을 위해 @CrossOrigin 추가 (필요하다면)
    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/analyze", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ClothesRecommendResult> analyzePhoto(
            @RequestParam("image") MultipartFile attach,
            // [수정] animalType 파라미터 추가
            @RequestParam(value = "animalType", required = false) String animalType
    ) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for clothes recommendation.");
            ClothesRecommendResult invalidResult = ClothesRecommendResult.builder()
                    .animalType("이미지 필요")
                    .backLength("N/A")
                    .chestGirth("N/A")
                    .neckGirth("N/A")
                    .recommendedSize("N/A")
                    .clothingType("N/A")
                    .colorAnalysis("유효한 이미지 파일을 업로드해주세요.")
                    .fittingImageDesc("이미지가 없어 가상 피팅을 진행할 수 없습니다.")
                    .fittingImageUrl("/images/virtual-fitting-placeholder.png")
                    .colorPalette(List.of("#9aa5b1", "#c9d1d9", "#6b7280"))
                    .build();
            return ResponseEntity.badRequest().body(invalidResult);
        }

        // [수정] animalType을 서비스에 전달
        ClothesRecommendResult result = clothesRecommendService.analyzeAndRecommend(attach, animalType);
        return ResponseEntity.ok(result);
    }
}