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
            @RequestParam("image") MultipartFile attach
    ) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for clothes recommendation.");
            return ResponseEntity.badRequest().body(null);
        }

        ClothesRecommendResult result = clothesRecommendService.analyzeAndRecommend(attach);
        return ResponseEntity.ok(result);
    }
}