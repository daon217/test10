package edu.sm.controller;

import edu.sm.app.springai.service1.AiServiceByChatClient;
import edu.sm.app.springai.service3.AiImageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/aidaon/face")
@RequiredArgsConstructor
@Slf4j
public class AidaonFaceAnalysisController {

    private final AiImageService aiImageService;
    private final AiServiceByChatClient aiServiceByChatClient;

    private static final Map<String, String> ANGLE_LABELS = Map.of(
            "front", "정면",
            "left", "좌측",
            "right", "우측",
            "up", "위쪽",
            "down", "아래쪽"
    );

    @PostMapping(value = "/analyze", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> analyzeFace(
            @RequestParam("front") MultipartFile front,
            @RequestParam("left") MultipartFile left,
            @RequestParam("right") MultipartFile right,
            @RequestParam("up") MultipartFile up,
            @RequestParam("down") MultipartFile down
    ) {
        Map<String, MultipartFile> uploads = new LinkedHashMap<>();
        uploads.put("front", front);
        uploads.put("left", left);
        uploads.put("right", right);
        uploads.put("up", up);
        uploads.put("down", down);

        try {
            validateUploads(uploads);
            Map<String, String> angleResults = analyzeAngles(uploads);
            String summary = buildOverallSummary(angleResults);

            Map<String, Object> response = new LinkedHashMap<>();
            response.put("angles", angleResults);
            response.put("summary", summary);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.warn("잘못된 요청: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "error", e.getMessage()
            ));
        } catch (IOException e) {
            log.error("파일 처리 중 오류", e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "error", "이미지 파일을 처리하는 중 문제가 발생했습니다."
            ));
        } catch (Exception e) {
            log.error("분석 요청 실패", e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "error", "얼굴 분석에 실패했습니다. 잠시 후 다시 시도해주세요."
            ));
        }
    }

    private void validateUploads(Map<String, MultipartFile> uploads) {
        for (Map.Entry<String, MultipartFile> entry : uploads.entrySet()) {
            MultipartFile file = entry.getValue();
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException(ANGLE_LABELS.get(entry.getKey()) + " 사진을 다시 촬영해주세요.");
            }
            String contentType = file.getContentType();
            if (!StringUtils.hasText(contentType) || !contentType.startsWith("image/")) {
                throw new IllegalArgumentException(ANGLE_LABELS.get(entry.getKey()) + " 파일이 이미지 형식이 아닙니다.");
            }
        }
    }

    private Map<String, String> analyzeAngles(Map<String, MultipartFile> uploads) throws IOException {
        Map<String, String> results = new LinkedHashMap<>();
        for (Map.Entry<String, MultipartFile> entry : uploads.entrySet()) {
            String angleKey = entry.getKey();
            MultipartFile file = entry.getValue();
            String label = ANGLE_LABELS.getOrDefault(angleKey, angleKey);

            String prompt = buildAnglePrompt(label);
            String contentType = file.getContentType();
            if (!StringUtils.hasText(contentType)) {
                contentType = "image/png";
            }

            String analysis = aiImageService.imageAnalysis2(prompt, contentType, file.getBytes());
            results.put(angleKey, analysis);
        }
        return results;
    }

    private String buildAnglePrompt(String angleLabel) {
        return """
                당신은 프리미엄 뷰티 컨설턴트입니다.
                아래 이미지는 고객의 %s 얼굴 사진입니다.
                피부 상태, 눈썹 정리, 얼굴형에 어울리는 헤어스타일, 권장 색조/베이스 메이크업 제품을 간단 명료한 bullet 형태로 제안해주세요.
                셀프 케어 팁과 주의할 점이 있다면 함께 알려주세요.
                """.formatted(angleLabel);
    }

    private String buildOverallSummary(Map<String, String> angleResults) {
        StringBuilder builder = new StringBuilder();
        builder.append("당신은 사용자의 이미지들을 종합해 스타일 코칭을 제공하는 전문가입니다.\n");
        builder.append("각 방향별 분석 결과를 참고해 전반적인 관리 플랜을 bullet 5개 이내로 정리하고, 일상에서 바로 적용할 수 있는 행동 팁도 포함하세요.\n\n");
        angleResults.forEach((angleKey, analysis) -> {
            String label = ANGLE_LABELS.getOrDefault(angleKey, angleKey);
            builder.append(label).append(" 분석 내용:\n");
            builder.append(analysis).append("\n\n");
        });
        return aiServiceByChatClient.generateText(builder.toString());
    }
}