package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/walk-matching")
public class WalkTogetherController {

    String dir = "walktogether/";

    @RequestMapping("")
    public String petWalkBoardList(Model model) {
        model.addAttribute("test", "walktogether/list");
        model.addAttribute("center", dir + "petWalkBoardList");
        return "index";
    }
    @RequestMapping("/write")
    public String write(Model model) {
        model.addAttribute("center", dir + "petWalkBoardWrite");
        return "index";
    }
    @RequestMapping("/detail")
    public String detail(Model model) {
        model.addAttribute("center", dir + "petWalkBoardDetail");
        return "index";
    }
}
