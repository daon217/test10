package edu.sm.app.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ShopOrderResponse {

    private String status;

    private String message;

    @JsonProperty("orderData")
    private OrderData orderData = new OrderData();

    private List<String> unavailableItems = new ArrayList<>();

    private List<String> clarificationQuestions = new ArrayList<>();

    private List<MenuCategory> menuCategories = new ArrayList<>();

    @JsonProperty("raw_response")
    private String rawResponse;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public static class OrderData {

        @JsonProperty("order_items")
        private List<OrderItem> orderItems = new ArrayList<>();
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public static class OrderItem {

        @JsonProperty("menu_name")
        private String menuName;

        private Integer quantity;

        private Integer price;

        @JsonProperty("image_name")
        private String imageName;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public static class MenuCategory {

        private String category;

        @JsonProperty("items")
        private List<ShopMenuItem> items = new ArrayList<>();
    }
}