package edu.sm.app.service;

import edu.sm.app.dto.Pet;
import edu.sm.app.dto.User;
import edu.sm.app.repository.PetRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class PetService implements SmService<Pet, Integer> {

    private final PetRepository petRepository;
    private final UserService userService;

    /**
     * 반려동물 등록
     */
    @Override
    @Transactional
    public void register(Pet pet) throws Exception {
        log.info("반려동물 등록 - name: {}, userId: {}", pet.getName(), pet.getUserId());
        petRepository.insert(pet);
        log.info("반려동물 등록 성공 - petId: {}", pet.getPetId());

        // Update user role to OWNER if currently GENERAL
        User user = userService.get(pet.getUserId());
        if (user != null && "GENERAL".equals(user.getRole())) {
            user.setRole("OWNER");
            userService.modify(user);
            log.info("사용자 권한 변경 (GENERAL -> OWNER) - userId: {}", user.getUserId());
        }
    }

    /**
     * 반려동물 정보 수정
     */
    @Override
    @Transactional
    public void modify(Pet pet) throws Exception {
        log.info("반려동물 정보 수정 - petId: {}", pet.getPetId());
        petRepository.update(pet);
    }

    /**
     * 반려동물 삭제
     */
    @Override
    @Transactional
    public void remove(Integer petId) throws Exception {
        log.info("반려동물 삭제 - petId: {}", petId);
        
        // Get pet info before deletion to know the owner
        Pet pet = petRepository.select(petId);
        if (pet == null) {
            throw new Exception("Pet not found");
        }
        Integer userId = pet.getUserId();

        petRepository.delete(petId);

        // Check remaining pet count
        int petCount = petRepository.countByUserId(userId);
        if (petCount == 0) {
            User user = userService.get(userId);
            if (user != null && "OWNER".equals(user.getRole())) {
                user.setRole("GENERAL");
                userService.modify(user);
                log.info("사용자 권한 변경 (OWNER -> GENERAL) - userId: {}", userId);
            }
        }
    }

    /**
     * 전체 반려동물 조회
     */
    @Override
    public List<Pet> get() throws Exception {
        return petRepository.selectAll();
    }

    /**
     * 반려동물 조회 (ID)
     */
    @Override
    public Pet get(Integer petId) throws Exception {
        return petRepository.select(petId);
    }

    /**
     * 사용자별 반려동물 조회
     */
    public List<Pet> getByUserId(Integer userId) throws Exception {
        return petRepository.selectByUserId(userId);
    }

    /**
     * 사용자의 반려동물 수 조회
     */
    public int countByUserId(Integer userId) throws Exception {
        return petRepository.countByUserId(userId);
    }

    /**
     * 사용자 역할 동기화 (전체 사용자 대상)
     * 반려동물 유무에 따라 GENERAL <-> OWNER 역할 재설정
     */
    @Transactional
    public void syncUserRoles() throws Exception {
        List<User> users = userService.get();
        int updatedCount = 0;

        for (User user : users) {
            // ADMIN은 건너뜀
            if ("ADMIN".equals(user.getRole())) {
                continue;
            }

            int petCount = petRepository.countByUserId(user.getUserId());
            String currentRole = user.getRole();
            String newRole = currentRole;

            if (petCount > 0 && "GENERAL".equals(currentRole)) {
                newRole = "OWNER";
            } else if (petCount == 0 && "OWNER".equals(currentRole)) {
                newRole = "GENERAL";
            }

            if (!newRole.equals(currentRole)) {
                user.setRole(newRole);
                userService.modify(user);
                updatedCount++;
                log.info("사용자 역할 동기화 - userId: {}, {} -> {}", user.getUserId(), currentRole, newRole);
            }
        }
        log.info("전체 사용자 역할 동기화 완료 - 총 {}명 변경됨", updatedCount);
    }
}