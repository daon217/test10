package edu.sm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminCustomerController {

    @RequestMapping("/customer")
    public String adminCustomer(Model model) {
        // 추후 Service를 통해 DB에서 문의 내역을 가져와 모델에 담습니다.
        // List<Inquiry> inquiries = customerService.getAllInquiries();
        // model.addAttribute("inquiries", inquiries);

        // admin/src/main/webapp/views/page/customer-center.jsp 로 이동
        model.addAttribute("center", "page/customer-center");
        return "index";
    }
}