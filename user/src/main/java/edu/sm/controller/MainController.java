package edu.sm.controller;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.User;
import edu.sm.app.service.PetService;
import edu.sm.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MainController {

    private final UserService userService;
    private final PetService petService;

    @RequestMapping("/")
    public String main(Model model) {
        model.addAttribute("center", "center");
        return "index";
    }

    @RequestMapping("/login")
    public String login(Model model) {
        model.addAttribute("center", "login");
        return "index";
    }

    @RequestMapping("/register")
    public String register(Model model) {
        model.addAttribute("center", "register");
        return "index";
    }

    @RequestMapping("/mypage")
    public String mypage(Model model, HttpSession session) {
        try {
            // 세션에서 사용자 정보 가져오기
            User user = (User) session.getAttribute("user");

            if (user == null) {
                // 로그인하지 않은 경우 로그인 페이지로 리다이렉트
                return "redirect:/login";
            }

            // 사용자 정보 갱신
            user = userService.get(user.getUserId());

            // 반려동물 정보 조회
            List<Pet> pets = petService.getByUserId(user.getUserId());
            int petCount = pets.size();

            // 모델에 데이터 추가
            model.addAttribute("user", user);
            model.addAttribute("pets", pets);
            model.addAttribute("petCount", petCount);
            model.addAttribute("center", "mypage");

            return "index";

        } catch (Exception e) {
            log.error("마이페이지 조회 중 오류 발생", e);
            model.addAttribute("error", "데이터를 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("center", "error");
            return "index";
        }
    }

    @RequestMapping("/health-check")
    public String health(Model model) {
        model.addAttribute("center", "health-check");
        return "index";
    }

    @RequestMapping("/homecam")
    public String homecam(Model model) {
        model.addAttribute("center", "homecam");
        return "index";
    }

    @RequestMapping("/clothes-recommend")
    public String clothesRecommend(Model model) {
        model.addAttribute("center", "clothes-recommend");
        return "index";
    }

    @RequestMapping("/pet-figure")
    public String petFigure(Model model) {
        model.addAttribute("center", "pet-figure");
        return "index";
    }

}
