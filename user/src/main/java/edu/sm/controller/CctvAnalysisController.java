package edu.sm.controller;

import edu.sm.app.service.CctvAnalysisService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import java.io.IOException;

@RestController
@RequestMapping("/cctv/api")
@RequiredArgsConstructor
@Slf4j
public class CctvAnalysisController {

    private final CctvAnalysisService cctvAnalysisService;
    private final edu.sm.app.repository.UserRepository userRepository;

    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/analysis", produces = MediaType.APPLICATION_NDJSON_VALUE)
    public Flux<String> analyzeSnapshot(
            @RequestParam("question") String question,
            @RequestParam("attach") MultipartFile attach,
            @RequestParam(value = "cctvId", required = false) String cctvId,
            jakarta.servlet.http.HttpSession session) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null
                || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for CCTV analysis. Returning NO_PET_VISIBLE.");
            return Flux.just("NO_PET_VISIBLE");
        }

        Integer userId = null;
        edu.sm.app.dto.User user = (edu.sm.app.dto.User) session.getAttribute("user");
        if (user != null) {
            userId = user.getUserId();
            log.info("User found in session: {}", userId);
        } else if (cctvId != null && !cctvId.isEmpty()) {
            log.info("No session user, trying cctvId: {}", cctvId);
            try {
                edu.sm.app.dto.User foundUser = userRepository.selectByUsername(cctvId);
                if (foundUser != null) {
                    userId = foundUser.getUserId();
                    log.info("User found by cctvId: {}", userId);
                } else {
                    log.warn("User not found for cctvId: {}", cctvId);
                }
            } catch (Exception e) {
                log.error("Failed to find user by cctvId: " + cctvId, e);
            }
        } else {
            log.warn("No session user and no cctvId provided.");
        }

        return cctvAnalysisService.analyzeAndRespond(question, attach.getContentType(), attach.getBytes(), userId);
    }
}