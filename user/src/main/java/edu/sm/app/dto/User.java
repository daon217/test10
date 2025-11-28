package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Integer userId;
    private String username;
    private String password;
    private String name;
    private String email;
    private String phone;
    private String role; // OWNER, GENERAL, ADMIN
    private String profileImage;
    private LocalDateTime joinDate;
    private LocalDateTime lastLogin;
    private String status; // ACTIVE, LOCKED, DELETED
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 비밀번호 확인용 (DB 저장 X)
    private String passwordConfirm;

    /**
     * 가입일 포맷팅 (yyyy-MM-dd)
     */
    public String getFormattedJoinDate() {
        if (joinDate == null) return "";
        return joinDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    /**
     * 가입일 포맷팅 (yyyy년 MM월 dd일)
     */
    public String getFormattedJoinDateKorean() {
        if (joinDate == null) return "";
        return joinDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
    }

    /**
     * 마지막 로그인 포맷팅
     */
    public String getFormattedLastLogin() {
        if (lastLogin == null) return "없음";
        return lastLogin.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}