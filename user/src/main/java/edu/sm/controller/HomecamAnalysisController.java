package edu.sm.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;
import edu.sm.app.service.HomecamAnalysisService;

import java.io.IOException;

@RestController
@RequestMapping("/homecam/api")
@RequiredArgsConstructor
@Slf4j
public class HomecamAnalysisController {

    private final HomecamAnalysisService homecamAnalysisService;

    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/analysis", produces = MediaType.APPLICATION_NDJSON_VALUE)
    public Flux<String> analyze(
            @RequestParam("question") String question,
            @RequestParam("attach") MultipartFile attach
    ) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for homecam analysis. Returning NO_DISASTER_DETECTED.");
            return Flux.just("NO_DISASTER_DETECTED");
        }

        return homecamAnalysisService.analyzeSnapshot(question, attach.getContentType(), attach.getBytes());
    }
}