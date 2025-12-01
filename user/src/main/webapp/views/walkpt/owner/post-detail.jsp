<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

<div class="walkpt-container">
    <div class="container">
        <c:catch var="e">
            <div class="row">
                <div class="col-lg-8">
                    <div class="pet-card mb-4">
                        <div class="pet-card-header">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h3>
                                        <c:out value="${post.title}" default="제목 없음" />
                                    </h3>
                                    <span class="walkpt-badge ${post.status == 'RECRUITING' ? 'badge-recruiting' : 'badge-completed'} mt-2">
                                            ${post.status == 'RECRUITING' ? '모집 중' : '모집 완료'}
                                    </span>
                                </div>
                                <c:if test="${sessionScope.user.userId == post.userId}">
                                    <div>
                                        <button class="btn btn-outline-secondary btn-sm" onclick="editPost()">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button class="btn btn-outline-danger btn-sm" onclick="deletePost()">
                                            <i class="fas fa-trash"></i> 삭제
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <div class="pet-card-body">
                            <div class="mb-4">
                                <h5><i class="fas fa-paw"></i> 반려동물 정보</h5>
                                <div class="row mt-3">
                                    <div class="col-md-4">
                                        <c:choose>
                                            <c:when test="${not empty post.petPhoto}">
                                                <img src="<c:url value='/img/${post.petPhoto}'/>"
                                                     onerror="this.src='https://via.placeholder.com/200x200?text=Pet+Photo'"
                                                     alt="반려동물 사진" class="img-fluid rounded">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/200x200?text=No+Image"
                                                     alt="기본 사진" class="img-fluid rounded">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-8">
                                        <table class="table table-borderless">
                                            <tr>
                                                <th width="120"><i class="fas fa-tag"></i> 이름</th>
                                                <td><c:out value="${post.petName}" default="-" /></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-dog"></i> 종류</th>
                                                <td>
                                                    <c:out value="${post.petType}" default="-" />
                                                    (<c:out value="${post.petBreed}" default="-" />)
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-weight"></i> 몸무게</th>
                                                <td><c:out value="${post.petWeight}" default="0" /> kg</td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-birthday-cake"></i> 나이</th>
                                                <td><c:out value="${post.petAge}" default="0" />살</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <hr>

                            <div class="mb-4">
                                <h5><i class="fas fa-calendar-check"></i> 산책 조건</h5>
                                <table class="table table-borderless mt-3">
                                    <tr>
                                        <th width="120"><i class="fas fa-calendar-alt"></i> 날짜</th>
                                        <td><c:out value="${post.walkDate}" default="-" /></td>
                                    </tr>
                                    <tr>
                                        <th><i class="fas fa-clock"></i> 시간</th>
                                        <td><c:out value="${post.walkTime}" default="-" /></td>
                                    </tr>
                                    <tr>
                                        <th><i class="fas fa-map-marker-alt"></i> 지역</th>
                                        <td><c:out value="${post.location}" default="-" /></td>
                                    </tr>
                                    <tr>
                                        <th><i class="fas fa-won-sign"></i> 보수</th>
                                        <td>
                                            <strong class="text-primary">시급
                                                <c:choose>
                                                    <c:when test="${not empty post.payAmount}">
                                                        <fmt:formatNumber value="${post.payAmount}" type="number" />원
                                                    </c:when>
                                                    <c:otherwise>협의</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <hr>

                            <div class="mb-4">
                                <h5><i class="fas fa-exclamation-circle"></i> 상세 내용 및 유의사항</h5>
                                <p class="mt-3">
                                    <c:out value="${post.content}" default="내용 없음" />
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="pet-card" id="applicants">
                        <div class="pet-card-header">
                            <h4><i class="fas fa-users"></i> 지원자 목록</h4>
                        </div>
                        <div class="pet-card-body">
                            <p class="text-muted">아직 지원자가 없습니다.</p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="pet-card sticky-top" style="top: 20px;">
                        <div class="pet-card-header">
                            <h5><i class="fas fa-info-circle"></i> 게시글 정보</h5>
                        </div>
                        <div class="pet-card-body">
                            <p><i class="fas fa-calendar-plus"></i> 작성일: <c:out value="${post.createdAt}" /></p>
                            <p><i class="fas fa-eye"></i> 조회수: <c:out value="${post.viewCount}" />회</p>
                            <hr>
                            <div class="d-grid gap-2">
                                <c:if test="${sessionScope.user.userId != post.userId}">
                                    <button class="btn btn-pet-primary btn-block" onclick="startChat()">
                                        <i class="fas fa-comments"></i> 채팅으로 문의하기
                                    </button>
                                    <button class="btn btn-pet-secondary btn-block" onclick="applyJob()">
                                        <i class="fas fa-check-circle"></i> 지원하기
                                    </button>
                                </c:if>

                                <a href="<c:url value='/walkpt/worker/job-list'/>" class="btn btn-pet-outline btn-block">
                                    <i class="fas fa-list"></i> 목록으로
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:catch>

        <c:if test="${not empty e}">
            <div class="alert alert-danger">
                <h4>오류 발생</h4>
                <p>페이지를 렌더링하는 중 오류가 발생했습니다.</p>
                <p>${e}</p>
                <p>${e.message}</p>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="../common/modals.jsp" />

<script>
    function editPost() {
        window.location.href = '<c:url value="/walkpt/owner/post-write?id=${post.postId}&mode=edit"/>';
    }

    function deletePost() {
        showConfirmModal('게시글 삭제', '정말 이 게시글을 삭제하시겠습니까?', function () {
            alert('삭제 기능은 아직 구현되지 않았습니다.');
        });
    }

    // [수정됨] 채팅 시작 함수
    function startChat() {
        let writerId = '${post.userId}'; // 게시글 작성자 ID
        let postId = '${post.postId}';   // 게시글 ID

        if(!writerId || !postId) {
            alert('정보를 불러올 수 없습니다.');
            return;
        }

        // 채팅 컨트롤러 호출 -> 채팅방(room.jsp)으로 이동
        location.href = '/chat/start?postId=' + postId + '&writerId=' + writerId;
    }

    function applyJob() {
        alert('지원 기능은 준비 중입니다.');
    }
</script>