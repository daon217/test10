<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .chat-list-container {
    max-width: 800px;
    margin: 40px auto;
    padding: 0 20px;
  }
  .chat-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    margin-bottom: 15px;
    transition: transform 0.2s;
    border: 1px solid #eee;
    cursor: pointer;
    text-decoration: none;
    color: inherit;
    display: block;
  }
  .chat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    text-decoration: none;
    color: inherit;
  }
  .chat-card-body {
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .chat-content {
    flex: 1;
    min-width: 0;
  }

  /* 상대방 이름 강조 */
  .chat-partner-name {
    font-weight: 700;
    font-size: 1.15rem;
    color: #333;
    margin-bottom: 6px;
    display: flex;
    align-items: center;
  }
  .chat-partner-name i {
    margin-right: 8px;
    color: #ffc107;
    font-size: 1.1rem;
  }

  /* 마지막 메시지 스타일 */
  .last-message {
    font-size: 0.95rem;
    color: #666;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 95%;
  }

  .chat-meta {
    text-align: right;
    min-width: 80px;
    margin-left: 15px;
  }
  .last-date {
    font-size: 0.8rem;
    color: #aaa;
    display: block;
    margin-bottom: 8px;
  }
  .empty-chat {
    text-align: center;
    padding: 80px 0;
    color: #999;
  }
  .empty-chat i {
    color: #ddd;
    margin-bottom: 15px;
  }
</style>

<div class="chat-list-container">
  <h3 class="mb-4 font-weight-bold"><i class="fas fa-comments text-warning"></i> 내 채팅 목록</h3>

  <c:choose>
    <c:when test="${empty chatRooms}">
      <div class="empty-chat">
        <i class="far fa-comment-dots fa-4x"></i>
        <p class="mt-3">진행 중인 대화가 없습니다.</p>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach var="room" items="${chatRooms}">
        <a href="<c:url value='/chat/room?roomId=${room.roomId}'/>" class="chat-card">
          <div class="chat-card-body">
            <div class="chat-content">
              <div class="chat-partner-name">
                <i class="fas fa-user-circle"></i>
                  ${room.otherPersonName != null ? room.otherPersonName : '알 수 없음'}
              </div>

              <div class="last-message">
                <c:choose>
                  <c:when test="${not empty room.lastMessage}">
                    ${room.lastMessage}
                  </c:when>
                  <c:otherwise>
                    <span style="color: #ccc;">(대화 내용 없음)</span>
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

              <i class="fas fa-chevron-right" style="color: #ddd;"></i>
            </div>
          </div>
        </a>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>