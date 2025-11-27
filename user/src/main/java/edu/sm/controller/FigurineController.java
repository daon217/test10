package edu.sm.controller;

import edu.sm.app.dto.FigurineResult;
import edu.sm.app.service.FigurineService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/figurine")
@RequiredArgsConstructor
@Slf4j
public class FigurineController {

    private final FigurineService figurineService;

    // CORS 정책을 위해 @CrossOrigin 추가
    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/generate", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<FigurineResult> generateFigurine(
            @RequestParam("image") MultipartFile attach
    ) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for figurine generation.");
            FigurineResult invalidResult = FigurineResult.builder()
                    .figurineImageUrl("/images/virtual-fitting-placeholder.png")
                    .description("유효한 이미지 파일을 업로드해주세요.")
                    .build();
            return ResponseEntity.badRequest().body(invalidResult);
        }

        FigurineResult result = figurineService.generateFigurine(attach);
        return ResponseEntity.ok(result);
    }
}