package edu.sm.app.dto;

import edu.sm.app.service.MapRouteService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponse {
    private String type; // heart, circle 등
    private List<MapRouteService.GeoPoint> points;
    private double distanceKm;
    private double estimatedMinutes;
}
