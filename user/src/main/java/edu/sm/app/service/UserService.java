package edu.sm.app.service;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.User;
import edu.sm.app.repository.PetRepository;
import edu.sm.app.repository.UserRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService implements SmService<User, Integer> {

    private final UserRepository userRepository;
    private final PetRepository petRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    /**
     * 사용자 등록 (반려동물 정보 포함)
     */
    @Override
    @Transactional
    public void register(User user) throws Exception {
        register(user, null);
    }

    @Transactional
    public void register(User user, Pet pet) throws Exception {
        log.info("회원가입 시도 - username: {}", user.getUsername());

        // 아이디 중복 체크 및 탈퇴한 사용자 처리
        User existingUser = userRepository.selectByUsernameAll(user.getUsername());
        if (existingUser != null) {
            if ("DELETED".equals(existingUser.getStatus())) {
                log.info("탈퇴한 사용자 재가입 시도 - 기존 계정 영구 삭제: {}", existingUser.getUserId());
                userRepository.deletePermanently(existingUser.getUserId());
            } else {
                throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
            }
        }

        // 이메일 중복 체크
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        userRepository.insert(user);
        log.info("회원가입 성공 - userId: {}", user.getUserId());

        // 반려동물 등록
        if (pet != null) {
            pet.setUserId(user.getUserId());
            petRepository.insert(pet);
            log.info("반려동물 등록 성공 - petName: {}", pet.getName());
        }
    }

    /**
     * 사용자 정보 수정
     */
    @Override
    @Transactional
    public void modify(User user) throws Exception {
        log.info("사용자 정보 수정 - userId: {}", user.getUserId());
        userRepository.update(user);
    }

    /**
     * 사용자 삭제 (소프트 삭제)
     */
    @Override
    @Transactional
    public void remove(Integer userId) throws Exception {
        log.info("사용자 삭제 - userId: {}", userId);
        userRepository.delete(userId);
    }

    /**
     * 전체 사용자 조회
     */
    @Override
    public List<User> get() throws Exception {
        return userRepository.selectAll();
    }

    /**
     * 사용자 조회 (ID)
     */
    @Override
    public User get(Integer userId) throws Exception {
        return userRepository.select(userId);
    }

    /**
     * 사용자 조회 (Username)
     */
    public User getByUsername(String username) throws Exception {
        return userRepository.selectByUsername(username);
    }

    /**
     * 로그인 처리
     */
    public User login(String username, String password) throws Exception {
        User user = userRepository.selectByUsername(username);

        if (user == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }

        if (!"ACTIVE".equals(user.getStatus())) {
            throw new IllegalArgumentException("비활성화된 계정입니다.");
        }

        // 비밀번호 확인
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        // 마지막 로그인 시간 업데이트
        userRepository.updateLastLogin(user.getUserId());

        log.info("로그인 성공 - userId: {}", user.getUserId());
        return user;
    }

    /**
     * 비밀번호 변경
     */
    @Transactional
    public void changePassword(Integer userId, String currentPassword, String newPassword) throws Exception {
        User user = userRepository.select(userId);

        if (user == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }

        // 현재 비밀번호 확인
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 새 비밀번호 암호화 및 업데이트
        String encodedPassword = passwordEncoder.encode(newPassword);
        userRepository.updatePassword(userId, encodedPassword);

        log.info("비밀번호 변경 성공 - userId: {}", userId);
    }

    /**
     * 역할별 사용자 수 조회
     */
    public int countByRole(String role) throws Exception {
        return userRepository.countByRole(role);
    }
}