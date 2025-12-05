<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>PetTopia AI - 스마트한 반려동물 생활</title>

            <meta name="description" content="더 편리한 반려동물과의 생활">
            <meta name="keywords" content="반려동물, AI 산책, 가상진단, 홈캠, 건강진단, 산책알바, 펫다이어리">

            <link rel="icon" type="image/x-icon" href="<c:url value='/images/favicon.ico'/>">

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Quicksand:wght@400;600;700&display=swap"
                rel="stylesheet">

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
            <c:if test="${center == 'diary'}">
                <link rel="stylesheet" href="<c:url value='/css/diary.css'/>">
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
                                <span class="pet-logo-title">Pettopia</span>
                                <span class="pet-logo-subtitle">스마트 반려 생활</span>
                            </div>
                        </a>

                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#petNavbar"
                            aria-controls="petNavbar" aria-expanded="false" aria-label="Toggle navigation">
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
                                        <a class="dropdown-item" href="<c:url value='/clothes-recommend'/>">
                                            <i class="fas fa-tshirt"></i> 옷 사이즈 추천
                                        </a>
                                        <a class="dropdown-item" href="<c:url value='/diary'/>">
                                            <i class="fas fa-book-open"></i> 펫 다이어리
                                        </a>
                                    </div>
                                </li>

                                <c:if test="${sessionScope.user != null}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="<c:url value='/chat/list'/>">
                                            <i class="fas fa-comments"></i>
                                            <span>채팅 목록</span>
                                        </a>
                                    </li>
                                </c:if>

                                <%-- <li class="nav-item">--%>
                                    <%-- <a class="nav-link" href="<c:url value='/notice'/>">--%>
                                        <%-- <i class="fas fa-bell"></i> 공지사항--%>
                                            <%-- </a>--%>
                                                <%-- </li>--%>
                            </ul>

                            <div class="header-actions ml-3">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <%-- <a href="<c:url value='/customer-service'/>"
                                            class="btn btn-pet-outline btn-sm mr-2">--%>
                                            <%-- <i class="fas fa-headset"></i> 고객센터--%>
                                                <%-- </a>--%>
                                                    <a href="<c:url value='/mypage'/>"
                                                        class="btn btn-pet-outline btn-sm mr-2">
                                                        <i class="fas fa-user-circle"></i> 마이페이지
                                                    </a>
                                                    <a href="<c:url value='/logout'/>"
                                                        class="btn btn-pet-primary btn-sm">
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
                        <jsp:include page="center.jsp" />
                    </c:when>
                    <c:otherwise>
                        <jsp:include page="${center}.jsp" />
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
                            &copy; 2024 Pettopia. All rights reserved.
                        </p>
                        <p class="company-info">
                            사업자등록번호: 123-45-67890 | 대표: 홍길동<br>
                            주소: 서울특별시 강남구 테헤란로 123, 4층 | 문의: 1588-1234
                        </p>
                    </div>
                </div>
                <!-- 전역 산책 종료 요청 배너 -->
                <div id="walkjobAlertBanner" style="display:none; position:fixed; top:16px; left:50%; transform:translateX(-50%);
            background:#fee2e2; color:#b91c1c; padding:10px 18px; border-radius:999px;
            box-shadow:0 4px 12px rgba(0,0,0,0.12); z-index:9999; cursor:pointer;">
                    산책을 종료하시겠습니까? 클릭하여 확인하세요.
                </div>

                <!-- 산책 종료 확인 모달 (간단 버전) -->
                <div id="walkjobFinishModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:10000;
            align-items:center; justify-content:center;">
                    <div style="background:#fff; padding:20px 24px; border-radius:16px; max-width:320px; width:90%;">
                        <h3 style="margin-top:0; margin-bottom:10px; font-size:1.1rem;">산책을 종료하시겠습니까?</h3>
                        <p style="font-size:0.9rem; color:#4b5563; margin-bottom:16px;">
                            알바생이 산책 종료를 요청했습니다. 종료하면 이번 산책이 기록으로 저장됩니다.
                        </p>
                        <div style="display:flex; justify-content:flex-end; gap:8px;">
                            <button id="walkjobFinishNoBtn"
                                style="padding:6px 12px; border-radius:999px; border:1px solid #d1d5db; background:#fff;">
                                아니오
                            </button>
                            <button id="walkjobFinishYesBtn"
                                style="padding:6px 12px; border-radius:999px; border:none; background:#ef4444; color:#fff;">
                                예
                            </button>
                        </div>
                    </div>
                </div>
            </footer>

            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

            <c:if test="${center == 'mypage'}">
                <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />
                <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
                <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales/ko.global.min.js'></script>
            </c:if>

            <script src="<c:url value='/js/main.js'/>"></script>

            <c:if test="${center == null || center == 'center'}">
                <script src="<c:url value='/js/scroll-video.js'/>"></script>
            </c:if>
            <c:if test="${center == 'mypage'}">
                <script src="<c:url value='/js/mypage.js'/>"></script>
            </c:if>

            <c:if test="${not empty sessionScope.user}">
                <script>
                    (function () {
                        const userId = "${sessionScope.user.userId}";
                        let globalWs;

                        function connectGlobalWs() {
                            const protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
                            const wsUrl = protocol + location.host + "/ws/chat";

                            globalWs = new WebSocket(wsUrl);

                            globalWs.onopen = function () {
                                console.log("🔔 알림용 소켓 연결됨");
                                const msg = { senderId: userId, content: "GLOBAL_INIT" };
                                globalWs.send(JSON.stringify(msg));
                            };

                            globalWs.onmessage = function (event) {
                                const data = JSON.parse(event.data);

                                if (data.type === "NOTIFICATION") {
                                    // 현재 같은 채팅방이면 알림 생략
                                    if (window.location.href.includes("roomId=" + data.roomId)) {
                                        return;
                                    }

                                    // 1. 메시지 및 링크 구성
                                    const senderName = data.senderName || "알림";
                                    const toastMsg = "💌 " + senderName + ": " + data.content;
                                    const chatLink = "/chat/room?roomId=" + data.roomId;

                                    // 2. 커스텀 토스트 호출 (main.js 수정 없이 구현)
                                    showChatNotification(toastMsg, chatLink);
                                }
                            };

                            globalWs.onclose = function () {
                                setTimeout(connectGlobalWs, 3000);
                            };
                        }

                        // ✅ 커스텀 알림 함수 (5초 유지 + 클릭 시 이동)
                        function showChatNotification(message, link) {
                            let toastContainer = document.getElementById('toastContainer');

                            // 컨테이너가 없으면 생성 (main.js가 아직 실행 안 됐을 경우 대비)
                            if (!toastContainer) {
                                toastContainer = document.createElement('div');
                                toastContainer.id = 'toastContainer';
                                toastContainer.style.cssText = 'position: fixed; top: 100px; right: 20px; z-index: 9999;';
                                document.body.appendChild(toastContainer);
                            }

                            const toast = document.createElement('div');
                            // 'toast-info' 스타일 사용
                            toast.className = 'toast toast-info show';
                            toast.style.cursor = 'pointer'; // 클릭 가능 커서

                            toast.innerHTML =
                                '<div class="toast-body">' +
                                '<i class="fas fa-info-circle"></i> ' +
                                '<span>' + message + '</span>' +
                                '</div>';

                            // 클릭 이벤트
                            toast.onclick = function () {
                                window.location.href = link;
                            };

                            toastContainer.appendChild(toast);

                            // 5초 후 사라짐
                            setTimeout(function () {
                                toast.classList.remove('show');
                                setTimeout(function () {
                                    toast.remove();
                                }, 300);
                            }, 5000);
                        }

                        window.addEventListener('load', function () {
                            connectGlobalWs();
                        });
                    })();
                </script>
            </c:if>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const banner = document.getElementById('walkjobAlertBanner');
                    const modal = document.getElementById('walkjobFinishModal');
                    const yesBtn = document.getElementById('walkjobFinishYesBtn');
                    const noBtn = document.getElementById('walkjobFinishNoBtn');

                    if (!banner || !modal) return;

                    let alertShown = false;

                    // 🔹 반려인 전역 알림용 SSE
                    const alertSource = new EventSource('<c:url value="/api/walkjob/alerts-stream"/>');

                    alertSource.addEventListener('finishRequest', function (e) {
                        if (alertShown) return; // 1회성
                        alertShown = true;
                        banner.style.display = 'block';
                    });

                    alertSource.onerror = function (e) {
                        console.error('alerts SSE error', e);
                    };

                    // 배너 클릭 → 모달 오픈 & 배너 닫기
                    banner.addEventListener('click', function () {
                        banner.style.display = 'none';
                        modal.style.display = 'flex';
                    });

                    // 아니오 → 모달만 닫고 아무 작업 안 함 (산책 계속)
                    noBtn.addEventListener('click', function () {
                        modal.style.display = 'none';
                    });

                    // 예 → 실제 finish 호출
                    yesBtn.addEventListener('click', async function () {
                        try {
                            const res = await fetch('<c:url value="/api/walkjob/finish"/>', {
                                method: 'POST'
                            });
                            if (!res.ok) throw new Error('finish error');

                            // 필요하면 응답값 파싱
                            // const data = await res.json();

                            alert('산책을 종료했습니다. 산책 기록이 저장되었습니다.');
                        } catch (e) {
                            console.error(e);
                            alert('산책 종료 중 오류가 발생했습니다. 다시 시도해 주세요.');
                        } finally {
                            modal.style.display = 'none';
                        }
                    });
                });
            </script>
        </body>

        </html>