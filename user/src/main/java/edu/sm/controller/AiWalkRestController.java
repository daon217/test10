package edu.sm.controller;

import edu.sm.app.dto.RouteResponse;
import edu.sm.app.dto.VoiceRouteResponse;
import edu.sm.app.service.MapRouteService;
import edu.sm.app.service.VoiceRouteService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/map")
@RequiredArgsConstructor
public class AiWalkRestController {

    private final MapRouteService mapRouteService;
    private final VoiceRouteService voiceRouteService;

    /**
     * 기존: type + centerLat/centerLon + targetKm 로 하트 경로 생성
     *  - GET /api/map/shape-route?type=heart&centerLat=..&centerLon=..&targetKm=4.0
     *
     * 일반 산책 / 모양 산책 모드는 프론트에서 나누고,
     * 이 API는 "모양 산책"에서만 사용한다.
     */
    @GetMapping("/shape-route")
    public RouteResponse shapeRoute(
            @RequestParam String type,
            @RequestParam double centerLat,
            @RequestParam double centerLon,
            @RequestParam(required = false) Double targetKm) {

        MapRouteService.ShapeRouteResponse res;

        if (targetKm != null) {
            res = mapRouteService.getShapeRouteByTargetKm(type, centerLat, centerLon, targetKm);
        } else {
            double sizeKm = 1.2;
            res = mapRouteService.getShapeRoute(type, centerLat, centerLon, sizeKm);
        }

        // ★ 방어 코드: GraphHopper에서 경로 생성 실패 시 NPE 방지
        if (res == null || res.getPoints() == null || res.getPoints().isEmpty()) {
            return new RouteResponse(
                    type,
                    java.util.List.of(),
                    0.0,
                    0.0
            );
        }

        return new RouteResponse(
                type,
                res.getPoints(),
                res.getDistanceKm(),
                res.getEstimatedMinutes()
        );
    }

    /**
     * 새 기능: 음성으로 "하트 모양 3km" 요청해서 바로 경로 뽑기
     *  - POST /api/map/voice-route  (multipart form, 키 이름 speech)
     */
    @PostMapping("/voice-route")
    public VoiceRouteResponse voiceRoute(
            @RequestParam("speech") MultipartFile speech,
            @RequestParam(value = "centerLat", required = false) Double centerLat,
            @RequestParam(value = "centerLon", required = false) Double centerLon
    ) throws Exception {

        return voiceRouteService.handleVoiceRoute(speech, centerLat, centerLon);
    }
}
