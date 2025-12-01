package edu.sm.controller;

import edu.sm.app.service.PetService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final PetService petService;

    @GetMapping("/sync-roles")
    public ResponseEntity<Map<String, String>> syncRoles() {
        try {
            petService.syncUserRoles();
            return ResponseEntity.ok(Collections.singletonMap("message", "User roles synced successfully"));
        } catch (Exception e) {
            log.error("Failed to sync user roles", e);
            return ResponseEntity.internalServerError().body(Collections.singletonMap("error", e.getMessage()));
        }
    }
}
