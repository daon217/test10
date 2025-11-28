package edu.sm.app.repository;

import edu.sm.app.dto.Pet;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PetRepository extends SmRepository<Pet, Integer> {

    /**
     * 사용자별 반려동물 조회
     */
    List<Pet> selectByUserId(@Param("userId") Integer userId);

    /**
     * 사용자의 반려동물 수 조회
     */
    int countByUserId(@Param("userId") Integer userId);
}