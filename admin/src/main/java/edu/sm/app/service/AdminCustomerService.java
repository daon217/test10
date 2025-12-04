package edu.sm.app.service;

import edu.sm.app.dto.CustomerInquiry;
import edu.sm.app.repository.CustomerInquiryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminCustomerService {

    private final CustomerInquiryMapper inquiryMapper;

    public List<CustomerInquiry> getAllInquiries() {
        return inquiryMapper.findAll();
    }
}
