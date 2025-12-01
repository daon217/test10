<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>PetCare AI - 스마트한 반려동물 케어</title>

    <meta name="description" content="AI 기술로 더 안전하고 건강한 반려동물 케어 서비스">
    <meta name="keywords" content="반려동물, AI 산책, 펫케어, 홈캠, 건강진단, 산책알바, 펫다이어리">

    <link rel="icon" type="image/x-icon" href="<c:url value='/images/favicon.ico'/>">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Quicksand:wght@400;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="<c:url value='/css/variables.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">

    <c:if test="${center == null || center == 'center'}">
        <link rel="stylesheet" href="<c:url value='/css/center.css'/>">
    </c:if>
    <c:if test="${center == 'login' || center == 'register'}">
        <link rel="stylesheet" href="<c:url value='/css/auth.css'/>">
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
</head>
<body>

<c:if test="${center == null || center == 'center'}">
    <div id="sequence-container"></div>
</c:if>

<header class="pet-header">
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="pet-logo" href="<c:url value='/'/>">
                <div class="pet-logo-icon">
                    <i class="fas fa-paw"></i>
                </div>
                <div class="pet-logo-text">
                    <span class="pet-logo-title">PetCare AI</span>
                    <span class="pet-logo-subtitle">스마트 반려 케어</span>
                </div>
            </a>

            <button class="navbar-toggler" type="button" data-toggle="collapse"
                    data-target="#petNavbar" aria-controls="petNavbar"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse pet-nav" id="petNavbar">
                <ul class="navbar-nav ml-auto">
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
                                <i class="fas fa-route"></i> AI 산책 추천
                            </a>
                            <a class="dropdown-item" href="<c:url value='/walk-matching'/>">
                                <i class="fas fa-handshake"></i> 산책 매칭
                            </a>
                            <a class="dropdown-item" href="<c:url value='/walkpt'/>">
                                <i class="fas fa-handshake"></i> 산책 알바
                            </a>
                        </div>
                    </li>

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

                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/diary'/>">
                            <i class="fas fa-book"></i> 펫 다이어리
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/notice'/>">
                            <i class="fas fa-bell"></i> 공지사항
                        </a>
                    </li>
                </ul>

                <div class="header-actions ml-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="<c:url value='/customer-service'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-headset"></i> 고객센터
                            </a>

                            <button type="button" class="btn btn-pet-outline btn-sm mr-2" data-toggle="modal" data-target="#chatModal">
                                <i class="fas fa-comments"></i> 채팅
                                <span class="badge badge-danger badge-pill ml-1" style="font-size: 0.6rem;">N</span>
                            </button>

                            <a href="<c:url value='/mypage'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-user-circle"></i> 마이페이지
                            </a>
                            <a href="<c:url value='/logout'/>" class="btn btn-pet-primary btn-sm">
                                <i class="fas fa-sign-out-alt"></i> 로그아웃
                            </a>
                        </c:when>
                        <c:otherwise>
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

<footer class="pet-footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="footer-logo-section">
                    <div class="pet-logo-icon mb-3">
                        <i class="fas fa-paw"></i>
                    </div>
                    <h5 class="pet-logo-title">PetCare AI</h5>
                    <p class="footer-desc">
                        AI 기술로 더 안전하고 건강한<br>
                        반려동물 케어 서비스
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
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="footer-title">정보</h6>
                <ul class="footer-links">
                    <li><a href="<c:url value='/about'/>">회사소개</a></li>
                    <li><a href="<c:url value='/notice'/>">공지사항</a></li>
                    <li><a href="<c:url value='/customer-service'/>">고객센터</a></li>
                    <li><a href="<c:url value='/faq'/>">FAQ</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="footer-title">약관</h6>
                <ul class="footer-links">
                    <li><a href="<c:url value='/terms'/>">이용약관</a></li>
                    <li><a href="<c:url value='/privacy'/>">개인정보처리방침</a></li>
                    <li><a href="<c:url value='/location'/>">위치기반서비스</a></li>
                </ul>
            </div>
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
                &copy; 2024 PetCare AI. All rights reserved.
            </p>
            <p class="company-info">
                사업자등록번호: 123-45-67890 | 대표: 홍길동<br>
                주소: 서울특별시 강남구 테헤란로 123, 4층 | 문의: 1588-1234
            </p>
        </div>
    </div>
</footer>

<div class="modal fade" id="chatModal" tabindex="-1" role="dialog" aria-labelledby="chatModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" style="border-radius: 20px; border: none; overflow: hidden; height: 650px; background-color: #fff;">

            <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                    style="position: absolute; right: 20px; top: 15px; z-index: 100; opacity: 0.6;">
                <span aria-hidden="true">&times;</span>
            </button>

            <div id="chat-list-view" style="height: 100%; display: flex; flex-direction: column;">

                <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title font-weight-bold" style="font-size: 1.4rem;">채팅</h5>
                </div>

                <div class="px-4 py-3">
                    <div style="background-color: #f1f3f5; border-radius: 12px; padding: 10px 15px; display: flex; align-items: center;">
                        <i class="fas fa-search text-muted mr-2"></i>
                        <input type="text" placeholder="대화 상대나 메시지 검색" style="border: none; background: transparent; width: 100%; outline: none; font-size: 0.9rem;">
                    </div>
                </div>

                <div class="modal-body p-0" style="overflow-y: auto;">
                    <div class="list-group list-group-flush">

                        <a href="#" class="list-group-item list-group-item-action border-0 py-3 px-4 chat-room-link" onclick="openChatRoom('강아지산책러', 'dog1.jpg')">
                            <div class="media align-items-center">
                                <img src="<c:url value='/images/dog1.jpg'/>" class="rounded-circle mr-3" style="width: 50px; height: 50px; object-fit: cover; border: 1px solid #eee;">
                                <div class="media-body overflow-hidden">
                                    <div class="d-flex justify-content-between mb-1">
                                        <strong class="text-dark">강아지산책러</strong>
                                        <small class="text-muted">방금 전</small>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <p class="text-muted text-truncate mb-0" style="max-width: 180px; font-size: 0.9rem;">내일 산책 가능하신가요?</p>
                                        <span class="badge badge-pill text-white" style="background-color: #ff6f0f;">1</span>
                                    </div>
                                </div>
                            </div>
                        </a>

                        <a href="#" class="list-group-item list-group-item-action border-0 py-3 px-4 chat-room-link" onclick="openChatRoom('펫시터 구해요', 'pet.png')">
                            <div class="media align-items-center">
                                <img src="<c:url value='/images/pet.png'/>" class="rounded-circle mr-3" style="width: 50px; height: 50px; object-fit: cover; border: 1px solid #eee;">
                                <div class="media-body overflow-hidden">
                                    <div class="d-flex justify-content-between mb-1">
                                        <strong class="text-dark">펫시터 구해요</strong>
                                        <small class="text-muted">2시간 전</small>
                                    </div>
                                    <p class="text-muted text-truncate mb-0" style="font-size: 0.9rem;">네, 알겠습니다. 그때 뵙겠습니다!</p>
                                </div>
                            </div>
                        </a>

                    </div>
                </div>
            </div>

            <div id="chat-room-view" style="height: 100%; display: none; flex-direction: column;">

                <div class="d-flex align-items-center px-3 py-3 border-bottom" style="height: 60px;">
                    <button class="btn btn-link text-dark p-0 mr-3" onclick="closeChatRoom()">
                        <i class="fas fa-arrow-left fa-lg"></i>
                    </button>
                    <img id="current-chat-img" src="" class="rounded-circle mr-2" style="width: 35px; height: 35px; object-fit: cover; border: 1px solid #eee;">
                    <div>
                        <h6 class="m-0 font-weight-bold" id="current-chat-name">상대방</h6>
                        <span class="text-muted" style="font-size: 0.75rem;">온라인</span>
                    </div>
                    <div class="ml-auto">
                        <button class="btn btn-link text-muted"><i class="fas fa-ellipsis-v"></i></button>
                    </div>
                </div>

                <div class="flex-grow-1 p-3" id="chat-messages" style="overflow-y: auto; background-color: #fff;">
                    <div class="text-center my-3">
                        <span class="px-3 py-1 rounded-pill bg-light text-muted small">2024년 11월 28일</span>
                    </div>

                    <div class="d-flex mb-3">
                        <img src="<c:url value='/images/dog1.jpg'/>" class="rounded-circle mr-2 align-self-start" style="width: 35px; height: 35px; border: 1px solid #eee;">
                        <div>
                            <div class="bg-light p-2 px-3 rounded" style="border-radius: 4px 18px 18px 18px !important; display: inline-block;">
                                안녕하세요! 산책 알바 구하시나요?
                            </div>
                            <span class="text-muted small ml-1">오후 2:15</span>
                        </div>
                    </div>

                    <div class="d-flex mb-3 justify-content-end">
                        <div class="text-right">
                            <div class="text-white p-2 px-3 rounded" style="background-color: #ff6f0f; border-radius: 18px 4px 18px 18px !important; display: inline-block; text-align: left;">
                                네 안녕하세요! 혹시 내일 가능하신가요?
                            </div>
                            <span class="text-muted small mr-1 d-block">오후 2:16</span>
                        </div>
                    </div>
                </div>

                <div class="p-3 border-top bg-white">
                    <div class="d-flex align-items-center bg-light rounded-pill px-3 py-2">
                        <input type="text" class="form-control border-0 bg-transparent shadow-none" placeholder="메시지 보내기..." style="font-size: 0.95rem;">
                        <button class="btn btn-link text-muted p-0 ml-2"><i class="far fa-smile fa-lg"></i></button>
                        <button class="btn btn-link p-0 ml-2" style="color: #ff6f0f;"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script src="<c:url value='/js/main.js'/>"></script>

<script>
    // 채팅방 열기
    function openChatRoom(name, imgName) {
        // 목록 숨기고 상세 보여주기
        $('#chat-list-view').hide();
        $('#chat-room-view').css('display', 'flex');

        // 상대방 정보 세팅
        $('#current-chat-name').text(name);
        $('#current-chat-img').attr('src', '/images/' + imgName);

        // 스크롤 맨 아래로
        var msgArea = document.getElementById('chat-messages');
        msgArea.scrollTop = msgArea.scrollHeight;
    }

    // 채팅방 닫기 (목록으로 돌아가기)
    function closeChatRoom() {
        $('#chat-room-view').hide();
        $('#chat-list-view').css('display', 'flex');
    }
</script>

<c:if test="${center == null || center == 'center'}">
    <script src="<c:url value='/js/scroll-video.js'/>"></script>
</c:if>
<c:if test="${center == 'mypage'}">
    <script src="<c:url value='/js/mypage.js'/>"></script>
</c:if>

</body>
</html>