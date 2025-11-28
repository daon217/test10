<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <!-- 구인 글 상세 -->
                        <div class="pet-card mb-4">
                            <div class="pet-card-header">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h3>소형견 산책 도와주실 분</h3>
                                        <span class="walkpt-badge badge-recruiting mt-2">모집 중</span>
                                    </div>
                                    <div>
                                        <button class="btn btn-outline-secondary btn-sm" onclick="editPost()">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button class="btn btn-outline-danger btn-sm" onclick="deletePost()">
                                            <i class="fas fa-trash"></i> 삭제
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="pet-card-body">
                                <!-- 반려동물 정보 -->
                                <div class="mb-4">
                                    <h5><i class="fas fa-paw"></i> 반려동물 정보</h5>
                                    <div class="row mt-3">
                                        <div class="col-md-4">
                                            <img src="https://via.placeholder.com/200x200?text=Pet+Photo" alt="반려동물 사진"
                                                class="img-fluid rounded">
                                        </div>
                                        <div class="col-md-8">
                                            <table class="table table-borderless">
                                                <tr>
                                                    <th width="120"><i class="fas fa-tag"></i> 이름</th>
                                                    <td>몽이</td>
                                                </tr>
                                                <tr>
                                                    <th><i class="fas fa-dog"></i> 종류</th>
                                                    <td>강아지 (포메라니안)</td>
                                                </tr>
                                                <tr>
                                                    <th><i class="fas fa-weight"></i> 크기</th>
                                                    <td>소형 (5kg 이하)</td>
                                                </tr>
                                                <tr>
                                                    <th><i class="fas fa-birthday-cake"></i> 나이</th>
                                                    <td>3살</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <hr>

                                <!-- 산책 조건 -->
                                <div class="mb-4">
                                    <h5><i class="fas fa-calendar-check"></i> 산책 조건</h5>
                                    <table class="table table-borderless mt-3">
                                        <tr>
                                            <th width="120"><i class="fas fa-calendar-alt"></i> 날짜</th>
                                            <td>2025년 12월 1일 (일요일)</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-clock"></i> 시간</th>
                                            <td>오후 3:00 ~ 오후 5:00 (2시간)</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-map-marker-alt"></i> 지역</th>
                                            <td>서울특별시 강남구 역삼동</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-won-sign"></i> 보수</th>
                                            <td><strong class="text-primary">시급 15,000원</strong></td>
                                        </tr>
                                    </table>
                                </div>

                                <hr>

                                <!-- 유의사항 -->
                                <div class="mb-4">
                                    <h5><i class="fas fa-exclamation-circle"></i> 유의사항</h5>
                                    <p class="mt-3">
                                        낯을 많이 가려서 처음엔 조금 경계할 수 있어요.
                                        다른 강아지를 보면 짖을 수 있으니 주의해주세요.
                                        간식을 주면 금방 친해집니다!
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- 지원자 목록 -->
                        <div class="pet-card" id="applicants">
                            <div class="pet-card-header">
                                <h4><i class="fas fa-users"></i> 지원자 목록 (3명)</h4>
                            </div>
                            <div class="pet-card-body">
                                <!-- 지원자 카드 1 -->
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 text-center">
                                                <img src="https://via.placeholder.com/80x80?text=Profile" alt="프로필"
                                                    class="rounded-circle" width="80">
                                            </div>
                                            <div class="col-md-7">
                                                <h5 class="mb-2">김산책</h5>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-star" style="color: #FFD43B;"></i> 평점 4.8 / 5.0 (산책
                                                    32회)
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-map-marker-alt"></i> 활동 지역: 강남구, 송파구
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-clock"></i> 가능 시간: 평일 오전·오후, 주말 가능
                                                </p>
                                                <p class="text-muted mt-2" style="font-size: 0.9rem;">
                                                    소형·중형견 경험 5년, 반려견 키움 경험 있음
                                                </p>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn btn-pet-outline btn-sm btn-block mb-2"
                                                    onclick="showResumeModal(1)">
                                                    <i class="fas fa-file-alt"></i> 이력서 보기
                                                </button>
                                                <button class="btn btn-pet-secondary btn-sm btn-block mb-2"
                                                    onclick="openChat(1)">
                                                    <i class="fas fa-comment"></i> 채팅하기
                                                </button>
                                                <button class="btn btn-success btn-sm btn-block mb-2"
                                                    onclick="acceptApplicant(1)">
                                                    <i class="fas fa-check"></i> 수락
                                                </button>
                                                <button class="btn btn-danger btn-sm btn-block"
                                                    onclick="rejectApplicant(1)">
                                                    <i class="fas fa-times"></i> 거절
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 지원자 카드 2 -->
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 text-center">
                                                <img src="https://via.placeholder.com/80x80?text=Profile" alt="프로필"
                                                    class="rounded-circle" width="80">
                                            </div>
                                            <div class="col-md-7">
                                                <h5 class="mb-2">박돌봄</h5>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-star" style="color: #FFD43B;"></i> 평점 4.9 / 5.0 (산책
                                                    45회)
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-map-marker-alt"></i> 활동 지역: 강남구, 서초구
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-clock"></i> 가능 시간: 주말 전일 가능
                                                </p>
                                                <p class="text-muted mt-2" style="font-size: 0.9rem;">
                                                    소형견 전문, 자격증 보유
                                                </p>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn btn-pet-outline btn-sm btn-block mb-2"
                                                    onclick="showResumeModal(2)">
                                                    <i class="fas fa-file-alt"></i> 이력서 보기
                                                </button>
                                                <button class="btn btn-pet-secondary btn-sm btn-block mb-2"
                                                    onclick="openChat(2)">
                                                    <i class="fas fa-comment"></i> 채팅하기
                                                </button>
                                                <button class="btn btn-success btn-sm btn-block mb-2"
                                                    onclick="acceptApplicant(2)">
                                                    <i class="fas fa-check"></i> 수락
                                                </button>
                                                <button class="btn btn-danger btn-sm btn-block"
                                                    onclick="rejectApplicant(2)">
                                                    <i class="fas fa-times"></i> 거절
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 수락된 지원자 예시 -->
                                <div class="card border-success mb-3">
                                    <div class="card-header bg-success text-white">
                                        <i class="fas fa-check-circle"></i> 수락된 지원자
                                    </div>
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 text-center">
                                                <img src="https://via.placeholder.com/80x80?text=Profile" alt="프로필"
                                                    class="rounded-circle" width="80">
                                            </div>
                                            <div class="col-md-7">
                                                <h5 class="mb-2">이친절 <span class="badge badge-success">매칭 완료</span></h5>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-star" style="color: #FFD43B;"></i> 평점 5.0 / 5.0 (산책
                                                    28회)
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-map-marker-alt"></i> 활동 지역: 강남구
                                                </p>
                                                <p class="walkpt-card-info mb-1">
                                                    <i class="fas fa-clock"></i> 가능 시간: 주말 오후 선호
                                                </p>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn btn-pet-secondary btn-sm btn-block mb-2"
                                                    onclick="openChat(3)">
                                                    <i class="fas fa-comment"></i> 채팅하기
                                                </button>
                                                <button class="btn btn-pet-primary btn-sm btn-block"
                                                    onclick="startWalk(1)">
                                                    <i class="fas fa-play"></i> 산책 시작
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 사이드바 -->
                    <div class="col-lg-4">
                        <div class="pet-card sticky-top" style="top: 20px;">
                            <div class="pet-card-header">
                                <h5><i class="fas fa-info-circle"></i> 게시글 정보</h5>
                            </div>
                            <div class="pet-card-body">
                                <p><i class="fas fa-calendar-plus"></i> 작성일: 2025-11-20</p>
                                <p><i class="fas fa-eye"></i> 조회수: 45회</p>
                                <p><i class="fas fa-users"></i> 지원자: 3명</p>
                                <hr>
                                <div class="d-grid gap-2">
                                    <a href="<c:url value='/walkpt/owner/post-list'/>"
                                        class="btn btn-pet-outline btn-block">
                                        <i class="fas fa-list"></i> 목록으로
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 이력서 모달 -->
        <div class="modal fade" id="resumeModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-file-alt"></i> 이력서</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="resumeContent">
                        <!-- 이력서 내용이 여기에 로드됨 -->
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />
        <jsp:include page="../chat/panel.jsp" />

        <script>
            function editPost() {
                window.location.href = '<c:url value="/walkpt/owner/post-write?id=1&mode=edit"/>';
            }

            function deletePost() {
                showConfirmModal('게시글 삭제', '정말 이 게시글을 삭제하시겠습니까?', function () {
                    // 서버에 삭제 요청
                    showToast('게시글이 삭제되었습니다.', 'success');
                    setTimeout(function () {
                        window.location.href = '<c:url value="/walkpt/owner/post-list"/>';
                    }, 1500);
                });
            }

            function showResumeModal(applicantId) {
                // 실제로는 서버에서 이력서 데이터 가져오기
                const dummyResume = `
        <h4>김산책</h4>
        <hr>
        <h6><i class="fas fa-user"></i> 기본 정보</h6>
        <p>나이: 25세<br>활동 지역: 강남구, 송파구</p>
        <hr>
        <h6><i class="fas fa-paw"></i> 반려동물 경험</h6>
        <p>소형·중형견 산책 경험 5년<br>자격증: 반려동물관리사 2급</p>
        <hr>
        <h6><i class="fas fa-comment"></i> 소개</h6>
        <p>책임감 있게 반려동물을 돌봐드립니다. 반려견을 키워본 경험이 있어 어떤 상황에서도 침착하게 대응할 수 있습니다.</p>
    `;
                document.getElementById('resumeContent').innerHTML = dummyResume;
                $('#resumeModal').modal('show');
            }

            function openChat(userId) {
                // 채팅 패널 열기
                const panel = document.getElementById('chatPanel');
                if (panel) {
                    panel.classList.add('active');
                }
            }
        </script>