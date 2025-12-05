// edu.sm.app.dto.WalkLogSaveRequest
package edu.sm.app.dto;

import lombok.Data;

import java.util.List;

@Data
public class WalkLogSaveRequest {

    private String shapeType;   // heart / circle / square / triangle
    private Double targetKm;

    private RouteDto plannedRoute;   // 도형 코스
    private RouteDto walkedRoute;    // 실제 걸은 코스

    private String startTimeIso;
    private String endTimeIso;
    // ★ 추가
    private Integer petId;

    @Data
    public static class RouteDto {
        private Double distanceKm;
        private List<PointDto> points;
    }

    @Data
    public static class PointDto {
        private double lat;
        private double lon;
    }
}
