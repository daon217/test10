package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerInquiry {
    private Long inquiryId;
    private Integer userId;
    private String username;
    private String category;
    private String title;
    private String content;
    private String status; // PENDING, ANSWERED 등
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}
