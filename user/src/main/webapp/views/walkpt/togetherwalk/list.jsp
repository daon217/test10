<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

<div class="walkpt-container">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="text-center mb-5">
            <h1 class="mb-3">
                <i class="fas fa-users text-primary"></i> 함께 산책하기
            </h1>
            <p class="lead text-secondary">
                같은 시간, 같은 장소에서 함께 산책할 반려인을 찾아보세요
            </p>
        </div>

        <!-- 액션 버튼 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="<c:url value='/walkpt'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> 돌아가기
                </a>
            </div>
            <div>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="<c:url value='/walkpt/togetherwalk/write'/>" class="btn btn-pet-primary">
                            <i class="fas fa-plus"></i> 글 작성하기
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-pet-primary" onclick="showLoginRequired()">
                            <i class="fas fa-plus"></i> 글 작성하기
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 검색 및 필터 -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="searchKeyword"><i class="fas fa-search"></i> 검색</label>
                            <input type="text" class="form-control" id="searchKeyword"
                                   placeholder="제목 또는 내용 검색...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="filterLocation"><i class="fas fa-map-marker-alt"></i> 지역</label>
                            <select class="form-control" id="filterLocation">
                                <option value="">전체</option>
                                <option value="강남구">강남구</option>
                                <option value="송파구">송파구</option>
                                <option value="강동구">강동구</option>
                                <option value="서초구">서초구</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="filterPetSize"><i class="fas fa-paw"></i> 반려동물 크기</label>
                            <select class="form-control" id="filterPetSize">
                                <option value="">전체</option>
                                <option value="small">소형</option>
                                <option value="medium">중형</option>
                                <option value="large">대형</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button class="btn btn-pet-primary btn-block" onclick="applyFilters()">
                                <i class="fas fa-filter"></i> 검색
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 글 목록 -->
        <h4 class="mb-4"><i class="fas fa-list"></i> 최근 게시글</h4>
        <div class="row" id="postList">
            <!-- 게시글 카드 1 -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="walkpt-card">
                    <div class="walkpt-card-header">
                        <h5 class="walkpt-card-title">한강공원에서 함께 산책해요!</h5>
                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                    </div>
                    <div class="walkpt-card-body">
                        <p class="walkpt-card-info">
                            <i class="fas fa-user"></i> 홍길동
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-map-marker-alt"></i> 서울 강남구 삼성동
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-calendar-alt"></i> 2025-12-05 오후 3:00
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-dog"></i> 말티즈 (소형, 2살)
                        </p>
                        <div class="walkpt-tags">
                            <span class="walkpt-tag">소형견</span>
                            <span class="walkpt-tag">한강공원</span>
                            <span class="walkpt-tag">평일</span>
                        </div>
                    </div>
                    <div class="walkpt-card-footer">
                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showDetail(1)">
                            <i class="fas fa-eye"></i> 상세보기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 게시글 카드 2 -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="walkpt-card">
                    <div class="walkpt-card-header">
                        <h5 class="walkpt-card-title">주말 아침 산책 메이트 구해요</h5>
                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                    </div>
                    <div class="walkpt-card-body">
                        <p class="walkpt-card-info">
                            <i class="fas fa-user"></i> 김산책
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-map-marker-alt"></i> 서울 송파구 잠실동
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-calendar-alt"></i> 2025-12-07 오전 9:00
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-dog"></i> 웰시코기 (중형, 3살)
                        </p>
                        <div class="walkpt-tags">
                            <span class="walkpt-tag">중형견</span>
                            <span class="walkpt-tag">주말</span>
                            <span class="walkpt-tag">아침</span>
                        </div>
                    </div>
                    <div class="walkpt-card-footer">
                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showDetail(2)">
                            <i class="fas fa-eye"></i> 상세보기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 게시글 카드 3 -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="walkpt-card">
                    <div class="walkpt-card-header">
                        <h5 class="walkpt-card-title">올림픽공원 산책 같이해요</h5>
                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                    </div>
                    <div class="walkpt-card-body">
                        <p class="walkpt-card-info">
                            <i class="fas fa-user"></i> 박반려
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-calendar-alt"></i> 2025-12-03 오후 5:00
                        </p>
                        <p class="walkpt-card-info">
                            <i class="fas fa-dog"></i> 골든리트리버 (대형, 5살)
                        </p>
                        <div class="walkpt-tags">
                            <span class="walkpt-tag">대형견</span>
                            <span class="walkpt-tag">올림픽공원</span>
                            <span class="walkpt-tag">평일</span>
                        </div>
                    </div>
                    <div class="walkpt-card-footer">
                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showDetail(3)">
                            <i class="fas fa-eye"></i> 상세보기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 페이지네이션 -->
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1">이전</a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item">
                    <a class="page-link" href="#">다음</a>
                </li>
            </ul>
        </nav>
    </div>
</div>

<!-- 로그인 필요 모달 -->
<jsp:include page="../common/modals.jsp" />

<script>
    // 로그인 여부 체크
    const isLoggedIn = ${ not empty sessionScope.user };

    // 상세보기
    function showDetail(postId) {
        window.location.href = '<c:url value="/walkpt/togetherwalk/detail"/>?id=' + postId;
    }

    // 필터 적용
    function applyFilters() {
        const keyword = document.getElementById('searchKeyword').value;
        const location = document.getElementById('filterLocation').value;
        const petSize = document.getElementById('filterPetSize').value;

        // 실제로는 서버에 요청
        console.log('Filters:', { keyword, location, petSize });
        showToast('검색 조건이 적용되었습니다.', 'info');
    }

    // 로그인 필요 모달
    function showLoginRequired() {
        $('#loginRequiredModal').modal('show');
    }
</script>