package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Pet {
    private Integer petId;
    private Integer userId;
    private String name;
    private String type; // DOG, CAT, ETC
    private String customType; // 기타 선택 시 직접 입력값
    private String breed;
    private String gender; // MALE, FEMALE
    private Integer age;
    private BigDecimal weight;
    private String photo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}