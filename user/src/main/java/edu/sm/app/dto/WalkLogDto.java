package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WalkLogDto {
    private Long walkingRecodeId;
    private Integer userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private double distanceKm;
    private String routeData;   // 코스 좌표 JSON
}
