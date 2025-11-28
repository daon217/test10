package edu.sm.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class RouteAiRankerService {

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public RouteAiRankerService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    /**
     * 후보 코스 목록 중 LLM이 "가장 예쁜 코스" 하나를 선택
     */
    public RankedResult pickBestRoute(List<MapRouteService.ShapeRouteResponse> candidates) {
        if (candidates == null || candidates.isEmpty()) {
            return null;
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < candidates.size(); i++) {
            MapRouteService.ShapeRouteResponse c = candidates.get(i);
            sb.append(String.format(
                    "%d) 길이: %.2f km, 예상 시간: %.0f 분%n",
                    i,
                    c.getDistanceKm(),
                    c.getEstimatedMinutes()
            ));
        }

        String userPrompt = """
                아래는 서로 다른 산책 코스 후보들의 정보입니다.
                각 코스는 길이(km)와 예상 소요시간(분)만 제공됩니다.
                반려동물과 함께 걷기 좋고, 너무 험하지 않을 것 같은 코스를 1개 선택하세요.

                반드시 다음 JSON 형식으로만 답변하세요. 추가 설명 문장은 쓰지 마세요.

                {
                  "bestIndex": 0,
                  "reason": "간단한 한국어 이유"
                }
                """;

        String content = chatClient.prompt()
                .system("당신은 산책 코스를 평가하는 도우미입니다. 응답은 반드시 JSON만 출력해야 합니다.")
                .user(userPrompt + "\n\n후보 목록:\n" + sb)
                .call()
                .content();

        log.info("LLM raw response = {}", content);

        AiRankResponse aiRes;
        try {
            aiRes = objectMapper.readValue(content, AiRankResponse.class);
        } catch (Exception e) {
            log.warn("JSON 파싱 실패, 기본 0번 선택", e);
            aiRes = new AiRankResponse();
            aiRes.setBestIndex(0);
            aiRes.setReason("JSON 파싱 오류로 0번 코스를 선택했습니다.");
        }

        int idx = aiRes.getBestIndex();
        if (idx < 0 || idx >= candidates.size()) {
            idx = 0;
        }

        RankedResult result = new RankedResult();
        result.setBestRoute(candidates.get(idx));
        result.setBestIndex(idx);
        result.setReason(aiRes.getReason());
        return result;
    }

    @Data
    public static class AiRankResponse {
        private int bestIndex;
        private String reason;
    }

    @Data
    public static class RankedResult {
        private MapRouteService.ShapeRouteResponse bestRoute;
        private int bestIndex;
        private String reason;
    }
}
