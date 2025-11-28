<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <h3 class="mb-4"><i class="fas fa-comments"></i> 채팅 목록</h3>

                <div class="row">
                    <div class="col-md-8 mx-auto">
                        <div class="pet-card">
                            <div class="pet-card-body">
                                <!-- 채팅방 아이템 1 -->
                                <div class="card mb-3" style="cursor: pointer;" onclick="openChatRoom(1)">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <img src="https://via.placeholder.com/60x60?text=User" alt="프로필"
                                                class="rounded-circle mr-3" width="60">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">홍길동</h6>
                                                <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                                    네, 무엇이든 물어보세요!
                                                </p>
                                                <small class="text-muted">오후 3:27</small>
                                            </div>
                                            <div class="text-right">
                                                <span class="badge badge-danger">2</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 채팅방 아이템 2 -->
                                <div class="card mb-3" style="cursor: pointer;" onclick="openChatRoom(2)">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <img src="https://via.placeholder.com/60x60?text=User" alt="프로필"
                                                class="rounded-circle mr-3" width="60">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">김산책</h6>
                                                <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                                    감사합니다! 그럼 내일 봬요 🐕
                                                </p>
                                                <small class="text-muted">오전 11:42</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 채팅방 아이템 3 -->
                                <div class="card mb-3" style="cursor: pointer;" onclick="openChatRoom(3)">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <img src="https://via.placeholder.com/60x60?text=User" alt="프로필"
                                                class="rounded-circle mr-3" width="60">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">박돌봄</h6>
                                                <p class="text-muted mb-1" style="font-size: 0.9rem;">
                                                    알겠습니다. 조심히 데려다드리겠습니다.
                                                </p>
                                                <small class="text-muted">어제</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 빈 상태 -->
                                <div class="text-center py-5" style="display: none;" id="emptyState">
                                    <i class="fas fa-comment-slash"
                                        style="font-size: 4rem; color: var(--text-tertiary);"></i>
                                    <p class="text-muted mt-3">아직 채팅 내역이 없습니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="panel.jsp" />

        <script>
            function openChatRoom(userId) {
                // 채팅 패널 열기
                const panel = document.getElementById('chatPanel');
                if (panel) {
                    // 사용자 이름 업데이트
                    const names = ['', '홍길동', '김산책', '박돌봄'];
                    document.getElementById('chatUserName').textContent = names[userId];

                    panel.classList.add('active');
                }
            }
        </script>