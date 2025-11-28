package edu.sm.app.dto;

import edu.sm.app.service.MapRouteService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VoiceRouteResponse {

    // STT 결과
    private String originalText;

    // 해석된 모양 타입 (heart / circle 등)
    private String shapeType;

    // 사용자가 말한 목표 거리(km)
    private double targetKm;

    // 실제 생성된 코스 정보
    private List<MapRouteService.GeoPoint> points;
    private double distanceKm;
    private double estimatedMinutes;

    // 안내 멘트 TTS (base64 mp3)
    private String ttsAudio;
}
