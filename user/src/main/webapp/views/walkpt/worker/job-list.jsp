<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <h3 class="mb-4"><i class="fas fa-briefcase"></i> 알바 모집 글 목록</h3>

                <!-- 검색/필터 -->
                <div class="pet-card mb-4">
                    <div class="pet-card-body">
                        <form class="form-inline">
                            <div class="form-group mr-2 mb-2">
                                <label for="regionFilter" class="mr-2">지역:</label>
                                <select class="form-control" id="regionFilter">
                                    <option value="">전체</option>
                                    <option value="gangnam">강남구</option>
                                    <option value="songpa">송파구</option>
                                    <option value="gangdong">강동구</option>
                                </select>
                            </div>
                            <div class="form-group mr-2 mb-2">
                                <label for="petSizeFilter" class="mr-2">반려동물 크기:</label>
                                <select class="form-control" id="petSizeFilter">
                                    <option value="">전체</option>
                                    <option value="small">소형견</option>
                                    <option value="medium">중형견</option>
                                    <option value="large">대형견</option>
                                </select>
                            </div>
                            <button type="button" class="btn btn-pet-primary mb-2">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </form>
                    </div>
                </div>

                <!-- 구인 글 리스트 -->
                <div class="row">
                    <!-- 구인 글 카드 1 -->
                    <div class="col-md-6 col-lg-4">
                        <div class="walkpt-card" style="cursor: pointer;" onclick="showJobDetail(1)">
                            <div class="walkpt-card-header">
                                <h5 class="walkpt-card-title">소형견 산책 도와주실 분</h5>
                                <span class="walkpt-badge badge-recruiting">모집 중</span>
                            </div>
                            <div class="walkpt-card-body">
                                <p class="walkpt-card-info">
                                    <i class="fas fa-map-marker-alt"></i> 서울 강남구 역삼동
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-calendar-alt"></i> 2025-12-01 오후 3:00
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-dog"></i> 포메라니안 (소형, 3살)
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-won-sign"></i> 시급 15,000원
                                </p>
                                <div class="walkpt-tags">
                                    <span class="walkpt-tag">소형견</span>
                                    <span class="walkpt-tag">평일</span>
                                    <span class="walkpt-tag">오후</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="walkpt-card" style="cursor: pointer;" onclick="showJobDetail(2)">
                            <div class="walkpt-card-header">
                                <h5 class="walkpt-card-title">중형견 산책 알바 구합니다</h5>
                                <span class="walkpt-badge badge-recruiting">모집 중</span>
                            </div>
                            <div class="walkpt-card-body">
                                <p class="walkpt-card-info">
                                    <i class="fas fa-map-marker-alt"></i> 서울 송파구 잠실동
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-calendar-alt"></i> 2025-12-02 오전 10:00
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-dog"></i> 웰시코기 (중형, 2살)
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-won-sign"></i> 시급 20,000원
                                </p>
                                <div class="walkpt-tags">
                                    <span class="walkpt-tag">중형견</span>
                                    <span class="walkpt-tag">주말</span>
                                    <span class="walkpt-tag">오전</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <div class="walkpt-card" style="cursor: pointer;" onclick="showJobDetail(3)">
                            <div class="walkpt-card-header">
                                <h5 class="walkpt-card-title">활발한 대형견 산책</h5>
                                <span class="walkpt-badge badge-recruiting">모집 중</span>
                            </div>
                            <div class="walkpt-card-body">
                                <p class="walkpt-card-info">
                                    <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-calendar-alt"></i> 2025-12-03 오후 5:00
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-dog"></i> 골든리트리버 (대형, 4살)
                                </p>
                                <p class="walkpt-card-info">
                                    <i class="fas fa-won-sign"></i> 시급 25,000원
                                </p>
                                <div class="walkpt-tags">
                                    <span class="walkpt-tag">대형견</span>
                                    <span class="walkpt-tag">평일</span>
                                    <span class="walkpt-tag">저녁</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 구인 글 상세 모달 -->
        <div class="modal fade" id="jobDetailModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-clipboard-list"></i> 구인 글 상세</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="jobDetailContent">
                        <!-- 상세 내용이 여기에 로드됨 -->
                        <div class="mb-3">
                            <h5>소형견 산책 도와주실 분</h5>
                            <span class="walkpt-badge badge-recruiting">모집 중</span>
                        </div>
                        <hr>
                        <h6><i class="fas fa-paw"></i> 반려동물 정보</h6>
                        <p>이름: 몽이<br>종류: 포메라니안 (소형, 3살)</p>
                        <hr>
                        <h6><i class="fas fa-calendar-check"></i> 산책 조건</h6>
                        <p>날짜: 2025-12-01<br>시간: 오후 3:00 ~ 5:00<br>지역: 서울 강남구 역삼동<br>보수: 시급 15,000원</p>
                        <hr>
                        <h6><i class="fas fa-exclamation-circle"></i> 유의사항</h6>
                        <p>낯을 많이 가려서 처음엔 조금 경계할 수 있어요. 다른 강아지를 보면 짖을 수 있으니 주의해주세요.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-pet-secondary" onclick="openChatFromModal()">
                            <i class="fas fa-comment"></i> 채팅하기
                        </button>
                        <button type="button" class="btn btn-pet-primary" onclick="applyToJobFromModal()">
                            <i class="fas fa-paper-plane"></i> 지원하기
                        </button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />
        <jsp:include page="../chat/panel.jsp" />

        <script>
            // 로그인 여부 체크 (서버에서 세션 정보 받아오기)
            const isLoggedIn = ${ not empty sessionScope.user };

            function showJobDetail(jobId) {
                // 실제로는 서버에서 상세 데이터 가져오기
                console.log('Showing job detail for ID:', jobId);
                $('#jobDetailModal').modal('show');
            }

            function openChatFromModal() {
                if (!isLoggedIn) {
                    $('#jobDetailModal').modal('hide');
                    setTimeout(() => {
                        showLoginRequired();
                    }, 300);
                } else {
                    $('#jobDetailModal').modal('hide');
                    setTimeout(() => {
                        const panel = document.getElementById('chatPanel');
                        if (panel) {
                            panel.classList.add('active');
                        }
                    }, 300);
                }
            }

            function applyToJobFromModal() {
                if (!isLoggedIn) {
                    $('#jobDetailModal').modal('hide');
                    setTimeout(() => {
                        showLoginRequired();
                    }, 300);
                } else {
                    $('#jobDetailModal').modal('hide');
                    setTimeout(() => {
                        applyToJob(1);
                    }, 300);
                }
            }
        </script>