package edu.sm.app.dto;

import edu.sm.app.service.MapRouteService;
import lombok.Data;

import java.util.List;

@Data
public class MatchTrackRequest {
    private List<MapRouteService.GeoPoint> points;
}

