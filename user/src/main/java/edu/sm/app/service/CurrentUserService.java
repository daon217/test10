// edu.sm.app.service.CurrentUserService
package edu.sm.app.service;

import edu.sm.app.dto.User;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CurrentUserService {

    private final HttpSession session;

    /**
     * 현재 로그인된 User의 userId 반환
     * (세션에 user가 없으면 예외 발생)
     */
    public int getCurrentUserIdOrThrow() {
        Object obj = session.getAttribute("user"); // ★ AuthController와 동일 키
        if (!(obj instanceof User)) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
        User user = (User) obj;
        return user.getUserId();
    }

    /**
     * 전체 User 객체가 필요한 경우
     */
    public User getCurrentUserOrThrow() {
        Object obj = session.getAttribute("user");
        if (!(obj instanceof User)) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
        return (User) obj;
    }
}
