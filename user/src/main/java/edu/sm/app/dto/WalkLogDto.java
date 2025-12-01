// edu.sm.app.dto.WalkLogDto
package edu.sm.app.dto;

import lombok.Data;

import java.time.LocalDateTime;
@Data
public class WalkLogDto {

    private Long walkingRecodeId;
    private Integer userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    // 기존 대표값
    private Double distanceKm;
    private String routeData;

    // 신규
    private Double plannedDistanceKm;
    private Double walkedDistanceKm;
    private String plannedRouteData;
    private String walkedRouteData;
    private String shapeType;
    private Double targetKm;
}
