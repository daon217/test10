package edu.sm.app.repository;

import edu.sm.app.dto.ChatMsg;
import edu.sm.app.dto.ChatRoom;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChatMapper {
    // 방 찾기 (나-상대 or 상대-나)
    ChatRoom findRoom(@Param("userId") String userId, @Param("targetId") String targetId);

    // 단일 방 조회
    ChatRoom getRoom(int roomId);

    // 방 생성
    void createRoom(ChatRoom chatRoom);

    // 내 방 목록 조회 (최신순 정렬)
    List<ChatRoom> getRoomList(String userId);

    // 메시지 저장
    void insertMsg(ChatMsg chatMsg);

    // 특정 방의 메시지 조회
    List<ChatMsg> getMsgList(int roomId);

    // 마지막 메시지 및 시간 업데이트
    void updateLastMsg(@Param("roomId") int roomId, @Param("lastMsg") String lastMsg);
}