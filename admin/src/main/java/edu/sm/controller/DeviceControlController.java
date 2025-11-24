package edu.sm.controller;

import edu.sm.config.SignalingHandler;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/control")
public class DeviceControlController {

    /**
     * Admin UI에서 장치 제어 요청을 받아 웹소켓으로 방송합니다.
     * @param deviceId 제어할 장치의 ID (예: "Light_01", "AC_02")
     * @param state 변경할 상태 (예: "ON", "OFF", "HEAT")
     * @return 성공 응답
     */
    @PostMapping("/{deviceId}/{state}")
    public ResponseEntity<String> controlDevice(
            @PathVariable String deviceId,
            @PathVariable String state) {

        // Babylon.js 클라이언트에게 보낼 JSON 메시지 생성
        String commandMessage = String.format(
                "{\"type\": \"CONTROL_COMMAND\", \"deviceId\": \"%s\", \"state\": \"%s\"}",
                deviceId,
                state
        );

        // SignalingHandler를 통해 모든 연결된 클라이언트(시뮬레이션 화면)에게 메시지 전송
        SignalingHandler.sendMessageToAll(commandMessage);

        System.out.println("제어 명령 방송됨: " + commandMessage);

        return ResponseEntity.ok("Command broadcasted successfully");
    }
}