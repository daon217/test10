package edu.sm.app.service;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import edu.sm.app.repository.ChatMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMapper chatMapper;

    /**
     * 채팅방 생성 또는 조회
     * 이미 존재하는 방이면 그 방 ID를, 없으면 새로 만들고 ID 반환
     */
    @Transactional
    public int createOrGetRoom(String userId, String targetId) {
        ChatRoom room = chatMapper.findRoom(userId, targetId);
        if (room == null) {
            room = ChatRoom.builder()
                    .userId(userId)
                    .targetId(targetId)
                    .build();
            chatMapper.createRoom(room);
        }
        return room.getRoomId();
    }

    public List<ChatRoom> getRoomList(String userId) {
        return chatMapper.getRoomList(userId);
    }

    public List<ChatMsg> getMsgList(int roomId) {
        return chatMapper.getMsgList(roomId);
    }

    @Transactional
    public void saveMsg(ChatMsg msg) {
        // 메시지 저장
        chatMapper.insertMsg(msg);
        // 채팅방의 마지막 메시지와 시간 갱신
        chatMapper.updateLastMsg(msg.getRoomId(), msg.getContent());
    }
}