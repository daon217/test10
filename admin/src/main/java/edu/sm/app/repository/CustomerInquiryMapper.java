package edu.sm.app.repository;

import edu.sm.app.dto.CustomerInquiry;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CustomerInquiryMapper {
    List<CustomerInquiry> findAll();
}
