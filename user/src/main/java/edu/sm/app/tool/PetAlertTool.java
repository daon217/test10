package edu.sm.app.tool;

import org.springframework.stereotype.Component;

/**
 * AI가 긴급 상황을 감지했을 때 보호자에게 즉시 알림을 보내는 툴입니다.
 * 실제로는 SMS, 푸시 알림, WebSocket 등을 통해 알림 API를 호출합니다.
 */
@Component
public class PetAlertTool {

    /**
     * 특정 반려동물의 보호자에게 긴급 알림 메시지를 전송합니다.
     * @param petId 알림 대상 반려동물 ID
     * @param message 전송할 경고 메시지
     * @return 알림 전송 결과
     */
    public String sendAlert(Long petId, String message) {
        String alertMessage = String.format("🚨 긴급 알림 (Pet ID: %d): %s", petId, message);

        // --- 실제 SMS/푸시 알림 API 호출 로직은 여기에 구현 ---

        // 콘솔 출력으로 전송 시뮬레이션
        System.out.println("=========================================");
        System.out.println("   보호자에게 긴급 알림 전송 완료 (시뮬레이션)");
        System.out.println(alertMessage);
        System.out.println("=========================================");

        return "SUCCESS: 보호자에게 긴급 알림이 성공적으로 전송되었습니다.";
    }
}