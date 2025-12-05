package edu.sm.app.service;

import edu.sm.app.tool.EmergencyCallTool;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import reactor.core.publisher.Flux;

/**
 * Service that sends CCTV snapshots to the configured AI model
 * and streams the resulting analysis.
 */
@Service
@Slf4j
public class CctvAnalysisService {

        private final ChatClient chatClient;
        private final EmergencyCallTool emergencyCallTool;
        private final DiaryService diaryService;

        public CctvAnalysisService(ChatModel chatModel, EmergencyCallTool emergencyCallTool,
                        DiaryService diaryService) {
                this.chatClient = ChatClient.builder(chatModel).build();
                this.emergencyCallTool = emergencyCallTool;
                this.diaryService = diaryService;
        }

        public Flux<String> analyzeAndRespond(String question, String contentType, byte[] bytes, Integer userId) {
                SystemMessage systemMessage = SystemMessage.builder()
                                .text("""
                                                당신은 가정용 반려동물 돌봄 카메라의 영상 분석 요원입니다.

                                                1. 화면에서 반려동물이 명확히 보이지 않으면 다른 설명 없이 'NO_PET_VISIBLE'만 출력하세요.
                                                2. 반려동물이 보이면 건강, 기분, 안전 상태를 행동과 표정을 근거로 간결한 한국어 한두 문장으로 요약하세요.
                                                3. 위험하거나 이상 징후(부상, 구토, 호흡 이상, 장시간 무기력 등)가 보이면 원인 추정과 즉시 취할 조치 1~2가지를 알려주세요.
                                                """)
                                .build();

                Media media = Media.builder()
                                .mimeType(MimeType.valueOf(contentType))
                                .data(new ByteArrayResource(bytes))
                                .build();

                UserMessage userMessage = UserMessage.builder()
                                .text(question)
                                .media(media)
                                .build();

                StringBuilder accumulatedResponse = new StringBuilder();

                return chatClient.prompt()
                                .messages(systemMessage, userMessage)
                                .tools(emergencyCallTool)
                                .stream()
                                .content()
                                .doOnNext(accumulatedResponse::append)
                                .doOnComplete(() -> {
                                        String fullResponse = accumulatedResponse.toString();
                                        if (!fullResponse.contains("NO_PET_VISIBLE") && userId != null) {
                                                try {
                                                        edu.sm.app.dto.DiaryDTO diary = edu.sm.app.dto.DiaryDTO
                                                                        .builder()
                                                                        .userId(userId)
                                                                        .type("HOMECAM")
                                                                        .title("홈캠 AI 감지")
                                                                        .content(fullResponse)
                                                                        .date(java.time.LocalDateTime.now())
                                                                        .isAuto(true)
                                                                        .build();
                                                        diaryService.add(diary);
                                                        log.info("Saved Homecam event to Diary for user {}", userId);
                                                } catch (Exception e) {
                                                        log.error("Failed to save Homecam event to Diary", e);
                                                }
                                        }
                                });
        }
}