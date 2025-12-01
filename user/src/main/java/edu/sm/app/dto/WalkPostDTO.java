package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WalkPostDTO {
    private Integer postId;
    private Integer userId;
    private Integer petId;

    private String category; // OWNER, WORKER, TOGETHER
    private String title;
    private String content;

    private String location;
    private String walkDate; // String으로 받아서 처리 (yyyy-MM-dd)
    private String walkTime;

    private String walkStartTime; // 폼 데이터 수신용
    private String walkEndTime; // 폼 데이터 수신용

    private Integer payAmount;
    private String status; // RECRUITING, COMPLETED
    private Integer viewCount;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인된 정보 (작성자)
    private String userName;
    private String userProfileImage;

    // 조인된 정보 (펫)
    private String petName;
    private String petType;
    private String petBreed;
    private Integer petAge;
    private Double petWeight; // DB는 DECIMAL(5,2)
    private String petPhoto;
    private String petGender;

    private MultipartFile petImage; // 이미지 업로드용
}
