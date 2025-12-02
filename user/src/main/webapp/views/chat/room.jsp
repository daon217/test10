<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .chat-wrapper { max-width: 800px; margin: 0 auto; padding: 20px; }
  .chat-container { height: 500px; overflow-y: auto; background: #f8f9fa; border: 1px solid #ddd; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
  .message-box { margin-bottom: 15px; display: flex; flex-direction: column; }
  .message-box.my-msg { align-items: flex-end; }
  .message-box.other-msg { align-items: flex-start; }
  .msg-bubble { max-width: 70%; padding: 10px 15px; border-radius: 15px; font-size: 15px; position: relative; word-break: break-all;}
  .my-msg .msg-bubble { background-color: #ffe082; border-top-right-radius: 0; }
  .other-msg .msg-bubble { background-color: white; border: 1px solid #eee; border-top-left-radius: 0; }
  .msg-info { font-size: 12px; color: #888; margin-top: 5px; }
  .chat-header-title { font-weight: bold; font-size: 1.1rem; display: flex; align-items: center; }
  .chat-header-title i { color: #ffc107; margin-right: 8px; font-size: 1.2rem; }

  /* 플러스 버튼 및 메뉴 스타일 */
  .chat-input-area { display: flex; align-items: center; gap: 10px; padding-top: 10px; }
  .btn-plus {
    width: 40px; height: 40px; border-radius: 50%; border: none;
    background-color: #eee; color: #555; font-size: 20px;
    display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: background 0.2s;
  }
  .btn-plus:hover { background-color: #ddd; }
  .btn-plus.active { background-color: #ccc; transform: rotate(45deg); }

  /* 확장 메뉴 스타일 */
  .plus-menu {
    display: none; padding: 20px 10px; background-color: #f8f9fa;
    border-top: 1px solid #ddd; margin-top: 15px; border-radius: 10px;
  }
  .plus-menu-grid {
    display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; text-align: center;
  }
  .menu-item { cursor: pointer; display: flex; flex-direction: column; align-items: center; color: #333; font-size: 13px; }
  .menu-icon-box {
    width: 50px; height: 50px; background-color: white; border-radius: 20px;
    display: flex; align-items: center; justify-content: center; font-size: 24px;
    margin-bottom: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: transform 0.1s; color: #555;
  }
  .menu-item:hover .menu-icon-box { transform: scale(1.05); background-color: #e3f2fd; color: #1565c0; }

  /* 카드 공통 스타일 */
  .walk-card, .video-card {
    width: 240px; background-color: white; border-radius: 12px; overflow: hidden;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1); border: 1px solid #eee; margin-top: 5px;
  }

  /* 산책 카드 스타일 */
  .walk-card-content { padding: 20px; text-align: center; background: #fff; }
  .walk-card-icon { font-size: 40px; color: #ffc107; margin-bottom: 12px; }
  .walk-card-title { font-weight: bold; font-size: 16px; margin-bottom: 5px; color: #333; }
  .walk-card-desc { font-size: 13px; color: #888; margin-bottom: 0; }
  .btn-start-walk {
    width: 100%; border: none; background-color: #f8f9fa; padding: 12px 0;
    font-size: 14px; color: #333; cursor: pointer; border-top: 1px solid #eee;
    font-weight: bold; transition: background 0.2s;
  }
  .btn-start-walk:hover { background-color: #ffe082; }
  /* [추가] 비활성화된 버튼 스타일 */
  .btn-start-walk:disabled {
    background-color: #eee; color: #999; cursor: default;
  }

  /* 영상통화 카드 스타일 */
  .video-card-content { padding: 20px; text-align: center; background: #fff; }
  .video-card-icon { font-size: 40px; color: #007bff; margin-bottom: 12px; }
  .video-card-title { font-weight: bold; font-size: 16px; margin-bottom: 5px; color: #333; }
  .video-card-desc { font-size: 13px; color: #888; margin-bottom: 0; }
  .btn-start-video {
    width: 100%; border: none; background-color: #f8f9fa; padding: 12px 0;
    font-size: 14px; color: #333; cursor: pointer; border-top: 1px solid #eee;
    font-weight: bold; transition: background 0.2s;
  }
  .btn-start-video:hover { background-color: #cce5ff; }
  /* [추가] 비활성화된 버튼 스타일 */
  .btn-start-video:disabled {
    background-color: #eee; color: #999; cursor: default;
  }
</style>

<div class="chat-wrapper">
  <div class="card">
    <div class="card-header bg-white">
      <div class="chat-header-title">
        <i class="fas fa-user-circle"></i>
        <c:choose>
          <c:when test="${room.ownerId == user.userId}">
            ${room.workerName}
          </c:when>
          <c:otherwise>
            ${room.ownerName}
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="card-body">
      <div id="chatContainer" class="chat-container">
        <c:forEach var="msg" items="${msgs}">
          <c:choose>
            <%-- 내가 보낸 메시지 --%>
            <c:when test="${msg.senderId == user.userId}">
              <div class="message-box my-msg">
                <c:choose>
                  <%-- 산책 요청 (보낸 사람: 버튼 비활성화) --%>
                  <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                    <div class="walk-card">
                      <div class="walk-card-content">
                        <div class="walk-card-icon"><i class="fas fa-dog"></i></div>
                        <div class="walk-card-title">산책해요!</div>
                        <p class="walk-card-desc">산책 메이트 신청을 보냈습니다.</p>
                      </div>
                      <button class="btn-start-walk" disabled>수락 대기중</button>
                    </div>
                  </c:when>
                  <%-- 영상통화 요청 (보낸 사람: 버튼 비활성화) --%>
                  <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                    <div class="video-card">
                      <div class="video-card-content">
                        <div class="video-card-icon"><i class="fas fa-video"></i></div>
                        <div class="video-card-title">영상통화</div>
                        <p class="video-card-desc">영상통화를 요청했습니다.</p>
                      </div>
                      <button class="btn-start-video" disabled>응답 대기중</button>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="msg-bubble">${msg.content}</div>
                  </c:otherwise>
                </c:choose>
              </div>
            </c:when>

            <%-- 상대방이 보낸 메시지 --%>
            <c:otherwise>
              <div class="message-box other-msg">
                <c:choose>
                  <%-- 산책 요청 (받는 사람: 수락 가능) --%>
                  <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                    <div class="walk-card">
                      <div class="walk-card-content">
                        <div class="walk-card-icon"><i class="fas fa-dog"></i></div>
                        <div class="walk-card-title">산책해요!</div>
                        <p class="walk-card-desc">함께 산책하시겠습니까?</p>
                      </div>
                      <button class="btn-start-walk" onclick="startWalk()">산책 시작하기</button>
                    </div>
                  </c:when>
                  <%-- 영상통화 요청 (받는 사람: 수락 가능) --%>
                  <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                    <div class="video-card">
                      <div class="video-card-content">
                        <div class="video-card-icon"><i class="fas fa-video"></i></div>
                        <div class="video-card-title">영상통화</div>
                        <p class="video-card-desc">영상통화를 시작하시겠습니까?</p>
                      </div>
                      <button class="btn-start-video" onclick="startVideoCall()">영상통화 시작하기</button>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="msg-bubble">${msg.content}</div>
                  </c:otherwise>
                </c:choose>
              </div>
            </c:otherwise>
          </c:choose>
        </c:forEach>
      </div>

      <div class="chat-input-area">
        <button type="button" id="plusBtn" class="btn-plus" onclick="togglePlusMenu()">
          <i class="fas fa-plus"></i>
        </button>

        <div class="input-group" style="flex: 1;">
          <input type="text" id="msgInput" class="form-control" placeholder="메시지 입력..." onkeypress="if(event.keyCode==13) sendMessage();">
          <div class="input-group-append">
            <button class="btn btn-warning" onclick="sendMessage()">전송</button>
          </div>
        </div>
      </div>

      <div id="plusMenu" class="plus-menu">
        <div class="plus-menu-grid">
          <div class="menu-item" onclick="requestVideoCall()">
            <div class="menu-icon-box"><i class="fas fa-video"></i></div>
            <span>영상통화</span>
          </div>
          <div class="menu-item" onclick="requestWalk()">
            <div class="menu-icon-box"><i class="fas fa-walking"></i></div>
            <span>산책하기</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  var ws;
  var roomId = "${room.roomId}";
  var myId = "${user.userId}";
  var chatContainer = document.getElementById("chatContainer");

  // 스크롤 맨 아래로
  chatContainer.scrollTop = chatContainer.scrollHeight;
  window.onload = function() {
    connect();
  };

  function connect() {
    var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
    var wsUrl = protocol + location.host + "/ws/chat";

    console.log("Connecting to: " + wsUrl);

    ws = new WebSocket(wsUrl);
    ws.onopen = function() {
      console.log("Connected!");
      var msg = {
        roomId: roomId,
        senderId: myId,
        content: "ENTER"
      };
      ws.send(JSON.stringify(msg));
    };

    ws.onmessage = function(event) {
      var data = JSON.parse(event.data);

      if(data.type === "NOTIFICATION" || data.content === "ENTER") return;

      var msgDiv = document.createElement("div");
      var isMine = (data.senderId == myId); // 내가 보낸 메시지인지 확인

      // [수정] 카드 렌더링 로직 (내가 보낸 경우 버튼 비활성화)
      if (data.content === "[[WALK_REQUEST]]") {
        var btnAttr = isMine ? 'disabled' : 'onclick="startWalk()"';
        var btnText = isMine ? '수락 대기중' : '산책 시작하기';
        var descText = isMine ? '산책 메이트 신청을 보냈습니다.' : '산책 요청이 도착했습니다.';

        var cardHtml =
                '<div class="walk-card">' +
                '<div class="walk-card-content">' +
                '<div class="walk-card-icon"><i class="fas fa-dog"></i></div>' +
                '<div class="walk-card-title">산책해요!</div>' +
                '<p class="walk-card-desc">' + descText + '</p>' +
                '</div>' +
                '<button class="btn-start-walk" ' + btnAttr + '>' + btnText + '</button>' +
                '</div>';
        msgDiv.innerHTML = cardHtml;

      } else if (data.content === "[[VIDEO_REQUEST]]") {
        var btnAttr = isMine ? 'disabled' : 'onclick="startVideoCall()"';
        var btnText = isMine ? '응답 대기중' : '영상통화 시작하기';
        var descText = isMine ? '영상통화를 요청했습니다.' : '영상통화를 시작하시겠습니까?';

        var cardHtml =
                '<div class="video-card">' +
                '<div class="video-card-content">' +
                '<div class="video-card-icon"><i class="fas fa-video"></i></div>' +
                '<div class="video-card-title">영상통화</div>' +
                '<p class="video-card-desc">' + descText + '</p>' +
                '</div>' +
                '<button class="btn-start-video" ' + btnAttr + '>' + btnText + '</button>' +
                '</div>';
        msgDiv.innerHTML = cardHtml;

      } else {
        var content = '<div class="msg-bubble">' + data.content + '</div>';
        msgDiv.innerHTML = content;
      }

      if(isMine) {
        msgDiv.className = "message-box my-msg";
      } else {
        msgDiv.className = "message-box other-msg";
      }

      chatContainer.appendChild(msgDiv);
      chatContainer.scrollTop = chatContainer.scrollHeight;
    };
  }

  function sendMessage() {
    var input = document.getElementById("msgInput");
    var text = input.value;
    if(!text.trim()) return;
    var msg = {
      roomId: roomId,
      senderId: myId,
      content: text
    };
    ws.send(JSON.stringify(msg));
    input.value = "";
  }

  function togglePlusMenu() {
    var menu = document.getElementById("plusMenu");
    var btn = document.getElementById("plusBtn");

    if (menu.style.display === "block") {
      menu.style.display = "none";
      btn.classList.remove("active");
    } else {
      menu.style.display = "block";
      btn.classList.add("active");
      chatContainer.scrollTop = chatContainer.scrollHeight;
    }
  }

  function requestVideoCall() {
    togglePlusMenu();
    var msg = {
      roomId: roomId,
      senderId: myId,
      content: "[[VIDEO_REQUEST]]"
    };
    ws.send(JSON.stringify(msg));
  }

  function requestWalk() {
    togglePlusMenu();
    var msg = {
      roomId: roomId,
      senderId: myId,
      content: "[[WALK_REQUEST]]"
    };
    ws.send(JSON.stringify(msg));
  }

  function startWalk() {
    alert("산책 모드를 시작합니다!");
  }

  function startVideoCall() {
    if(confirm("영상통화를 연결하시겠습니까?")) {
      alert("영상통화 연결 중...");
    }
  }
</script>