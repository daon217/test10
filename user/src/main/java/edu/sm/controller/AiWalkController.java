package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/ai-walk")
public class AiWalkController {

    String dir = "aiwalk/";


    @RequestMapping("")
    public String showHeartMap(Model model) {
        model.addAttribute("center", dir + "mapHeart");
        return "index";
    }
    @RequestMapping("/nav")
    public String navPage(Model model) {
        model.addAttribute("center", dir + "navRoute");
        return "index";
    }
}