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
public class ChatMsg {
    private int msgId;
    private String roomId;
    private int senderId;
    private String content;
    private LocalDateTime sentAt;
    private boolean isRead;
}