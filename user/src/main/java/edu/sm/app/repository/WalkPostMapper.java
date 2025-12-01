package edu.sm.app.repository;

import edu.sm.app.dto.WalkPostDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface WalkPostMapper {
    // 글 작성
    int insert(WalkPostDTO walkPost);

    // 글 상세 조회
    WalkPostDTO selectById(Integer postId);

    // 글 목록 조회 (검색 조건 포함 가능)
    List<WalkPostDTO> selectList(WalkPostDTO searchCondition);

    // 글 수정
    int update(WalkPostDTO walkPost);

    // 글 삭제
    int delete(Integer postId);

    // 조회수 증가
    int updateViewCount(Integer postId);
}
