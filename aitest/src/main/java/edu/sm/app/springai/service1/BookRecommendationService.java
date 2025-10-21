package edu.sm.app.springai.service1;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.prompt.ChatOptions;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class BookRecommendationService {

    private final ChatClient chatClient;

    public BookRecommendationService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    public String recommend(String readingFrequency, String todayMood, String moodReason, String dailyTime) {
        String systemPrompt = """
                당신은 사용자의 독서 취향을 섬세하게 분석해서 책을 추천하는 사서입니다.
                모든 답변은 한국어로 작성하고, 번호가 있는 목록 형태로 3권의 책을 추천하세요.
                각 책에 대해 제목, 간단한 소개, 추천 이유, 예상 독서 소요 시간을 제시하세요.
                가능하다면 다양한 장르를 제안하고, 사용자의 요구에 맞는 맞춤형 조언을 덧붙이세요.
                """;

        String userPrompt = """
                사용자가 아래 정보를 제공했습니다.
                1. 평소 독서 빈도: %s
                2. 오늘의 기분 상태: %s
                2-1. 그렇게 느끼는 이유: %s
                3. 오늘 독서에 사용할 수 있는 시간: %s

                위 정보를 분석하여 어울리는 책을 추천해 주세요.
                """.formatted(readingFrequency, todayMood, moodReason, dailyTime);

        return chatClient.prompt()
                .system(systemPrompt)
                .user(userPrompt)
                .options(ChatOptions.builder().build())
                .call()
                .content();
    }
}