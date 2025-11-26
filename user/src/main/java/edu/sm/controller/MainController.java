package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
public class MainController {

    @RequestMapping("/")
    public String main(Model model) {
        model.addAttribute("center","center");
        return "index";
    }

    @RequestMapping("/login")
    public String login(Model model) {
        model.addAttribute("center", "login");
        return "index";
    }

    @RequestMapping("/register")
    public String register(Model model) {
        model.addAttribute("center", "register");
        return "index";
    }
    @RequestMapping("/health-check")
    public String health(Model model) {
        model.addAttribute("center", "health-check");
        return "index";
    }
    @RequestMapping("/homecam")
    public String homecam(Model model) {
        model.addAttribute("center", "homecam");
        return "index";
    }
}
