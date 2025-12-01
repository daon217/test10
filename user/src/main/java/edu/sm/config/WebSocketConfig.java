package edu.sm.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {

    private final SignalingHandler signalingHandler; // 기존
    private final ChatHandler chatHandler;           // [필수] 신규 채팅 핸들러

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // 기존 화상채팅용
        registry.addHandler(signalingHandler, "/signal")
                .setAllowedOriginPatterns("*");

        // [필수] 1:1 채팅용 (로그인 세션 정보 공유를 위해 Interceptor 추가)
        registry.addHandler(chatHandler, "/ws/chat")
                .addInterceptors(new HttpSessionHandshakeInterceptor())
                .setAllowedOriginPatterns("*");
    }
}