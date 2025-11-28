package edu.sm.controller;

import edu.sm.app.dto.WalkRecommendResponse;
import edu.sm.app.service.PetWalkRecommendService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/pet")
@RequiredArgsConstructor
public class PetAiRestController {

    private final PetWalkRecommendService petWalkRecommendService;

    /**
     * GET /api/pet/walk-recommend
     *  - 현재(임시) 유저의 대표 반려동물 정보를 기반으로
     *    AI가 추천한 산책 거리와 설명을 반환.
     */
    @GetMapping("/walk-recommend")
    public WalkRecommendResponse recommendWalk() {
        return petWalkRecommendService.recommendForCurrentUser();
    }
}
