package edu.sm.controller;

import edu.sm.app.service.AdminCustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminCustomerController {

    private final AdminCustomerService adminCustomerService;

    public AdminCustomerController(AdminCustomerService adminCustomerService) {
        this.adminCustomerService = adminCustomerService;
    }

    @RequestMapping("/customer")
    public String adminCustomer(Model model) {
        model.addAttribute("inquiries", adminCustomerService.getAllInquiries());

        // admin/src/main/webapp/views/page/customer-center.jsp 로 이동
        model.addAttribute("center", "page/customer-center");
        return "index";
    }
}
