package edu.sm.app.service;

import edu.sm.app.dto.AiWalkRecommendResult;
import edu.sm.app.dto.Pet;
import edu.sm.app.dto.WalkRecommendResponse;
import edu.sm.app.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PetWalkRecommendService {

    private final PetRepository petRepository;
    private final ChatClient chatClient;
    private final CurrentUserService currentUserService;

    /**
     * 기존 기능: 현재 로그인한 사용자(반려인) 기준 추천
     */
    public WalkRecommendResponse recommendForCurrentUser() {
        int userId = currentUserService.getCurrentUserIdOrThrow();
        return recommendForUserInternal(userId);
    }

    /**
     * 새 기능: 특정 userId(반려인) 기준 추천
     * - 알바생 화면에서 "오늘 산책할 반려인의 반려동물" 정보를 보고 싶을 때 사용
     */
    public WalkRecommendResponse recommendForUser(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("userId는 null일 수 없습니다.");
        }
        return recommendForUserInternal(userId);
    }

    /**
     * 공통 내부 로직: 주어진 userId의 반려동물 중 대표 1마리 기준으로 추천
     */
    private WalkRecommendResponse recommendForUserInternal(int userId) {
        List<Pet> pets = petRepository.selectByUserId(userId);
        if (pets == null || pets.isEmpty()) {
            throw new IllegalStateException("등록된 반려동물이 없습니다. 반려동물을 먼저 등록해 주세요.");
        }

        // 대표 반려동물: 일단 첫 번째 사용
        Pet pet = pets.get(0);

        String type = safeString(pet.getType());           // DOG, CAT, ETC
        String customType = safeString(pet.getCustomType());
        String breed = safeString(pet.getBreed());
        String gender = safeString(pet.getGender());       // MALE, FEMALE 등
        Integer age = pet.getAge();
        BigDecimal weight = pet.getWeight();

        String speciesDesc = buildSpeciesDesc(type, customType, breed);

        double weightValue = (weight != null) ? weight.doubleValue() : 5.0;
        int ageValue = (age != null) ? age : 3;

        String prompt = """
                너는 개·고양이 등 소형 반려동물의 운동 처방을 전문으로 하는 수의사야.

                아래 반려동물 정보를 바탕으로
                "하루에 몇 km 정도 산책하는 것이 적당한지"를 추천해 줘.

                [반려동물 정보]
                - 종/유형(type): %s
                - 커스텀 타입(customType): %s
                - 품종(breed): %s
                - 종합 설명: %s
                - 체중(kg): %s
                - 나이(살): %s
                - 성별: %s

                [응답 형식]
                JSON으로만 답변해.
                {
                  "recommendedKm": 숫자,
                  "reason": "한국어 설명 텍스트"
                }

                [조건]
                1) recommendedKm는 0.5 이상, 10.0 이하의 값으로 정해.
                2) 나이, 체중, 품종(또는 타입), 성별을 고려해서
                   왜 그 거리로 추천했는지 reason에 한국어로 구체적으로 설명해.
                3) JSON 이외의 불필요한 텍스트는 절대 쓰지 마.
                """.formatted(
                type,
                customType,
                breed,
                speciesDesc,
                weightValue,
                ageValue,
                gender
        );

        AiWalkRecommendResult aiResult = chatClient
                .prompt()
                .user(prompt)
                .call()
                .entity(AiWalkRecommendResult.class);

        double km = aiResult.recommendedKm();
        if (km < 0.5) km = 0.5;
        if (km > 10.0) km = 10.0;

        WalkRecommendResponse res = new WalkRecommendResponse();
        res.setPet(pet);
        res.setRecommendedKm(km);
        res.setReason(aiResult.reason());
        return res;
    }

    private String safeString(String s) {
        return (s == null || s.isBlank()) ? "알 수 없음" : s;
    }

    /**
     * type/customType/breed 조합해서 "강아지 / 품종: 사모예드" 같은 설명 생성
     */
    private String buildSpeciesDesc(String type, String customType, String breed) {
        String typeKorean;
        switch (type) {
            case "DOG" -> typeKorean = "강아지";
            case "CAT" -> typeKorean = "고양이";
            case "ETC" -> typeKorean = "기타";
            default -> typeKorean = type;
        }

        String ct = safeString(customType);
        String br = safeString(breed);

        StringBuilder sb = new StringBuilder();
        sb.append(typeKorean);

        if (!"알 수 없음".equals(ct)) {
            sb.append(" / 커스텀: ").append(ct);
        }
        if (!"알 수 없음".equals(br)) {
            sb.append(" / 품종: ").append(br);
        }

        return sb.toString();
    }
}
