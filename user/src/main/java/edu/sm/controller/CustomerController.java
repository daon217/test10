package edu.sm.controller;

import edu.sm.app.dto.User;
import edu.sm.app.service.CustomerInquiryService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;

@Controller
public class CustomerController {

    private final CustomerInquiryService inquiryService;

    public CustomerController(CustomerInquiryService inquiryService) {
        this.inquiryService = inquiryService;
    }

    @GetMapping("/customer-service")
    public String customerService(Model model, HttpSession session) {
        model.addAttribute("center", "customer-service"); // user/src/main/webapp/views/customer-service.jsp

        Object userObj = session.getAttribute("user");
        if (userObj instanceof User) {
            model.addAttribute("inquiries", inquiryService.getMyInquiries());
        } else {
            model.addAttribute("inquiries", Collections.emptyList());
        }

        return "index";
    }

    @PostMapping("/customer/inquiry")
    public String submitInquiry(@RequestParam String category,
                                @RequestParam String title,
                                @RequestParam String content,
                                RedirectAttributes redirectAttributes) {
        try {
            inquiryService.submit(category, title, content);
            redirectAttributes.addFlashAttribute("message", "문의가 등록되었습니다.");
            return "redirect:/customer-service";
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("message", "로그인 후 문의를 등록해 주세요.");
            return "redirect:/login";
        }
    }
}
