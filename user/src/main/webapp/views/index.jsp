<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>PetCare AI - 스마트한 반려동물 케어</title>

    <!-- SEO Meta Tags -->
    <meta name="description" content="AI 기술로 더 안전하고 건강한 반려동물 케어 서비스">
    <meta name="keywords" content="반려동물, AI 산책, 펫케어, 홈캠, 건강진단, 산책알바, 펫다이어리">

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

    <!-- 페이지별 CSS -->
    <c:if test="${center == null || center == 'center'}">
        <link rel="stylesheet" href="<c:url value='/css/center.css'/>">
    </c:if>
    <c:if test="${center == 'login' || center == 'register'}">
        <link rel="stylesheet" href="<c:url value='/css/auth.css'/>">
    </c:if>
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
                    <span class="pet-logo-title">PetCare AI</span>
                    <span class="pet-logo-subtitle">스마트 반려 케어</span>
                </div>
            </a>

            <!-- 모바일 토글 -->
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                    data-target="#petNavbar" aria-controls="petNavbar"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- 네비게이션 메뉴 (요구사항 반영) -->
            <div class="collapse navbar-collapse pet-nav" id="petNavbar">
                <ul class="navbar-nav ml-auto">
                    <!-- ✅ 산책 드롭다운 (통합 버전) -->
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
                        </div>
                    </li>

                    <!-- ✅ AI 서비스 드롭다운 (피규어 만들기 추가) -->
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

                <!-- ✅ 헤더 액션 버튼 (로그인 상태별) -->
                <div class="header-actions ml-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <!-- 로그인 상태 -->
                            <a href="<c:url value='/customer-service'/>" class="btn btn-pet-outline btn-sm mr-2">
                                <i class="fas fa-headset"></i> 고객센터
                            </a>
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

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JS -->
<script src="<c:url value='/js/main.js'/>"></script>

<!-- 페이지별 JS -->
<c:if test="${center == null || center == 'center'}">
    <script src="<c:url value='/js/scroll-video.js'/>"></script>
</c:if>

</body>
</html>
