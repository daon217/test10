package edu.sm.controller;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.dto.User;
import edu.sm.app.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatRestController {

    private final ChatService chatService;

    private String getLoginUsername(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return user.getUsername();
    }

    @PostMapping("/room")
    public int createRoom(@RequestParam("targetId") String targetId, HttpSession session) {
        String userId = getLoginUsername(session);
        try {
            return chatService.createOrGetRoom(userId, targetId);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @GetMapping("/rooms")
    public List<ChatRoom> getRooms(HttpSession session) {
        String userId = getLoginUsername(session);
        List<ChatRoom> rooms = chatService.getRoomList(userId);

        rooms.forEach(room -> {
            String target = room.getUserId().equals(userId) ? room.getTargetId() : room.getUserId();
            room.setTargetId(target);
            if (room.getTargetName() == null || room.getTargetName().isEmpty()) {
                room.setTargetName(target);
            }
        });
        return rooms;
    }

    @GetMapping("/messages")
    public List<ChatMsg> getMessages(@RequestParam("roomId") int roomId, HttpSession session) {
        String userId = getLoginUsername(session);
        ChatRoom room = chatService.getRoom(roomId);
        if (room == null || !(room.getUserId().equals(userId) || room.getTargetId().equals(userId))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "채팅방 접근 권한이 없습니다.");
        }
        return chatService.getMsgList(roomId);
    }
}