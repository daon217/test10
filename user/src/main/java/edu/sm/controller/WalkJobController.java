package edu.sm.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/walkjob")
public class WalkJobController {

    /**
     * 반려인 모니터링 페이지
     */
    @GetMapping("/owner")
    public String ownerPage(Model model) {
        model.addAttribute("center", "walkjob/owner");
        return "index";
    }

    /**
     * 알바생 산책 페이지
     */
    @GetMapping("/worker")
    public String workerPage(Model model) {
        model.addAttribute("center", "walkjob/worker");
        return "index";    }
}
