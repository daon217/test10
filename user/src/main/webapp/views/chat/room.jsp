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
</style>

<div class="chat-wrapper">
  <div class="card">
    <div class="card-header bg-white">
      <h5 class="mb-0"><i class="fas fa-comments"></i> ${room.postTitle}</h5>
    </div>
    <div class="card-body">
      <div id="chatContainer" class="chat-container">
        <c:forEach var="msg" items="${msgs}">
          <c:choose>
            <c:when test="${msg.senderId == user.userId}">
              <div class="message-box my-msg">
                <div class="msg-bubble">${msg.content}</div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="message-box other-msg">
                <div class="msg-bubble">${msg.content}</div>
              </div>
            </c:otherwise>
          </c:choose>
        </c:forEach>
      </div>

      <div class="input-group">
        <input type="text" id="msgInput" class="form-control" placeholder="메시지 입력..." onkeypress="if(event.keyCode==13) sendMessage();">
        <button class="btn btn-warning" onclick="sendMessage()">전송</button>
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
    // [핵심] SSL(https)이면 wss, 아니면 ws 자동 선택
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
      if(data.content === "ENTER") return;

      var msgDiv = document.createElement("div");
      var content = '<div class="msg-bubble">' + data.content + '</div>';

      if(data.senderId == myId) {
        msgDiv.className = "message-box my-msg";
      } else {
        msgDiv.className = "message-box other-msg";
      }

      msgDiv.innerHTML = content;
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
</script>