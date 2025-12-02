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
    // 🔹 추가: 알림용, 알바생용 SSE
    private final List<AlertClient> alertEmitters = new CopyOnWriteArrayList<>();
    private final List<SseEmitter> workerEmitters = new CopyOnWriteArrayList<>();

    // 🔹 추가: 마지막 경과 시간, 상태
    private long lastElapsedSec = 0L;

    public enum Status {
        IDLE,           // 산책 안 함
        WALKING,        // 산책 중
        FINISH_REQUESTED, // 알바생이 종료 버튼 눌러서 승인 대기 중
        FINISHED
    }

    private Status status = Status.IDLE;

    // ★ 현재 산책 세션의 "반려인 userId" 저장
    private Integer ownerUserId = null;

    public SseEmitter subscribeOwner() {
        SseEmitter emitter = new SseEmitter(0L);
        ownerEmitters.add(emitter);

        emitter.onCompletion(() -> ownerEmitters.remove(emitter));
        emitter.onTimeout(() -> ownerEmitters.remove(emitter));
        emitter.onError(e -> ownerEmitters.remove(emitter));

        if (ownerUserId == null) {
            try {
                ownerUserId = currentUserService.getCurrentUserIdOrThrow();
                log.info("산책알바 반려인 userId={}", ownerUserId);
            } catch (Exception e) {
                log.warn("반려인 SSE 구독 시 현재 사용자 조회 실패", e);
            }
        }

        // 🔹 init 이벤트에 lastElapsedSec도 넘겨줌 (페이스/시간 복구용)
        try {
            emitter.send(SseEmitter.event()
                    .name("init")
                    .data(new WalkUpdate(totalDistanceKm, lastElapsedSec, new ArrayList<>(routePoints))));
        } catch (IOException e) {
            log.warn("SSE init send failed", e);
        }

        return emitter;
    }

    public SseEmitter subscribeAlerts() {
        SseEmitter emitter = new SseEmitter(0L);

        Integer uid = null;
        try {
            uid = currentUserService.getCurrentUserIdOrThrow();
        } catch (Exception e) {
            log.warn("alerts-stream 구독 시 현재 사용자 조회 실패", e);
        }

        AlertClient client = new AlertClient(emitter, uid);
        alertEmitters.add(client);

        emitter.onCompletion(() -> alertEmitters.remove(client));
        emitter.onTimeout(() -> alertEmitters.remove(client));
        emitter.onError(e -> alertEmitters.remove(client));

        return emitter;
    }

    // 🔹 알바생 화면용 (산책 종료 확정 알림)
    public SseEmitter subscribeWorker() {
        SseEmitter emitter = new SseEmitter(0L);
        workerEmitters.add(emitter);

        emitter.onCompletion(() -> workerEmitters.remove(emitter));
        emitter.onTimeout(() -> workerEmitters.remove(emitter));
        emitter.onError(e -> workerEmitters.remove(emitter));

        return emitter;
    }

    public void publishUpdate(double lat, double lon, double distanceKm, long elapsedSec) {
        if (startTime == null) {
            startTime = Instant.now();
        }
        totalDistanceKm = distanceKm;
        lastElapsedSec = elapsedSec;
        status = Status.WALKING;

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

    public void requestFinish() {
        if (status != Status.WALKING && status != Status.FINISH_REQUESTED) {
            log.info("requestFinish 호출됐지만 WALKING 상태가 아님: {}", status);
            return;
        }

        status = Status.FINISH_REQUESTED;

        // 🔹 반려인 userId가 없으면 알림 보낼 대상이 없음
        if (ownerUserId == null) {
            log.warn("requestFinish 호출됐지만 ownerUserId 가 없음");
            return;
        }

        FinishRequestAlert alert = new FinishRequestAlert(totalDistanceKm, lastElapsedSec);

        List<AlertClient> dead = new ArrayList<>();
        for (AlertClient client : alertEmitters) {
            try {
                // 🟢 이 줄이 핵심: ownerUserId와 같은 유저에게만 finishRequest 이벤트 전송
                if (client.getUserId() != null && client.getUserId().equals(ownerUserId)) {
                    client.getEmitter().send(
                            SseEmitter.event()
                                    .name("finishRequest")
                                    .data(alert)
                    );
                }
            } catch (Exception e) {
                dead.add(client);
            }
        }
        alertEmitters.removeAll(dead);
    }


    @Data
    @AllArgsConstructor
    public static class FinishRequestAlert {
        private double distanceKm;
        private long elapsedSec;
    }

    public WalkSnapshot finish() {
        // 🔹 elapsedSec 없으면 start/endTime으로 계산
        long elapsed = this.lastElapsedSec;
        if (elapsed <= 0 && startTime != null) {
            elapsed = (long) (Instant.now().getEpochSecond() - startTime.getEpochSecond());
        }

        WalkSnapshot snap = new WalkSnapshot();
        snap.setDistanceKm(totalDistanceKm);
        snap.setPoints(new ArrayList<>(routePoints));
        snap.setStartTime(startTime);
        snap.setEndTime(Instant.now());
        snap.setOwnerUserId(ownerUserId);
        snap.setElapsedSec(elapsed);
        snap.setStatus(Status.FINISHED.name());

        status = Status.FINISHED;

        // 🔹 finish 이벤트를 owner + worker + alert 모두에게 보냄
        for (SseEmitter emitter : ownerEmitters) {
            try {
                emitter.send(SseEmitter.event().name("finish").data(snap));
                emitter.complete();
            } catch (Exception e) { /* ignore */ }
        }
        for (SseEmitter emitter : workerEmitters) {
            try {
                emitter.send(SseEmitter.event().name("finish").data(snap));
                emitter.complete();
            } catch (Exception e) { /* ignore */ }
        }
        for (AlertClient client : alertEmitters) {
            try {
                SseEmitter emitter = client.getEmitter();
                if (emitter != null) {
                    emitter.send(SseEmitter.event().name("finish").data(snap));
                    emitter.complete();
                }
            } catch (Exception e) { /* ignore */ }
        }

        ownerEmitters.clear();
        workerEmitters.clear();
        alertEmitters.clear();
        routePoints.clear();
        totalDistanceKm = 0.0;
        startTime = null;
        ownerUserId = null;
        lastElapsedSec = 0L;
        status = Status.IDLE;

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
        // 🔹 추가
        private long elapsedSec;
        private String status;  // IDLE / WALKING / FINISH_REQUESTED / FINISHED
    }

    public WalkSnapshot getSnapshot() {
        WalkSnapshot snap = new WalkSnapshot();
        snap.setDistanceKm(totalDistanceKm);
        snap.setPoints(new ArrayList<>(routePoints));
        snap.setStartTime(startTime);
        snap.setEndTime(null);
        snap.setOwnerUserId(ownerUserId);
        snap.setElapsedSec(lastElapsedSec);
        snap.setStatus(status.name());
        return snap;
    }
    // 🔹 알림 클라이언트
    @Data
    @AllArgsConstructor
    public static class AlertClient {
        private SseEmitter emitter;
        private Integer userId; // 이 emitter를 열고 있는 유저
    }
}
