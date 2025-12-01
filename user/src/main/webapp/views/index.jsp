<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>PetTopia AI - 스마트한 반려동물 생활</title>

    <!-- SEO Meta Tags -->
    <meta name="description" content="더 편리한 반려동물과의 생활">
    <meta name="keywords" content="반려동물, AI 산책, 가상진단, 홈캠, 건강진단, 산책알바, 펫다이어리">

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="<c:url value='/images/favicon.ico'/>">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Quicksand:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/variables.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">

    <!-- ✅ 채팅 필수: SockJS & StompJS -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <!-- 페이지별 CSS -->
    <c:if test="${center == null || center == 'center'}">
        <link rel="stylesheet" href="<c:url value='/css/center.css'/>">
    </c:if>
    <c:if test="${center == 'login'}">
        <link rel="stylesheet" href="<c:url value='/css/auth.css'/>">
    </c:if>
    <!-- ✅ 회원가입 CSS (누락 방지) -->
    <c:if test="${center == 'register'}">
        <link rel="stylesheet" href="<c:url value='/css/auth.css'/>">
        <link rel="stylesheet" href="<c:url value='/css/register.css'/>">
    </c:if>
    <c:if test="${center == 'mypage'}">
        <link rel="stylesheet" href="<c:url value='/css/mypage.css'/>">
    </c:if>
    <c:if test="${center == 'walktogether/petWalkBoardList'}">
        <link rel="stylesheet" href="<c:url value='/css/petWalkBoardList.css'/>">
    </c:if>
    <c:if test="${center == 'walktogether/petWalkBoardDetail'}">
        <link rel="stylesheet" href="<c:url value='/css/petWalkBoardDetail.css'/>">
    </c:if>
    <c:if test="${center == 'walktogether/petWalkBoardWrite'}">
        <link rel="stylesheet" href="<c:url value='/css/petWalkBoardWrite.css'/>">
    </c:if>

    <!-- ✅ 채팅방 전용 스타일 (모달 & 리스트) -->
    <style>
        /* 채팅 모달 컨테이너 */
        .chat-modal-content {
            border-radius: 20px;
            height: 700px;
            background-color: #fff;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border: none;
        }

        /* 검색창 스타일 */
        .chat-search-box {
            background-color: #f1f3f5;
            border-radius: 12px;
            padding: 12px 15px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            color: #868e96;
            transition: all 0.2s;
        }
        .chat-search-box:focus-within {
            background-color: #fff;
            box-shadow: 0 0 0 2px #212529;
            color: #212529;
        }
        .chat-search-box i { margin-right: 10px; }
        .chat-search-box input {
            border: none;
            background: transparent;
            width: 100%;
            outline: none;
            font-size: 0.95rem;
        }

        /* 필터 태그 스타일 */
        .chat-filter-tags { display: flex; gap: 8px; margin-bottom: 5px; }
        .chat-filter-tag {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid #e9ecef;
            background-color: #fff;
            color: #495057;
            transition: all 0.2s;
        }
        .chat-filter-tag:hover { background-color: #f8f9fa; }
        .chat-filter-tag.active {
            background-color: #212529;
            color: #fff;
            border-color: #212529;
        }

        /* 채팅 리스트 아이템 */
        .chat-item-link {
            text-decoration: none !important;
            color: inherit !important;
            display: block;
            padding: 16px 20px;
            border-bottom: 1px solid #f8f9fa;
            transition: background-color 0.2s;
            cursor: pointer;
        }
        .chat-item-link:hover { background-color: #f8f9fa; }

        .chat-profile-img {
            width: 54px;
            height: 54px;
            border-radius: 18px;
            object-fit: cover;
            border: 1px solid #eee;
        }

        .chat-text-ellipsis {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 0.95rem;
            color: #868e96;
        }

        .chat-time {
            font-size: 0.75rem;
            color: #adb5bd;
        }

        /* 뱃지 */
        .chat-badge {
            background-color: #ff6f0f;
            color: white;
            font-size: 10px;
            padding: 3px 6px;
            border-radius: 10px;
            margin-left: 5px;
            min-width: 18px;
            text-align: center;
            display: inline-block;
        }

        /* 커스텀 스크롤바 */
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-track { background: transparent; }
        .custom-scroll::-webkit-scrollbar-thumb { background: #dee2e6; border-radius: 3px; }
        .custom-scroll::-webkit-scrollbar-thumb:hover { background: #adb5bd; }
    </style>

    <!-- Context Path 저장 (JS에서 사용) -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>

<!-- ✅ 이미지 시퀀스 백그라운드 (center 페이지에만) -->
<c:if test="${center == null || center == 'center'}">
    <div id="sequence-container"></div>
</c:if>

<!-- 헤더 -->
<header class="pet-header">
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <!-- 로고 -->
            <a class="pet-logo" href="<c:url value='/'/>">
                <div class="pet-logo-icon">
                    <i class="fas fa-paw"></i>
                </div>
                <div class="pet-logo-text">
                    <span class="pet-logo-title">Pettopia</span>
                    <span class="pet-logo-subtitle">스마트 반려 생활</span>
                </div>
            </a>

            <!-- 모바일 토글 -->
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                    data-target="#petNavbar" aria-controls="petNavbar"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- 네비게이션 메뉴 -->
            <div class="collapse navbar-collapse pet-nav" id="petNavbar">
                <ul class="navbar-nav ml-auto">
                    <!-- 산책 드롭다운 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="walkMenu" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-walking"></i> 산책
                        </a>
                        <div class="dropdown-menu" aria-labelledby="walkMenu">
                            <a class="dropdown-item" href="<c:url value='/map'/>">
                                <i class="fas fa-map-marked-alt"></i> 지도 기반 산책
                            </a>
                            <a class="dropdown-item" href="<c:url value='/ai-walk'/>">
                                <i class="fas fa-route"></i> AI 산책 제시
                            </a>
                            <a class="dropdown-item" href="<c:url value='/walk-matching'/>">
                                <i class="fas fa-handshake"></i> 산책 매칭
                            </a>
                            <a class="dropdown-item" href="<c:url value='/walkpt'/>">
                                <i class="fas fa-handshake"></i> 산책 알바
                            </a>
                        </div>
                    </li>

                    <!-- AI 서비스 드롭다운 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="aiMenu" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-brain"></i> AI 서비스
                        </a>
                        <div class="dropdown-menu" aria-labelledby="aiMenu">
                            <a class="dropdown-item" href="<c:url value='/homecam'/>">
                                <i class="fas fa-video"></i> AI 홈캠 분석
                            </a>
                            <a class="dropdown-item" href="<c:url value='/health-check'/>">
                                <i class="fas fa-heartbeat"></i> AI 가상 진단
                            </a>
                            <a class="dropdown-item" href="<c:url value='/behavior-report'/>">
                                <i class="fas fa-chart-line"></i> 행동 리포트
                            </a>
                            <a class="dropdown-item" href="<c:url value='/clothes-recommend'/>">
                                <i class="fas fa-tshirt"></i> 옷 사이즈 추천
                            </a>
                            <a class="dropdown-item" href="<c:url value='/pet-figurine'/>">
                                <i class="fas fa-palette"></i> 피규어 만들기
                            </a>
                        </div>
                    </li>

                    <!-- 다이어리 -->
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/diary'/>">
                            <i class="fas fa-book"></i> 펫 다이어리
                        </a>
                    </li>

                    <!-- 공지사항 -->
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/notice'/>">
                            <i class="fas fa-bell"></i> 공지사항
                        </a>
                    </li>
                </ul>

                <!-- ✅ 헤더 액션 버튼 (채팅 버튼 추가됨) -->
                <div class="header-actions ml-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <!-- 로그인 ID (username) 저장 -->
                            <input type="hidden" id="loginUserId" value="${sessionScope.user.username}">

                            <a href="<c:url value='/customer-service'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-headset"></i> 고객센터
                            </a>

                            <!-- 🗨️ 채팅 버튼 (모달 오픈) -->
                            <button type="button" class="btn btn-pet-outline btn-sm mr-2" data-toggle="modal" data-target="#chatModal" onclick="initChat()">
                                <i class="fas fa-comments"></i> 채팅
                            </button>

                            <a href="<c:url value='/mypage'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-user-circle"></i> 마이페이지
                            </a>
                            <a href="<c:url value='/logout'/>" class="btn btn-pet-primary btn-sm">
                                <i class="fas fa-sign-out-alt"></i> 로그아웃
                            </a>
                        </c:when>
                        <c:otherwise>
                            <!-- 미로그인 상태 -->
                            <a href="<c:url value='/login'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-sign-in-alt"></i> 로그인
                            </a>
                            <a href="<c:url value='/register'/>" class="btn btn-pet-primary btn-sm">
                                <i class="fas fa-user-plus"></i> 회원가입
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>

<!-- 메인 컨텐츠 -->
<main class="pet-main-content">
    <c:choose>
        <c:when test="${center == null}">
            <jsp:include page="center.jsp"/>
        </c:when>
        <c:otherwise>
            <jsp:include page="${center}.jsp"/>
        </c:otherwise>
    </c:choose>
</main>

<!-- 푸터 -->
<footer class="pet-footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="footer-logo-section">
                    <div class="pet-logo-icon mb-3">
                        <i class="fas fa-paw"></i>
                    </div>
                    <h5 class="pet-logo-title">Pettopia</h5>
                    <p class="footer-desc">
                        반려동물과 스마트한 일상<br>
                    </p>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="footer-title">서비스</h6>
                <ul class="footer-links">
                    <li><a href="<c:url value='/map'/>">지도 기반 산책</a></li>
                    <li><a href="<c:url value='/ai-walk'/>">AI 산책 추천</a></li>
                    <li><a href="<c:url value='/walk-matching'/>">산책 매칭</a></li>
                    <li><a href="<c:url value='/homecam'/>">AI 홈캠</a></li>
                </ul>
            </div>
            <!-- ... 중략 ... -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="footer-title">소셜</h6>
                <div class="social-links">
                    <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
        <hr class="footer-divider">
        <div class="footer-bottom">
            <p class="copyright">
                &copy; 2024 Pettopia. All rights reserved.
            </p>
            <p class="company-info">
                사업자등록번호: 123-45-67890 | 대표: 홍길동<br>
                주소: 서울특별시 강남구 테헤란로 123, 4층 | 문의: 1588-1234
            </p>
        </div>
    </div>
</footer>

<!-- ========================================== -->
<!-- 🗨️ 채팅 모달 (Chat Modal) -->
<!-- ========================================== -->
<div class="modal fade" id="chatModal" tabindex="-1" role="dialog" aria-hidden="true" style="z-index: 1050;">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content chat-modal-content">

            <button type="button" class="close" data-dismiss="modal" style="position: absolute; right: 20px; top: 20px; z-index: 100; font-size: 1.8rem; opacity: 0.5;">&times;</button>

            <!-- 1. 채팅 목록 -->
            <div id="chat-list-view" style="height: 100%; display: flex; flex-direction: column;">
                <div class="px-4 pt-4 pb-2">
                    <h4 class="font-weight-bold mb-3" style="color: #212529;">채팅</h4>
                    <div class="chat-search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="chatSearchInput" placeholder="닉네임 또는 대화 내용을 검색해보세요">
                    </div>
                    <!-- 필터 태그 -->
                    <div class="chat-filter-tags">
                        <div class="chat-filter-tag active" onclick="filterChatList('all', this)">전체</div>
                        <div class="chat-filter-tag" onclick="filterChatList('unread', this)">안 읽음</div>
                        <div class="chat-filter-tag" onclick="filterChatList('job', this)">알바 문의</div>
                    </div>
                </div>

                <!-- 테스트용 대화 버튼 -->
                <div class="px-4 pb-2 text-right">
                    <small class="text-muted mr-1">테스트:</small>
                    <button class="btn btn-sm btn-light border py-0" onclick="openChatWithUser('test2')">+ test2</button>
                    <button class="btn btn-sm btn-light border py-0" onclick="openChatWithUser('admin')">+ admin</button>
                </div>

                <!-- 목록 리스트 -->
                <div class="modal-body p-0 custom-scroll" style="overflow-y: auto; flex: 1;">
                    <div id="chatRoomListArea">
                        <!-- JS로 리스트가 여기에 들어감 -->
                    </div>
                </div>
            </div>

            <!-- 2. 채팅 상세 -->
            <div id="chat-room-view" style="height: 100%; display: none; flex-direction: column;">
                <div class="d-flex align-items-center px-3 py-3 border-bottom bg-white" style="height: 65px; z-index: 10;">
                    <button class="btn btn-link text-dark p-0 mr-3" onclick="closeChatRoom()"><i class="fas fa-arrow-left fa-lg"></i></button>
                    <div><h6 class="m-0 font-weight-bold" id="current-chat-name" style="font-size: 1.1rem;">상대방</h6></div>
                    <div class="ml-auto"><button class="btn btn-link text-secondary"><i class="fas fa-ellipsis-v"></i></button></div>
                </div>

                <div class="flex-grow-1 p-3 custom-scroll" id="chat-messages" style="overflow-y: auto; background-color: #fcfcfc;">
                    <!-- 메시지 로드 -->
                </div>

                <div class="p-3 border-top bg-white">
                    <div class="d-flex align-items-center bg-light rounded-pill px-2 py-1" style="border: 1px solid #eee;">
                        <input type="text" id="msgInput" class="form-control border-0 bg-transparent shadow-none"
                               placeholder="메시지를 입력하세요." onkeypress="if(event.keyCode==13) sendMsg()">
                        <button class="btn btn-link ml-1" style="color: #ff6f0f;" onclick="sendMsg()"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/js/main.js'/>"></script>

<!-- 채팅 로직 -->
<script>
    var stompClient = null;
    var currentRoomId = null;
    var myId = $('#loginUserId').val(); // 없으면 undefined
    var allChatRooms = [];

    function initChat() {
        if(!myId) {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/login';
            return;
        }
        loadRoomList();
        if (stompClient !== null && stompClient.connected) return;

        var socket = new SockJS(contextPath + '/ws-stomp');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function () { console.log('소켓 연결 성공'); });
    }

    function loadRoomList() {
        $.get(contextPath + '/api/chat/rooms', function(rooms) {
            if(!rooms) rooms = [];
            // 임시 데이터 (기능 확인용)
            rooms.forEach(function(r) {
                r.unreadCount = r.unreadCount !== undefined ? r.unreadCount : 0;
                r.isJob = (r.lastMsg && (r.lastMsg.includes('알바') || r.lastMsg.includes('산책')));
            });
            allChatRooms = rooms;
            renderChatList(allChatRooms);
        });
    }

    function filterChatList(type, element) {
        $('.chat-filter-tag').removeClass('active');
        $(element).addClass('active');
        var filtered = [];
        if (type === 'all') filtered = allChatRooms;
        else if (type === 'unread') filtered = allChatRooms.filter(r => r.unreadCount > 0);
        else if (type === 'job') filtered = allChatRooms.filter(r => r.isJob);
        renderChatList(filtered);
    }

    $('#chatSearchInput').on('input', function() {
        var keyword = $(this).val().toLowerCase();
        var filtered = allChatRooms.filter(r =>
            (r.targetName && r.targetName.toLowerCase().includes(keyword)) ||
            (r.lastMsg && r.lastMsg.toLowerCase().includes(keyword))
        );
        renderChatList(filtered);
    });

    function renderChatList(rooms) {
        var html = '';
        if(!rooms || rooms.length === 0) {
            html = '<div class="text-center mt-5 text-muted"><p>해당하는 대화가 없습니다.</p></div>';
        } else {
            rooms.forEach(function(r) {
                var img = r.targetImg ? r.targetImg : (r.roomId % 2 == 0 ? 'dog1.jpg' : 'pet.png');
                html += '<div class="chat-item-link" onclick="openChatRoom(' + r.roomId + ', \'' + r.targetName + '\')">';
                html += '  <div class="d-flex align-items-center">';
                html += '    <div class="mr-3 position-relative"><img src="' + contextPath + '/images/' + img + '" class="chat-profile-img"></div>';
                html += '    <div class="flex-grow-1" style="min-width: 0;">';
                html += '      <div class="d-flex justify-content-between mb-1"><span class="font-weight-bold text-dark">' + r.targetName + '</span><span class="chat-time">' + (r.lastDate ? r.lastDate.substring(5,10) : '') + '</span></div>';
                html += '      <div class="d-flex justify-content-between align-items-center"><div class="chat-text-ellipsis">' + (r.lastMsg || '대화 시작') + '</div>';
                if (r.unreadCount > 0) html += '<span class="chat-badge">' + r.unreadCount + '</span>';
                html += '      </div></div></div></div>';
            });
        }
        $('#chatRoomListArea').html(html);
    }

    // 테스트용
    window.openChatWithUser = function(targetId, targetName) {
        if(targetId === myId) { alert('본인과는 대화 불가'); return; }
        $.post(contextPath + '/api/chat/room', { targetId: targetId }, function(roomId) {
            if(roomId > 0) openChatRoom(roomId, targetName || targetId);
        });
    }

    function openChatRoom(roomId, targetName) {
        currentRoomId = roomId;
        $('#chat-list-view').hide();
        $('#chat-room-view').css('display', 'flex');
        $('#current-chat-name').text(targetName || '상대방');
        $('#chat-messages').empty();

        $.get(contextPath + '/api/chat/messages?roomId=' + roomId, function(msgs) {
            msgs.forEach(appendMessage);
            scrollToBottom();
        });

        if (stompClient && stompClient.connected) {
            stompClient.subscribe('/sub/chat/room/' + roomId, function (msg) {
                appendMessage(JSON.parse(msg.body));
                scrollToBottom();
            });
        }
    }

    function sendMsg() {
        var content = $('#msgInput').val();
        if(!content.trim()) return;
        stompClient.send("/pub/chat/message", {}, JSON.stringify({ roomId: currentRoomId, senderId: myId, content: content }));
        $('#msgInput').val('');
    }

    function appendMessage(msg) {
        var isMe = (msg.senderId === myId);
        var align = isMe ? 'justify-content-end' : 'justify-content-start';
        var bg = isMe ? 'background-color: #ff6f0f; color: white;' : 'background-color: white; border: 1px solid #eee;';

        var html = '<div class="d-flex mb-3 ' + align + '">';
        if(!isMe) html += '<img src="' + contextPath + '/images/pet.png" class="rounded-circle mr-2" style="width: 30px; height: 30px;">';
        html += '<div class="px-3 py-2 shadow-sm rounded" style="' + bg + ' max-width: 250px;">' + msg.content + '</div></div>';
        $('#chat-messages').append(html);
    }

    function scrollToBottom() { var area = document.getElementById('chat-messages'); area.scrollTop = area.scrollHeight; }
    function closeChatRoom() { currentRoomId = null; $('#chat-room-view').hide(); $('#chat-list-view').css('display', 'flex'); loadRoomList(); }
</script>

<!-- 페이지별 JS (회원가입 기능 포함) -->
<c:if test="${center == null || center == 'center'}">
    <script src="<c:url value='/js/scroll-video.js'/>"></script>
</c:if>
<c:if test="${center == 'mypage'}">
    <script src="<c:url value='/js/mypage.js'/>"></script>
</c:if>
<!-- ✅ register.js 필수 추가 -->
<c:if test="${center == 'register'}">
    <script src="<c:url value='/js/register.js'/>"></script>
</c:if>

</body>
</html>