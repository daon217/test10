package edu.sm.app.dto;

import lombok.Data;

@Data
public class WalkRecommendResponse {

    private Pet pet;             // ✅ 새 Pet DTO 사용
    private double recommendedKm;
    private String reason;
}
