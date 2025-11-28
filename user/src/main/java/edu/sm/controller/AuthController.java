package edu.sm.controller;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.User;
import edu.sm.app.service.PetService;
import edu.sm.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final PetService petService;

    /**
     * 아이디 중복 확인
     */
    @GetMapping("/register/check-username")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkUsername(
            @RequestParam("username") String username) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 아이디 유효성 검사
            if (username == null || username.trim().isEmpty()) {
                response.put("available", false);
                response.put("message", "아이디를 입력해주세요.");
                return ResponseEntity.ok(response);
            }

            if (username.length() < 4 || username.length() > 20) {
                response.put("available", false);
                response.put("message", "아이디는 4-20자로 입력해주세요.");
                return ResponseEntity.ok(response);
            }

            if (!username.matches("^[a-zA-Z0-9]+$")) {
                response.put("available", false);
                response.put("message", "아이디는 영문과 숫자만 사용 가능합니다.");
                return ResponseEntity.ok(response);
            }

            // 중복 확인
            User existingUser = userService.getByUsername(username);

            if (existingUser != null) {
                response.put("available", false);
                response.put("message", "이미 사용 중인 아이디입니다.");
                log.info("아이디 중복 - username: {}", username);
            } else {
                response.put("available", true);
                response.put("message", "사용 가능한 아이디입니다.");
                log.info("아이디 사용 가능 - username: {}", username);
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("아이디 중복 확인 중 오류 발생", e);
            response.put("available", false);
            response.put("message", "중복 확인 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 로그인 처리
     */
    @PostMapping("/login")
    public String loginProcess(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        try {
            // 로그인 검증
            User user = userService.login(username, password);

            // 세션에 사용자 정보 저장
            session.setAttribute("user", user);

            log.info("로그인 성공 - username: {}", username);

            // 메인 페이지로 리다이렉트
            return "redirect:/";

        } catch (IllegalArgumentException e) {
            // 로그인 실패
            log.warn("로그인 실패 - username: {}, reason: {}", username, e.getMessage());
            model.addAttribute("error", e.getMessage());
            model.addAttribute("center", "login");
            return "index";

        } catch (Exception e) {
            log.error("로그인 처리 중 오류 발생", e);
            model.addAttribute("error", "로그인 처리 중 오류가 발생했습니다.");
            model.addAttribute("center", "login");
            return "index";
        }
    }

    /**
     * 로그아웃 처리
     */
    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        log.info("로그아웃 성공");
        return "redirect:/";
    }

    /**
     * 회원가입 처리
     */
    @PostMapping("/register")
    public String registerProcess(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("passwordConfirm") String passwordConfirm,
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("userRole") String userRole,
            @RequestParam(value = "petName_0", required = false) String petName,
            @RequestParam(value = "petType_0", required = false) String petType,
            @RequestParam(value = "customPetType_0", required = false) String customPetType,
            @RequestParam(value = "petBreed_0", required = false) String petBreed,
            @RequestParam(value = "petGender_0", required = false) String petGender,
            @RequestParam(value = "petAge_0", required = false) Integer petAge,
            @RequestParam(value = "petWeight_0", required = false) BigDecimal petWeight,
            @RequestParam(value = "petPhoto_0", required = false) MultipartFile petPhoto,
            Model model) {

        try {
            // 비밀번호 확인
            if (!password.equals(passwordConfirm)) {
                throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
            }

            // 사용자 등록
            User user = User.builder()
                    .username(username)
                    .password(password)
                    .name(name)
                    .email(email)
                    .phone(phone)
                    .role(userRole)
                    .build();

            userService.register(user);
            log.info("회원가입 성공 - username: {}, role: {}", username, userRole);

            // 반려인이고 반려동물 정보가 실제로 입력된 경우에만 반려동물 등록
            // 중요: petName이 null이 아니고, 빈 문자열도 아니어야 함
            if ("OWNER".equals(userRole) && petName != null && !petName.trim().isEmpty()) {
                Pet pet = Pet.builder()
                        .userId(user.getUserId())
                        .name(petName.trim())
                        .type(petType)
                        .customType("ETC".equals(petType) ? customPetType : null)
                        .breed(petBreed != null ? petBreed.trim() : null)
                        .gender(petGender)
                        .age(petAge)
                        .weight(petWeight)
                        .build();

                // TODO: 사진 업로드 처리
                // if (petPhoto != null && !petPhoto.isEmpty()) {
                //     String photoUrl = uploadPetPhoto(petPhoto);
                //     pet.setPhoto(photoUrl);
                // }

                petService.register(pet);
                log.info("반려동물 정보 등록 완료 - petName: {}, userId: {}", petName, user.getUserId());
            } else if ("OWNER".equals(userRole)) {
                log.info("반려인이지만 반려동물 정보가 입력되지 않음 - userId: {}", user.getUserId());
            } else {
                log.info("일반 사용자 가입 완료 - userId: {}", user.getUserId());
            }

            // 로그인 페이지로 리다이렉트
            model.addAttribute("message", "회원가입이 완료되었습니다. 로그인해주세요.");
            model.addAttribute("center", "login");
            return "index";

        } catch (IllegalArgumentException e) {
            log.warn("회원가입 실패 - username: {}, reason: {}", username, e.getMessage());
            model.addAttribute("error", e.getMessage());
            model.addAttribute("center", "register");
            return "index";

        } catch (Exception e) {
            log.error("회원가입 처리 중 오류 발생", e);
            model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
            model.addAttribute("center", "register");
            return "index";
        }
    }
}