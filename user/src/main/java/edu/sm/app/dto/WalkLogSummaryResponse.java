package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WalkLogSummaryResponse {
    private Long id;
    private double distanceKm;
    private String startDate;   // "2025-11-26" 같은 날짜 문자열
    private long minutes;       // 총 소요시간(분)
}
