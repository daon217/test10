<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="petwalk-list-page">
  <div class="pet-board-wrapper">

    <!-- 상단 타이틀 + 뱃지 -->
    <div class="pet-board-header-row">
      <div>
        <div class="pet-board-title">함께 산책 메이트 찾기</div>
        <div class="pet-board-subtitle">
          내 반려견과 잘 맞는 이웃 반려인을 찾아 보세요. AI가 종·성격·활동 패턴을 바탕으로 추천해드려요.
        </div>
      </div>
      <div class="pet-board-badge">
        <i class="fas fa-paw"></i>
        오늘도 <strong>&nbsp;산책 메이트&nbsp;</strong>를 찾는 중
      </div>
    </div>

    <!-- AI 추천 상단 배너 -->
    <section class="ai-banner">
      <div class="ai-banner-top">
        <div>
          <div class="ai-banner-header">
            AI가 추천해주는 산책 메이트 게시글을 한 곳에서 확인해보세요.
          </div>
          <div class="ai-banner-sub">
            반려견의 종, 크기, 성격, 활동 패턴을 바탕으로 비슷한 반려견을 가진 이웃을 추천합니다.<br>
            게시글 작성일 기준 <strong>1주일 이내</strong>의 글만 추천에 포함돼요.
          </div>
        </div>
        <span class="ai-banner-tag">
          <i class="fas fa-magic"></i>
          내 반려견 프로필 기반 자동 매칭
        </span>
      </div>

      <div class="ai-banner-stats">
        <div class="ai-banner-stat">
          <div class="ai-banner-stat-label">등록된 게시글 수</div>
          <div class="ai-banner-stat-value">
            <c:out value="${totalPostCount}" default="2,399"/>
          </div>
        </div>
        <div class="ai-banner-stat">
          <div class="ai-banner-stat-label">AI 추천 매칭 시도 수</div>
          <div class="ai-banner-stat-value">
            <c:out value="${aiMatchCount}" default="5,346"/>
          </div>
        </div>
        <div class="ai-banner-stat">
          <div class="ai-banner-stat-label">후기/평가 수</div>
          <div class="ai-banner-stat-value">
            <c:out value="${reviewCount}" default="6,783"/>
          </div>
        </div>
      </div>
    </section>

    <!-- AI 추천 카드 리스트 -->
    <section class="ai-reco-section">
      <div class="ai-reco-header">
        <i class="fas fa-paw"></i>
        <span>AI가 반려견 정보를 바탕으로 비슷한 산책 메이트를 찾았어요.</span>
      </div>
      <div class="ai-reco-desc">
        내 반려견의 정보와 가장 비슷한 반려견이 포함된 게시글이에요. 게시글에서 더 자세한 산책 일정을 확인해보세요.
      </div>

      <div class="ai-reco-grid">
        <%-- 실제로는 추천 리스트 loop (예시용) --%>
        <c:forEach begin="1" end="4" varStatus="status">
<%--          <a href="/walk-matching/detail?id=${status.index}" class="ai-reco-card">--%>
            <a href="/walk-matching/detail" class="ai-reco-card">

            <img class="ai-reco-thumb" src="/images/dog1.jpg" alt="추천 반려견 대표사진"/>
            <div class="ai-reco-body">
              <div class="ai-reco-title">천안천 산책하실 분</div>
              <div class="ai-reco-meta">
                말티즈 · 소형견 · 활발한 성격<br/>
                2025.11.26 · 천안시 서북구
              </div>
            </div>
          </a>
        </c:forEach>
      </div>

      <!-- 검색/정렬 바 -->
      <form method="get" action="/walktogether" class="board-search-bar">
        <input type="text" class="board-search-input"
               placeholder="검색 : 종, 나이, 장소, 제목 등"
               name="keyword"
               value="${param.keyword}"/>
        <button type="submit" class="board-btn">
          <i class="fas fa-search"></i> 검색
        </button>
      </form>

      <div class="board-sort-row">
        <div class="board-sort-left">
          <span>정렬 기준</span>
          <select name="sort" class="board-sort-select"
                  onchange="location.href='?sort=' + this.value + '&keyword=${fn:escapeXml(param.keyword)}'">
            <option value="latest"
                    <c:if test="${param.sort == 'latest' || empty param.sort}">selected</c:if>>
              최신순
            </option>
            <option value="oldest"
                    <c:if test="${param.sort == 'oldest'}">selected</c:if>>
              오래된순
            </option>
            <option value="view"
                    <c:if test="${param.sort == 'view'}">selected</c:if>>
              조회순
            </option>
            <option value="match"
                    <c:if test="${param.sort == 'match'}">selected</c:if>>
              AI 매칭 점수순
            </option>
          </select>
        </div>
        <div class="board-result-count">
          <strong><c:out value="${searchResultCount}" default="2,399"/></strong>개 결과
        </div>
      </div>
    </section>

    <!-- 전체 게시글 리스트 -->
    <section class="board-section">
      <div class="board-section-header">
        <div class="board-tabs-left">
          <div class="board-section-title">전체 게시글</div>
          <div class="board-tab-buttons">
            <button type="button" class="board-tab-btn active">전체</button>
            <button type="button" class="board-tab-btn">내가 쓴 글</button>
          </div>
        </div>
        <button type="button" class="board-write-btn"
                onclick="location.href='/walk-matching/write'">
          <i class="fas fa-pen"></i> 게시글 작성
        </button>
      </div>

      <div class="board-grid">
        <%-- 실제로는 게시글 리스트 loop (예시용) --%>
        <c:forEach begin="1" end="6">
          <a href="/walk-matching/detail" class="board-card">
            <img class="board-card-thumb" src="/images/dog1.jpg" alt="대표 사진"/>
            <div class="board-card-body">
              <div class="board-card-title">천안천 산책하실 분</div>
              <div class="board-card-text">
                천안천 산책 같이 하실 분 구합니다. 내일 오전 9시에 가벼운 산책 계획 중이에요...
              </div>
              <div class="board-card-meta">
                <span>말티즈 · 2살 · 소형견</span>
                <span>조회 15 · 2025.11.26</span>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>

      <!-- 페이징 (예시) -->
      <div class="board-pagination">
        <button class="page-btn">&lt;</button>
        <button class="page-btn active">1</button>
        <button class="page-btn">2</button>
        <button class="page-btn">3</button>
        <button class="page-btn">&gt;</button>
      </div>
    </section>

  </div>
</div>
