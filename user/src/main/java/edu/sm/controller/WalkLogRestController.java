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

    /** 산책 코스 저장 */
    @PostMapping("/logs")
    public WalkLogSaveResponse saveLog(@RequestBody WalkLogSaveRequest req) throws Exception {
        return walkLogService.save(req);
    }

    /** 저장된 코스 목록 */
    @GetMapping("/logs")
    public List<WalkLogSummaryResponse> listLogs() {
        return walkLogService.getListForCurrentUser();
    }

    /** 특정 코스의 실제 좌표를 다시 가져오기 (navRoute.jsp 에서 사용) */
    @GetMapping("/logs/{id}")
    public RouteResponse getLogRoute(@PathVariable long id) throws Exception {

        WalkLogDto log = walkLogService.getOne(id);

        // DB에 저장해둔 route_data(JSON) → GeoPoint[] 로 역직렬화
        MapRouteService.GeoPoint[] arr =
                objectMapper.readValue(log.getRouteData(), MapRouteService.GeoPoint[].class);

        List<MapRouteService.GeoPoint> points = Arrays.asList(arr);

        // 예상 시간은 거리 기준으로 다시 계산 (서비스와 동일한 로직 사용해도 OK)
        double distanceKm = log.getDistanceKm();
        double estimatedMinutes = (distanceKm <= 0)
                ? 1
                : (distanceKm / 4.0) * 60.0;

        return new RouteResponse(
                "saved",
                points,
                distanceKm,
                estimatedMinutes
        );
    }
}
