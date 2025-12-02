package edu.sm.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.dto.User;
import edu.sm.app.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
@RequiredArgsConstructor
public class ChatHandler extends TextWebSocketHandler {

    private final ChatService chatService;
    private final ObjectMapper objectMapper;

    // 1. 채팅방별 세션 (채팅방 안에서 대화용)
    private static final Map<String, List<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();

    // 2. 전체 접속 유저 세션 (알림 전송용) - UserID -> Session List
    private static final Map<Integer, List<WebSocketSession>> userSessions = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        log.info("## 소켓 연결됨: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        ChatMsg chatMsg = objectMapper.readValue(payload, ChatMsg.class);

        // --- A. 로그인 직후 알림용 연결 초기화 ---
        if ("GLOBAL_INIT".equals(chatMsg.getContent())) {
            int userId = chatMsg.getSenderId();
            userSessions.computeIfAbsent(userId, k -> new ArrayList<>()).add(session);
            log.info("## 알림용 세션 등록 완료: User " + userId);
            return;
        }

        // --- B. 일반 채팅 메시지 처리 ---
        String roomId = chatMsg.getRoomId();

        // 1. 방 세션 관리
        roomSessions.computeIfAbsent(roomId, k -> new ArrayList<>());
        List<WebSocketSession> list = roomSessions.get(roomId);
        if (list.stream().noneMatch(s -> s.getId().equals(session.getId()))) {
            list.add(session);
        }

        // 2. 메시지 DB 저장 및 보낸 사람 이름 확인
        int senderId = 0;
        String senderName = "알 수 없음"; // [추가]

        if (chatMsg.getContent() != null && !chatMsg.getContent().equals("ENTER")) {
            Map<String, Object> attrs = session.getAttributes();
            User user = (User) attrs.get("user");
            if(user != null) {
                senderId = user.getUserId();
                senderName = user.getName(); // [추가] User 객체에서 이름 가져오기

                chatMsg.setSenderId(senderId);
                chatService.saveMessage(chatMsg);
            }
        }

        // 3. 대화 전송
        for (WebSocketSession sess : list) {
            if (sess.isOpen()) {
                sess.sendMessage(new TextMessage(objectMapper.writeValueAsString(chatMsg)));
            }
        }

        // 4. [수정] 알림 전송 (이름 포함)
        if (senderId != 0) {
            sendNotification(roomId, senderId, chatMsg.getContent(), senderName);
        }
    }

    // [수정] senderName 파라미터 추가
    private void sendNotification(String roomId, int senderId, String content, String senderName) {
        try {
            ChatRoom room = chatService.getRoom(roomId);
            if (room == null) return;

            int receiverId = (room.getOwnerId() == senderId) ? room.getWorkerId() : room.getOwnerId();

            List<WebSocketSession> receiverSessions = userSessions.get(receiverId);
            if (receiverSessions != null && !receiverSessions.isEmpty()) {

                // 알림 데이터 생성
                Map<String, Object> notiMap = new HashMap<>();
                notiMap.put("type", "NOTIFICATION");
                notiMap.put("content", content);
                notiMap.put("roomId", roomId);
                notiMap.put("senderId", senderId);
                notiMap.put("senderName", senderName); // [추가] 이름 정보

                String notiJson = objectMapper.writeValueAsString(notiMap);
                TextMessage notiMsg = new TextMessage(notiJson);

                for (WebSocketSession sess : receiverSessions) {
                    if (sess.isOpen()) {
                        sess.sendMessage(notiMsg);
                    }
                }
            }
        } catch (Exception e) {
            log.error("알림 전송 실패", e);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        roomSessions.values().forEach(list -> list.remove(session));
        userSessions.values().forEach(list -> list.remove(session));
        log.info("## 소켓 연결 종료: " + session.getId());
    }
}