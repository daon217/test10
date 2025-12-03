<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* [디자인 테마 설정] */
    :root {
        --primary-color: #FF6B6B;
        --primary-light: #FFF0F0;
        --secondary-color: #4ECDC4;
        --secondary-light: #E0F2F1;
        --bg-color: #F2F4F7;
        --my-bubble-bg: #FF6B6B;
        --my-bubble-text: #FFFFFF;
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
    .message-box.my-msg .msg-bubble {
        background-color: var(--my-bubble-bg);
        color: var(--my-bubble-text);
        border-top-right-radius: 2px;
        box-shadow: 0 2px 5px rgba(255, 107, 107, 0.3);
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

    /* 특수 카드 (산책, 영상통화) */
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

    /* 영상통화 스타일 */
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
    .video-style .btn-event-action:hover:not(:disabled) {
        background: var(--secondary-light);
        color: var(--secondary-color);
    }
    .btn-event-action:disabled { background: #eee; color: #aaa; cursor: default; }

    /* 하단 입력창 영역 */
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

    .input-wrapper { flex: 1; position: relative; display: flex; }
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

    /* 확장 메뉴 */
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

    /* 영상통화 모달 */
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
        width: 100%; max-width: 800px; height: auto;
        background: #222; border-radius: 10px;
    }
    #localVideo {
        position: absolute; bottom: 20px; right: 20px;
        width: 120px; height: 90px;
        background: #000;
        border: 2px solid #fff; border-radius: 5px;
        object-fit: cover;
    }
    .video-controls { margin-top: 20px; display: flex; gap: 20px; }
    .btn-close-video {
        background: #ff4b4b; color: white; border: none;
        padding: 10px 20px; border-radius: 20px;
        font-weight: bold; cursor: pointer; font-size: 16px;
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
                            <%-- 산책 요청 카드 --%>
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
                            <%-- [NEW] 산책 현황 카드 (내가 보냄 = 내가 산책 수행자 = Worker) --%>
                            <c:when test="${msg.content eq '[[WALK_STARTED]]'}">
                                <div class="event-card">
                                    <div class="event-card-content">
                                        <div class="event-icon-circle" style="background:#E0F2F1; color:#4ECDC4;"><i class="fas fa-running"></i></div>
                                        <div class="event-title">산책 현황</div>
                                        <p class="event-desc">산책이 시작되었습니다.<br>현황을 확인하세요.</p>
                                    </div>
                                        <%-- [수정] 알바생 화면으로 이동 --%>
                                    <button class="btn-event-action" onclick="location.href='/walkjob/worker'">산책 현황 보기</button>
                                </div>
                            </c:when>
                            <%-- 영상통화 요청 카드 --%>
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
                            <%-- [NEW] 산책 현황 카드 (상대가 보냄 = 나는 산책 요청자 = Owner) --%>
                            <c:when test="${msg.content eq '[[WALK_STARTED]]'}">
                                <div class="event-card">
                                    <div class="event-card-content">
                                        <div class="event-icon-circle" style="background:#E0F2F1; color:#4ECDC4;"><i class="fas fa-running"></i></div>
                                        <div class="event-title">산책 현황</div>
                                        <p class="event-desc">산책이 시작되었습니다.<br>현황을 확인하세요.</p>
                                    </div>
                                        <%-- [수정] 견주 화면으로 이동 --%>
                                    <button class="btn-event-action" onclick="location.href='/walkjob/owner'">산책 현황 보기</button>
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

<div id="videoModal">
    <video id="remoteVideo" autoplay playsinline></video>
    <video id="localVideo" autoplay playsinline muted></video>
    <div class="video-controls">
        <button class="btn-close-video" onclick="endCall()">통화 종료</button>
    </div>
</div>

<script>
    var ws;    // 채팅 소켓
    var sigWs; // 시그널링 소켓 (WebRTC용)

    var roomId = "${room.roomId}";
    var myId = "${user.userId}";
    var chatContainer = document.getElementById("chatContainer");

    // [WebRTC 변수]
    var localStream = null;      // 나의 비디오/오디오 스트림
    var peerConnection = null;
    var candidateQueue = [];     // [중요] 타이밍 문제 해결용 후보 저장소

    // 구글 무료 STUN 서버
    var peerConnectionConfig = {
        'iceServers': [
            {'urls': 'stun:stun.l.google.com:19302'}
        ]
    };

    // 스크롤 초기화
    chatContainer.scrollTop = chatContainer.scrollHeight;

    window.onload = function() {
        connectChat();   // 채팅 연결
        connectSignal(); // 시그널링 연결
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

            // [채팅 UI 처리]
            // 1. 산책 요청
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

                // 2. [NEW] 산책 현황 (산책 시작됨)
            } else if (data.content === "[[WALK_STARTED]]") {
                // [수정] 페이지 URL 매핑
                // isMine (내가 누름) -> Worker Page
                // !isMine (상대가 누름) -> Owner Page
                var targetUrl = isMine ? "/walkjob/worker" : "/walkjob/owner";

                msgDiv.innerHTML =
                    '<div class="event-card">' +
                    '<div class="event-card-content">' +
                    '<div class="event-icon-circle" style="background:#E0F2F1; color:#4ECDC4;"><i class="fas fa-running"></i></div>' +
                    '<div class="event-title">산책 현황</div>' +
                    '<p class="event-desc">산책이 시작되었습니다.<br>현황을 확인하세요.</p>' +
                    '</div>' +
                    '<button class="btn-event-action" onclick="location.href=\'' + targetUrl + '\'">산책 현황 보기</button>' +
                    '</div>';

                // 3. 영상통화 요청
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
                // 4. 일반 메시지
            } else {
                msgDiv.innerHTML = '<div class="msg-bubble">' + data.content + '</div>';
            }

            msgDiv.className = isMine ? "message-box my-msg" : "message-box other-msg";
            chatContainer.appendChild(msgDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight;
        };
    }

    // 2. 시그널링 소켓 연결
    function connectSignal() {
        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var sigUrl = protocol + location.host + "/signal";
        sigWs = new WebSocket(sigUrl);

        sigWs.onopen = function() {
            console.log("Signaling Server Connected");
        };

        sigWs.onmessage = function(event) {
            var message = JSON.parse(event.data);
            if(message.roomId && message.roomId !== roomId) return;
            if(message.senderId === myId) return;

            handleSignalMessage(message);
        };
    }

    // [WebRTC 시그널링 핸들러]
    async function handleSignalMessage(message) {
        try {
            if (message.type === 'offer') {
                // [수신자] 전화 옴
                console.log("Received Offer");

                // 1. 수신자 미디어 확보
                if (!localStream) {
                    localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                    document.getElementById('localVideo').srcObject = localStream;
                    document.getElementById('videoModal').style.display = 'flex';
                }

                // 2. PeerConnection 생성
                createPeerConnection();

                // 3. 상대방 정보 설정 및 대기열 처리
                await peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp));
                processCandidateQueue(); // [중요] 대기 중인 후보 처리

                // 4. Answer 생성 및 전송
                var answer = await peerConnection.createAnswer();
                await peerConnection.setLocalDescription(answer);

                sendSignal({
                    type: 'answer',
                    sdp: answer,
                    roomId: roomId,
                    senderId: myId
                });

            } else if (message.type === 'answer') {
                // [발신자] 전화 받음
                console.log("Received Answer");
                if(peerConnection) {
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp));
                    processCandidateQueue(); // [중요]
                }

            } else if (message.type === 'candidate') {
                // [공통] ICE Candidate 수신
                if (peerConnection && peerConnection.remoteDescription) {
                    await peerConnection.addIceCandidate(new RTCIceCandidate(message.candidate));
                } else {
                    console.log("Queueing candidate...");
                    candidateQueue.push(message.candidate);
                }
            }
        } catch (e) {
            console.error("Signal Handling Error:", e);
        }
    }

    // 대기열 후보 일괄 처리
    async function processCandidateQueue() {
        while (candidateQueue.length > 0) {
            var candidate = candidateQueue.shift();
            if(peerConnection) {
                try {
                    await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
                } catch(e) {
                    console.error("Error adding queued candidate", e);
                }
            }
        }
    }

    // WebRTC 객체 생성
    function createPeerConnection() {
        if(peerConnection) return;

        peerConnection = new RTCPeerConnection(peerConnectionConfig);

        // ICE Candidate 전송
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

        // 스트림 수신 (상대방 얼굴)
        peerConnection.ontrack = function(event) {
            var remoteVideo = document.getElementById('remoteVideo');
            if (remoteVideo.srcObject !== event.streams[0]) {
                remoteVideo.srcObject = event.streams[0];
            }
        };

        // 내 스트림 추가
        if(localStream) {
            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });
        }
    }

    function sendSignal(data) {
        if(sigWs && sigWs.readyState === WebSocket.OPEN) {
            sigWs.send(JSON.stringify(data));
        }
    }

    // -------------------------
    // UI 이벤트 핸들러
    // -------------------------

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

    // 산책 시작
    function startWalk() {
        if(!confirm("산책을 시작하시겠습니까?")) return;
        // 서버로 산책 시작 신호 전송
        var msg = { roomId: roomId, senderId: myId, content: "[[WALK_STARTED]]" };
        ws.send(JSON.stringify(msg));
    }

    // [발신자] 영상통화 시작
    async function startVideoCall() {
        if(!confirm("영상통화를 연결하시겠습니까?")) return;

        document.getElementById('videoModal').style.display = 'flex';

        try {
            localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            document.getElementById('localVideo').srcObject = localStream;

            createPeerConnection();

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
        candidateQueue = [];
        location.reload();
    }
</script>