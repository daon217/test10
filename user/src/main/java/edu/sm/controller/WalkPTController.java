package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/walkpt")
public class WalkPTController {

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", "walkpt/main");
        return "index";
    }

    // ===== Owner (반려인) Pages =====

    @RequestMapping("/owner/post-write")
    public String ownerPostWrite(Model model) {
        model.addAttribute("center", "walkpt/owner/post-write");
        return "index";
    }

    @RequestMapping("/owner/post-list")
    public String ownerPostList(Model model) {
        model.addAttribute("center", "walkpt/owner/post-list");
        return "index";
    }

    @RequestMapping("/owner/post-detail")
    public String ownerPostDetail(Model model) {
        model.addAttribute("center", "walkpt/owner/post-detail");
        return "index";
    }

    @RequestMapping("/owner/monitoring")
    public String ownerMonitoring(Model model) {
        model.addAttribute("center", "walkpt/owner/monitoring");
        return "index";
    }

    @RequestMapping("/owner/review-write")
    public String ownerReviewWrite(Model model) {
        model.addAttribute("center", "walkpt/owner/review-write");
        return "index";
    }

    @RequestMapping("/owner/history")
    public String ownerHistory(Model model) {
        model.addAttribute("center", "walkpt/owner/history");
        return "index";
    }

    // ===== Worker (알바생) Pages =====

    @RequestMapping("/worker/resume")
    public String workerResume(Model model) {
        model.addAttribute("center", "walkpt/worker/resume");
        return "index";
    }

    @RequestMapping("/worker/job-post-write")
    public String workerJobPostWrite(Model model) {
        model.addAttribute("center", "walkpt/worker/job-post-write");
        return "index";
    }

    @RequestMapping("/worker/job-list")
    public String workerJobList(Model model) {
        model.addAttribute("center", "walkpt/worker/job-list");
        return "index";
    }

    @RequestMapping("/worker/application-status")
    public String workerApplicationStatus(Model model) {
        model.addAttribute("center", "walkpt/worker/application-status");
        return "index";
    }

    @RequestMapping("/worker/work-progress")
    public String workerWorkProgress(Model model) {
        model.addAttribute("center", "walkpt/worker/work-progress");
        return "index";
    }
}
