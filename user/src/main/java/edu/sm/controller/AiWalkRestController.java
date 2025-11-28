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
     */
    @GetMapping("/shape-route")
    public RouteResponse shapeRoute(
            @RequestParam String type,
            @RequestParam double centerLat,
            @RequestParam double centerLon,
            @RequestParam(required = false) Double targetKm) {

        MapRouteService.ShapeRouteResponse res;
        double usedSizeOrTarget;

        if (targetKm != null) {
            res = mapRouteService.getShapeRouteByTargetKm(type, centerLat, centerLon, targetKm);
            usedSizeOrTarget = targetKm;
        } else {
            // 옛날 sizeKm 방식 쓰고 싶으면 여기서 사용
            double sizeKm = 1.2;
            res = mapRouteService.getShapeRoute(type, centerLat, centerLon, sizeKm);
            usedSizeOrTarget = sizeKm;
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

