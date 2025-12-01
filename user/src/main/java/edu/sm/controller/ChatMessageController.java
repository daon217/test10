package edu.sm.controller;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequiredArgsConstructor
public class ChatMessageController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat/message")
    public void handleChatMessage(ChatMsg msg) {
        if (msg == null || msg.getContent() == null || msg.getContent().trim().isEmpty()) {
            return;
        }

        ChatRoom room = chatService.getRoom(msg.getRoomId());
        if (room == null) {
            throw new IllegalArgumentException("존재하지 않는 채팅방입니다.");
        }
        if (!msg.getSenderId().equals(room.getUserId()) && !msg.getSenderId().equals(room.getTargetId())) {
            throw new IllegalArgumentException("채팅방 참여자만 메시지를 전송할 수 있습니다.");
        }

        msg.setRegDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
        chatService.saveMsg(msg);
        messagingTemplate.convertAndSend("/sub/chat/room/" + msg.getRoomId(), msg);
    }
}
