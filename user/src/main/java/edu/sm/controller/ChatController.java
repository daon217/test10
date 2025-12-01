package edu.sm.controller;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.dto.User;
import edu.sm.app.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    // 채팅 시작 (방 생성/조회 후 이동)
    @GetMapping("/start")
    public String startChat(@RequestParam("postId") int postId,
                            @RequestParam("writerId") int writerId,
                            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        String roomId = chatService.createOrGetRoom(postId, writerId, user.getUserId());
        return "redirect:/chat/room?roomId=" + roomId;
    }

    // 채팅방 화면
    @GetMapping("/room")
    public String chatRoom(@RequestParam("roomId") String roomId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        ChatRoom room = chatService.getRoom(roomId);
        List<ChatMsg> msgs = chatService.getMessages(roomId);

        model.addAttribute("room", room);
        model.addAttribute("msgs", msgs);
        model.addAttribute("user", user);
        model.addAttribute("center", "chat/room");
        return "index";
    }

    // 채팅 목록 화면
    @GetMapping("/list")
    public String chatList(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        List<ChatRoom> myRooms = chatService.getMyChatRooms(user.getUserId());
        model.addAttribute("chatRooms", myRooms);
        model.addAttribute("center", "chat/list");
        return "index";
    }
}