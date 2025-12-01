<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

            <div class="walkpt-container">
                <div class="container">
                    <!-- 서비스 헤더 -->
                    <div class="text-center mb-5">
                        <h1 class="mb-3">
                            <i class="fas fa-handshake text-primary"></i> 산책 알바 매칭
                        </h1>
                        <p class="lead text-secondary">
                            반려인과 산책 알바를 연결해주는 AI 기반 매칭 서비스
                        </p>
                    </div>

                    <!-- 탭 및 액션 버튼 -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <ul class="nav nav-tabs walkpt-tabs border-0" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="tab" href="#jobPostings" role="tab">
                                    <i class="fas fa-clipboard-list"></i> 구인 글 보기
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#workerPostings" role="tab">
                                    <i class="fas fa-user-check"></i> 구직 글 보기
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#togetherWalk" role="tab">
                                    <i class="fas fa-users"></i> 함께 산책하기
                                </a>
                            </li>
                        </ul>
                        <div class="action-buttons">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="<c:url value='/walkpt/owner/post-write'/>"
                                        class="btn btn-pet-primary mr-2">
                                        <i class="fas fa-plus"></i> 구인 글 작성
                                    </a>
                                    <a href="<c:url value='/walkpt/worker/job-post-write'/>"
                                        class="btn btn-pet-secondary mr-2">
                                        <i class="fas fa-plus"></i> 구직 글 작성
                                    </a>
                                    <a href="<c:url value='/walkpt/togetherwalk/write'/>" class="btn btn-pet-info">
                                        <i class="fas fa-plus"></i> 함께 산책하기
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-pet-primary mr-2" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 구인 글 작성
                                    </button>
                                    <button class="btn btn-pet-secondary mr-2" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 구직 글 작성
                                    </button>
                                    <button class="btn btn-pet-info" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 함께 산책하기
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 탭 컨텐츠 -->
                    <div class="tab-content mt-5">
                        <!-- 구인 글 목록 -->
                        <div class="tab-pane fade show active" id="jobPostings" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-clipboard-list"></i> 최근 구인 글</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty ownerPosts}">
                                        <c:forEach items="${ownerPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-calendar-alt"></i> ${post.walkDate}
                                                            ${post.walkTime}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-dog"></i> ${post.petName}
                                                            (${post.petBreed}, ${post.petAge}살)
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-won-sign"></i> 시급
                                                            <fmt:formatNumber value="${post.payAmount}" type="number" />
                                                            원
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="<c:url value='/walkpt/owner/post-detail?id=${post.postId}'/>"
                                                            class="btn btn-pet-outline btn-sm btn-block">
                                                            <i class="fas fa-eye"></i> 상세보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 구인 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <a href="<c:url value='/walkpt/worker/job-list'/>" class="btn btn-pet-primary">
                                    <i class="fas fa-plus-circle"></i> 더 많은 구인 글 보기
                                </a>
                            </div>
                        </div>

                        <!-- 구직 글 목록 -->
                        <div class="tab-pane fade" id="workerPostings" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-user-check"></i> 최근 구직 글</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty workerPosts}">
                                        <c:forEach items="${workerPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">구직 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-user"></i> ${post.userName}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-clock"></i> ${post.walkTime}
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="#" class="btn btn-pet-outline btn-sm btn-block"
                                                            onclick="alert('준비 중입니다.')">
                                                            <i class="fas fa-eye"></i> 이력서 보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 구직 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <button class="btn btn-pet-primary" onclick="alert('준비 중입니다.')">
                                    <i class="fas fa-plus-circle"></i> 더 많은 구직 글 보기
                                </button>
                            </div>
                        </div>

                        <!-- 함께 산책하기 목록 -->
                        <div class="tab-pane fade" id="togetherWalk" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-users"></i> 함께 산책하기</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty togetherPosts}">
                                        <c:forEach items="${togetherPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-user"></i> ${post.userName}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-calendar-alt"></i> ${post.walkDate}
                                                            ${post.walkTime}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-dog"></i> ${post.petName}
                                                            (${post.petBreed}, ${post.petAge}살)
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="<c:url value='/walkpt/togetherwalk/detail?id=${post.postId}'/>"
                                                            class="btn btn-pet-outline btn-sm btn-block">
                                                            <i class="fas fa-eye"></i> 상세보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 함께 산책하기 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <a href="<c:url value='/walkpt/togetherwalk/list'/>" class="btn btn-pet-primary">
                                    <i class="fas fa-plus-circle"></i> 더 많은 글 보기
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 로그인 필요 모달 및 공통 함수 -->
            <jsp:include page="common/modals.jsp" />

            <script>
                // 로그인 필요 모달 표시
                function showLoginRequired() {
                    $('#loginRequiredModal').modal('show');
                }
            </script>