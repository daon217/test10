package edu.sm.app.dto;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class ClothesRecommendResult {
    private String animalType;      // 반려동물 종류
    private String backLength;      // 추정 등 길이 (예: '40 cm')
    private String chestGirth;      // 추정 가슴 둘레 (예: '55 cm')
    private String neckGirth;       // 추정 목 둘레 (예: '35 cm')
    private String recommendedSize; // 권장 사이즈 (예: 'L')
    private String clothingType;    // 권장 의류 유형 (예: '가벼운 티셔츠')
    private String colorAnalysis;   // 컬러 추천 분석 결과
    private String fittingImageDesc; // 가상 피팅 이미지 설명
    private String fittingImageUrl; // 가상 피팅 이미지 URL
    private List<String> colorPalette; // 추천 색상 팔레트(HEX)
}