package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WalkLogSaveResponse {
    private Long id;
    private double distanceKm;
    private long minutes;
}
