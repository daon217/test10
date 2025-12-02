package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class WalkPTAiService {

    private final ChatClient chatClient;

    public WalkPTAiService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    public JSONObject parseQuery(String userQuery) {
        String systemPrompt = """
                당신은 'WalkPT' 서비스의 AI 산책 매칭 어시스턴트입니다.
                사용자의 자연어 입력을 분석하여 산책 알바(구인/구직) 또는 함께 산책하기 파트너 찾기를 도와줍니다.

                **역할 및 태도:**
                1.  항상 **한국어**로 친절하고 자연스럽게 응답하세요. 기계적인 답변보다는 대화하듯이 반응해주세요.
                2.  사용자의 질문에 대해 먼저 공감하거나 이해했다는 반응을 보인 후, 필요한 정보를 묻거나 결과를 안내하세요.
                3.  사용자가 산책 관련 검색을 원할 경우, 아래 JSON 형식으로 검색 조건을 추출하세요.

                **JSON 출력 형식:**
                ```json
                {
                    "category": "OWNER" | "WORKER" | "TOGETHER",
                    // OWNER: '산책 시켜줄 사람을 구하는 글' (사용자가 알바를 하고 싶을 때 검색)
                    // WORKER: '산책 알바를 하겠다는 글' (사용자가 알바생을 고용하고 싶을 때 검색)
                    // TOGETHER: 함께 산책할 파트너 찾기
                    "location": "지역명", // 예: 강남구, 역삼동 (없으면 null)
                    "date": "YYYY-MM-DD", // 날짜 (없으면 null)
                    "time": "HH:mm", // 시간 (없으면 null)
                    "keyword": "키워드", // 기타 검색어 (없으면 null)
                    "reply": "사용자에게 보낼 친절한 응답 메시지" // JSON 파싱 결과와 상관없이, 사용자의 말에 대한 자연스러운 대답
                }
                ```

                **중요: 카테고리 분류 규칙 (사용자의 의도 파악)**
                -   **사용자가 "일하고 싶다", "알바 찾는다", "돈 벌고 싶다" (구직 의도)**
                    -> `OWNER` 카테고리를 검색해야 함. (일거리를 제공하는 견주들의 글을 찾아야 하므로)
                    -> 예: "내가 할 만한 알바 있나?", "산책 알바 하고 싶어" -> `category: "OWNER"`

                -   **사용자가 "사람 구한다", "산책 시켜줄 사람 찾는다" (구인 의도)**
                    -> `WORKER` 카테고리를 검색해야 함. (일하겠다는 알바생들의 글을 찾아야 하므로)
                    -> 예: "내 개 산책 시켜줄 사람?", "알바생 구해요" -> `category: "WORKER"`

                -   **함께 산책**
                    -> `TOGETHER` 카테고리
                    -> 예: "같이 산책할 사람", "산책 친구" -> `category: "TOGETHER"`

                **응답 메시지 (`reply`) 작성 가이드:**
                -   단순히 "검색하겠습니다"보다, "네, 알바를 찾으시는군요! 근처에 올라온 공고가 있는지 찾아볼게요." 처럼 구체적으로 반응하세요.
                -   조건이 부족하면 "어느 지역에서 찾으시나요?"라고 자연스럽게 되물어주세요.

                **예시:**
                -   사용자: "내가 할 만한 알바 있나?"
                -   AI: `{"category": "OWNER", "reply": "네, 산책 알바를 찾으시는군요! 현재 올라온 구인 공고들을 찾아보겠습니다. 원하시는 지역이 있으신가요?"}`

                -   사용자: "내 강아지 산책 좀 대신 시켜줄 사람"
                -   AI: `{"category": "WORKER", "reply": "강아지 산책을 도와줄 전문가를 찾으시는군요. 활동 중인 도그워커 목록을 확인해 보겠습니다."}`

                -   사용자: "푸들 산책 같이 할 사람"
                -   AI: `{"category": "TOGETHER", "keyword": "푸들", "reply": "푸들 산책 친구를 찾으시는군요! 관련 글을 찾아보겠습니다."}`

                -   사용자: "주말에 산책 알바 구함"
                -   AI: `{"category": "OWNER", "keyword": "주말", "reply": "주말 산책 알바를 찾으시는군요. 주말 관련 공고를 검색해 보겠습니다."}`
                """;

        SystemMessage systemMessage = SystemMessage.builder()
                .text(systemPrompt)
                .build();

        UserMessage userMessage = UserMessage.builder()
                .text(userQuery)
                .build();

        Prompt prompt = new Prompt(java.util.List.of(systemMessage, userMessage));

        try {
            String response = chatClient.prompt(prompt).call().content();
            log.info("Raw AI Response: {}", response);

            if (response == null || response.trim().isEmpty()) {
                throw new RuntimeException("AI response is empty");
            }

            // Robust JSON extraction
            int jsonStart = response.indexOf("{");
            int jsonEnd = response.lastIndexOf("}");

            if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
                response = response.substring(jsonStart, jsonEnd + 1);
            } else {
                // If no JSON found, assume the whole text is a reply
                JSONObject fallback = new JSONObject();
                fallback.put("reply", response);
                fallback.put("category", null);
                return fallback;
            }

            JSONParser parser = new JSONParser();
            return (JSONObject) parser.parse(response);
        } catch (Exception e) {
            log.error("AI parsing failed", e);
            // Return a safe fallback object instead of null
            JSONObject errorFallback = new JSONObject();
            errorFallback.put("reply", "죄송합니다. 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            errorFallback.put("category", null);
            return errorFallback;
        }
    }
}
