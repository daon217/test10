package edu.sm.app.service;

import edu.sm.app.dto.ZoneState;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class EnvironmentService {

    private Map<Integer, ZoneState> zones = new ConcurrentHashMap<>();

    // --- [설정값] ---
    private final double TARGET_TEMP = 22.5; // 목표 온도
    private final double TARGET_HUM = 50.0;  // 목표 습도

    // 작동 시작 기준 (트리거)
    private final double HEAT_START_LIMIT = 21.0; // 21도 미만이면 난방 시작
    private final double COOL_START_LIMIT = 24.0; // 24도 초과하면 냉방 시작

    private final double HUM_START_LIMIT = 40.0;  // 40% 미만이면 가습 시작
    private final double DEHUM_START_LIMIT = 60.0;// 60% 초과하면 제습 시작

    @PostConstruct
    public void init() {
        // 서버 시작 시 1~5구역 랜덤 초기화
        for (int i = 1; i <= 5; i++) {
            // 온도: 15.0 ~ 30.0도 사이 랜덤
            double startTemp = 15.0 + (Math.random() * 15.0);

            // 습도: 30.0 ~ 70.0% 사이 랜덤
            double startHum = 30.0 + (Math.random() * 40.0);

            // 깔끔하게 소수점 1자리로 반올림
            startTemp = Math.round(startTemp * 10) / 10.0;
            startHum = Math.round(startHum * 10) / 10.0;

            zones.put(i, new ZoneState(i, startTemp, startHum, false, false, false, false, "시스템 시작"));
        }
    }

    public List<ZoneState> getLinkData() {
        return new ArrayList<>(zones.values());
    }

    // 1분(60000ms)마다 실행
    @Scheduled(fixedRate = 60000)
    public void simulateEnvironment() {
        for (int i = 1; i <= 5; i++) {
            ZoneState z = zones.get(i);

            // 1. AI 판단 (장치 끄고 켜기)
            controlTemperature(z);
            controlHumidity(z);

            // 2. 판단된 상태를 기반으로 메시지 새로고침
            refreshStatusMessage(z);

            // 3. 물리적 환경 변화 (온습도 변경)
            applyPhysics(z);

            // [로그 확인]
            System.out.println("[구역 " + i + "] Temp: " + String.format("%.1f", z.getTemp()) +
                    " (AC:" + z.isAc() + ", Heat:" + z.isHeater() + "), Msg: " + z.getMsg());
        }
    }

    private void controlTemperature(ZoneState z) {
        // 에어컨 제어
        if (z.isAc()) {
            if (z.getTemp() <= TARGET_TEMP) z.setAc(false);
        } else {
            if (z.getTemp() > COOL_START_LIMIT) {
                z.setAc(true);
                z.setHeater(false);
            }
        }

        // 히터 제어
        if (z.isHeater()) {
            if (z.getTemp() >= TARGET_TEMP) z.setHeater(false);
        } else {
            if (z.getTemp() < HEAT_START_LIMIT) {
                z.setHeater(true);
                z.setAc(false);
            }
        }
    }

    private void controlHumidity(ZoneState z) {
        // 제습기 제어
        if (z.isDehumidifier()) {
            if (z.getHum() <= TARGET_HUM) z.setDehumidifier(false);
        } else {
            if (z.getHum() > DEHUM_START_LIMIT) {
                z.setDehumidifier(true);
                z.setHumidifier(false);
            }
        }

        // 가습기 제어
        if (z.isHumidifier()) {
            if (z.getHum() >= TARGET_HUM) z.setHumidifier(false);
        } else {
            if (z.getHum() < HUM_START_LIMIT) {
                z.setHumidifier(true);
                z.setDehumidifier(false);
            }
        }
    }

    private void refreshStatusMessage(ZoneState z) {
        List<String> actives = new ArrayList<>();

        if (z.isAc()) actives.add("냉방");
        if (z.isHeater()) actives.add("난방");
        if (z.isHumidifier()) actives.add("가습");
        if (z.isDehumidifier()) actives.add("제습");

        if (actives.isEmpty()) {
            z.setMsg("쾌적함 유지 중");
        } else {
            z.setMsg(String.join(", ", actives) + " 가동 중");
        }
    }

    private void applyPhysics(ZoneState z) {
        // 장치 작동 시 변화량
        if (z.isAc()) z.setTemp(z.getTemp() - 0.5);
        else if (z.isHeater()) z.setTemp(z.getTemp() + 0.5);
        else z.setTemp(z.getTemp() + (Math.random() - 0.5) * 0.1); // 자연 변동

        if (z.isHumidifier()) z.setHum(z.getHum() + 2.0);
        else if (z.isDehumidifier()) z.setHum(z.getHum() - 2.0);
        else z.setHum(z.getHum() + (Math.random() - 0.5) * 0.5); // 자연 변동
    }
}