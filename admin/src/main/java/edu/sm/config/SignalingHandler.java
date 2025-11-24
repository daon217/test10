package edu.sm.config;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Component
public class SignalingHandler extends TextWebSocketHandler {
    // 연결된 모든 세션(CCTV, Admin, Simulator)을 저장
    // 동시성 문제를 위해 Collections.synchronizedList 사용을 권장합니다.
    private static final List<WebSocketSession> sessions = Collections.synchronizedList(new ArrayList<>());

    // [추가된 부분] 외부(컨트롤러)에서 메시지를 보낼 수 있는 정적 메서드
    public static void sendMessageToAll(String message) {
        TextMessage textMessage = new TextMessage(message);
        // 복사본을 사용하여 순회 중 발생할 수 있는 ConcurrentModificationException 방지
        List<WebSocketSession> currentSessions = new ArrayList<>(sessions);

        for (WebSocketSession session : currentSessions) {
            if (session.isOpen()) {
                try {
                    // 세션에 메시지를 보냅니다.
                    session.sendMessage(textMessage);
                } catch (IOException e) {
                    System.err.println("메시지 전송 오류: " + e.getMessage());
                    // 오류가 발생한 세션을 제거할 수 있습니다. (옵션)
                    // sessions.remove(session);
                }
            }
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session); //
        System.out.println("새 세션 연결: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // 기존 코드는 그대로 유지 (메시지를 나를 제외한 다른 세션에게 전달)
        // 이 로직은 CCTV <-> Admin 간 통신에 사용되고, 시뮬레이터 제어 명령은 sendMessageToAll()로 처리합니다.
        for (WebSocketSession webSocketSession : sessions) { //
            if (webSocketSession.isOpen() && !session.getId().equals(webSocketSession.getId())) { //
                webSocketSession.sendMessage(message); //
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) throws Exception {
        sessions.remove(session); //
        System.out.println("세션 연결 종료: " + session.getId());
    }
}