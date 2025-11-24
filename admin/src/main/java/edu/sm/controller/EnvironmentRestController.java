package edu.sm.controller;

import edu.sm.app.dto.ZoneState;
import edu.sm.app.service.EnvironmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/env")
@RequiredArgsConstructor
public class EnvironmentRestController {

    private final EnvironmentService service;

    @GetMapping("/zones")
    public List<ZoneState> getZones() {
        // ★ 수정됨: 위에서 만든 함수 이름과 똑같이 맞춤
        return service.getLinkData();
    }
}