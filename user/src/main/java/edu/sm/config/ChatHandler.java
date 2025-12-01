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

        // --- A. 로그인 직후 알림용 연결 초기화 (index.jsp에서 보냄) ---
        if ("GLOBAL_INIT".equals(chatMsg.getContent())) {
            int userId = chatMsg.getSenderId();
            userSessions.computeIfAbsent(userId, k -> new ArrayList<>()).add(session);
            log.info("## 알림용 세션 등록 완료: User " + userId);
            return;
        }

        // --- B. 일반 채팅 메시지 처리 ---
        String roomId = chatMsg.getRoomId();

        // 1. 방 세션 관리 (기존 로직)
        roomSessions.computeIfAbsent(roomId, k -> new ArrayList<>());
        List<WebSocketSession> list = roomSessions.get(roomId);
        if (list.stream().noneMatch(s -> s.getId().equals(session.getId()))) {
            list.add(session);
        }

        // 2. 메시지 DB 저장 (ENTER 제외)
        int senderId = 0;
        if (chatMsg.getContent() != null && !chatMsg.getContent().equals("ENTER")) {
            Map<String, Object> attrs = session.getAttributes();
            User user = (User) attrs.get("user");
            if(user != null) {
                senderId = user.getUserId();
                chatMsg.setSenderId(senderId);
                chatService.saveMessage(chatMsg);
            }
        }

        // 3. 방 안에 있는 사람들에게 메시지 전송 (대화 내용)
        for (WebSocketSession sess : list) {
            if (sess.isOpen()) {
                sess.sendMessage(new TextMessage(objectMapper.writeValueAsString(chatMsg)));
            }
        }

        // 4. [NEW] 알림 전송 (상대방이 채팅방 밖에 있을 때)
        if (senderId != 0) { // 실제 메시지를 보낸 경우에만
            sendNotification(roomId, senderId, chatMsg.getContent());
        }
    }

    private void sendNotification(String roomId, int senderId, String content) {
        try {
            // 방 정보를 조회해서 상대방(Receiver) 찾기
            ChatRoom room = chatService.getRoom(roomId);
            if (room == null) return;

            int receiverId = (room.getOwnerId() == senderId) ? room.getWorkerId() : room.getOwnerId();

            // 상대방의 글로벌 세션 찾기
            List<WebSocketSession> receiverSessions = userSessions.get(receiverId);
            if (receiverSessions != null && !receiverSessions.isEmpty()) {
                // 알림 패킷 생성
                Map<String, Object> notiMap = new HashMap<>();
                notiMap.put("type", "NOTIFICATION");
                notiMap.put("content", content);
                notiMap.put("roomId", roomId);
                notiMap.put("senderId", senderId);

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
        // 모든 맵에서 세션 제거
        roomSessions.values().forEach(list -> list.remove(session));
        userSessions.values().forEach(list -> list.remove(session));
        log.info("## 소켓 연결 종료: " + session.getId());
    }
}