<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  :root {
    /* [사진 참고] 메인 코랄 레드 컬러 */
    --point-color: #FF6B6B;
    --point-light: #FFF0F0;

    /* 서브 민트 컬러 (호버 효과 등 포인트용) */
    --sub-color: #4ECDC4;

    --text-dark: #333333;
    --text-gray: #999999;
  }

  .chat-list-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 30px 20px;
    background-color: #FAFAFA;
    min-height: 100vh;
  }

  .chat-header h3 {
    font-size: 1.5rem;
    font-weight: 800;
    color: var(--text-dark);
    margin-bottom: 25px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .chat-card {
    display: flex;
    align-items: center;
    background: #ffffff;
    padding: 18px 20px;
    border-radius: 20px;
    margin-bottom: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.03);
    transition: all 0.2s ease;
    text-decoration: none;
    color: inherit;
    border: 1px solid transparent;
  }

  .chat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.08);
    border-color: var(--point-color); /* 호버 시 붉은색 테두리 */
  }

  /* 프로필 아이콘 영역 */
  .profile-circle {
    width: 55px;
    height: 55px;
    border-radius: 50%;
    background-color: var(--point-light);
    color: var(--point-color);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    flex-shrink: 0;
    margin-right: 15px;
  }

  .chat-content {
    flex: 1;
    min-width: 0;
  }

  .chat-partner-name {
    font-weight: 700;
    font-size: 1.05rem;
    color: var(--text-dark);
    margin-bottom: 4px;
  }

  .last-message {
    font-size: 0.9rem;
    color: var(--text-gray);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 95%;
  }

  .chat-meta {
    text-align: right;
    min-width: 70px;
    margin-left: 10px;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    justify-content: space-between;
    height: 45px;
  }

  .last-date {
    font-size: 0.75rem;
    color: #bbb;
    font-weight: 500;
  }

  .arrow-icon {
    color: #eee;
    font-size: 0.9rem;
    transition: 0.2s;
  }
  .chat-card:hover .arrow-icon {
    color: var(--point-color);
    transform: translateX(3px);
  }

  .empty-chat {
    text-align: center;
    padding: 100px 0;
    color: var(--text-gray);
    opacity: 0.7;
  }
</style>

<div class="chat-list-container">
  <div class="chat-header">
    <h3><i class="fas fa-comments" style="color: var(--point-color);"></i> 내 채팅 목록</h3>
  </div>

  <c:choose>
    <c:when test="${empty chatRooms}">
      <div class="empty-chat">
        <i class="far fa-comment-dots fa-4x mb-3"></i>
        <p>아직 진행 중인 대화가 없어요.<br>새로운 메이트를 찾아보세요!</p>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach var="room" items="${chatRooms}">
        <a href="<c:url value='/chat/room?roomId=${room.roomId}'/>" class="chat-card">

          <div class="profile-circle">
            <i class="fas fa-user"></i>
          </div>

          <div class="chat-content">
            <div class="chat-partner-name">
                ${room.otherPersonName != null ? room.otherPersonName : '알 수 없음'}
            </div>
            <div class="last-message">
              <c:choose>
                <c:when test="${not empty room.lastMessage}">
                  ${room.lastMessage}
                </c:when>
                <c:otherwise>
                  <span style="color: #ccc;">대화를 시작해보세요!</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="chat-meta">
            <span class="last-date">
              <c:if test="${not empty room.lastDate}">
                <fmt:parseDate value="${room.lastDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                <jsp:useBean id="now" class="java.util.Date" />
                <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="today" />
                <fmt:formatDate value="${parsedDate}" pattern="yyyyMMdd" var="msgDate" />

                <c:choose>
                  <c:when test="${today eq msgDate}">
                    <fmt:formatDate value="${parsedDate}" pattern="a h:mm"/>
                  </c:when>
                  <c:otherwise>
                    <fmt:formatDate value="${parsedDate}" pattern="MM-dd"/>
                  </c:otherwise>
                </c:choose>
              </c:if>
            </span>
            <i class="fas fa-chevron-right arrow-icon"></i>
          </div>
        </a>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>