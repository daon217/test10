package edu.sm.app.service;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
@Slf4j
@RequiredArgsConstructor
public class WalkJobSessionService {

    private final CurrentUserService currentUserService;   // ★ 추가

    // 데모: roomId 하나만 쓴다고 가정 ("demo")
    private final List<SseEmitter> ownerEmitters = new CopyOnWriteArrayList<>();
    private final List<Point> routePoints = new ArrayList<>();

    private Instant startTime = null;
    private double totalDistanceKm = 0.0;

    // ★ 현재 산책 세션의 "반려인 userId" 저장
    private Integer ownerUserId = null;

    public SseEmitter subscribeOwner() {
        SseEmitter emitter = new SseEmitter(0L); // 타임아웃 없음
        ownerEmitters.add(emitter);

        emitter.onCompletion(() -> ownerEmitters.remove(emitter));
        emitter.onTimeout(() -> ownerEmitters.remove(emitter));
        emitter.onError(e -> ownerEmitters.remove(emitter));

        // ★ 최초 구독 시 현재 로그인 유저를 반려인으로 기억
        if (ownerUserId == null) {
            try {
                ownerUserId = currentUserService.getCurrentUserIdOrThrow();
                log.info("산책알바 반려인 userId={}", ownerUserId);
            } catch (Exception e) {
                log.warn("반려인 SSE 구독 시 현재 사용자 조회 실패", e);
            }
        }

        // 연결 직후 현재 상태 한번 보내기 (선택)
        try {
            emitter.send(SseEmitter.event()
                    .name("init")
                    .data(new WalkUpdate(totalDistanceKm, 0L, new ArrayList<>(routePoints))));
        } catch (IOException e) {
            log.warn("SSE init send failed", e);
        }

        return emitter;
    }

    /** 알바생이 위치/거리 업데이트 보내면, 반려인에게 SSE로 브로드캐스트 */
    public void publishUpdate(double lat, double lon, double distanceKm, long elapsedSec) {
        if (startTime == null) {
            startTime = Instant.now();
        }
        totalDistanceKm = distanceKm;
        routePoints.add(new Point(lat, lon));

        WalkUpdate update = new WalkUpdate(distanceKm, elapsedSec, new ArrayList<>(routePoints));

        List<SseEmitter> dead = new ArrayList<>();
        for (SseEmitter emitter : ownerEmitters) {
            try {
                emitter.send(SseEmitter.event()
                        .name("update")
                        .data(update));
            } catch (Exception e) {
                dead.add(emitter);
            }
        }
        ownerEmitters.removeAll(dead);
    }

    /** 산책 종료 시 스냅샷 반환 후, 메모리 상태 초기화 */
    public WalkSnapshot finish() {
        WalkSnapshot snap = new WalkSnapshot();
        snap.setDistanceKm(totalDistanceKm);
        snap.setPoints(new ArrayList<>(routePoints));
        snap.setStartTime(startTime);
        snap.setEndTime(Instant.now());
        snap.setOwnerUserId(ownerUserId);  // ★ 반려인 userId 함께 반환

        // 종료 이벤트 보내기
        for (SseEmitter emitter : ownerEmitters) {
            try {
                emitter.send(SseEmitter.event().name("finish").data(snap));
                emitter.complete();
            } catch (Exception e) {
                // ignore
            }
        }
        ownerEmitters.clear();
        routePoints.clear();
        totalDistanceKm = 0.0;
        startTime = null;
        ownerUserId = null;  // ★ 세션 초기화

        return snap;
    }

    @Data
    @AllArgsConstructor
    public static class Point {
        private double lat;
        private double lon;
    }

    @Data
    @AllArgsConstructor
    public static class WalkUpdate {
        private double distanceKm;
        private long elapsedSec;
        private List<Point> points;
    }

    @Data
    public static class WalkSnapshot {
        private double distanceKm;
        private List<Point> points;
        private Instant startTime;
        private Instant endTime;
        private Integer ownerUserId;   // ★ 추가
    }
}
