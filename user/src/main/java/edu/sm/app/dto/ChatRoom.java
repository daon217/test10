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

    // 조인용 필드 (화면 표시용)
    private String otherPersonName;
    private String postTitle;
    private String lastMessage;
    private LocalDateTime lastDate;
}