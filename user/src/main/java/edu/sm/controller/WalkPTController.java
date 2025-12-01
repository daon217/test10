package edu.sm.controller;

import edu.sm.app.dto.User;
import edu.sm.app.dto.WalkPostDTO;
import edu.sm.app.service.WalkPostService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/walkpt")
@RequiredArgsConstructor
public class WalkPTController {

    private final WalkPostService walkPostService;
    private final edu.sm.app.service.PetService petService;

    @RequestMapping("")
    public String main(Model model) {
        try {
            // 구인 글 (OWNER) 최신 3개
            WalkPostDTO ownerSearch = new WalkPostDTO();
            ownerSearch.setCategory("OWNER");
            com.github.pagehelper.PageHelper.startPage(1, 3);
            List<WalkPostDTO> ownerPosts = walkPostService.getList(ownerSearch);
            model.addAttribute("ownerPosts", ownerPosts);

            // 구직 글 (WORKER) 최신 3개
            WalkPostDTO workerSearch = new WalkPostDTO();
            workerSearch.setCategory("WORKER");
            com.github.pagehelper.PageHelper.startPage(1, 3);
            List<WalkPostDTO> workerPosts = walkPostService.getList(workerSearch);
            model.addAttribute("workerPosts", workerPosts);

            // 함께 산책 (TOGETHER) 최신 3개
            WalkPostDTO togetherSearch = new WalkPostDTO();
            togetherSearch.setCategory("TOGETHER");
            com.github.pagehelper.PageHelper.startPage(1, 3);
            List<WalkPostDTO> togetherPosts = walkPostService.getList(togetherSearch);
            model.addAttribute("togetherPosts", togetherPosts);

        } catch (Exception e) {
            log.error("메인 페이지 데이터 조회 실패", e);
        }
        model.addAttribute("center", "walkpt/main");
        return "index";
    }

    // ===== Together Walk (함께 산책하기) Pages =====

    @RequestMapping("/togetherwalk/list")
    public String togetherWalkList(Model model, WalkPostDTO searchCondition) {
        log.info("함께 산책하기 목록 조회 요청: {}", searchCondition);
        try {
            searchCondition.setCategory("TOGETHER");
            List<WalkPostDTO> list = walkPostService.getList(searchCondition);
            log.info("조회된 게시글 수: {}", list.size());
            model.addAttribute("posts", list);
        } catch (Exception e) {
            log.error("함께 산책하기 목록 조회 실패", e);
        }
        model.addAttribute("center", "walkpt/togetherwalk/list");
        return "index";
    }

    @RequestMapping("/togetherwalk/write")
    public String togetherWalkWrite(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        try {
            List<edu.sm.app.dto.Pet> pets = petService.getByUserId(user.getUserId());
            model.addAttribute("pets", pets);
        } catch (Exception e) {
            log.error("반려동물 목록 조회 실패", e);
        }
        model.addAttribute("center", "walkpt/togetherwalk/write");
        return "index";
    }

    @RequestMapping("/togetherwalk/register")
    public String togetherWalkRegister(WalkPostDTO walkPost, HttpSession session) {
        log.info("함께 산책하기 등록 요청: {}", walkPost);
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                log.warn("로그인되지 않은 사용자의 등록 시도");
                return "redirect:/login";
            }
            walkPost.setUserId(user.getUserId());
            walkPost.setCategory("TOGETHER");
            walkPost.setStatus("RECRUITING"); // 기본값 설정

            // 시간 합치기
            if (walkPost.getWalkStartTime() != null && walkPost.getWalkEndTime() != null) {
                walkPost.setWalkTime(walkPost.getWalkStartTime() + " ~ " + walkPost.getWalkEndTime());
            }

            // TODO: 이미지 파일 처리 로직 필요 (현재는 파일명만 받는다고 가정)
            if (walkPost.getPetImage() != null && !walkPost.getPetImage().isEmpty()) {
                // 파일 저장 로직 구현 필요. 여기서는 파일명만 DTO에 설정한다고 가정하지만
                // WalkPostDTO에는 petImage 필드가 없고, 조인된 petPhoto만 있음.
                // 실제로는 walk_posts 테이블에 이미지가 없고 pets 테이블의 이미지를 쓰거나
                // walk_posts에 별도 이미지 컬럼이 있어야 함.
                // 현재 스키마에는 walk_posts에 이미지 컬럼이 없음.
                // 따라서 이 부분은 일단 스킵하거나, 추후 스키마 변경 필요.
                log.info("이미지 업로드 요청됨: {}", walkPost.getPetImage().getOriginalFilename());
            }

            log.info("DB 등록 시도: {}", walkPost);
            walkPostService.register(walkPost);
            log.info("DB 등록 성공");
        } catch (Exception e) {
            log.error("함께 산책하기 글 등록 실패", e);
            return "redirect:/walkpt/togetherwalk/write?error=true";
        }
        return "redirect:/walkpt/togetherwalk/list";
    }

    @RequestMapping("/togetherwalk/detail")
    public String togetherWalkDetail(Model model, @RequestParam("id") Integer postId) {
        try {
            WalkPostDTO post = walkPostService.get(postId);
            model.addAttribute("post", post);
        } catch (Exception e) {
            log.error("함께 산책하기 상세 조회 실패", e);
            return "redirect:/walkpt/togetherwalk/list";
        }
        model.addAttribute("center", "walkpt/togetherwalk/detail");
        return "index";
    }

    // ===== Owner (반려인) Pages =====

    @RequestMapping(value = "/owner/post-write", method = RequestMethod.GET)
    public String ownerPostWrite(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        try {
            List<edu.sm.app.dto.Pet> pets = petService.getByUserId(user.getUserId());
            model.addAttribute("pets", pets);
        } catch (Exception e) {
            log.error("반려동물 목록 조회 실패", e);
        }
        model.addAttribute("center", "walkpt/owner/post-write");
        return "index";
    }

    @RequestMapping(value = "/owner/post-write", method = RequestMethod.POST)
    public String ownerPostRegister(WalkPostDTO walkPost, HttpSession session) {
        log.info("산책 구인 글 등록 요청: {}", walkPost);
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/login";
            }
            walkPost.setUserId(user.getUserId());
            walkPost.setCategory("OWNER");
            walkPost.setStatus("RECRUITING");

            // 시간 합치기
            if (walkPost.getWalkStartTime() != null && walkPost.getWalkEndTime() != null) {
                walkPost.setWalkTime(walkPost.getWalkStartTime() + " ~ " + walkPost.getWalkEndTime());
            }

            // TODO: 이미지 처리 로직

            walkPostService.register(walkPost);
        } catch (Exception e) {
            log.error("산책 구인 글 등록 실패", e);
            return "redirect:/walkpt/owner/post-write?error=true";
        }
        return "redirect:/walkpt";
    }

    @RequestMapping("/owner/post-detail")
    public String ownerPostDetail(Model model, @RequestParam("id") int id) {
        try {
            WalkPostDTO post = walkPostService.get(id);
            if (post == null) {
                throw new Exception("게시글이 존재하지 않습니다.");
            }
            model.addAttribute("post", post);
        } catch (Exception e) {
            log.error("구인 글 상세 조회 실패", e);
            return "redirect:/walkpt";
        }
        model.addAttribute("center", "walkpt/owner/post-detail");
        return "index";
    }

    @RequestMapping("/owner/post-list")
    public String ownerPostList(Model model) {
        model.addAttribute("center", "walkpt/owner/post-list");
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
    public String workerJobList(Model model, WalkPostDTO searchCondition) {
        try {
            searchCondition.setCategory("OWNER");
            List<WalkPostDTO> list = walkPostService.getList(searchCondition);
            model.addAttribute("jobs", list);
        } catch (Exception e) {
            log.error("구인 글 목록 조회 실패", e);
        }
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
