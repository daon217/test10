package edu.sm.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {

    @RequestMapping("/register")
    public String main(Model model) {
        model.addAttribute("center","register");
        model.addAttribute("left","left");
        return "index";
    }

    @RequestMapping("/login")
    public String add(Model model) {
        model.addAttribute("center","login");
        model.addAttribute("left","left");
        return "index";
    }
}