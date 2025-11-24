package edu.sm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling; // 1. 이 줄 추가

@SpringBootApplication
@EnableScheduling // 2. 이 줄 추가 (스케줄러 활성화)
public class AdminApplication {

	public static void main(String[] args) {
		SpringApplication.run(AdminApplication.class, args);
	}

}