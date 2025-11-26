<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 비디오 백그라운드 -->
<div id="video-background">
    <video id="scroll-video" preload="auto" muted playsinline>
        <source src="<c:url value='/images/dog-run.mp4'/>" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <div class="video-overlay"></div>
</div>

<!-- 히어로 섹션 -->
<section class="hero-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                <div class="hero-content">
                    <h1>
                        반려동물과 함께하는<br>
                        <span class="highlight">스마트한 일상</span>
                    </h1>
                    <p>
                        AI 기술로 더 안전하고 건강한<br>
                        반려동물 케어 서비스를 제공합니다
                    </p>
                    <div class="hero-buttons">
                        <button class="btn btn-pet-primary btn-lg" onclick="location.href='<c:url value='/map'/>'">
                            <i class="fas fa-map-marked-alt mr-2"></i>
                            산책 시작하기
                        </button>
                        <button class="btn btn-pet-secondary btn-lg" onclick="location.href='<c:url value='/register'/>'">
                            <i class="fas fa-user-plus mr-2"></i>
                            무료 회원가입
                        </button>
                    </div>

                    <!-- 통계 박스 -->
                    <div class="hero-stats-box">
                        <div class="hero-stats-title">
                            <i class="fas fa-star"></i>
                            <span>왜 PetCare AI를 선택해야 할까요?</span>
                        </div>
                        <div class="hero-stats-grid">
                            <div class="hero-stat-item">
                                <div class="hero-stat-icon">
                                    <i class="fas fa-brain"></i>
                                </div>
                                <div class="hero-stat-number" data-target="5000">0</div>
                                <div class="hero-stat-label">AI 기반 분석<br><small class="text-muted">실시간 건강 모니터링</small></div>
                            </div>
                            <div class="hero-stat-item">
                                <div class="hero-stat-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="hero-stat-number" data-target="8000">0</div>
                                <div class="hero-stat-label">안전한 산책<br><small class="text-muted">최적 경로 추천</small></div>
                            </div>
                            <div class="hero-stat-item">
                                <div class="hero-stat-icon">
                                    <i class="fas fa-route"></i>
                                </div>
                                <div class="hero-stat-number" data-target="15000">0</div>
                                <div class="hero-stat-label">AI 산책 기록<br><small class="text-muted">데이터 기반 관리</small></div>
                            </div>
                            <div class="hero-stat-item">
                                <div class="hero-stat-icon">
                                    <i class="fas fa-heart"></i>
                                </div>
                                <div class="hero-stat-number" data-target="98">0</div>
                                <div class="hero-stat-label">24시간 케어<br><small class="text-muted">홈캠 실시간 분석</small></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 스크롤 인디케이터 -->
    <div class="scroll-indicator" id="scrollIndicator">
        <i class="fas fa-chevron-down"></i>
    </div>
</section>

<!-- 주요 서비스 -->
<section class="services-section">
    <div class="container">
        <div class="section-title">
            <h2>똑똑한 반려생활의 시작</h2>
            <p class="section-subtitle">AI가 함께하는 반려동물 케어의 모든 것</p>
        </div>

        <div class="services-grid">
            <!-- 1. 지도 기반 산책 -->
            <div class="service-card" onclick="location.href='<c:url value='/map'/>'">
                <div class="service-icon">
                    <i class="fas fa-map-marked-alt"></i>
                </div>
                <h3 class="service-title">지도 기반 산책</h3>
                <p class="service-desc">
                    주변 병원·카페·호텔 등 시설 정보와<br>
                    안전한 산책 경로를 추천해드립니다
                </p>
            </div>

            <!-- 2. AI 산책 기능 -->
            <div class="service-card" onclick="location.href='<c:url value='/ai-walk'/>'">
                <div class="service-icon">
                    <i class="fas fa-route"></i>
                </div>
                <h3 class="service-title">AI 산책 추천</h3>
                <p class="service-desc">
                    AI가 날씨·체력·만족도를 분석해<br>
                    최적의 산책 코스를 추천합니다
                </p>
            </div>

            <!-- 3. 산책 알바 -->
            <div class="service-card" onclick="location.href='<c:url value='/walk-helper'/>'">
                <div class="service-icon">
                    <i class="fas fa-people-carry"></i>
                </div>
                <h3 class="service-title">산책 알바</h3>
                <p class="service-desc">
                    믿을 수 있는 산책 알바를<br>
                    AI 매칭으로 빠르게 찾아보세요
                </p>
            </div>

            <!-- 4. AI 홈캠 분석 -->
            <div class="service-card" onclick="location.href='<c:url value='/homecam'/>'">
                <div class="service-icon">
                    <i class="fas fa-video"></i>
                </div>
                <h3 class="service-title">AI 홈캠 분석</h3>
                <p class="service-desc">
                    외출 중에도 안심, AI가 반려동물의<br>
                    행동과 이상 징후를 실시간 분석합니다
                </p>
            </div>

            <!-- 5. AI 가상 진단 -->
            <div class="service-card" onclick="location.href='<c:url value='/health-check'/>'">
                <div class="service-icon">
                    <i class="fas fa-heartbeat"></i>
                </div>
                <h3 class="service-title">AI 가상 진단</h3>
                <p class="service-desc">
                    사진 한 장으로 피부·눈·치아 상태를<br>
                    AI가 예비 진단하고 병원을 추천합니다
                </p>
            </div>

            <!-- 6. 펫 다이어리 -->
            <div class="service-card" onclick="location.href='<c:url value='/diary'/>'">
                <div class="service-icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3 class="service-title">펫 다이어리</h3>
                <p class="service-desc">
                    소중한 순간을 기록하고<br>
                    산책·홈캠 기록이 자동으로 연동됩니다
                </p>
            </div>

            <!-- 7. 행동 리포트 -->
            <div class="service-card" onclick="location.href='<c:url value='/behavior-report'/>'">
                <div class="service-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="service-title">행동 리포트</h3>
                <p class="service-desc">
                    AI가 활동량·수면 패턴을 분석해<br>
                    주간·월간 리포트를 제공합니다
                </p>
            </div>

            <!-- 8. 함께 산책 -->
            <div class="service-card" onclick="location.href='<c:url value='/walk-together'/>'">
                <div class="service-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="service-title">함께 산책</h3>
                <p class="service-desc">
                    성향이 맞는 주변 반려인과<br>
                    함께 즐거운 산책을 떠나세요
                </p>
            </div>
        </div>
    </div>
</section>

<!-- 특별 혜택 -->
<section class="container">
    <div class="special-offer">
        <div class="row align-items-center">
            <div class="col-lg-8 offer-content">
                <span class="offer-badge">🎉 신규 회원 혜택</span>
                <h2 class="offer-title">지금 가입하고 무료로 시작하세요!</h2>
                <p style="font-size: 1.2rem; margin-bottom: 2rem;">첫 달 프리미엄 기능 무료 + AI 건강진단 3회 무료</p>
                <ul class="offer-benefits">
                    <li><i class="fas fa-check-circle"></i> 무제한 산책 기록</li>
                    <li><i class="fas fa-check-circle"></i> AI 맞춤 코스 추천</li>
                    <li><i class="fas fa-check-circle"></i> 홈캠 실시간 분석</li>
                    <li><i class="fas fa-check-circle"></i> 행동 리포트 제공</li>
                </ul>
            </div>
            <div class="col-lg-4 text-center">
                <button class="btn btn-light btn-lg" style="box-shadow: 0 8px 24px rgba(0,0,0,0.15); font-size: 1.25rem; padding: 1rem 2.5rem;" onclick="location.href='<c:url value='/register'/>'">
                    <i class="fas fa-gift mr-2"></i> 지금 시작하기
                </button>
            </div>
        </div>
    </div>
</section>

<script>
    // 통계 카운팅 애니메이션
    document.addEventListener('DOMContentLoaded', function() {
        const stats = document.querySelectorAll('.hero-stat-number');
        stats.forEach(stat => {
            const target = parseInt(stat.getAttribute('data-target'));
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;

            const updateNumber = () => {
                current += increment;
                if (current < target) {
                    stat.textContent = Math.floor(current).toLocaleString();
                    requestAnimationFrame(updateNumber);
                } else {
                    stat.textContent = target.toLocaleString();
                }
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        updateNumber();
                        observer.unobserve(entry.target);
                    }
                });
            });

            observer.observe(stat);
        });

        // 스크롤 인디케이터 숨기기
        const scrollIndicator = document.getElementById('scrollIndicator');
        if (scrollIndicator) {
            window.addEventListener('scroll', function() {
                if (window.scrollY > 100) {
                    scrollIndicator.classList.add('hidden');
                } else {
                    scrollIndicator.classList.remove('hidden');
                }
            });
        }
    });
</script>
