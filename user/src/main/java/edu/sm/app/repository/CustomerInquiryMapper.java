package edu.sm.app.repository;

import edu.sm.app.dto.CustomerInquiry;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CustomerInquiryMapper {
    void insert(CustomerInquiry inquiry);

    List<CustomerInquiry> findByUserId(@Param("userId") int userId);
}
