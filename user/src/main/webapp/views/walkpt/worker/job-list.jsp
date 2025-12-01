<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                                <button type="button" class="btn btn-pet-primary mb-2">
                                    <i class="fas fa-search"></i> 검색
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- 구인 글 리스트 -->
                    <div class="row">
                        <c:forEach items="${jobs}" var="job">
                            <div class="col-md-6 col-lg-4">
                                <div class="walkpt-card" style="cursor: pointer;" onclick="location.href='<c:url value="
                                    /walkpt/owner/post-detail?id=${job.postId}" />'">
                                <div class="walkpt-card-header">
                                    <h5 class="walkpt-card-title">${job.title}</h5>
                                    <span class="walkpt-badge badge-recruiting">모집 중</span>
                                </div>
                                <div class="walkpt-card-body">
                                    <p class="walkpt-card-info">
                                        <i class="fas fa-map-marker-alt"></i> ${job.location}
                                    </p>
                                    <p class="walkpt-card-info">
                                        <i class="fas fa-calendar-alt"></i> ${job.walkDate} ${job.walkTime}
                                    </p>
                                    <p class="walkpt-card-info">
                                        <i class="fas fa-dog"></i> ${job.petName} (${job.petBreed}, ${job.petAge}살)
                                    </p>
                                    <p class="walkpt-card-info">
                                        <i class="fas fa-won-sign"></i> 시급
                                        <fmt:formatNumber value="${job.payAmount}" type="number" />원
                                    </p>
                                    <div class="walkpt-tags">
                                        <span class="walkpt-tag">${job.petType == 'dog' ? '강아지' : (job.petType == 'cat'
                                            ? '고양이' : '기타')}</span>
                                    </div>
                                </div>
                            </div>
                    </div>
                    </c:forEach>

                    <c:if test="${empty jobs}">
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-search fa-3x text-muted mb-3"></i>
                            <p class="text-muted">등록된 구인 글이 없습니다.</p>
                        </div>
                    </c:if>
                </div>
            </div>
            </div>

            <jsp:include page="../common/modals.jsp" />