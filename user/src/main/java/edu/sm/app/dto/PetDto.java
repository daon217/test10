package edu.sm.app.dto;

import lombok.Data;

@Data
public class PetDto {
    private Integer petId;
    private String petName;
    private String species;
    private Double weight;
    private Integer age;
    private String gender;
    private Integer userId;
}
