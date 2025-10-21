package edu.sm.app.repository;

import edu.sm.app.dto.MemberReview;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface ReviewRepository {

    List<MemberReview> findRecentReviews(int limit);
}