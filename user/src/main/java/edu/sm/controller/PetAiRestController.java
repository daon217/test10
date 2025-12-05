package edu.sm.controller;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.WalkRecommendResponse;
import edu.sm.app.service.PetWalkRecommendService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/pet")
@RequiredArgsConstructor
public class PetAiRestController {

    private final PetWalkRecommendService petWalkRecommendService;

    /**
     * 기존: 로그인한 사용자(반려인) 기준 추천
     */
    @GetMapping("/walk-recommend")
    public WalkRecommendResponse recommendWalk() {
        return petWalkRecommendService.recommendForCurrentUser();
    }

    /**
     * 새로 추가: 특정 userId(반려인) 기준 추천
     * - 알바생 화면에서 '오늘 산책할 반려인의 반려동물' 정보를 보고 싶을 때 사용
     */
    @GetMapping("/walk-recommend/for-user/{userId}")
    public WalkRecommendResponse recommendWalkForUser(@PathVariable Integer userId) {
        return petWalkRecommendService.recommendForUser(userId);
    }
    /** ★ 새로 추가: 현재 로그인 사용자의 반려동물 목록 */
    @GetMapping("/my-pets")
    public List<Pet> myPets() {
        return petWalkRecommendService.getPetsForCurrentUser();
    }

    /** ★ 새로 추가: 특정 petId 기준 추천 (지도에서 선택한 펫) */
    @GetMapping("/walk-recommend/for-pet/{petId}")
    public WalkRecommendResponse recommendWalkForPet(@PathVariable Integer petId) {
        return petWalkRecommendService.recommendForPet(petId);
    }
}
