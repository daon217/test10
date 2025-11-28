package edu.sm.controller;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.User;
import edu.sm.app.service.PetService;
import edu.sm.app.service.UserService;
import edu.sm.util.FileUploadUtil;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {

    private final UserService userService;
    private final PetService petService;

    @Value("${app.dir.uploadimgdir:src/main/webapp/images/profile/}")
    private String uploadDir;

    /**
     * 프로필 사진 업로드
     */
    @PostMapping("/upload-profile-image")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadProfileImage(
            @RequestParam("profileImage") MultipartFile file,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 파일 검증
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "파일을 선택해주세요.");
                return ResponseEntity.ok(response);
            }

            // 파일 크기 검증 (5MB)
            if (file.getSize() > 5 * 1024 * 1024) {
                response.put("success", false);
                response.put("message", "파일 크기는 5MB 이하여야 합니다.");
                return ResponseEntity.ok(response);
            }

            // 파일 타입 검증
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.put("success", false);
                response.put("message", "이미지 파일만 업로드 가능합니다.");
                return ResponseEntity.ok(response);
            }

            // 업로드 디렉토리 생성
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 기존 파일 삭제
            if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) {
                try {
                    String oldFileName = user.getProfileImage().substring(user.getProfileImage().lastIndexOf("/") + 1);
                    FileUploadUtil.deleteFile(oldFileName, uploadDir);
                } catch (Exception e) {
                    log.warn("기존 프로필 사진 삭제 실패", e);
                }
            }

            // 새 파일명 생성 (UUID + 원본 확장자)
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;

            // 파일 저장
            FileUploadUtil.saveFile(file, uploadDir);

            // 파일명을 UUID로 변경
            Path source = Paths.get(uploadDir + originalFilename);
            Path target = Paths.get(uploadDir + newFilename);
            Files.move(source, target);

            // DB 업데이트
            String imageUrl = "/images/profile/" + newFilename;
            user.setProfileImage(imageUrl);
            userService.modify(user);

            // 세션 갱신
            session.setAttribute("user", user);

            log.info("프로필 사진 업로드 성공 - userId: {}, filename: {}", user.getUserId(), newFilename);

            response.put("success", true);
            response.put("message", "프로필 사진이 업로드되었습니다.");
            response.put("imageUrl", imageUrl);
            return ResponseEntity.ok(response);

        } catch (IOException e) {
            log.error("파일 업로드 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("프로필 사진 업데이트 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 개인정보 수정
     */
    @PostMapping("/update-profile")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 사용자 정보 업데이트
            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);

            userService.modify(user);

            // 세션 갱신
            session.setAttribute("user", user);

            log.info("개인정보 수정 성공 - userId: {}", user.getUserId());

            response.put("success", true);
            response.put("message", "개인정보가 수정되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("개인정보 수정 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 비밀번호 변경
     */
    @PostMapping("/change-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 비밀번호 확인
            if (!newPassword.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "새 비밀번호가 일치하지 않습니다.");
                return ResponseEntity.ok(response);
            }

            userService.changePassword(user.getUserId(), currentPassword, newPassword);

            log.info("비밀번호 변경 성공 - userId: {}", user.getUserId());

            response.put("success", true);
            response.put("message", "비밀번호가 변경되었습니다.");
            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            log.warn("비밀번호 변경 실패 - reason: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("비밀번호 변경 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * ✅ 반려동물 추가 - 일반 사용자가 반려동물을 추가하면 자동으로 반려인으로 변경
     */
    @PostMapping("/add-pet")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addPet(
            @RequestParam("name") String name,
            @RequestParam("type") String type,
            @RequestParam(value = "customType", required = false) String customType,
            @RequestParam(value = "breed", required = false) String breed,
            @RequestParam("gender") String gender,
            @RequestParam("age") Integer age,
            @RequestParam("weight") BigDecimal weight,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            Pet pet = Pet.builder()
                    .userId(user.getUserId())
                    .name(name)
                    .type(type)
                    .customType("ETC".equals(type) ? customType : null)
                    .breed(breed)
                    .gender(gender)
                    .age(age)
                    .weight(weight)
                    .build();

            petService.register(pet);

            // ✅ 일반 사용자가 반려동물을 추가하면 자동으로 반려인으로 변경
            if ("GENERAL".equals(user.getRole())) {
                log.info("✅ 일반 사용자가 반려동물 추가 → 반려인으로 역할 변경 시작 - userId: {}", user.getUserId());

                user.setRole("OWNER");
                userService.modify(user);

                // 세션 업데이트
                session.setAttribute("user", user);

                log.info("✅ 역할 변경 완료: GENERAL → OWNER - userId: {}", user.getUserId());

                response.put("roleChanged", true);
                response.put("message", "반려동물이 추가되었으며, 반려인으로 전환되었습니다.");
            } else {
                log.info("반려동물 추가 성공 - userId: {}, petName: {}", user.getUserId(), name);
                response.put("message", "반려동물이 추가되었습니다.");
            }

            response.put("success", true);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("반려동물 추가 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 반려동물 정보 조회
     */
    @GetMapping("/get-pet")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPet(
            @RequestParam("petId") Integer petId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            Pet pet = petService.get(petId);

            if (pet == null) {
                response.put("success", false);
                response.put("message", "반려동물 정보를 찾을 수 없습니다.");
                return ResponseEntity.ok(response);
            }

            // 본인의 반려동물인지 확인
            if (!pet.getUserId().equals(user.getUserId())) {
                response.put("success", false);
                response.put("message", "권한이 없습니다.");
                return ResponseEntity.ok(response);
            }

            log.info("반려동물 정보 조회 성공 - petId: {}", petId);

            response.put("success", true);
            response.put("pet", pet);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("반려동물 정보 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "반려동물 정보를 불러오는 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 반려동물 수정
     */
    @PostMapping("/update-pet")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updatePet(
            @RequestParam("petId") Integer petId,
            @RequestParam("name") String name,
            @RequestParam("type") String type,
            @RequestParam(value = "customType", required = false) String customType,
            @RequestParam(value = "breed", required = false) String breed,
            @RequestParam("gender") String gender,
            @RequestParam("age") Integer age,
            @RequestParam("weight") BigDecimal weight,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            Pet pet = Pet.builder()
                    .petId(petId)
                    .userId(user.getUserId())
                    .name(name)
                    .type(type)
                    .customType("ETC".equals(type) ? customType : null)
                    .breed(breed)
                    .gender(gender)
                    .age(age)
                    .weight(weight)
                    .build();

            petService.modify(pet);

            log.info("반려동물 수정 성공 - petId: {}", petId);

            response.put("success", true);
            response.put("message", "반려동물 정보가 수정되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("반려동물 수정 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 반려동물 삭제
     */
    @PostMapping("/delete-pet")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deletePet(
            @RequestParam("petId") Integer petId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            petService.remove(petId);

            log.info("반려동물 삭제 성공 - petId: {}", petId);

            response.put("success", true);
            response.put("message", "반려동물이 삭제되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("반려동물 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 회원 탈퇴
     */
    @PostMapping("/delete-account")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteAccount(
            @RequestParam("password") String password,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 비밀번호 확인을 위해 로그인 시도
            userService.login(user.getUsername(), password);

            // 회원 삭제 (소프트 삭제)
            userService.remove(user.getUserId());

            // 세션 무효화
            session.invalidate();

            log.info("회원 탈퇴 성공 - userId: {}", user.getUserId());

            response.put("success", true);
            response.put("message", "회원 탈퇴가 완료되었습니다.");
            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            log.warn("회원 탈퇴 실패 - reason: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "비밀번호가 일치하지 않습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("회원 탈퇴 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "회원 탈퇴 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }
}