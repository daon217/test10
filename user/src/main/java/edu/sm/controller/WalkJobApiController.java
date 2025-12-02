package edu.sm.controller;

import edu.sm.app.dto.WalkLogSaveRequest;
import edu.sm.app.dto.WalkLogSaveResponse;
import edu.sm.app.service.WalkJobSessionService;
import edu.sm.app.service.WalkLogService;
import jakarta.servlet.http.HttpSession;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/walkjob")
public class WalkJobApiController {

    private final WalkJobSessionService sessionService;
    private final WalkLogService walkLogService;

    /** 반려인: SSE 구독 */
    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter stream() {
        log.info("산책알바 SSE 구독 요청");
        return sessionService.subscribeOwner();
    }

    /** 알바생: 위치/거리 업데이트 전송 */
    @PostMapping("/update")
    public void update(@RequestBody WalkUpdateRequest req) {
        log.debug("산책알바 업데이트: lat={}, lon={}, dist={}",
                req.getLat(), req.getLon(), req.getDistanceKm());
        sessionService.publishUpdate(req.getLat(), req.getLon(),
                req.getDistanceKm(), req.getElapsedSec());
    }

    /** 산책 종료 → walk_log에 저장 */
    @PostMapping("/finish")
    public WalkLogSaveResponse finish(HttpSession httpSession) throws Exception {
        log.info("산책알바 종료 요청");

        // 1) 세션 서비스에서 스냅샷 가져오기
        WalkJobSessionService.WalkSnapshot snap = sessionService.finish();

        // 2) WalkLogSaveRequest로 변환하여 기존 저장 로직 재사용
        WalkLogSaveRequest req = new WalkLogSaveRequest();
        req.setShapeType("JOB");     // 산책알바 용도 표시용
        req.setTargetKm(snap.getDistanceKm()); // 목표 거리 = 실제 거리로

        String startIso = DateTimeFormatter.ISO_INSTANT.format(
                snap.getStartTime() != null ? snap.getStartTime() : Instant.now());
        String endIso = DateTimeFormatter.ISO_INSTANT.format(
                snap.getEndTime() != null ? snap.getEndTime() : Instant.now());

        req.setStartTimeIso(startIso);
        req.setEndTimeIso(endIso);

        // plannedRoute는 없이, walkedRoute만 저장
        WalkLogSaveRequest.RouteDto walked = new WalkLogSaveRequest.RouteDto();
        walked.setDistanceKm(snap.getDistanceKm());

        List<WalkJobSessionService.Point> pts = snap.getPoints();
        walked.setPoints(
                pts.stream()
                        .map(p -> {
                            WalkLogSaveRequest.PointDto dto = new WalkLogSaveRequest.PointDto();
                            dto.setLat(p.getLat());
                            dto.setLon(p.getLon());
                            return dto;
                        })
                        .toList()
        );
        req.setWalkedRoute(walked);

        // ★ 반려인 userId(세션 구독 시 저장된 값)를 사용해서 저장
        Integer ownerUserId = snap.getOwnerUserId();

        if (ownerUserId == null) {
            // 예외 상황 대비: ownerUserId가 없으면 기존 방식대로(현재 로그인 유저) 저장
            log.warn("WalkSnapshot에 ownerUserId가 없음 → 현재 로그인 유저로 저장");
            return walkLogService.save(req);
        } else {
            return walkLogService.saveForUser(req, ownerUserId);
        }
    }

    @Data
    public static class WalkUpdateRequest {
        private double lat;
        private double lon;
        private double distanceKm;
        private long elapsedSec;
    }

    // 기존 stream, update, finish 는 그대로 유지

    // 🔹 알바생용 SSE
    @GetMapping(value = "/worker-stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter workerStream() {
        log.info("산책알바 worker SSE 구독");
        return sessionService.subscribeWorker();
    }

    // 🔹 반려인 전역 알림용 SSE (index.jsp)
    @GetMapping(value = "/alerts-stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter alertsStream() {
        log.info("산책알바 alerts SSE 구독");
        return sessionService.subscribeAlerts();
    }

    // 🔹 알바생이 산책 종료 버튼을 눌렀을 때 (finish 요청만)
    @PostMapping("/finish-request")
    public void finishRequest() {
        log.info("산책알바 종료 요청 (알바생 → 반려인 승인 대기)");
        sessionService.requestFinish();
    }

    // 🔹 현재 세션 상태 조회 (알바생 화면 복구용)
    @GetMapping("/state")
    public WalkJobSessionService.WalkSnapshot state() {
        return sessionService.getSnapshot();
    }
}
