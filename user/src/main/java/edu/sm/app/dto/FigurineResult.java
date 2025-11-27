package edu.sm.app.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FigurineResult {
    private String figurineImageUrl; // 캐릭터화된 피규어 이미지 URL
    private String description;      // 이미지에 대한 설명
}