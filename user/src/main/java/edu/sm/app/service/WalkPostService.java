package edu.sm.app.service;

import edu.sm.app.dto.WalkPostDTO;
import edu.sm.app.repository.WalkPostMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class WalkPostService {

    private final WalkPostMapper walkPostMapper;

    /**
     * 게시글 등록
     */
    @Transactional
    public void register(WalkPostDTO walkPost) throws Exception {
        log.info("게시글 등록 - title: {}, userId: {}", walkPost.getTitle(), walkPost.getUserId());
        walkPostMapper.insert(walkPost);
        log.info("게시글 등록 성공 - postId: {}", walkPost.getPostId());
    }

    /**
     * 게시글 상세 조회 (조회수 증가 포함)
     */
    @Transactional
    public WalkPostDTO get(Integer postId) throws Exception {
        // 조회수 증가
        walkPostMapper.updateViewCount(postId);
        return walkPostMapper.selectById(postId);
    }

    /**
     * 게시글 상세 조회 (조회수 증가 없음 - 수정용)
     */
    public WalkPostDTO getForModify(Integer postId) throws Exception {
        return walkPostMapper.selectById(postId);
    }

    /**
     * 게시글 목록 조회
     */
    public List<WalkPostDTO> getList(WalkPostDTO searchCondition) throws Exception {
        return walkPostMapper.selectList(searchCondition);
    }

    /**
     * 게시글 수정
     */
    @Transactional
    public void modify(WalkPostDTO walkPost) throws Exception {
        log.info("게시글 수정 - postId: {}", walkPost.getPostId());
        walkPostMapper.update(walkPost);
    }

    /**
     * 게시글 삭제
     */
    @Transactional
    public void remove(Integer postId) throws Exception {
        log.info("게시글 삭제 - postId: {}", postId);
        walkPostMapper.delete(postId);
    }
}
