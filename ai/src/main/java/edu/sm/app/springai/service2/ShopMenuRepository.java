package edu.sm.app.springai.service2;

import edu.sm.app.dto.ShopMenuItem;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ShopMenuRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;

    private static final RowMapper<ShopMenuItem> ROW_MAPPER = (rs, rowNum) -> ShopMenuItem.builder()
            .id(rs.getLong("menu_id"))
            .category(rs.getString("category_name"))
            .menuName(rs.getString("menu_name"))
            .price(rs.getInt("menu_price"))
            .imageName(rs.getString("menu_image"))
            .build();

    public List<ShopMenuItem> findAll() {
        String sql = "SELECT m.menu_id, c.category_name, m.menu_name, m.menu_price, m.menu_image " +
                "FROM menu m JOIN category c ON m.category_id = c.category_id " +
                "ORDER BY c.category_id, m.menu_id";
        return jdbcTemplate.query(sql, new HashMap<>(), ROW_MAPPER);
    }
}