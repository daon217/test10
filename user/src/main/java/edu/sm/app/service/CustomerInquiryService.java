package edu.sm.app.service;

import edu.sm.app.dto.CustomerInquiry;
import edu.sm.app.dto.User;
import edu.sm.app.repository.CustomerInquiryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CustomerInquiryService {

    private final CustomerInquiryMapper inquiryMapper;
    private final CurrentUserService currentUserService;

    public void submit(String category, String title, String content) {
        User user = currentUserService.getCurrentUserOrThrow();

        CustomerInquiry inquiry = CustomerInquiry.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .category(category)
                .title(title)
                .content(content)
                .status("PENDING")
                .build();

        inquiryMapper.insert(inquiry);
    }

    public List<CustomerInquiry> getMyInquiries() {
        int userId = currentUserService.getCurrentUserIdOrThrow();
        return inquiryMapper.findByUserId(userId);
    }
}
