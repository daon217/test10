package edu.sm.app.repository;

import edu.sm.app.dto.PetDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PetMapper {

    /**
     * 현재는 로그인 전이라, 임시로 user_id = 1 (또는 'id01' 유저의 ID) 기준으로
     * 대표 반려동물 1마리만 가져온다고 가정.
     */
    PetDto findMainPetByUserId(@Param("userId") int userId);
}
