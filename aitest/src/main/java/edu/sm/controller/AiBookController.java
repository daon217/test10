package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/book")
public class AiBookController {

    String dir = "book/";

    @RequestMapping("")
    public String aimain(Model model) {
        model.addAttribute("center", dir+"center");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/book")
    public String book(Model model) {
        model.addAttribute("center", dir+"book");
        model.addAttribute("left", dir+"left");
        return "index";
    }
}