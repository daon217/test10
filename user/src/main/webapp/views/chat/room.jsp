<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    :root {
        --point-color: #FF6B6B;
        --point-light: #FFF0F0;
        --sub-color: #4ECDC4;
        --text-dark: #333333;
        --text-gray: #999999;
    }

    .chat-wrapper {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }

    .chat-container {
        height: 500px;
        overflow-y: auto;
        background: #f8f9fa;
        border: 1px solid #ddd;
        padding: 20px;
        border-radius: 20px;
        margin-bottom: 20px;
    }

    .message-box {
        margin-bottom: 15px;
        display: flex;
        flex-direction: column;
    }

    .message-box.my-msg {
        align-items: flex-end;
    }

    .message-box.other-msg {
        align-items: flex-start;
    }

    .msg-bubble {
        max-width: 70%;
        padding: 10px 15px;
        border-radius: 20px;
        font-size: 15px;
        position: relative;
        word-break: break-all;
    }

    .my-msg .msg-bubble {
        background-color: var(--point-light);
        border-top-right-radius: 0;
        color: var(--text-dark);
    }

    .other-msg .msg-bubble {
        background-color: white;
        border: 1px solid #eee;
        border-top-left-radius: 0;
    }

    .msg-info {
        font-size: 12px;
        color: #888;
        margin-top: 5px;
    }

    .chat-header-title {
        font-weight: bold;
        font-size: 1.1rem;
        display: flex;
        align-items: center;
    }

    .chat-header-title i {
        color: var(--point-color);
        margin-right: 8px;
        font-size: 1.2rem;
    }

    /* 플러스 버튼 및 메뉴 스타일 */
    .chat-input-area {
        display: flex;
        align-items: center;
        gap: 10px;
        padding-top: 10px;
    }

    .btn-plus {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: none;
        background-color: #eee;
        color: #555;
        font-size: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: background 0.2s;
    }

    .btn-plus:hover {
        background-color: #ddd;
    }

    .btn-plus.active {
        background-color: #ccc;
        transform: rotate(45deg);
    }

    /* 확장 메뉴 스타일 */
    .plus-menu {
        display: none;
        padding: 20px 10px;
        background-color: #f8f9fa;
        border-top: 1px solid #ddd;
        margin-top: 15px;
        border-radius: 20px;
    }

    .plus-menu-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
        text-align: center;
    }

    .menu-item {
        cursor: pointer;
        display: flex;
        flex-direction: column;
        align-items: center;
        color: #333;
        font-size: 13px;
    }

    .menu-icon-box {
        width: 50px;
        height: 50px;
        background-color: white;
        border-radius: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        margin-bottom: 8px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        transition: transform 0.1s;
        color: #555;
    }

    .menu-item:hover .menu-icon-box {
        transform: scale(1.05);
        background-color: var(--point-light);
        color: var(--point-color);
    }

    /* 카드 공통 스타일 */
    .walk-card, .video-card, .resume-card {
        width: 260px;
        background-color: white;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        border: 1px solid #eee;
        margin-top: 5px;
    }

    .card-content-area {
        padding: 20px;
        text-align: center;
        background: #fff;
    }

    .card-icon-large {
        font-size: 40px;
        margin-bottom: 12px;
    }

    .card-title {
        font-weight: bold;
        font-size: 16px;
        margin-bottom: 5px;
        color: #333;
    }

    .card-desc {
        font-size: 13px;
        color: #888;
        margin-bottom: 0;
    }

    .btn-card-action {
        width: 100%;
        border: none;
        background-color: #f8f9fa;
        padding: 12px 0;
        font-size: 14px;
        color: #333;
        cursor: pointer;
        border-top: 1px solid #eee;
        font-weight: bold;
        transition: background 0.2s;
    }

    .btn-card-action:disabled {
        background-color: #eee;
        color: #999;
        cursor: default;
    }

    /* 테마별 스타일 */
    .walk-theme .card-icon-large { color: var(--point-color); }
    .walk-theme .btn-card-action:hover { background-color: var(--point-light); }

    .video-theme .card-icon-large { color: var(--sub-color); }
    .video-theme .btn-card-action:hover { background-color: #E0F2F1; }

    .resume-theme .card-icon-large { color: var(--sub-color); }
    .resume-theme .btn-card-action { background-color: var(--sub-color); color: white; }
    .resume-theme .btn-card-action:hover { opacity: 0.9; }

    .resume-list {
        text-align: left;
        font-size: 13px;
        color: #555;
        background-color: #fafafa;
        padding: 10px 15px;
        border-radius: 10px;
        margin-top: 10px;
        list-style: none;
    }
    .resume-list li { margin-bottom: 4px; }
    .resume-list li:last-child { margin-bottom: 0; }
    .resume-list strong { color: var(--text-dark); margin-right: 5px; }

    /* 모달 스타일 */
    .modal {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.5);
        backdrop-filter: blur(2px);
    }

    .modal-content {
        background-color: #fff;
        margin: 5% auto;
        padding: 30px;
        border-radius: 20px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        position: relative;
        animation: slideIn 0.3s;
    }

    @keyframes slideIn {
        from { transform: translateY(-50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }

    .close-modal {
        color: #aaa;
        position: absolute;
        top: 20px;
        right: 25px;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.2s;
    }

    .close-modal:hover {
        color: var(--point-color);
    }

    /* 이력서 모달 내부 디자인 */
    .resume-header {
        text-align: center;
        border-bottom: 2px dashed #eee;
        padding-bottom: 20px;
        margin-bottom: 20px;
    }

    .resume-avatar {
        width: 80px;
        height: 80px;
        background-color: var(--point-light);
        border-radius: 50%;
        margin: 0 auto 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 40px;
        color: var(--point-color);
    }

    .resume-name {
        font-size: 1.5rem;
        font-weight: bold;
        color: var(--text-dark);
        margin-bottom: 5px;
    }

    .resume-meta {
        color: #888;
        font-size: 0.9rem;
    }

    .resume-section {
        margin-bottom: 20px;
    }

    .resume-section h4 {
        font-size: 1.1rem;
        font-weight: bold;
        color: var(--text-dark);
        border-left: 4px solid var(--sub-color);
        padding-left: 10px;
        margin-bottom: 12px;
    }

    .resume-table {
        width: 100%;
        font-size: 0.95rem;
        border-collapse: separate;
        border-spacing: 0 8px;
    }

    .resume-table td {
        vertical-align: top;
    }

    .resume-label {
        width: 30%;
        color: #777;
        font-weight: 500;
    }

    .resume-value {
        color: #333;
    }

    .resume-badge {
        display: inline-block;
        background-color: #E0F2F1;
        color: #009688;
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 0.8rem;
        margin-right: 5px;
        margin-bottom: 5px;
        font-weight: bold;
    }

    .modal-footer-btn {
        display: block;
        width: 100%;
        padding: 15px;
        background-color: var(--sub-color);
        color: white;
        text-align: center;
        border-radius: 12px;
        text-decoration: none;
        font-weight: bold;
        font-size: 1.1rem;
        border: none;
        cursor: pointer;
        transition: 0.2s;
    }
    .modal-footer-btn:hover {
        background-color: #26A69A;
    }
</style>

<div class="chat-wrapper">
    <div class="card" style="border-radius: 20px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.03);">
        <div class="card-header bg-white" style="border-top-left-radius: 20px; border-top-right-radius: 20px;">
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
                        <c:when test="${msg.senderId == user.userId}">
                            <div class="message-box my-msg">
                                <c:choose>
                                    <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                                        <div class="walk-card walk-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-dog"></i></div>
                                                <div class="card-title">산책해요!</div>
                                                <p class="card-desc">산책 메이트 신청을 보냈습니다.</p>
                                            </div>
                                            <button class="btn-card-action" disabled>수락 대기중</button>
                                        </div>
                                    </c:when>
                                    <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                                        <div class="video-card video-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-video"></i></div>
                                                <div class="card-title">영상통화</div>
                                                <p class="card-desc">영상통화를 요청했습니다.</p>
                                            </div>
                                            <button class="btn-card-action" disabled>응답 대기중</button>
                                        </div>
                                    </c:when>
                                    <c:when test="${msg.content eq '[[RESUME_SEND]]'}">
                                        <div class="resume-card resume-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-id-card-alt"></i></div>
                                                <div class="card-title">이력서 전송 완료</div>
                                                    <%-- [수정] 카드 내용 변경 --%>
                                                <ul class="resume-list">
                                                    <li><strong>반려견 산책:</strong> 3회</li>
                                                    <li><strong>반려묘 미용:</strong> 1회</li>
                                                </ul>
                                            </div>
                                            <button class="btn-card-action" style="background-color: #ddd; color: #777; cursor: default;">전송됨</button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="msg-bubble">${msg.content}</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="message-box other-msg">
                                <c:choose>
                                    <c:when test="${msg.content eq '[[WALK_REQUEST]]'}">
                                        <div class="walk-card walk-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-dog"></i></div>
                                                <div class="card-title">산책해요!</div>
                                                <p class="card-desc">함께 산책하시겠습니까?</p>
                                            </div>
                                            <button class="btn-card-action" onclick="startWalk()">산책 시작하기</button>
                                        </div>
                                    </c:when>
                                    <c:when test="${msg.content eq '[[VIDEO_REQUEST]]'}">
                                        <div class="video-card video-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-video"></i></div>
                                                <div class="card-title">영상통화</div>
                                                <p class="card-desc">영상통화를 시작하시겠습니까?</p>
                                            </div>
                                            <button class="btn-card-action" onclick="startVideoCall()">영상통화 시작하기</button>
                                        </div>
                                    </c:when>
                                    <c:when test="${msg.content eq '[[RESUME_SEND]]'}">
                                        <div class="resume-card resume-theme">
                                            <div class="card-content-area">
                                                <div class="card-icon-large"><i class="fas fa-id-card-alt"></i></div>
                                                <div class="card-title">이력서가 도착했습니다</div>
                                                    <%-- [수정] 카드 내용 변경 --%>
                                                <ul class="resume-list">
                                                    <li><strong>반려견 산책:</strong> 3회</li>
                                                    <li><strong>반려묘 미용:</strong> 1회</li>
                                                </ul>
                                            </div>
                                                <%-- JSP 로딩 시점 상대방 이름 설정 --%>
                                            <c:set var="targetName" value="${room.ownerId == user.userId ? room.workerName : room.ownerName}" />
                                            <button class="btn-card-action" onclick="openResumeModal('${targetName}')">상세보기</button>
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
                    <input type="text" id="msgInput" class="form-control" placeholder="메시지 입력..."
                           onkeypress="if(event.keyCode==13) sendMessage();">
                    <div class="input-group-append">
                        <button class="btn btn-warning" onclick="sendMessage()" style="background-color: var(--point-color); border: none; color: white;">전송</button>
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

                    <c:if test="${room.ownerId != user.userId}">
                        <div class="menu-item" onclick="sendResume()">
                            <div class="menu-icon-box"><i class="fas fa-id-card"></i></div>
                            <span>이력서</span>
                        </div>
                    </c:if>

                    <c:if test="${room.ownerId == user.userId}">
                        <div class="menu-item" onclick="openReport()">
                            <div class="menu-icon-box"><i class="fas fa-clipboard-list"></i></div>
                            <span>리포트</span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="resumeModal" class="modal" onclick="closeResumeModal(event)">
    <div class="modal-content">
        <span class="close-modal" onclick="closeResumeModal(event)">&times;</span>

        <div class="resume-header">
            <div class="resume-avatar">
                <i class="fas fa-user"></i>
            </div>
            <div class="resume-name" id="modalResumeName">이름 없음</div>
            <div class="resume-meta">24세 / 서울시 강남구</div>
        </div>

        <div class="resume-section">
            <h4><i class="fas fa-history"></i> 경력사항</h4>
            <table class="resume-table">
                <tr>
                    <td class="resume-label">반려견 산책</td>
                    <td class="resume-value">3회</td>
                </tr>
                <tr>
                    <td class="resume-label">반려묘 미용</td>
                    <td class="resume-value">1회</td>
                </tr>
            </table>
        </div>

        <div class="resume-section">
            <h4><i class="fas fa-certificate"></i> 자격증</h4>
            <div>
                <span class="resume-badge">반려동물관리사 2급</span>
                <span class="resume-badge">반려견스타일리스트 3급</span>
            </div>
        </div>

        <div class="resume-section">
            <h4><i class="fas fa-comment-dots"></i> 한마디</h4>
            <p style="color: #555; font-size: 0.95rem; line-height: 1.5;">
                강아지를 너무 좋아해서 시작하게 되었습니다.<br>
                내 가족처럼 책임감 있게, 사랑으로 돌봐드리겠습니다!
                믿고 맡겨주세요 :)
            </p>
        </div>

        <button class="modal-footer-btn" onclick="closeResumeModal(event)">닫기</button>
    </div>
</div>

<script>
    var ws;
    var roomId = "${room.roomId}";
    var myId = "${user.userId}";

    // JS 오류 방지: 문자열로 비교
    var ownerId = "${room.ownerId}";
    var currentUserId = "${user.userId}";
    var amIOwner = (ownerId === currentUserId);

    var myName = amIOwner ? "${room.ownerName}" : "${room.workerName}";
    var partnerName = amIOwner ? "${room.workerName}" : "${room.ownerName}";

    var chatContainer = document.getElementById("chatContainer");

    if(chatContainer) {
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }

    window.onload = function () {
        connect();
    };

    function connect() {
        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var wsUrl = protocol + location.host + "/ws/chat";

        console.log("Connecting to: " + wsUrl);

        ws = new WebSocket(wsUrl);
        ws.onopen = function () {
            console.log("Connected!");
            var msg = {
                roomId: roomId,
                senderId: myId,
                content: "ENTER"
            };
            ws.send(JSON.stringify(msg));
        };

        ws.onmessage = function (event) {
            var data = JSON.parse(event.data);
            if (data.type === "NOTIFICATION" || data.content === "ENTER") return;

            var msgDiv = document.createElement("div");
            var isMine = (data.senderId == myId);

            var senderName = isMine ? myName : partnerName;

            if (data.content === "[[WALK_REQUEST]]") {
                var btnAttr = isMine ? 'disabled' : 'onclick="startWalk()"';
                var btnText = isMine ? '수락 대기중' : '산책 시작하기';
                var descText = isMine ? '산책 메이트 신청을 보냈습니다.' : '산책 요청이 도착했습니다.';

                msgDiv.innerHTML =
                    '<div class="walk-card walk-theme">' +
                    '<div class="card-content-area">' +
                    '<div class="card-icon-large"><i class="fas fa-dog"></i></div>' +
                    '<div class="card-title">산책해요!</div>' +
                    '<p class="card-desc">' + descText + '</p>' +
                    '</div>' +
                    '<button class="btn-card-action" ' + btnAttr + '>' + btnText + '</button>' +
                    '</div>';

            } else if (data.content === "[[VIDEO_REQUEST]]") {
                var btnAttr = isMine ? 'disabled' : 'onclick="startVideoCall()"';
                var btnText = isMine ? '응답 대기중' : '영상통화 시작하기';
                var descText = isMine ? '영상통화를 요청했습니다.' : '영상통화를 시작하시겠습니까?';

                msgDiv.innerHTML =
                    '<div class="video-card video-theme">' +
                    '<div class="card-content-area">' +
                    '<div class="card-icon-large"><i class="fas fa-video"></i></div>' +
                    '<div class="card-title">영상통화</div>' +
                    '<p class="card-desc">' + descText + '</p>' +
                    '</div>' +
                    '<button class="btn-card-action" ' + btnAttr + '>' + btnText + '</button>' +
                    '</div>';

            } else if (data.content === "[[RESUME_SEND]]") {
                var titleText = isMine ? '이력서 전송 완료' : '이력서가 도착했습니다';
                var btnStyle = isMine ? 'style="background-color: #ddd; color: #777; cursor: default;"' : '';
                var btnText = isMine ? '전송됨' : '상세보기';
                var btnAttr = isMine ? 'disabled' : 'onclick="openResumeModal(\'' + senderName + '\')"';

                msgDiv.innerHTML =
                    '<div class="resume-card resume-theme">' +
                    '<div class="card-content-area">' +
                    '<div class="card-icon-large"><i class="fas fa-id-card-alt"></i></div>' +
                    '<div class="card-title">' + titleText + '</div>' +
                    // [수정] JS 렌더링 카드 내용 변경
                    '<ul class="resume-list">' +
                    '<li><strong>반려견 산책:</strong> 3회</li>' +
                    '<li><strong>반려묘 미용:</strong> 1회</li>' +
                    '</ul>' +
                    '</div>' +
                    '<button class="btn-card-action" ' + btnStyle + ' ' + btnAttr + '>' + btnText + '</button>' +
                    '</div>';

            } else {
                msgDiv.innerHTML = '<div class="msg-bubble">' + data.content + '</div>';
            }

            if (isMine) {
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
        if (!text.trim()) return;
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

    function sendResume() {
        console.log("Sending Resume...");
        togglePlusMenu();
        var msg = {
            roomId: roomId,
            senderId: myId,
            content: "[[RESUME_SEND]]"
        };
        ws.send(JSON.stringify(msg));
    }

    function startWalk() {
        alert("산책 모드를 시작합니다!");
    }

    function startVideoCall() {
        if (confirm("영상통화를 연결하시겠습니까?")) {
            alert("영상통화 연결 중...");
        }
    }

    function openReport() {
        alert("산책 리포트 확인 기능 (구현 예정)");
    }

    function openResumeModal(name) {
        var nameField = document.getElementById("modalResumeName");
        if(name) {
            nameField.innerText = name;
        } else {
            nameField.innerText = "이름 없음";
        }
        document.getElementById("resumeModal").style.display = "block";
    }

    function closeResumeModal(event) {
        if (event.target.id === "resumeModal" || event.target.className === "close-modal" || event.target.className === "modal-footer-btn") {
            document.getElementById("resumeModal").style.display = "none";
        }
    }
</script>