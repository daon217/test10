package edu.sm.app.service;

import edu.sm.app.dto.DiaryDTO;
import edu.sm.app.dto.WalkLogDto;
import edu.sm.app.repository.DiaryMapper;
import edu.sm.app.repository.WalkLogMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class DiaryService {

    private final DiaryMapper diaryMapper;
    private final WalkLogMapper walkLogMapper;

    public void add(DiaryDTO diary) throws Exception {
        diaryMapper.insert(diary);
    }

    public void modify(DiaryDTO diary) throws Exception {
        diaryMapper.update(diary);
    }

    public void remove(Integer id) throws Exception {
        diaryMapper.delete(id);
    }

    public void removeWalkLog(Integer id) throws Exception {
        walkLogMapper.delete(id);
    }

    public DiaryDTO get(Integer id) throws Exception {
        return diaryMapper.selectById(id);
    }

    public List<DiaryDTO> getByUserId(Integer userId) throws Exception {
        return diaryMapper.selectByUserId(userId);
    }

    /**
     * Fetches a merged timeline of manual diary entries and automatic walk logs for
     * a specific month.
     * 
     * @param userId    User ID
     * @param yearMonth Format: "YYYY-MM"
     * @param petId     Optional Pet ID for filtering
     * @return Sorted list of DiaryDTO
     */
    public List<DiaryDTO> getTimeline(Integer userId, String yearMonth, Integer petId) throws Exception {
        List<DiaryDTO> timeline = new ArrayList<>();

        // 1. Fetch Manual Entries (including Homecam events stored in Diary table)
        // We need to update mapper to support petId filtering
        List<DiaryDTO> manualEntries = diaryMapper.selectByUserIdAndMonth(userId, yearMonth, petId);
        for (DiaryDTO entry : manualEntries) {
            entry.setAuto("HOMECAM".equals(entry.getType()) || "HEALTH".equals(entry.getType())); // Assume these are
                                                                                                  // auto if type
                                                                                                  // matches
            timeline.add(entry);
        }

        // 2. Fetch Walk Logs and convert to DiaryDTO (Only if no specific pet filter is
        // applied, as walks are not pet-specific yet)
        // 2. Fetch Walk Logs and convert to DiaryDTO
        List<WalkLogDto> walkLogs = walkLogMapper.findByUserIdAndMonth(userId, yearMonth);
        for (WalkLogDto walk : walkLogs) {
            // Filter by petId if provided
            if (petId != null) {
                if (walk.getPetId() == null || !walk.getPetId().equals(petId)) {
                    continue;
                }
            }

            // Skip if essential data is missing
            if (walk.getWalkingRecodeId() == null || walk.getStartTime() == null) {
                continue;
            }

            DiaryDTO walkEntry = DiaryDTO.builder()
                    .id(walk.getWalkingRecodeId().intValue()) // Safe conversion after null check
                    .userId(walk.getUserId())
                    .type("walk")
                    .title("산책 기록")
                    .content(String.format("거리: %.2fkm, 시간: %s ~ %s",
                            walk.getDistanceKm() != null ? walk.getDistanceKm() : 0.0,
                            walk.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")),
                            walk.getEndTime() != null
                                    ? walk.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm"))
                                    : "00:00"))
                    .date(walk.getStartTime())
                    .isAuto(true)
                    .meta(walk.getWalkedRouteData()) // Pass route data for map display
                    .build();
            timeline.add(walkEntry);
        }

        // 3. Sort by Date Descending
        timeline.sort(Comparator.comparing(DiaryDTO::getDate).reversed());

        return timeline;
    }
}
