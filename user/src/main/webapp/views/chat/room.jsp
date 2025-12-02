<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  /* [디자인 테마 설정] */
  :root {
    /* 1. 메인 컬러 (붉은색/Coral) - 산책, 전송버튼, 내 말풍선 */
    --primary-color: #FF6B6B;
    --primary-light: #FFF0F0;

    /* 2. 서브 컬러 (민트색/Teal) - 영상통화 등 */
    --secondary-color: #4ECDC4;
    --secondary-light: #E0F2F1;

    --bg-color: #F2F4F7;
    --my-bubble-bg: #FF6B6B;   /* 내 말풍선 배경 (진한 색) */
    --my-bubble-text: #FFFFFF; /* 내 말풍선 글자 (흰색) */
    --other-bubble: #FFFFFF;
    --shadow-sm: 0 2px 5px rgba(0,0,0,0.05);
  }

  body { background-color: var(--bg-color); }

  .chat-wrapper {
    max-width: 600px;
    margin: 0 auto;
    height: 100vh;
    background-color: var(--bg-color);
    display: flex;
    flex-direction: column;
    position: relative;
  }

  /* 헤더 스타일 */
  .chat-header {
    background: #fff;
    padding: 15px 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 1px 10px rgba(0,0,0,0.05);
    z-index: 100;
    position: sticky;
    top: 0;
  }
  .chat-header-title {
    font-weight: 700;
    font-size: 1.1rem;
    color: #333;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .chat-header-title i { color: var(--primary-color); font-size: 1.3rem; }

  /* 채팅 영역 스타일 */
  .chat-container {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    background-color: var(--bg-color);
    display: flex;
    flex-direction: column;
    gap: 15px;
    padding-bottom: 20px;
  }

  .message-box {
    display: flex;
    flex-direction: column;
    max-width: 80%;
  }

  /* 내 메시지 (오른쪽) */
  .message-box.my-msg {
    align-self: flex-end;
    align-items: flex-end;
  }
  /* 내 말풍선 디자인 변경: 진한 색 + 흰 글씨 */
  .message-box.my-msg .msg-bubble {
    background-color: var(--my-bubble-bg);
    color: var(--my-bubble-text);
    border-top-right-radius: 2px;
    box-shadow: 0 2px 5px rgba(255, 107, 107, 0.3); /* 붉은 그림자 */
  }

  /* 상대방 메시지 (왼쪽) */
  .message-box.other-msg {
    align-self: flex-start;
    align-items: flex-start;
  }
  .message-box.other-msg .msg-bubble {
    background-color: var(--other-bubble);
    border: 1px solid #eee;
    border-top-left-radius: 2px;
    color: #333;
  }

  /* 공통 말풍선 */
  .msg-bubble {
    padding: 12px 18px;
    border-radius: 18px;
    font-size: 15px;
    line-height: 1.5;
    position: relative;
    word-break: break-all;
    box-shadow: var(--shadow-sm);
  }

  /* 3. 특수 카드 (산책, 영상통화) 스타일 개선 */
  .event-card {
    background: #fff;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 260px;
    text-align: center;
    margin-top: 5px;
    border: 1px solid rgba(0,0,0,0.05);
  }
  .event-card-content { padding: 25px 20px; }

  /* 기본 아이콘 (산책 - Red) */
  .event-icon-circle {
    width: 60px;
    height: 60px;
    background: var(--primary-light);
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 15px;
    font-size: 28px;
    color: var(--primary-color);
  }

  /* 영상통화 스타일 (영상통화 - Mint) */
  .video-style .event-icon-circle {
    background: var(--secondary-light);
    color: var(--secondary-color);
  }

  .event-title { font-weight: bold; font-size: 16px; margin-bottom: 5px; color: #333; }
  .event-desc { font-size: 13px; color: #888; margin: 0; }

  .btn-event-action {
    width: 100%; padding: 15px 0;
    border: none;
    background: #f9f9f9;
    font-weight: 600;
    font-size: 14px;
    color: #333;
    border-top: 1px solid #eee;
    cursor: pointer; transition: 0.2s;
  }
  .btn-event-action:hover:not(:disabled) {
    background: var(--primary-light);
    color: var(--primary-color);
  }
  /* 영상통화 버튼 호버 시 민트색 */
  .video-style .btn-event-action:hover:not(:disabled) {
    background: var(--secondary-light);
    color: var(--secondary-color);
  }

  .btn-event-action:disabled { background: #eee; color: #aaa; cursor: default; }


  /* 4. 하단 입력창 영역 */
  .chat-input-area {
    background: #fff;
    padding: 15px;
    display: flex;
    align-items: center;
    gap: 12px;
    border-top: 1px solid #eee;
    position: sticky;
    bottom: 0;
  }

  /* 플러스 버튼 */
  .btn-plus {
    width: 40px; height: 40px;
    border-radius: 50%;
    border: none;
    background-color: #F0F0F0;
    color: #666;
    font-size: 18px;
    display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: 0.3s;
  }
  .btn-plus:hover { background-color: #e0e0e0; }
  .btn-plus.active { background-color: var(--primary-color); color: #fff; transform: rotate(45deg); }

  /* 입력 필드 */
  .input-wrapper {
    flex: 1;
    position: relative;
    display: flex;
  }
  .chat-input {
    width: 100%;
    padding: 12px 50px 12px 20px;
    border: 1px solid #ddd;
    border-radius: 25px;
    background-color: #FAFAFA;
    outline: none;
    font-size: 15px;
    transition: 0.2s;
  }
  .chat-input:focus {
    background-color: #fff;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
  }

  /* 전송 버튼 */
  .btn-send {
    position: absolute;
    right: 5px; top: 50%;
    transform: translateY(-50%);
    border: none;
    background: var(--primary-color);
    color: white;
    width: 36px; height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center; justify-content: center;
    cursor: pointer;
    font-size: 14px;
    box-shadow: 0 2px 5px rgba(255, 107, 107, 0.3);
  }
  .btn-send:hover { opacity: 0.9; transform: translateY(-50%) scale(1.05); }

  /* 5. 확장 메뉴 */
  .plus-menu {
    display: none;
    background-color: #fff;
    border-top: 1px solid #eee;
    padding: 20px;
  }
  .plus-menu-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
  }
  .menu-item {
    display: flex; flex-direction: column; align-items: center;
    cursor: pointer; color: #555;
    font-size: 12px;
  }
  .menu-icon-box {
    width: 55px; height: 55px;
    background-color: #F8F9FA;
    border-radius: 18px;
    display: flex;
    align-items: center; justify-content: center;
    font-size: 24px;
    color: #555;
    margin-bottom: 8px;
    transition: 0.2s;
  }

  /* 메뉴 아이콘 호버 시 각 색상 적용 */
  .menu-item.video-type:hover .menu-icon-box {
    background-color: var(--secondary-light);
    color: var(--secondary-color);
    transform: scale(1.05);
  }
  .menu-item.walk-type:hover .menu-icon-box {
    background-color: var(--primary-light);
    color: var(--primary-color);
    transform: scale(1.05);
  }

  /* [NEW] 영상통화 모달 스타일 */
  #videoModal {
    display: none;
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0,0,0,0.9);
    z-index: 9999;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  #remoteVideo {
    width: 100%;
    max-width: 800px;
    height: auto;
    background: #222;
    border-radius: 10px;
  }
  #localVideo {
    position: absolute;
    bottom: 20px;
    right: 20px;
    width: 120px;
    height: 90px;
    background: #000;
    border: 2px solid #fff;
    border-radius: 5px;
    object-fit: cover;
  }
  .video-controls {
    margin-top: 20px;
    display: flex; gap: 20px;
  }
  .btn-close-video {
    background: #ff4b4b; color: white; border: none;
    padding: 10px 20px; border-radius: 20px; font-weight: bold;
    cursor: pointer; font-size: 16px;
  }

</style>

<div class="chat-wrapper">
  <div class="chat-header">
    <div class="chat-header-title">
      <i class="fas fa-paw"></i>
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

  <div id="chatContainer" class="chat-container">
    <c:forEach var="msg" items="${msgs}">
      <c:choose>
        <%-- 내가 보낸 메시지 --%>
        <c:when test="${msg.senderId == user.userId}">
          <div class="message-box my-msg">
            <c:choose>
              <%-- 산책 요청 카드 (Red Theme) --%>
              <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                <div class="event-card">
                  <div class="event-card-content">
                    <div class="event-icon-circle"><i class="fas fa-dog"></i></div>
                    <div class="event-title">산책해요!</div>
                    <p class="event-desc">산책 알바 신청을 보냈습니다.</p>
                  </div>
                  <button class="btn-event-action" disabled>수락 대기중</button>
                </div>
              </c:when>
              <%-- 영상통화 요청 카드 (Mint Theme) --%>
              <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                <div class="event-card video-style">
                  <div class="event-card-content">
                    <div class="event-icon-circle"><i class="fas fa-video"></i></div>
                    <div class="event-title">영상통화</div>
                    <p class="event-desc">영상통화를 요청했습니다.</p>
                  </div>
                  <button class="btn-event-action" disabled>응답 대기중</button>
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
              <%-- 산책 요청 수락 카드 --%>
              <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                <div class="event-card">
                  <div class="event-card-content">
                    <div class="event-icon-circle"><i class="fas fa-dog"></i></div>
                    <div class="event-title">산책해요!</div>
                    <p class="event-desc">함께 산책하시겠습니까?</p>
                  </div>
                  <button class="btn-event-action" onclick="startWalk()">산책 시작하기</button>
                </div>
              </c:when>
              <%-- 영상통화 수락 카드 --%>
              <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                <div class="event-card video-style">
                  <div class="event-card-content">
                    <div class="event-icon-circle"><i class="fas fa-video"></i></div>
                    <div class="event-title">영상통화</div>
                    <p class="event-desc">영상통화를 시작하시겠습니까?</p>
                  </div>
                    <%-- [중요] 영상통화 수락 버튼 --%>
                  <button class="btn-event-action" onclick="startVideoCall()">영상통화 시작하기</button>
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

    <div class="input-wrapper">
      <input type="text" id="msgInput" class="chat-input" placeholder="메시지를 입력하세요..." onkeypress="if(event.keyCode==13) sendMessage();">
      <button class="btn-send" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
    </div>
  </div>

  <div id="plusMenu" class="plus-menu">
    <div class="plus-menu-grid">
      <div class="menu-item video-type" onclick="requestVideoCall()">
        <div class="menu-icon-box"><i class="fas fa-video"></i></div>
        <span>영상통화</span>
      </div>
      <div class="menu-item walk-type" onclick="requestWalk()">
        <div class="menu-icon-box"><i class="fas fa-walking"></i></div>
        <span>산책하기</span>
      </div>
    </div>
  </div>
</div>

<%-- [NEW] 영상통화 모달 (숨김 상태) --%>
<div id="videoModal">
  <video id="remoteVideo" autoplay playsinline></video>
  <video id="localVideo" autoplay playsinline muted></video>
  <div class="video-controls">
    <button class="btn-close-video" onclick="endCall()">통화 종료</button>
  </div>
</div>

<script>
  var ws; // 채팅 소켓
  var sigWs; // [NEW] 시그널링 소켓 (WebRTC용)

  var roomId = "${room.roomId}";
  var myId = "${user.userId}";
  var chatContainer = document.getElementById("chatContainer");

  // [NEW] WebRTC 변수
  var localStream;
  var peerConnection;
  var peerConnectionConfig = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'} // 구글 무료 STUN 서버
    ]
  };

  // 스크롤 맨 아래로
  chatContainer.scrollTop = chatContainer.scrollHeight;

  window.onload = function() {
    connectChat();   // 기존 채팅 연결
    connectSignal(); // [NEW] 시그널링 연결
  };

  // 1. 채팅 소켓 연결
  function connectChat() {
    var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
    var wsUrl = protocol + location.host + "/ws/chat";

    ws = new WebSocket(wsUrl);
    ws.onopen = function() {
      console.log("Chat Connected!");
      var msg = { roomId: roomId, senderId: myId, content: "ENTER" };
      ws.send(JSON.stringify(msg));
    };

    ws.onmessage = function(event) {
      var data = JSON.parse(event.data);
      if(data.type === "NOTIFICATION" || data.content === "ENTER") return;

      var msgDiv = document.createElement("div");
      var isMine = (data.senderId == myId);

      // [카드 UI 처리]
      if (data.content === "[[WALK_REQUEST]]") {
        var btnAttr = isMine ? 'disabled' : 'onclick="startWalk()"';
        var btnText = isMine ? '수락 대기중' : '산책 시작하기';
        var descText = isMine ? '산책 메이트 신청을 보냈습니다.' : '산책 요청이 도착했습니다.';

        msgDiv.innerHTML =
                '<div class="event-card">' +
                '<div class="event-card-content">' +
                '<div class="event-icon-circle"><i class="fas fa-dog"></i></div>' +
                '<div class="event-title">산책해요!</div>' +
                '<p class="event-desc">' + descText + '</p>' +
                '</div>' +
                '<button class="btn-event-action" ' + btnAttr + '>' + btnText + '</button>' +
                '</div>';

      } else if (data.content === "[[VIDEO_REQUEST]]") {
        var btnAttr = isMine ? 'disabled' : 'onclick="startVideoCall()"';
        var btnText = isMine ? '응답 대기중' : '영상통화 시작하기';
        var descText = isMine ? '영상통화를 요청했습니다.' : '영상통화를 시작하시겠습니까?';

        msgDiv.innerHTML =
                '<div class="event-card video-style">' +
                '<div class="event-card-content">' +
                '<div class="event-icon-circle"><i class="fas fa-video"></i></div>' +
                '<div class="event-title">영상통화</div>' +
                '<p class="event-desc">' + descText + '</p>' +
                '</div>' +
                '<button class="btn-event-action" ' + btnAttr + '>' + btnText + '</button>' +
                '</div>';

      } else {
        msgDiv.innerHTML = '<div class="msg-bubble">' + data.content + '</div>';
      }

      msgDiv.className = isMine ? "message-box my-msg" : "message-box other-msg";
      chatContainer.appendChild(msgDiv);
      chatContainer.scrollTop = chatContainer.scrollHeight;
    };
  }

  // 2. [NEW] 시그널링 소켓 연결 (영상통화용)
  function connectSignal() {
    var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
    // WebSocketConfig에 설정된 /signal 경로
    var sigUrl = protocol + location.host + "/signal";

    sigWs = new WebSocket(sigUrl);
    sigWs.onopen = function() {
      console.log("Signaling Server Connected");
    };

    sigWs.onmessage = function(event) {
      var message = JSON.parse(event.data);

      // [중요] 다른 방의 신호는 무시 (간단한 필터링)
      if(message.roomId && message.roomId !== roomId) return;

      // 내가 보낸 신호가 되돌아온 경우 무시
      if(message.senderId === myId) return;

      handleSignalMessage(message);
    };
  }

  // [NEW] WebRTC 시그널링 처리
  async function handleSignalMessage(message) {
    if (message.type === 'offer') {
      // A(요청자): B가 보낸 Offer를 받음 -> 즉시 화면을 켬 (A는 수동 승인 없이 바로 연결)
      console.log("Received Offer");

      // 화면 UI 띄우기
      document.getElementById('videoModal').style.display = 'flex';

      createPeerConnection();

      // 상대방(B)의 Offer 설정
      await peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp));

      // Answer 생성 및 전송
      var answer = await peerConnection.createAnswer();
      await peerConnection.setLocalDescription(answer);

      sendSignal({
        type: 'answer',
        sdp: answer,
        roomId: roomId,
        senderId: myId
      });

    } else if (message.type === 'answer') {
      // B(수신자): A의 Answer를 받음 -> 연결 확정
      console.log("Received Answer");
      if(peerConnection) {
        await peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp));
      }

    } else if (message.type === 'candidate') {
      // ICE Candidate 교환
      if(peerConnection) {
        await peerConnection.addIceCandidate(new RTCIceCandidate(message.candidate));
      }
    }
  }

  // [NEW] WebRTC 연결 객체 생성
  function createPeerConnection() {
    if(peerConnection) return;

    peerConnection = new RTCPeerConnection(peerConnectionConfig);

    // ICE Candidate 발생 시 상대에게 전송
    peerConnection.onicecandidate = function(event) {
      if (event.candidate) {
        sendSignal({
          type: 'candidate',
          candidate: event.candidate,
          roomId: roomId,
          senderId: myId
        });
      }
    };

    // 상대방 영상 스트림 수신 (A가 B의 얼굴을 보는 부분)
    peerConnection.ontrack = function(event) {
      var remoteVideo = document.getElementById('remoteVideo');
      if (remoteVideo.srcObject !== event.streams[0]) {
        remoteVideo.srcObject = event.streams[0];
      }
    };

    // 내 스트림이 있으면 연결에 추가 (B가 A에게 보낼 때)
    if(localStream) {
      localStream.getTracks().forEach(track => {
        peerConnection.addTrack(track, localStream);
      });
    }
  }

  // 시그널 메시지 전송 헬퍼
  function sendSignal(data) {
    if(sigWs && sigWs.readyState === WebSocket.OPEN) {
      sigWs.send(JSON.stringify(data));
    }
  }

  // 채팅 메시지 전송
  function sendMessage() {
    var input = document.getElementById("msgInput");
    var text = input.value;
    if(!text.trim()) return;
    var msg = { roomId: roomId, senderId: myId, content: text };
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

  // [Step 1] A가 영상통화 요청 (채팅 메시지 전송)
  function requestVideoCall() {
    togglePlusMenu();
    var msg = { roomId: roomId, senderId: myId, content: "[[VIDEO_REQUEST]]" };
    ws.send(JSON.stringify(msg));
  }

  function requestWalk() {
    togglePlusMenu();
    var msg = { roomId: roomId, senderId: myId, content: "[[WALK_REQUEST]]" };
    ws.send(JSON.stringify(msg));
  }

  function startWalk() {
    alert("산책 모드를 시작합니다!");
  }

  // [Step 2] B가 영상통화 수락 버튼 클릭
  async function startVideoCall() {
    if(!confirm("영상통화를 연결하시겠습니까?")) return;

    // UI 표시
    document.getElementById('videoModal').style.display = 'flex';

    try {
      // 카메라 권한 요청
      localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
      document.getElementById('localVideo').srcObject = localStream;

      // PeerConnection 생성
      createPeerConnection();

      // Offer(연결 요청서) 생성 및 전송
      var offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);

      sendSignal({
        type: 'offer',
        sdp: offer,
        roomId: roomId,
        senderId: myId
      });

    } catch(e) {
      console.error("Camera Error:", e);
      alert("카메라 권한이 필요합니다.");
      document.getElementById('videoModal').style.display = 'none';
    }
  }

  // 통화 종료
  function endCall() {
    document.getElementById('videoModal').style.display = 'none';
    if(peerConnection) {
      peerConnection.close();
      peerConnection = null;
    }
    if(localStream) {
      localStream.getTracks().forEach(track => track.stop());
      localStream = null;
    }
    // 선택사항: 종료 메시지 전송 등
  }
</script>