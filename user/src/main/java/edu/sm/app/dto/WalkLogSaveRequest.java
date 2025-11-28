package edu.sm.app.dto;

import edu.sm.app.service.MapRouteService;
import lombok.Data;

import java.util.List;

@Data
public class WalkLogSaveRequest {

    // JS에서 보내는 값
    private double distanceKm;      // 실제 걸은 거리(km)
    private String startTimeIso;    // ISO 문자열 (new Date().toISOString())
    private String endTimeIso;

    // 코스 좌표 (lat, lon)
    private List<MapRouteService.GeoPoint> points;
}
