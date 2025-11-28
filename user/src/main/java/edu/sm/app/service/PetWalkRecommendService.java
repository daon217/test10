package edu.sm.app.service;

import edu.sm.app.dto.AiWalkRecommendResult;
import edu.sm.app.dto.PetDto;
import edu.sm.app.dto.WalkRecommendResponse;
import edu.sm.app.repository.PetMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PetWalkRecommendService {

    private final PetMapper petMapper;
    private final ChatClient chatClient;

    // 로그인 전 임시 유저 ID (id01의 user_id = 1이라고 가정)
    private static final int FIXED_USER_ID = 1;

    public WalkRecommendResponse recommendForCurrentUser() {

        // 1) DB에서 반려동물 1마리 조회
        PetDto pet = petMapper.findMainPetByUserId(FIXED_USER_ID);
        if (pet == null) {
            throw new IllegalStateException("등록된 반려동물이 없습니다. pet 테이블에 더미 데이터를 하나 넣어주세요.");
        }

        // 2) 프롬프트 작성
        String prompt = """
                너는 수의사이자 반려동물 운동 코치야.
                아래 반려동물의 정보를 보고, 오늘 한 번 산책할 때 적절한 산책 거리(킬로미터)를 0.1 단위로 하나만 추천해.
                
                반드시 JSON 형식으로만 출력해:
                {
                  "recommendedKm": 3.2,
                  "reason": "간단한 한국어 설명"
                }
                
                기준(대략적인 가이드라인, 꼭 그대로가 아니어도 됨):
                - 체중 5kg 미만: 1.0 ~ 3.0 km
                - 5 ~ 10kg: 2.0 ~ 4.0 km
                - 10 ~ 20kg: 3.0 ~ 5.0 km
                - 20kg 이상: 4.0 ~ 7.0 km
                - 나이가 많거나 비만일 것 같으면 거리를 조금 줄이고, 어린 에너지 많은 개는 약간 늘려도 된다.
                
                반려동물 정보:
                - 종: %s
                - 몸무게(kg): %.1f
                - 나이(살): %d
                - 성별: %s
                """.formatted(
                nullToUnknown(pet.getSpecies()),
                pet.getWeight() == null ? 5.0 : pet.getWeight(),
                pet.getAge() == null ? 3 : pet.getAge(),
                nullToUnknown(pet.getGender())
        );

        // 3) Spring AI로 LLM 호출 + JSON -> DTO 매핑
        AiWalkRecommendResult aiResult = chatClient
                .prompt()
                .user(prompt)
                .call()
                .entity(AiWalkRecommendResult.class);

        double km = aiResult.recommendedKm();

        // 안전 범위(0.5~10km) 안으로 클램핑
        if (km < 0.5) km = 0.5;
        if (km > 10.0) km = 10.0;

        // 4) 최종 응답 조립
        WalkRecommendResponse res = new WalkRecommendResponse();
        res.setPet(pet);
        res.setRecommendedKm(km);
        res.setReason(aiResult.reason());
        return res;
    }

    private String nullToUnknown(String s) {
        return (s == null || s.isBlank()) ? "알 수 없음" : s;
    }
}
