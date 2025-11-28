package edu.sm.app.dto;

import lombok.Data;

@Data
public class WalkRecommendResponse {

    private PetDto pet;          // 반려동물 정보
    private double recommendedKm; // 추천 산책 거리(km)
    private String reason;        // AI 설명
}
