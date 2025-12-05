package edu.sm.app.repository;

import edu.sm.app.dto.DiaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface DiaryMapper {
    int insert(DiaryDTO diary);

    int update(DiaryDTO diary);

    int delete(Integer id);

    DiaryDTO selectById(Integer id);

    List<DiaryDTO> selectByUserId(Integer userId);

    List<DiaryDTO> selectByUserIdAndMonth(@Param("userId") Integer userId, @Param("yearMonth") String yearMonth,
            @Param("petId") Integer petId); // yearMonth format:
    // '2024-12'
}
