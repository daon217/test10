package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerCarePlan {
    private String review;
    private ReviewClassification.Sentiment sentiment;
    private String priority;
    private String owner;
    private String automationTrigger;
    private List<String> followUpActions;
}