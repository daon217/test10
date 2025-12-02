package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoom {
    private String roomId;
    private int postId;
    private int ownerId;
    private int workerId;
    private LocalDateTime createdAt;

    // 화면 표시용 필드
    private String postTitle;
    private String otherPersonName; // 목록용

    // ✅ [추가] 방 상세 화면용 이름 필드
    private String ownerName;
    private String workerName;

    // 마지막 메시지 정보
    private String lastMessage;
    private LocalDateTime lastDate;
}