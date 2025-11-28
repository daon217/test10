<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="pet-detail-page">
  <div class="pet-detail-wrapper">

    <!-- 상단 제목/작성자 영역 -->
    <section class="detail-header">
      <div>
        <div class="detail-header-left-title">
          <c:out value="${post.title}" default="천안천 산책하실분"/>
        </div>
        <div class="detail-header-meta">
          ID : <c:out value="${post.writerId}" default="id01"/> ·
          <c:out value="${post.createdAt}" default="2025.01.01 20:15:58"/>
        </div>
      </div>
      <div class="detail-header-right">
        조회
        <strong><c:out value="${post.viewCount}" default="15"/></strong>
      </div>
    </section>

    <!-- 본문 + 대표 사진 -->
    <section class="detail-main-card">
      <div class="detail-content-text">
        <c:out value="${post.content}" default="천안천 산책하려고 하는데 말티즈가 제일 좋아요. 내일 9시에 천안천 입구에서 기다렸다 같이 산책하실 분은 댓글 남겨주세요!" />
      </div>

      <img class="detail-main-image" src="<c:url value='/images/dog1.jpg'/>" alt="반려견 대표 사진">

      <div class="detail-pet-meta">
        반려견 정보 : 말티즈 · 2살 · 소형견 · 활동적인 성격<br/>
        산책 희망 : 2025.11.26(수) · 오전 9시 · 천안천 입구
      </div>
    </section>

    <!-- 댓글 영역 -->
    <section class="comment-section">
      <div class="comment-title">댓글을 남겨보세요</div>

      <!-- 댓글 작성 -->
      <form class="comment-form" method="post" action="/walkboard/${post.id}/comment">
        <textarea name="content" placeholder="산책 참여 의사나 궁금한 점을 남겨주세요."></textarea>
        <div class="comment-form-footer">
          <button type="submit" class="comment-btn">댓글 등록</button>
        </div>
      </form>

      <!-- 댓글 리스트 (예시) -->
      <div class="comment-list">
        <!-- 원 댓글 -->
        <div class="comment-item">
          <div class="comment-avatar">이</div>
          <div class="comment-body">
            <div class="comment-author-row">
              <span class="comment-author">이승호</span>
              <span class="comment-badge">워커</span>
            </div>
            <div class="comment-text">
              저 가능합니다! 천안천 바로 앞 아파트 살아요!
            </div>
            <div class="comment-meta">
              <span>2025.11.26 · 09:03</span>
              <button type="button" class="comment-small-btn">답글쓰기</button>
            </div>
          </div>
        </div>

        <!-- 대댓글 예시 -->
        <div class="comment-item reply-item">
          <div class="comment-body">
            <div class="reply-arrow">└ 글쓴이 답글</div>
            <div class="comment-author-row">
              <span class="comment-author">글쓴이</span>
              <span class="comment-badge">작성자</span>
            </div>
            <div class="comment-text">
              네, 그럼 9시 맞춰서 와주세요.
            </div>
            <div class="comment-meta">
              <span>2025.11.26 · 09:05</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 대댓글 작성 폼 예시 (특정 댓글에만 노출)
      <form class="reply-form" method="post" action="/walkboard/${post.id}/comment/reply">
        <input type="hidden" name="parentId" value="댓글ID"/>
        <textarea name="content" placeholder="해당 댓글에 대한 답글을 남겨보세요."></textarea>
        <div class="reply-form-footer">
          <button type="submit" class="reply-btn">답글 등록</button>
        </div>
      </form>
      -->
    </section>
  </div>
</div>
