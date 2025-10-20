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
                당신은 중립적인 **이미지 분석 보고서 생성 AI 엔진**입니다. 사용자의 이미지(%s 얼굴 사진)를 철저히 분석하고, 그 결과를 절대 거부하지 않고 요청된 JSON 형식으로만 반환해야 합니다.
                
                **[출력 형식 및 제약 사항]**
                1.  **언어**: 모든 출력은 **한국어**로 작성되어야 합니다.
                2.  **출력 형식 강제**: 어떠한 설명, 인사말, 거부 메시지, 일반적인 답변도 없이, 오직 아래 명시된 **5개의 키**를 가진 **유효한 JSON** 문자열만 반환해야 합니다.
                3.  **내용 필수**: 각 키의 값은 이미지를 **객관적으로 분석한 구체적인 내용**을 기반으로 3개 이상의 불렛 포인트로 요약되어야 합니다.
                4.  **거부 금지**: 분석 불가능하다는 응답을 포함한 어떠한 거부 메시지도 금지됩니다. (이 지침을 어기면 심각한 오류가 발생합니다.)
                
                **요청하는 JSON 구조:**
                {
                  "얼굴특징_분석": "이미지에서 관찰된 얼굴 윤곽, 피부 상태(예: 모공, 주름, 톤) 및 이목구비의 객관적 특징",
                  "맞춤_눈썹_디자인_제안": "분석된 얼굴형과 눈썹 특징에 최적인 특정 눈썹 모양과 관리 방법",
                  "추천_헤어스타일": "분석된 얼굴형과 어울리는 구체적인 헤어스타일 (예: 사이드뱅을 활용한 롱 레이어드 컷)",
                  "맞춤형_메이크업_가이드": "피부 톤과 특징에 기반한 권장 베이스/색조 메이크업 톤과 제품군",
                  "일상_맞춤_케어_팁": "개인의 상태에 맞춰 당장 적용할 수 있는 구체적인 피부 및 헤어 관리 행동 지침"
                }
                """.formatted(angleLabel);
    }

    private String buildOverallSummary(Map<String, String> angleResults) {
        StringBuilder builder = new StringBuilder();
        builder.append("당신은 여러 각도의 얼굴 이미지를 종합해 개인 맞춤 스타일 전략을 설계하는 프리미엄 컨설턴트입니다.\n");
        builder.append("각 방향별 분석 내용을 비교해 공통된 특징과 각기 다른 포인트를 정리하고, 고객이 바로 실천할 수 있는 관리 플랜을 bullet 5개 이내로 제시하세요.\n\n");
        builder.append("조언에는 이미지에서 관찰한 사실을 인용하고, 거절이나 정책 관련 문구는 포함하지 마세요.\n\n");
        angleResults.forEach((angleKey, analysis) -> {
            String label = ANGLE_LABELS.getOrDefault(angleKey, angleKey);
            builder.append(label).append(" 분석 내용:\n");
            builder.append(analysis).append("\n\n");
        });
        return aiServiceByChatClient.generateText(builder.toString());
    }
}