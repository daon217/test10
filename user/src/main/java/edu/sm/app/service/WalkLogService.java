package edu.sm.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.WalkLogDto;
import edu.sm.app.dto.WalkLogSaveRequest;
import edu.sm.app.dto.WalkLogSaveResponse;
import edu.sm.app.dto.WalkLogSummaryResponse;
import edu.sm.app.repository.WalkLogMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WalkLogService {

    private final WalkLogMapper walkLogMapper;
    private final ObjectMapper objectMapper;
    private final CurrentUserService currentUserService;  // ★ 세션 기반

    private static final double WALK_SPEED_KMH = 4.0;

    private LocalDateTime parseIsoToLocal(String iso) {
        Instant inst = Instant.parse(iso);
        return LocalDateTime.ofInstant(inst, ZoneId.systemDefault());
    }

    /**
     * 공통 저장 로직
     *  - userId를 파라미터로 받아서, 호출하는 쪽에서 "누구 기준으로 저장할지"를 결정
     *  - 여기서 "일반 산책 / 모양 산책" 로직을 나눈다.
     *
     *  규칙:
     *    1) 모양 산책 (shapeType != null/blank)
     *       - plannedRoute: 모양(도형) 경로
     *       - walkedRoute : 실제 이동 경로
     *       - distance/route_data (레거시 컬럼)는 "모양(계획) 경로" 기준으로 저장
     *
     *    2) 일반 산책 (shapeType == null/blank)
     *       - plannedRoute: 보통 null
     *       - walkedRoute : 실제 이동 경로
     *       - distance/route_data 는 "walked(실제)" 기준으로 저장
     */
    private WalkLogSaveResponse saveInternal(WalkLogSaveRequest req, int userId) throws Exception {

        LocalDateTime start = parseIsoToLocal(req.getStartTimeIso());
        LocalDateTime end   = parseIsoToLocal(req.getEndTimeIso());

        // ---- 1) 도형/실제 경로 분리 ----
        Double plannedDistanceKm = null;
        Double walkedDistanceKm  = null;
        String plannedRouteJson  = null;
        String walkedRouteJson   = null;

        if (req.getPlannedRoute() != null) {
            plannedDistanceKm = req.getPlannedRoute().getDistanceKm();
            if (req.getPlannedRoute().getPoints() != null) {
                plannedRouteJson =
                        objectMapper.writeValueAsString(req.getPlannedRoute().getPoints());
            }
        }

        if (req.getWalkedRoute() != null) {
            walkedDistanceKm = req.getWalkedRoute().getDistanceKm();
            if (req.getWalkedRoute().getPoints() != null) {
                walkedRouteJson =
                        objectMapper.writeValueAsString(req.getWalkedRoute().getPoints());
            }
        }

        // ---- 2) 일반 산책 vs 모양 산책 분기 ----
        boolean isShapeWalk = req.getShapeType() != null && !req.getShapeType().isBlank();

        Double distanceKmLegacy;
        String routeDataLegacy;

        if (isShapeWalk) {
            // 모양 산책:
            //  - 네비 / 요약에서 "모양 경로"를 기준으로 보이게 유지 (기존 로직 유지)
            distanceKmLegacy = (plannedDistanceKm != null) ? plannedDistanceKm : walkedDistanceKm;
            routeDataLegacy  = (plannedRouteJson != null) ? plannedRouteJson : walkedRouteJson;
        } else {
            // 일반 산책:
            //  - 사용자가 실제로 걸은 경로 기준으로 distance/route_data를 저장
            distanceKmLegacy = (walkedDistanceKm != null) ? walkedDistanceKm : plannedDistanceKm;
            routeDataLegacy  = (walkedRouteJson != null) ? walkedRouteJson : plannedRouteJson;
        }

        // 혹시라도 둘 다 null이면 최소 안전값으로
        if (distanceKmLegacy == null) {
            distanceKmLegacy = 0.0;
        }
        if (routeDataLegacy == null) {
            routeDataLegacy = "[]";
        }

        // ---- 3) DTO 구성 ----
        WalkLogDto log = new WalkLogDto();
        log.setUserId(userId);
        log.setStartTime(start);
        log.setEndTime(end);

        // 레거시 컬럼
        log.setDistanceKm(distanceKmLegacy);
        log.setRouteData(routeDataLegacy);

        // 신규 컬럼
        log.setPlannedDistanceKm(plannedDistanceKm);
        log.setWalkedDistanceKm(walkedDistanceKm);
        log.setPlannedRouteData(plannedRouteJson);
        log.setWalkedRouteData(walkedRouteJson);
        log.setShapeType(req.getShapeType());
        log.setTargetKm(req.getTargetKm());

        // ---- 4) INSERT ----
        walkLogMapper.insert(log);

        double d = distanceKmLegacy;
        long minutes = calcMinutesByDistance(d);
        return new WalkLogSaveResponse(
                log.getWalkingRecodeId(),
                d,
                minutes
        );
    }

    /**
     * 산책 코스 저장 (기존 방식 + 확장)
     *  - 현재 로그인된 사용자 기준
     *  - 프론트에서
     *      * 모양 산책: shapeType + plannedRoute + walkedRoute
     *      * 일반 산책: shapeType = null, plannedRoute = null, walkedRoute 만 채움
     */
    public WalkLogSaveResponse save(WalkLogSaveRequest req) throws Exception {

        int userId = currentUserService.getCurrentUserIdOrThrow();
        return saveInternal(req, userId);
    }

    /**
     * 산책 코스 저장 (특정 userId 기준)
     *  - 산책알바 종료 시, 반려인(owner)의 userId를 넘겨서 사용
     */
    public WalkLogSaveResponse saveForUser(WalkLogSaveRequest req, int userId) throws Exception {
        return saveInternal(req, userId);
    }

    /** 현재 로그인 유저의 코스 목록 */
    public List<WalkLogSummaryResponse> getListForCurrentUser() {

        int userId = currentUserService.getCurrentUserIdOrThrow();
        List<WalkLogDto> list = walkLogMapper.findByUserId(userId);

        return list.stream()
                .map(l -> {
                    double dist = (l.getDistanceKm() != null ? l.getDistanceKm() : 0.0);
                    long minutes = calcMinutesByDistance(dist);
                    String date = l.getStartTime().toLocalDate().toString();
                    return new WalkLogSummaryResponse(
                            l.getWalkingRecodeId(),
                            dist,
                            date,
                            minutes
                    );
                })
                .collect(Collectors.toList());
    }

    /** 특정 코스 한 개 (로그인 유저 기준) */
    public WalkLogDto getOne(long id) {
        int userId = currentUserService.getCurrentUserIdOrThrow();
        return walkLogMapper.findByIdAndUserId(id, userId);
    }

    private long calcMinutesByDistance(double distanceKm) {
        if (distanceKm <= 0) return 1;
        double minutesD = (distanceKm / WALK_SPEED_KMH) * 60.0;
        long minutes = Math.round(minutesD);
        return (minutes <= 0 ? 1 : minutes);
    }
}
