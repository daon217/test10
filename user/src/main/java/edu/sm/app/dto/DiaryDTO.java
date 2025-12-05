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
public class DiaryDTO {
    private Integer id;
    private Integer userId;
    private Integer petId;
    private String type; // WALK, HOMECAM, MEMO, SPECIAL, HEALTH, etc.
    private String title;
    private String content;
    private LocalDateTime date; // Combined date and time
    private String images; // JSON array or comma-separated URLs
    private String tags;
    private LocalDateTime createdAt;

    // Extra fields for frontend display (not in DB)
    private boolean isAuto;
    private String meta; // For extra info like distance, cost, etc.

    // Form binding fields
    private String dateStr;
    private String timeStr;
    private String existingImages; // Comma-separated list of existing images to keep
}
