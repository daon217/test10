package edu.sm.controller;

import edu.sm.app.springai.service1.BookRecommendationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/book")
public class AiBookController {

    String dir = "book/";
    private final BookRecommendationService bookRecommendationService;

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

    @PostMapping("/recommend")
    @ResponseBody
    public String recommend(
            @RequestParam("readingFrequency") String readingFrequency,
            @RequestParam("todayMood") String todayMood,
            @RequestParam("moodReason") String moodReason,
            @RequestParam("dailyTime") String dailyTime
    ) {
        return bookRecommendationService.recommend(readingFrequency, todayMood, moodReason, dailyTime);
    }
}