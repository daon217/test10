<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3><i class="fas fa-clipboard-list"></i> 내 구인 글 관리</h3>
                    <a href="<c:url value='/walkpt/owner/post-write'/>" class="btn btn-pet-primary">
                        <i class="fas fa-plus"></i> 새 구인 글 작성
                    </a>
                </div>

                <!-- 필터 탭 -->
                <ul class="nav nav-tabs walkpt-tabs mb-4" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#all" role="tab">
                            전체
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#recruiting" role="tab">
                            모집 중
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#inProgress" role="tab">
                            진행 중
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#completed" role="tab">
                            완료
                        </a>
                    </li>
                </ul>

                <!-- 탭 컨텐츠 -->
                <div class="tab-content">
                    <!-- 전체 -->
                    <div class="tab-pane fade show active" id="all" role="tabpanel">
                        <div class="row">
                            <!-- 구인 글 카드 예시 1 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">소형견 산책 도와주실 분</h5>
                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-12-01 오후 3:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 포메라니안 (소형, 3살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강남구 역삼동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-users"></i> 지원자: <strong class="text-primary">3명</strong>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <div class="btn-group btn-group-sm w-100" role="group">
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=1'/>"
                                                class="btn btn-pet-outline">
                                                <i class="fas fa-eye"></i> 상세
                                            </a>
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=1#applicants'/>"
                                                class="btn btn-pet-primary">
                                                <i class="fas fa-users"></i> 지원자
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 구인 글 카드 예시 2 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">중형견 산책 알바 구합니다</h5>
                                        <span class="walkpt-badge badge-progress">진행 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-28 오전 10:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 웰시코기 (중형, 2살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 송파구 잠실동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-user-check"></i> 매칭: <strong
                                                class="text-success">김산책</strong>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <a href="<c:url value='/walkpt/owner/monitoring?sessionId=1'/>"
                                            class="btn btn-pet-primary btn-sm btn-block">
                                            <i class="fas fa-eye"></i> 산책 모니터링
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- 구인 글 카드 예시 3 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">활발한 대형견 산책</h5>
                                        <span class="walkpt-badge badge-completed">완료</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-25 오후 5:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 골든리트리버 (대형, 4살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-star"></i> 후기:
                                            <c:choose>
                                                <c:when test="${true}">
                                                    <span class="text-success">작성 완료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger">미작성</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <div class="btn-group btn-group-sm w-100" role="group">
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=3'/>"
                                                class="btn btn-pet-outline">
                                                <i class="fas fa-eye"></i> 상세
                                            </a>
                                            <a href="<c:url value='/walkpt/owner/review-write?sessionId=3'/>"
                                                class="btn btn-pet-secondary">
                                                <i class="fas fa-star"></i> 후기
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 모집 중 -->
                    <div class="tab-pane fade" id="recruiting" role="tabpanel">
                        <div class="row">
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">소형견 산책 도와주실 분</h5>
                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-12-01 오후 3:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 포메라니안 (소형, 3살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강남구 역삼동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-users"></i> 지원자: <strong class="text-primary">3명</strong>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <div class="btn-group btn-group-sm w-100" role="group">
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=1'/>"
                                                class="btn btn-pet-outline">
                                                <i class="fas fa-eye"></i> 상세
                                            </a>
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=1#applicants'/>"
                                                class="btn btn-pet-primary">
                                                <i class="fas fa-users"></i> 지원자
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 진행 중 -->
                    <div class="tab-pane fade" id="inProgress" role="tabpanel">
                        <div class="row">
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">중형견 산책 알바 구합니다</h5>
                                        <span class="walkpt-badge badge-progress">진행 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-28 오전 10:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 웰시코기 (중형, 2살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 송파구 잠실동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-user-check"></i> 매칭: <strong
                                                class="text-success">김산책</strong>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <a href="<c:url value='/walkpt/owner/monitoring?sessionId=1'/>"
                                            class="btn btn-pet-primary btn-sm btn-block">
                                            <i class="fas fa-eye"></i> 산책 모니터링
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 완료 -->
                    <div class="tab-pane fade" id="completed" role="tabpanel">
                        <div class="row">
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">활발한 대형견 산책</h5>
                                        <span class="walkpt-badge badge-completed">완료</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-25 오후 5:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-dog"></i> 골든리트리버 (대형, 4살)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-star"></i> 후기: <span class="text-success">작성 완료</span>
                                        </p>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <div class="btn-group btn-group-sm w-100" role="group">
                                            <a href="<c:url value='/walkpt/owner/post-detail?id=3'/>"
                                                class="btn btn-pet-outline">
                                                <i class="fas fa-eye"></i> 상세
                                            </a>
                                            <a href="<c:url value='/walkpt/owner/review-write?sessionId=3'/>"
                                                class="btn btn-pet-secondary">
                                                <i class="fas fa-star"></i> 후기
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 빈 상태 메시지 (데이터가 없을 때) -->
                <div class="text-center py-5" style="display: none;" id="emptyState">
                    <i class="fas fa-inbox" style="font-size: 4rem; color: var(--text-tertiary);"></i>
                    <p class="text-muted mt-3">등록한 구인 글이 없습니다</p>
                    <a href="<c:url value='/walkpt/owner/post-write'/>" class="btn btn-pet-primary mt-2">
                        <i class="fas fa-plus"></i> 첫 구인 글 작성하기
                    </a>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />