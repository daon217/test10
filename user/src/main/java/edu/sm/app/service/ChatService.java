package edu.sm.app.service;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.repository.ChatMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMapper chatMapper;

    public String createOrGetRoom(int postId, int ownerId, int workerId) {
        ChatRoom existingRoom = chatMapper.findRoomByPostAndWorker(postId, workerId);
        if (existingRoom != null) {
            return existingRoom.getRoomId();
        }
        String newRoomId = UUID.randomUUID().toString();
        ChatRoom newRoom = ChatRoom.builder()
                .roomId(newRoomId)
                .postId(postId)
                .ownerId(ownerId)
                .workerId(workerId)
                .build();
        chatMapper.insertRoom(newRoom);
        return newRoomId;
    }

    public ChatRoom getRoom(String roomId) {
        return chatMapper.findRoomById(roomId);
    }

    public void saveMessage(ChatMsg msg) {
        chatMapper.insertMsg(msg);
    }

    public List<ChatMsg> getMessages(String roomId) {
        return chatMapper.selectMsgsByRoomId(roomId);
    }

    public List<ChatRoom> getMyChatRooms(int userId) {
        return chatMapper.selectMyRooms(userId);
    }
}