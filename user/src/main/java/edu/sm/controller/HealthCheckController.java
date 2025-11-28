package edu.sm.controller;

import edu.sm.app.springai.AiImageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/health-check")
@RequiredArgsConstructor
@Slf4j
public class HealthCheckController {

    private final AiImageService aiImageService;

    @PostMapping("/analyze")
    public String analyze(@RequestParam(value = "image", required = false) MultipartFile image,
            @RequestParam(value = "text", required = false) String text) {
        log.info("Analyzing health check request. Image present: {}, Text present: {}",
                image != null && !image.isEmpty(), text != null && !text.isBlank());

        try {
            if ((image == null || image.isEmpty()) && (text == null || text.isBlank())) {
                throw new IllegalArgumentException("At least one of image or text must be provided");
            }

            String contentType = (image != null) ? image.getContentType() : "image/jpeg"; // Default or actual
            byte[] bytes = (image != null) ? image.getBytes() : null;

            return aiImageService.analyzeImage(text, contentType, bytes);
        } catch (IOException e) {
            log.error("Error processing image", e);
            return "{\"error\": \"Failed to process image\"}";
        } catch (Exception e) {
            log.error("Error analyzing request", e);
            return "{\"error\": \"AI analysis failed: " + e.getMessage() + "\"}";
        }
    }

    @PostMapping("/history")
    public Map<String, String> saveHistory(@RequestBody Map<String, Object> historyData) {
        log.info("Saving history: {}", historyData);
        // TODO: Implement actual database saving logic here
        // For now, just log and return success
        return Map.of("status", "success", "message", "History saved successfully");
    }
}
