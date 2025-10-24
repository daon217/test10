package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/doors")
public class AiDoorsController {

    String dir = "doors/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "index";
    }
    @RequestMapping("/recognition")
    public String recognition(Model model) {
        model.addAttribute("center", dir + "recognition");
        model.addAttribute("left", dir + "left");
        return "index";
    }
    @RequestMapping("/records")
    public String records(Model model) {
        model.addAttribute("center", dir + "records");
        model.addAttribute("left", dir + "left");
        return "index";
    }
}