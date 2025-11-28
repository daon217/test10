package edu.sm.app.repository;

import edu.sm.app.dto.User;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserRepository extends SmRepository<User, Integer> {

    /**
     * 사용자명으로 사용자 조회
     */
    User selectByUsername(@Param("username") String username);

    /**
     * 비밀번호 변경
     */
    void updatePassword(@Param("userId") Integer userId, @Param("newPassword") String newPassword);

    /**
     * 마지막 로그인 시간 업데이트
     */
    void updateLastLogin(@Param("userId") Integer userId);

    /**
     * 아이디 중복 체크
     */
    boolean existsByUsername(@Param("username") String username);

    /**
     * 이메일 중복 체크
     */
    boolean existsByEmail(@Param("email") String email);

    /**
     * 역할별 사용자 수 조회
     */
    int countByRole(@Param("role") String role);
}