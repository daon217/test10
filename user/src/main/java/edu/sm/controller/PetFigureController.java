package edu.sm.controller;

import edu.sm.app.service.PetFigureService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/pet-figure")
@RequiredArgsConstructor
@Slf4j
public class PetFigureController {

    private final PetFigureService petFigureService;

    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/generate", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, String>> generateFigure(
            @RequestParam("image") MultipartFile attach,
            @RequestParam(value = "customPrompt", required = false) String customPrompt
    ) {
        String imageUrl = petFigureService.generateFigure(attach, customPrompt);
        Map<String, String> response = new HashMap<>();
        if (imageUrl.startsWith("ERROR")) {
            response.put("error", imageUrl);
            return ResponseEntity.badRequest().body(response);
        }
        response.put("imageUrl", imageUrl);
        return ResponseEntity.ok(response);
    }
}
