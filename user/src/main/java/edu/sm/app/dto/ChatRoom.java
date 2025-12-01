package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatRoom {
    private int roomId;
    private String userId;    // 사용자 아이디
    private String targetId;  // 상대방 아이디
    private String lastMsg;
    private String lastDate;

    // 화면 표시용 (상대방 이름/사진 - 조인 결과 담을 곳)
    private String targetName;
    private String targetImg;

    // 안 읽은 메시지 수 (필터링용)
    private int unreadCount;
}