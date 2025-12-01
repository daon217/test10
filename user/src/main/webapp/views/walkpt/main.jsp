<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                                <a href="<c:url value='/walkpt/owner/post-write'/>" class="btn btn-pet-primary mr-2">
                                    <i class="fas fa-plus"></i> 구인 글 작성
                                </a>
                                <a href="<c:url value='/walkpt/worker/job-post-write'/>" class="btn btn-pet-secondary mr-2">
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
                            <!-- 구인 글 카드 1 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
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
                                    <div class="walkpt-card-footer">
                                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showJobDetail(1)">
                                            <i class="fas fa-eye"></i> 상세보기
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- 구인 글 카드 2 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
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
                                    <div class="walkpt-card-footer">
                                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showJobDetail(2)">
                                            <i class="fas fa-eye"></i> 상세보기
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- 구인 글 카드 3 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">활발한 대형견 산책</h5>
                                        <span class="walkpt-badge badge-progress">진행 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강동구 천호동
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-calendar-alt"></i> 2025-11-30 오후 5:00
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
                                    <div class="walkpt-card-footer">
                                        <button class="btn btn-pet-outline btn-sm btn-block" onclick="showJobDetail(3)">
                                            <i class="fas fa-eye"></i> 상세보기
                                        </button>
                                    </div>
                                </div>
                            </div>
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
                            <!-- 구직 글 카드 예시 -->
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card">
                                    <div class="walkpt-card-header">
                                        <h5 class="walkpt-card-title">책임감 있는 산책 알바</h5>
                                        <span class="walkpt-badge badge-recruiting">구직 중</span>
                                    </div>
                                    <div class="walkpt-card-body">
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-user"></i> 김산책 (25세)
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-map-marker-alt"></i> 서울 강남구, 송파구
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-clock"></i> 평일 오전·오후, 주말 가능
                                        </p>
                                        <p class="walkpt-card-info">
                                            <i class="fas fa-paw"></i> 소형·중형견 경험 5년
                                        </p>
                                        <div class="walkpt-tags">
                                            <span class="walkpt-tag">반려견 키움</span>
                                            <span class="walkpt-tag">자격증 보유</span>
                                        </div>
                                    </div>
                                    <div class="walkpt-card-footer">
                                        <button class="btn btn-pet-outline btn-sm btn-block">
                                            <i class="fas fa-eye"></i> 이력서 보기
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <button class="btn btn-pet-primary">
                                <i class="fas fa-plus-circle"></i> 더 많은 구직 글 보기
                            </button>
                        </div>
                    </div> <!-- 여기 추가: 구직 글 탭 닫기 -->
                    <!-- 함께 산책하기 목록 -->
                    <div class="tab-pane fade" id="togetherWalk" role="tabpanel">
                        <!-- 함께 산책하기 목록 -->
                            <h4 class="mb-4"><i class="fas fa-users"></i> 함께 산책하기</h4>
                            <div class="row">
                                <!-- 함께 산책하기 카드 1 -->
                                <div class="col-md-6 col-lg-4">
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
                                            <button class="btn btn-pet-outline btn-sm btn-block"
                                                    onclick="showTogetherWalkDetail(1)">
                                                <i class="fas fa-eye"></i> 상세보기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <!-- 함께 산책하기 카드 2 -->
                                <div class="col-md-6 col-lg-4">
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
                                            <button class="btn btn-pet-outline btn-sm btn-block"
                                                    onclick="showTogetherWalkDetail(2)">
                                                <i class="fas fa-eye"></i> 상세보기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <!-- 함께 산책하기 카드 3 -->
                                <div class="col-md-6 col-lg-4">
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
                                            <button class="btn btn-pet-outline btn-sm btn-block"
                                                    onclick="showTogetherWalkDetail(3)">
                                                <i class="fas fa-eye"></i> 상세보기
                                            </button>
                                        </div>
                                    </div>
                                </div>
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
                            <h5 id="jobTitle">소형견 산책 도와주실 분</h5>
                            <span class="walkpt-badge badge-recruiting">모집 중</span>
                        </div>
                        <hr>
                        <h6><i class="fas fa-paw"></i> 반려동물 정보</h6>
                        <p id="petInfo">이름: 몽이<br>종류: 포메라니안 (소형, 3살)</p>
                        <hr>
                        <h6><i class="fas fa-calendar-check"></i> 산책 조건</h6>
                        <p id="walkInfo">날짜: 2025-12-01<br>시간: 오후 3:00 ~ 5:00<br>지역: 서울 강남구 역삼동<br>보수: 시급 15,000원</p>
                        <hr>
                        <h6><i class="fas fa-exclamation-circle"></i> 유의사항</h6>
                        <p id="notes">낯을 많이 가려서 처음엔 조금 경계할 수 있어요. 다른 강아지를 보면 짖을 수 있으니 주의해주세요.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-pet-primary" onclick="applyToJobFromModal()">
                            <i class="fas fa-paper-plane"></i> 채팅하기
                        </button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 로그인 필요 모달 및 공통 함수 -->
        <jsp:include page="common/modals.jsp" />

        <script>
            // 로그인 여부 체크
            const isLoggedIn = ${ not empty sessionScope.user };

            // 구인글 상세 데이터 (실제로는 서버에서 가져와야 함)
            const jobData = {
                1: {
                    title: '소형견 산책 도와주실 분',
                    petInfo: '이름: 몽이<br>종류: 포메라니안 (소형, 3살)',
                    walkInfo: '날짜: 2025-12-01<br>시간: 오후 3:00 ~ 5:00<br>지역: 서울 강남구 역삼동<br>보수: 시급 15,000원',
                    notes: '낯을 많이 가려서 처음엔 조금 경계할 수 있어요. 다른 강아지를 보면 짖을 수 있으니 주의해주세요.'
                },
                2: {
                    title: '중형견 산책 알바 구합니다',
                    petInfo: '이름: 코코<br>종류: 웰시코기 (중형, 2살)',
                    walkInfo: '날짜: 2025-12-02<br>시간: 오전 10:00 ~ 12:00<br>지역: 서울 송파구 잠실동<br>보수: 시급 20,000원',
                    notes: '활발한 성격이라 산책량이 많습니다. 체력이 좋으신 분이면 좋겠어요!'
                },
                3: {
                    title: '활발한 대형견 산책',
                    petInfo: '이름: 골디<br>종류: 골든리트리버 (대형, 4살)',
                    walkInfo: '날짜: 2025-11-30<br>시간: 오후 5:00 ~ 7:00<br>지역: 서울 강동구 천호동<br>보수: 시급 25,000원',
                    notes: '대형견이지만 온순합니다. 힘이 세니 리드줄을 단단히 잡아주세요.'
                }
            };

            function showJobDetail(jobId) {
                const job = jobData[jobId];
                if (job) {
                    document.getElementById('jobTitle').textContent = job.title;
                    document.getElementById('petInfo').innerHTML = job.petInfo;
                    document.getElementById('walkInfo').innerHTML = job.walkInfo;
                    document.getElementById('notes').textContent = job.notes;
                }
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
            // 함께 산책하기 상세보기
            function showTogetherWalkDetail(postId) {
                window.location.href = '<c:url value="/walkpt/togetherwalk/detail"/>?id=' + postId;
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

            // 로그인 필요 모달 표시
            function showLoginRequired() {
                $('#loginRequiredModal').modal('show');
            }
        </script>