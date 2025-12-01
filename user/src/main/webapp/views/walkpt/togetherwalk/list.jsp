<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <!-- 헤더 -->
                <div class="text-center mb-5">
                    <h1 class="mb-3">
                        <i class="fas fa-users text-primary"></i> 함께 산책하기
                    </h1>
                    <p class="lead text-secondary">
                        같은 시간, 같은 장소에서 함께 산책할 반려인을 찾아보세요
                    </p>
                </div>

                <!-- 액션 버튼 -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <a href="<c:url value='/walkpt'/>" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> 돌아가기
                        </a>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<c:url value='/walkpt/togetherwalk/write'/>" class="btn btn-pet-primary">
                                    <i class="fas fa-plus"></i> 글 작성하기
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-pet-primary" onclick="showLoginRequired()">
                                    <i class="fas fa-plus"></i> 글 작성하기
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 검색 필터 -->
                <div class="card mb-4 border-0 shadow-sm">
                    <div class="card-body bg-light rounded">
                        <form action="<c:url value='/walkpt/togetherwalk/list'/>" method="get"
                            class="form-row align-items-center justify-content-center">
                            <div class="col-auto">
                                <div class="input-group mb-2">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text"><i class="fas fa-map-marker-alt"></i></div>
                                    </div>
                                    <input type="text" class="form-control" name="location" placeholder="지역 (예: 강남구)"
                                        value="${param.location}">
                                </div>
                            </div>
                            <div class="col-auto">
                                <div class="input-group mb-2">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text"><i class="fas fa-search"></i></div>
                                    </div>
                                    <input type="text" class="form-control" name="title" placeholder="제목 검색"
                                        value="${param.title}">
                                </div>
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-secondary mb-2">검색</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 게시글 목록 -->
                <div class="row">
                    <c:forEach items="${posts}" var="post">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm pet-card-hover"
                                onclick="location.href='<c:url value='/walkpt/togetherwalk/detail?id=${post.postId}'/>'"
                                style="cursor: pointer; transition: transform 0.2s;">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span
                                            class="badge badge-pill ${post.status == 'COMPLETED' ? 'badge-secondary' : 'badge-primary'}">
                                            ${post.status == 'COMPLETED' ? '모집완료' : '모집중'}
                                        </span>
                                        <small class="text-muted"><i class="fas fa-eye"></i> ${post.viewCount}</small>
                                    </div>
                                    <h5 class="card-title text-truncate font-weight-bold">${post.title}</h5>
                                    <p class="card-text text-muted small mb-2">
                                        <i class="fas fa-map-marker-alt text-danger"></i> ${post.location}
                                    </p>
                                    <p class="card-text text-muted small mb-3">
                                        <i class="fas fa-calendar-alt text-info"></i> ${post.walkDate} ${post.walkTime}
                                    </p>

                                    <div class="d-flex align-items-center border-top pt-3">
                                        <img src="<c:url value='/img/${post.petPhoto}'/>"
                                            onerror="this.src='https://via.placeholder.com/50?text=Pet'"
                                            class="rounded-circle mr-3" width="50" height="50"
                                            style="object-fit: cover;" alt="Pet">
                                        <div>
                                            <div class="font-weight-bold small text-dark">${post.petName} <span
                                                    class="text-muted">(${post.petBreed})</span></div>
                                            <div class="text-muted small">By ${post.userName}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty posts}">
                        <div class="col-12 text-center py-5">
                            <div class="text-muted mb-3">
                                <i class="fas fa-dog fa-4x"></i>
                            </div>
                            <h4>등록된 산책 모임이 없습니다.</h4>
                            <p class="text-muted">첫 번째 산책 모임을 만들어보세요!</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 로그인 필요 모달 -->
        <div class="modal fade" id="loginRequiredModal" tabindex="-1" role="dialog"
            aria-labelledby="loginRequiredModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="loginRequiredModalLabel">로그인 필요</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        이 기능은 로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                        <a href="<c:url value='/login'/>" class="btn btn-primary">로그인</a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showLoginRequired() {
                $('#loginRequiredModal').modal('show');
            }

            // 카드 호버 효과
            $('.pet-card-hover').hover(
                function () { $(this).addClass('shadow-lg').css('transform', 'translateY(-5px)'); },
                function () { $(this).removeClass('shadow-lg').css('transform', 'translateY(0)'); }
            );
        </script>