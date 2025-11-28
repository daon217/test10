<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="pet-write-page">
  <div class="pet-write-wrapper">
    <div class="write-header">
      <div class="write-title">함께 산책할 반려인을 찾아볼까요?</div>
      <div class="write-sub">
        반려견 정보와 산책 일정을 자세히 적어주면, AI가 비슷한 반려견을 가진 이웃에게 더 잘 추천해줄 수 있어요.
      </div>
    </div>

    <div class="write-card">
      <form method="post"
            action="/walkboard/write"
            enctype="multipart/form-data">

        <!-- 제목 -->
        <div class="write-field">
          <label class="write-label">제목</label>
          <input type="text" name="title" class="write-input"
                 placeholder="예) 천안천 아침 산책 같이 하실 분 구해요" required/>
        </div>

        <!-- 내용 -->
        <div class="write-field">
          <label class="write-label">내용</label>
          <textarea name="content" class="write-textarea"
                    placeholder="산책 코스, 시간, 만나는 장소, 반려견 성격 등을 자세히 적어주세요."
                    required></textarea>
        </div>

        <!-- 산책 일정 -->
        <div class="write-field">
          <label class="write-label">산책 일정</label>
          <div class="write-row-2">
            <div>
              <input type="date" name="walkDate" class="write-input" required/>
            </div>
            <div>
              <input type="time" name="walkTime" class="write-input" required/>
            </div>
          </div>
          <div class="write-helper">산책 날짜와 시간을 대략적으로 기입해주세요.</div>
        </div>

        <!-- 만나는 장소 -->
        <div class="write-field">
          <label class="write-label">만나는 장소</label>
          <input type="text" name="location" class="write-input"
                 placeholder="예) 천안천 ○○다리 앞 입구" required/>
        </div>

        <!-- 반려견 정보 -->
        <div class="write-field">
          <label class="write-label">반려견 정보</label>
          <div class="write-row-2">
            <div>
              <input type="text" name="breed" class="write-input"
                     placeholder="종 (예: 말티즈)" required/>
            </div>
            <div>
              <select name="size" class="write-select" required>
                <option value="">크기 선택</option>
                <option value="small">소형견</option>
                <option value="medium">중형견</option>
                <option value="large">대형견</option>
              </select>
            </div>
          </div>
          <div class="write-row-2" style="margin-top:8px;">
            <div>
              <input type="number" name="age" class="write-input"
                     placeholder="나이 (살)" min="0"/>
            </div>
            <div>
              <input type="text" name="temperament" class="write-input"
                     placeholder="성격 (예: 사람 좋아하고 활발해요)"/>
            </div>
          </div>
          <div class="write-helper">
            이 정보는 AI가 비슷한 반려견을 추천하는 데 사용돼요.
          </div>
        </div>

        <!-- 대표 사진 (필수) -->
        <div class="write-field">
          <label class="write-label">대표사진 (필수)</label>
          <div class="write-photo-box">
            산책 게시글에 사용할 대표사진을 한 장 업로드해주세요. 게시판 카드와 상세 페이지 상단에 사용됩니다.
            <br/>
            <input type="file" name="mainImage" accept="image/*" required/>
          </div>
        </div>

        <!-- AI 추천 옵션 (선택) -->
        <div class="write-field">
          <label class="write-label">AI 추천 사용</label>
          <div class="write-ai-option">
            <label>
              <input type="checkbox" name="useAiRecommend" checked/>
              내 반려견 정보와 게시글이 다른 사용자에게 AI 추천으로 노출되는 것을 허용합니다.
            </label>
          </div>
        </div>

        <!-- 버튼 -->
        <div class="write-footer">
          <button type="button" class="write-btn-cancel"
                  onclick="history.back();">취소</button>
          <button type="submit" class="write-btn-submit">등록하기</button>
        </div>
      </form>
    </div>
  </div>
</div>
