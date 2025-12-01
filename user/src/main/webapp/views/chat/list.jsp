<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .chat-list-container {
    max-width: 800px;
    margin: 30px auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 15px;
    box-shadow: 0 0 15px rgba(0,0,0,0.1);
  }
  .chat-item {
    border-bottom: 1px solid #eee;
    transition: background-color 0.2s;
  }
  .chat-item:hover {
    background-color: #f8f9fa;
    text-decoration: none;
    color: inherit;
  }
  .chat-item:last-child {
    border-bottom: none;
  }
  .chat-avatar {
    width: 50px;
    height: 50px;
    background-color: #e9ecef;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: #adb5bd;
    margin-right: 15px;
  }
  .badge-unread {
    background-color: #ff5c5c;
    color: white;
    font-size: 0.75rem;
    padding: 4px 8px;
    border-radius: 10px;
  }
</style>

<div class="chat-list-container">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="font-weight-bold"><i class="fas fa-comments text-warning"></i> 내 채팅 목록</h3>
  </div>

  <div class="list-group list-group-flush">
    <c:choose>
      <%-- 채팅방이 없는 경우 --%>
      <c:when test="${empty chatRooms}">
        <div class="text-center py-5">
          <i class="far fa-comment-dots fa-4x text-muted mb-3"></i>
          <p class="text-muted">참여 중인 채팅방이 없습니다.</p>
          <a href="<c:url value='/walkpt'/>" class="btn btn-warning btn-sm text-white">
            산책 알바 구하러 가기
          </a>
        </div>
      </c:when>

      <%-- 채팅방이 있는 경우 --%>
      <c:otherwise>
        <c:forEach var="room" items="${chatRooms}">
          <a href="<c:url value='/chat/room?roomId=${room.roomId}'/>" class="list-group-item chat-item py-3">
            <div class="d-flex w-100 justify-content-between align-items-center">
              <div class="d-flex align-items-center">
                <div class="chat-avatar">
                  <i class="fas fa-user"></i>
                </div>

                <div>
                  <h5 class="mb-1 text-dark" style="font-size: 1.1rem;">
                    <c:out value="${room.postTitle}" default="제목 없음" />
                  </h5>

                  <p class="mb-1 text-muted small text-truncate" style="max-width: 300px;">
                    <c:choose>
                      <c:when test="${not empty room.lastMessage}">
                        <c:out value="${room.lastMessage}" />
                      </c:when>
                      <c:otherwise>
                        <span class="text-info">새로운 채팅방이 개설되었습니다.</span>
                      </c:otherwise>
                    </c:choose>
                  </p>

                  <small class="text-secondary">
                    <i class="fas fa-user-friends"></i> ${room.otherPersonName}님과 대화 중
                  </small>
                </div>
              </div>

              <div class="text-right">
                <small class="text-muted d-block mb-1">
                  <c:if test="${not empty room.lastDate}">
                    <fmt:parseDate value="${room.lastDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />

                    <%-- 오늘 날짜인지 확인 --%>
                    <jsp:useBean id="now" class="java.util.Date" />
                    <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="today" />
                    <fmt:formatDate value="${parsedDate}" pattern="yyyyMMdd" var="msgDate" />

                    <c:choose>
                      <c:when test="${today == msgDate}">
                        <fmt:formatDate value="${parsedDate}" pattern="a h:mm" />
                      </c:when>
                      <c:otherwise>
                        <fmt:formatDate value="${parsedDate}" pattern="MM월 dd일" />
                      </c:otherwise>
                    </c:choose>
                  </c:if>
                </small>
                <i class="fas fa-chevron-right text-muted"></i>
              </div>
            </div>
          </a>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>