package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/diary")
public class AiDiaryController {

    String dir = "diary/";

    @RequestMapping("")
    public String aimain(Model model) {
        model.addAttribute("center", dir+"center");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/diary")
    public String diary(Model model) {
        model.addAttribute("center", dir+"diary");
        model.addAttribute("left", dir+"left");
        return "index";
    }

}