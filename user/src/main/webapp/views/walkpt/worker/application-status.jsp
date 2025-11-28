<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <h3 class="mb-4"><i class="fas fa-clipboard-check"></i> 내 알바 지원 현황</h3>

                <!-- 현황 카드 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="pet-card text-center">
                            <h4 class="text-primary">5</h4>
                            <p class="mb-0">총 지원</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="pet-card text-center">
                            <h4 class="text-warning">2</h4>
                            <p class="mb-0">대기 중</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="pet-card text-center">
                            <h4 class="text-success">2</h4>
                            <p class="mb-0">수락됨</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="pet-card text-center">
                            <h4 class="text-secondary">1</h4>
                            <p class="mb-0">완료</p>
                        </div>
                    </div>
                </div>

                <!-- 지원 목록 -->
                <div class="pet-card">
                    <div class="pet-card-body">
                        <!-- 지원 항목 1 - 대기 중 -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h5>소형견 산책 도와주실 분</h5>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-calendar-alt"></i> 2025-12-01 오후 3:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강남구 역삼동
                                        </p>
                                        <span class="walkpt-badge" style="background: #fff3e0; color: #f57c00;">대기
                                            중</span>
                                    </div>
                                    <div>
                                        <button class="btn btn-outline-danger btn-sm" onclick="cancelApplication(1)">
                                            <i class="fas fa-times"></i> 지원 취소
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 지원 항목 2 - 수락됨 -->
                        <div class="card mb-3 border-success">
                            <div class="card-header bg-success text-white">
                                <i class="fas fa-check-circle"></i> 수락됨
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h5>중형견 산책 알바 구합니다</h5>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-30 오전 10:00
                                        </p>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-map-marker-alt"></i> 서울 송파구 잠실동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-user"></i> 반려인: 홍길동님
                                        </p>
                                    </div>
                                    <div>
                                        <button class="btn btn-pet-secondary btn-sm mb-2" onclick="openChat()">
                                            <i class="fas fa-comment"></i> 채팅
                                        </button>
                                        <a href="<c:url value='/walkpt/worker/work-progress?sessionId=1'/>"
                                            class="btn btn-pet-primary btn-sm">
                                            <i class="fas fa-play"></i> 산책 시작
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 지원 항목 3 - 진행 중 -->
                        <div class="card mb-3 border-primary">
                            <div class="card-header bg-primary text-white">
                                <i class="fas fa-running"></i> 진행 중
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h5>고양이 산책 도와주세요</h5>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-calendar-alt"></i> 오늘 오후 2:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-clock"></i> 경과 시간: 32분
                                        </p>
                                    </div>
                                    <div>
                                        <a href="<c:url value='/walkpt/worker/work-progress?sessionId=2'/>"
                                            class="btn btn-pet-primary btn-sm">
                                            <i class="fas fa-eye"></i> 진행 상황 보기
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 지원 항목 4 - 완료 -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h5>활발한 대형견 산책</h5>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-27 오후 5:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                                        </p>
                                        <span class="walkpt-badge badge-completed">완료</span>
                                    </div>
                                    <div>
                                        <button class="btn btn-pet-outline btn-sm">
                                            <i class="fas fa-eye"></i> 상세 보기
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 지원 항목 5 - 거절됨 -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h5>강아지 산책 알바</h5>
                                        <p class="walkpt-card-info mb-1">
                                            <i class="fas fa-calendar-alt"></i> 2025-12-05 오전 9:00
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강남구
                                        </p>
                                        <span class="walkpt-badge"
                                            style="background: #ffebee; color: #c62828;">거절됨</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />
        <jsp:include page="../chat/panel.jsp" />

        <script>
            function cancelApplication(applicationId) {
                showConfirmModal('지원 취소', '정말 지원을 취소하시겠습니까?', function () {
                    // 실제로는 서버에 요청
                    showToast('지원이 취소되었습니다.', 'info');
                    setTimeout(function () {
                        location.reload();
                    }, 1500);
                });
            }

            function openChat() {
                const panel = document.getElementById('chatPanel');
                if (panel) {
                    panel.classList.add('active');
                }
            }
        </script>