package edu.sm.app.repository;

import edu.sm.app.dto.WalkLogDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WalkLogMapper {

    // 1) INSERT – BIGSERIAL PK는 useGeneratedKeys로 채워짐
    void insert(WalkLogDto log);

    // 2) 특정 사용자 전체 코스 목록
    List<WalkLogDto> findByUserId(@Param("userId") int userId);

    // 3) 특정 사용자 + 코스 1개 조회
    WalkLogDto findByIdAndUserId(@Param("id") long id,
            @Param("userId") int userId);

    List<WalkLogDto> findByUserIdAndMonth(@Param("userId") int userId, @Param("yearMonth") String yearMonth);

    void delete(Integer id);
}
