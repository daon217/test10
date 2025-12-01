package edu.sm.controller;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.dto.User;
import edu.sm.app.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate template;

    // 1. 채팅방 목록 조회 API (AJAX 호출용)
    @GetMapping("/api/chat/rooms")
    @ResponseBody
    public List<ChatRoom> getRooms(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return null;
        }
        // 빨간줄 해결: getUserId() 대신 getUsername() 사용
        return chatService.getRoomList(user.getUsername());
    }

    // 2. 채팅방 생성 또는 가져오기 API
    @PostMapping("/api/chat/room")
    @ResponseBody
    public int createRoom(@RequestParam("targetId") String targetId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return -1;
        }
        // 빨간줄 해결: getUserId() 대신 getUsername() 사용
        return chatService.createOrGetRoom(user.getUsername(), targetId);
    }

    // 3. 메시지 내역 조회 API
    @GetMapping("/api/chat/messages")
    @ResponseBody
    public List<ChatMsg> getMessages(@RequestParam("roomId") int roomId) {
        return chatService.getMsgList(roomId);
    }

    // 4. 소켓 메시지 전송 및 저장 (User -> Server -> Subscribers)
    @MessageMapping("/chat/message")
    public void sendMessage(ChatMsg message) {
        log.info("채팅 메시지 수신: room={}, sender={}, msg={}", message.getRoomId(), message.getSenderId(), message.getContent());

        // 1. DB에 메시지 저장 및 채팅방 갱신
        chatService.saveMsg(message);

        // 2. 해당 방 구독자들에게 메시지 실시간 전송
        template.convertAndSend("/sub/chat/room/" + message.getRoomId(), message);
    }
}