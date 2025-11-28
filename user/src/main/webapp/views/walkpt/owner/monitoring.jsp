<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container-fluid">
                <h3 class="mb-4"><i class="fas fa-eye"></i> 산책 모니터링</h3>

                <div class="monitor-container">
                    <!-- 좌측: 지도/경로 영역 -->
                    <div class="map-placeholder">
                        <div class="text-center">
                            <i class="fas fa-map-marked-alt" style="font-size: 3rem;"></i>
                            <p class="mt-3">지도/경로 표시 영역</p>
                            <small class="text-muted">(실제 지도 API 연동 예정)</small>
                        </div>
                    </div>

                    <!-- 우측: 정보 사이드바 -->
                    <div class="monitor-sidebar">
                        <!-- 세션 정보 -->
                        <div class="mb-4">
                            <h5><i class="fas fa-info-circle"></i> 산책 정보</h5>
                            <div class="mt-3">
                                <p><strong>알바생:</strong> 김산책</p>
                                <p><strong>반려동물:</strong> 몽이 (포메라니안)</p>
                                <p><strong>예정 시간:</strong> 오후 3:00 - 5:00</p>
                                <p>
                                    <strong>현재 상태:</strong>
                                    <span class="badge badge-success">진행 중</span>
                                </p>
                            </div>
                        </div>

                        <hr>

                        <!-- 진행 통계 -->
                        <div class="monitor-stats mb-4">
                            <div class="stat-item">
                                <div class="stat-value">45:32</div>
                                <div class="stat-label">경과 시간</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">2.3km</div>
                                <div class="stat-label">이동 거리</div>
                            </div>
                        </div>

                        <hr>

                        <!-- 로그/피드 리스트 -->
                        <div class="mb-3">
                            <h6><i class="fas fa-list"></i> 활동 로그</h6>
                        </div>

                        <div class="log-list">
                            <div class="log-item">
                                <span class="log-time">15:45</span>
                                <span>산책 시작</span>
                            </div>
                            <div class="log-item">
                                <span class="log-time">15:52</span>
                                <span>공원 도착</span>
                            </div>
                            <div class="log-item">
                                <span class="log-time">16:05</span>
                                <span>배변 완료</span>
                            </div>
                            <div class="log-item">
                                <span class="log-time">16:12</span>
                                <span>물 급여</span>
                            </div>
                            <div class="log-item">
                                <span class="log-time">16:18</span>
                                <span><i class="fas fa-camera text-primary"></i> 사진 업로드</span>
                            </div>
                            <div class="log-item">
                                <span class="log-time">16:25</span>
                                <span><i class="fas fa-recycle text-success"></i> 환경 활동: 쓰레기 줍기</span>
                            </div>
                        </div>

                        <!-- 사진 썸네일 -->
                        <div class="mt-4">
                            <h6><i class="fas fa-images"></i> 산책 사진</h6>
                            <div class="d-flex flex-wrap mt-2">
                                <img src="https://via.placeholder.com/80x80?text=Photo1" class="mr-2 mb-2 rounded"
                                    style="cursor: pointer;">
                                <img src="https://via.placeholder.com/80x80?text=Photo2" class="mr-2 mb-2 rounded"
                                    style="cursor: pointer;">
                                <img src="https://via.placeholder.com/80x80?text=Photo3" class="mr-2 mb-2 rounded"
                                    style="cursor: pointer;">
                            </div>
                        </div>

                        <!-- 액션 버튼 -->
                        <div class="mt-4">
                            <button class="btn btn-pet-secondary btn-block mb-2" onclick="openChat()">
                                <i class="fas fa-comment"></i> 채팅 열기
                            </button>
                            <button class="btn btn-pet-outline btn-block" onclick="alert('영상 통화 기능은 준비 중입니다')">
                                <i class="fas fa-video"></i> 영상 통화 (준비 중)
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../chat/panel.jsp" />

        <script>
            function openChat() {
                const panel = document.getElementById('chatPanel');
                if (panel) {
                    panel.classList.add('active');
                }
            }

            // 실시간 업데이트 시뮬레이션 (실제로는 WebSocket 사용)
            let elapsedSeconds = 2732; // 45:32
            setInterval(function () {
                elapsedSeconds++;
                const minutes = Math.floor(elapsedSeconds / 60);
                const seconds = elapsedSeconds % 60;
                const timeStr = minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
                document.querySelector('.stat-value').textContent = timeStr;
            }, 1000);
        </script>