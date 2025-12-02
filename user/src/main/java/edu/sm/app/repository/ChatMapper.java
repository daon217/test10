package edu.sm.app.repository;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChatMapper {
    ChatRoom findRoomByPostAndWorker(int postId, int workerId);
    void insertRoom(ChatRoom chatRoom);
    ChatRoom findRoomById(String roomId);
    List<ChatRoom> selectMyRooms(int userId);
    void insertMsg(ChatMsg chatMsg);
    List<ChatMsg> selectMsgsByRoomId(String roomId);
}