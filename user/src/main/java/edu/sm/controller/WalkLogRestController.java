package edu.sm.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.*;
import edu.sm.app.service.MapRouteService;
import edu.sm.app.service.WalkLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api/walk")
@RequiredArgsConstructor
public class WalkLogRestController {

    private final WalkLogService walkLogService;
    private final ObjectMapper objectMapper;

    /** 산책 코스 저장 (일반 / 모양 공통) */
    @PostMapping("/logs")
    public WalkLogSaveResponse saveLog(@RequestBody WalkLogSaveRequest req) throws Exception {
        return walkLogService.save(req);
    }

    /** 현재 로그인 유저의 저장된 코스 목록 */
    @GetMapping("/logs")
    public List<WalkLogSummaryResponse> listLogs() {
        return walkLogService.getListForCurrentUser();
    }

    /**
     * 특정 코스의 "네비용 경로" 다시 가져오기
     *  - 일반 산책 : 실제 걸은 코스(walked)를 기준으로 distance/route_data 저장되어 있음
     *  - 모양 산책 : 도형(계획) 코스(planned)를 기준으로 distance/route_data 저장되어 있음
     *  => 여기서는 레거시 컬럼(route_data)을 그대로 사용
     */
    @GetMapping("/logs/{id}")
    public RouteResponse getLogRoute(@PathVariable long id) throws Exception {

        WalkLogDto log = walkLogService.getOne(id);

        // DB에 저장된 route_data(JSON) → GeoPoint[] 로 역직렬화
        MapRouteService.GeoPoint[] arr =
                objectMapper.readValue(log.getRouteData(), MapRouteService.GeoPoint[].class);

        List<MapRouteService.GeoPoint> points = Arrays.asList(arr);

        double distanceKm = (log.getDistanceKm() != null) ? log.getDistanceKm() : 0.0;
        double estimatedMinutes = (distanceKm <= 0)
                ? 1
                : (distanceKm / 4.0) * 60.0;

        // type은 shapeType이 있으면 그걸, 없으면 "saved"
        String type = (log.getShapeType() != null && !log.getShapeType().isBlank())
                ? log.getShapeType()
                : "saved";

        return new RouteResponse(
                type,
                points,
                distanceKm,
                estimatedMinutes
        );
    }
}
