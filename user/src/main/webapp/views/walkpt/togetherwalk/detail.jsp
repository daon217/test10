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
                                        <h3 class="mb-2" id="postTitle">${post.title}</h3>
                                        <div class="text-muted">
                                            <i class="fas fa-user"></i> <span id="authorName">${post.userName}</span>
                                            <span class="mx-2">|</span>
                                            <i class="fas fa-calendar"></i> <span
                                                id="createdDate">${post.createdAt}</span>
                                        </div>
                                    </div>
                                    <span class="walkpt-badge badge-recruiting">
                                        <c:choose>
                                            <c:when test="${post.status == 'COMPLETED'}">모집 완료</c:when>
                                            <c:otherwise>모집 중</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <!-- 작성자 본인일 경우 수정/삭제 버튼 표시 -->
                                <c:if test="${sessionScope.user.userId == post.userId}">
                                    <div class="mt-3 text-right">
                                        <button class="btn btn-sm btn-outline-primary"
                                            onclick="location.href='<c:url value='/walkpt/togetherwalk/modify?id=${post.postId}'/>'">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger"
                                            onclick="deletePost(${post.postId})">
                                            <i class="fas fa-trash"></i> 삭제
                                        </button>
                                    </div>
                                </c:if>
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
                                                            <td id="petName">${post.petName}</td>
                                                        </tr>
                                                        <tr>
                                                            <th><i class="fas fa-dog"></i> 종류</th>
                                                            <td id="petType">${post.petType} (${post.petBreed})</td>
                                                        </tr>
                                                        <tr>
                                                            <th><i class="fas fa-weight"></i> 크기/몸무게</th>
                                                            <td id="petSize">
                                                                ${post.petWeight}kg
                                                                <c:choose>
                                                                    <c:when test="${post.petWeight <= 5}">(소형)</c:when>
                                                                    <c:when test="${post.petWeight <= 15}">(중형)</c:when>
                                                                    <c:otherwise>(대형)</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th><i class="fas fa-birthday-cake"></i> 나이</th>
                                                            <td id="petAge">${post.petAge}살</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="col-md-4 text-center">
                                                <img id="petImage" src="<c:url value='/img/${post.petPhoto}'/>"
                                                    onerror="this.src='https://via.placeholder.com/200x200?text=No+Image'"
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
                                                    <strong>날짜:</strong> <span id="walkDate">${post.walkDate}</span>
                                                </p>
                                                <p class="mb-2">
                                                    <i class="fas fa-clock text-primary"></i>
                                                    <strong>시간:</strong> <span id="walkTime">${post.walkTime}</span>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-2">
                                                    <i class="fas fa-map-marker-alt text-primary"></i>
                                                    <strong>장소:</strong> <span id="location">${post.location}</span>
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
                                            ${post.content}</div>
                                    </div>
                                </div>

                                <!-- 채팅하기 버튼 -->
                                <div class="text-center">
                                    <c:choose>
                                        <c:when
                                            test="${not empty sessionScope.user and sessionScope.user.userId != post.userId}">
                                            <button class="btn btn-pet-primary btn-lg" onclick="startChat()">
                                                <i class="fas fa-comment-dots"></i> 채팅하기
                                            </button>
                                        </c:when>
                                        <c:when test="${sessionScope.user.userId == post.userId}">
                                            <button class="btn btn-secondary btn-lg" disabled>
                                                <i class="fas fa-user"></i> 본인이 작성한 글입니다
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
                // TODO: 채팅방 생성 및 이동 로직
                showToast('채팅 기능은 추후 구현 예정입니다.', 'info');
            }

            // 로그인 필요 모달
            function showLoginRequired() {
                $('#loginRequiredModal').modal('show');
            }

            // 게시글 삭제
            function deletePost(postId) {
                if (confirm('정말 이 게시글을 삭제하시겠습니까?')) {
                    location.href = '<c:url value="/walkpt/togetherwalk/delete"/>?id=' + postId;
                }
            }
        </script>