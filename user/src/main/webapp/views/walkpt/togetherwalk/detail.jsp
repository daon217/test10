<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

<div class="walkpt-container">
    <div class="container">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                <!-- 뒤로가기 버튼 -->
                <div class="mb-3">
                    <a href="<c:url value='/walkpt/togetherwalk/list'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> 목록으로
                    </a>
                </div>

                <div class="pet-card">
                    <!-- 헤더 -->
                    <div class="pet-card-header">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h3 class="mb-2" id="postTitle">한강공원에서 함께 산책해요!</h3>
                                <div class="text-muted">
                                    <i class="fas fa-user"></i> <span id="authorName">홍길동</span>
                                    <span class="mx-2">|</span>
                                    <i class="fas fa-calendar"></i> <span id="createdDate">2025-12-01</span>
                                </div>
                            </div>
                            <span class="walkpt-badge badge-recruiting">모집 중</span>
                        </div>
                    </div>

                    <div class="pet-card-body">
                        <!-- 반려동물 정보 -->
                        <div class="card mb-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-paw"></i> 반려동물 정보</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <table class="table table-borderless mb-0">
                                            <tbody>
                                            <tr>
                                                <th width="120"><i class="fas fa-tag"></i> 이름</th>
                                                <td id="petName">몽이</td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-dog"></i> 종류</th>
                                                <td id="petType">말티즈</td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-weight"></i> 크기</th>
                                                <td id="petSize">소형 (5kg 이하)</td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-birthday-cake"></i> 나이</th>
                                                <td id="petAge">2살</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-md-4 text-center">
                                        <img id="petImage"
                                             src="https://via.placeholder.com/200x200?text=Pet+Image"
                                             alt="반려동물 사진" class="img-fluid rounded"
                                             style="max-height: 200px; object-fit: cover;">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 산책 일정 -->
                        <div class="card mb-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-calendar-check"></i> 산책 일정</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p class="mb-2">
                                            <i class="fas fa-calendar-alt text-primary"></i>
                                            <strong>날짜:</strong> <span id="walkDate">2025-12-05</span>
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-clock text-primary"></i>
                                            <strong>시간:</strong> <span id="walkTime">오후 3:00 ~ 5:00</span>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-2">
                                            <i class="fas fa-map-marker-alt text-primary"></i>
                                            <strong>장소:</strong> <span id="location">서울 강남구 삼성동 한강공원</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 상세 내용 -->
                        <div class="card mb-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-align-left"></i> 상세 내용</h5>
                            </div>
                            <div class="card-body">
                                <div id="content" style="white-space: pre-line; line-height: 1.8;">
                                    안녕하세요! 한강공원에서 함께 산책할 반려인을 찾고 있어요.

                                    저희 몽이는 2살 말티즈로, 활발하고 다른 강아지들과 잘 어울리는 편이에요.
                                    특히 비슷한 나이대의 소형견 친구들을 좋아합니다.

                                    주말 오후에 한강공원을 자주 가는데, 함께 산책하면서 반려동물들도 친구를 만들고
                                    우리도 반려인 친구를 사귀면 좋을 것 같아요!

                                    관심 있으시면 편하게 채팅 주세요 😊
                                </div>
                            </div>
                        </div>

                        <!-- 채팅하기 버튼 -->
                        <div class="text-center">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <button class="btn btn-pet-primary btn-lg" onclick="startChat()">
                                        <i class="fas fa-comment-dots"></i> 채팅하기
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-pet-primary btn-lg" onclick="showLoginRequired()">
                                        <i class="fas fa-comment-dots"></i> 채팅하기
                                    </button>
                                    <p class="text-muted mt-2">
                                        <i class="fas fa-info-circle"></i> 채팅하기는 로그인 후 이용 가능합니다.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 로그인 필요 모달 -->
<jsp:include page="../common/modals.jsp" />

<script>
    // 로그인 여부 체크
    const isLoggedIn = ${ not empty sessionScope.user };

    // 채팅하기
    function startChat() {
        if (!isLoggedIn) {
            showLoginRequired();
            return;
        }

        // 실제로는 채팅 페이지로 이동하거나 채팅 모달 열기
        showToast('채팅 기능은 추후 구현 예정입니다.', 'info');

        // 예시: 채팅 페이지로 이동
        // window.location.href = '<c:url value="/chat/room"/>?postId=1&userId=...';
    }

    // 로그인 필요 모달
    function showLoginRequired() {
        $('#loginRequiredModal').modal('show');
    }

    // 실제 데이터 로드 (서버에서 가져와야 함)
    // 여기서는 샘플 데이터로 표시
    function loadPostDetail() {
        const urlParams = new URLSearchParams(window.location.search);
        const postId = urlParams.get('id');

        // 실제로는 서버에서 데이터를 가져와야 함
        const sampleData = {
            1: {
                title: '한강공원에서 함께 산책해요!',
                author: '홍길동',
                createdDate: '2025-12-01',
                petName: '몽이',
                petType: '말티즈',
                petSize: '소형 (5kg 이하)',
                petAge: '2살',
                walkDate: '2025-12-05',
                walkTime: '오후 3:00 ~ 5:00',
                location: '서울 강남구 삼성동 한강공원',
                content: `안녕하세요! 한강공원에서 함께 산책할 반려인을 찾고 있어요.

저희 몽이는 2살 말티즈로, 활발하고 다른 강아지들과 잘 어울리는 편이에요.
특히 비슷한 나이대의 소형견 친구들을 좋아합니다.

주말 오후에 한강공원을 자주 가는데, 함께 산책하면서 반려동물들도 친구를 만들고
우리도 반려인 친구를 사귀면 좋을 것 같아요!

관심 있으시면 편하게 채팅 주세요 😊`
            },
            2: {
                title: '주말 아침 산책 메이트 구해요',
                author: '김산책',
                createdDate: '2025-11-30',
                petName: '코코',
                petType: '웰시코기',
                petSize: '중형 (5-15kg)',
                petAge: '3살',
                walkDate: '2025-12-07',
                walkTime: '오전 9:00 ~ 11:00',
                location: '서울 송파구 잠실동 올림픽공원',
                content: `주말 아침에 함께 산책하실 분 찾아요!\n\n코코는 활발한 웰시코기로 산책을 정말 좋아합니다.\n정기적으로 함께 산책하실 분이면 더욱 좋겠어요!`
            },
            3: {
                title: '올림픽공원 산책 같이해요',
                author: '박반려',
                createdDate: '2025-11-29',
                petName: '골디',
                petType: '골든리트리버',
                petSize: '대형 (15kg 이상)',
                petAge: '5살',
                walkDate: '2025-12-03',
                walkTime: '오후 5:00 ~ 7:00',
                location: '서울 강동구 천호동 올림픽공원',
                content: `대형견이지만 온순한 골디와 함께 산책하실 분을 찾습니다.\n대형견을 키우시는 분이면 더욱 좋을 것 같아요!`
            }
        };

        if (postId && sampleData[postId]) {
            const data = sampleData[postId];
            document.getElementById('postTitle').textContent = data.title;
            document.getElementById('authorName').textContent = data.author;
            document.getElementById('createdDate').textContent = data.createdDate;
            document.getElementById('petName').textContent = data.petName;
            document.getElementById('petType').textContent = data.petType;
            document.getElementById('petSize').textContent = data.petSize;
            document.getElementById('petAge').textContent = data.petAge;
            document.getElementById('walkDate').textContent = data.walkDate;
            document.getElementById('walkTime').textContent = data.walkTime;
            document.getElementById('location').textContent = data.location;
            document.getElementById('content').textContent = data.content;
        }
    }

    // 페이지 로드 시 데이터 로드
    document.addEventListener('DOMContentLoaded', loadPostDetail);
</script>