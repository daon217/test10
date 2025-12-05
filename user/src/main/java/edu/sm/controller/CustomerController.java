package edu.sm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomerController {

    @RequestMapping("/customer-service")
    public String customerService(Model model) {
        // user/src/main/webapp/views/customer-service.jsp 로 이동
        model.addAttribute("center", "customer-service");
        return "index";
    }

    // 문의 등록 처리 예시 (추후 구현)
    @RequestMapping("/customer/inquiry")
    public String submitInquiry(String title, String content) {
        // service.registerInquiry(title, content);
        return "redirect:/customer-service";
    }
}