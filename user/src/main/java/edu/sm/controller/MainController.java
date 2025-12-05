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

import java.time.format.DateTimeFormatter;
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
            User user = (User) session.getAttribute("user");

            if (user == null) {
                return "redirect:/login";
            }

            user = userService.get(user.getUserId());

            // 가입일 포맷팅 (LocalDateTime이라면)
            if (user.getCreatedAt() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
                String formattedDate = user.getCreatedAt().format(formatter);
                model.addAttribute("formattedCreatedAt", formattedDate);
            }

            List<Pet> pets = petService.getByUserId(user.getUserId());
            int petCount = pets.size();

            // ✅ 반려동물 정보 상세 로그
            log.info("조회된 반려동물 수: {}", petCount);
            for (Pet pet : pets) {
                log.info("Pet [petId={}, name={}, type={}, customType={}, breed={}, age={}, weight={}]",
                        pet.getPetId(), pet.getName(), pet.getType(), pet.getCustomType(),
                        pet.getBreed(), pet.getAge(), pet.getWeight());
            }

            // 가입일 포맷팅
            if (user.getCreatedAt() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
                String formattedDate = user.getCreatedAt().format(formatter);
                model.addAttribute("formattedCreatedAt", formattedDate);
            }


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
    @RequestMapping("/map")
    public String map(Model model) {
        model.addAttribute("center", "map");
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

    @RequestMapping("/diary")
    public String diary(Model model, HttpSession session) {
        // 로그인 체크
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("center", "diary");
        return "index";
    }

    @RequestMapping("/report")
    public String report(Model model, HttpSession session) {
        // 로그인 체크
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("center", "report");
        return "index";
    }
}
