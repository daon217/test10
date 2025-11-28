package edu.sm.app.service;

import edu.sm.app.dto.Pet;
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

    /**
     * 반려동물 등록
     */
    @Override
    @Transactional
    public void register(Pet pet) throws Exception {
        log.info("반려동물 등록 - name: {}, userId: {}", pet.getName(), pet.getUserId());
        petRepository.insert(pet);
        log.info("반려동물 등록 성공 - petId: {}", pet.getPetId());
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
        petRepository.delete(petId);
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
}