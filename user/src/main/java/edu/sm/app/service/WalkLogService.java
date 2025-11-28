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

    // ⬇⬇⬇ 여기만 변경됨
    private final WalkLogMapper walkLogMapper;
    private final ObjectMapper objectMapper;

    // 로그인 전까지는 하드코딩
    private static final int FIXED_USER_ID = 1;
    private static final double WALK_SPEED_KMH = 4.0; // 평균 보행속도

    /** ISO 문자열(…Z) → LocalDateTime(서버 타임존) */
    private LocalDateTime parseIsoToLocal(String iso) {
        Instant inst = Instant.parse(iso); // "2025-11-26T02:13:58.926Z" 이런 형식
        return LocalDateTime.ofInstant(inst, ZoneId.systemDefault());
    }

    /** 산책 코스 저장 */
    public WalkLogSaveResponse save(WalkLogSaveRequest req) throws Exception {

        LocalDateTime start = parseIsoToLocal(req.getStartTimeIso());
        LocalDateTime end   = parseIsoToLocal(req.getEndTimeIso());

        WalkLogDto log = new WalkLogDto();
        log.setUserId(FIXED_USER_ID);
        log.setStartTime(start);
        log.setEndTime(end);
        log.setDistanceKm(req.getDistanceKm());

        // 코스 좌표를 JSON으로 직렬화
        String json = objectMapper.writeValueAsString(req.getPoints());
        log.setRouteData(json);

        // ⬇⬇⬇ Repository 대신 Mapper 직접 호출
        walkLogMapper.insert(log);  // useGeneratedKeys 로 PK 세팅됨

        long minutes = calcMinutesByDistance(req.getDistanceKm());
        return new WalkLogSaveResponse(
                log.getWalkingRecodeId(),
                req.getDistanceKm(),
                minutes
        );
    }

    /** 현재(하드코딩) 유저의 코스 목록 */
    public List<WalkLogSummaryResponse> getListForCurrentUser() {

        List<WalkLogDto> list = walkLogMapper.findByUserId(FIXED_USER_ID);

        return list.stream()
                .map(l -> {
                    long minutes = calcMinutesByDistance(l.getDistanceKm());
                    String date = l.getStartTime().toLocalDate().toString();
                    return new WalkLogSummaryResponse(
                            l.getWalkingRecodeId(),
                            l.getDistanceKm(),
                            date,
                            minutes
                    );
                })
                .collect(Collectors.toList());
    }

    /** 특정 id 의 로그 (현재 유저 기준) */
    public WalkLogDto getOne(long id) {
        return walkLogMapper.findByIdAndUserId(id, FIXED_USER_ID);
    }

    /** 거리 기준으로 예상 시간(분) 계산 */
    private long calcMinutesByDistance(double distanceKm) {
        if (distanceKm <= 0) return 1;
        double minutesD = (distanceKm / WALK_SPEED_KMH) * 60.0;
        long minutes = Math.round(minutesD);
        return (minutes <= 0 ? 1 : minutes);
    }
}
