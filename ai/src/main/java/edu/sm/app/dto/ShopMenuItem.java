package edu.sm.app.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShopMenuItem {

    private Long id;

    private String category;

    @JsonProperty("menu_name")
    private String menuName;

    private Integer price;

    @JsonProperty("image_name")
    private String imageName;
}