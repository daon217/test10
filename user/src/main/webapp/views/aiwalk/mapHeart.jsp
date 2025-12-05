<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모양별 산책 코스</title>

    <!-- Leaflet -->
    <link rel="stylesheet"
          href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin=""/>

    <!-- 분리한 CSS -->
    <link rel="stylesheet" href="<c:url value='/css/mapheart.css'/>">
</head>

<body>

<br>


<!-- HERO -->
<section class="map-hero">
    <div class="map-hero__content">
        <p class="map-hero__eyebrow">PET WALKING EXPERIENCE</p>
        <h1 class="map-hero__title">내 주변 모양별 산책 코스</h1>
        <p class="map-hero__desc">
            현재 위치를 기준으로 예쁜 도형 산책 코스와 일반 산책 코스를 기록할 수 있어요.<br>
            반려동물 정보 기반 AI 제시 거리, 음성으로 코스 요청, 저장된 코스 네비게이션까지 한 화면에서 이용해 보세요.
        </p>

        <!-- ★ 추가: 반려동물 선택 -->
        <div class="pet-row" style="margin-bottom:8px;">
            <label for="petSelect" style="font-size:0.9rem; margin-right:4px;">
                반려동물 선택
            </label>
            <select id="petSelect" style="padding:4px 8px; font-size:0.9rem;">
                <!-- JS에서 채움 -->
            </select>
        </div>

        <div class="map-hero__actions">
            <button type="button" class="btn btn-primary btn-lg" id="heroGeneralBtn">
                일반 산책 시작
            </button>
            <button type="button" class="btn btn-primary btn-lg" id="heroShapeBtn">
                내 주변 도형 코스 보기
            </button>
        </div>
    </div>
    <div class="map-hero__illustration">
        <div class="pulse"></div>
        <div class="pulse delay"></div>
        <div class="hero-card">
            <p class="hero-card__title">오늘 제시된 산책 거리</p>
            <p class="hero-card__value" id="heroPlannedKm">- km</p>
            <p class="hero-card__hint" style="font-size:0.8rem; color:var(--map-muted);">
                반려동물 정보 기반 제시 코스
            </p>
        </div>
    </div>
</section>

<!-- 상단 2열: 왼쪽 일반 산책, 오른쪽 반려동물 추천 -->
<section class="map-layout" id="generalLayout">
    <!-- 일반 산책 코스 카드 -->
    <div class="map-panel">
        <div class="map-panel__header">
            <div>
                <p class="map-panel__eyebrow">LIVE WALK LOG</p>
                <h2>일반 산책 코스 기록</h2>
                <p class="map-panel__sub">
                    별도 도형 없이, 실제로 걸은 경로를 그대로 기록합니다.<br>
                    네비게이션 시작 후 산책을 마친 뒤 저장하면, 다이어리에서 다시 볼 수 있어요.
                </p>
            </div>
        </div>

        <div class="map-panel__body">
            <div class="map-canvas">
                <div id="mapFree" aria-label="일반 산책 지도"></div>
            </div>
        </div>

        <div class="map-panel__footer">
            <div class="map-stats">
                <div>
                    <p class="map-stats__label">오늘 산책 거리(일반)</p>
                    <p class="map-stats__value" id="generalDistanceLabel">-</p>
                </div>
                <div>
                    <p class="map-stats__label">실제 소요 시간</p>
                    <p class="map-stats__value" id="generalTimeLabel">-</p>
                </div>
            </div>
            <div style="margin-top:14px; display:flex; gap:8px; flex-wrap:wrap;">
                <button type="button" class="btn btn-primary btn-sm" onclick="startGeneralWalk()">
                    네비게이션 시작
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="finishGeneralWalk()">
                    산책 종료 &amp; 저장
                </button>
            </div>
        </div>
    </div>

    <!-- 오른쪽: 반려동물 정보 기반 산책 거리 제시 -->
    <div class="side-panel">
        <div id="setupSidePanels">
            <article class="panel-card">
                <header>
                    <p class="panel-card__eyebrow">PET RECOMMENDATION</p>
                    <h3>반려동물 정보 기반 산책 거리 제시</h3>
                    <p class="panel-card__desc">
                        등록된 반려동물의 나이, 체중, 종, 성별 정보를 바탕으로
                        오늘 적당한 산책 거리를 AI가 추천해 드립니다.
                    </p>
                </header>

                <div id="petBox" class="pet-box">
                    <div class="pet-box-title">내 반려동물 정보 기반 AI 산책 거리 제시</div>
                    <div id="petLoadingText">반려동물 정보를 불러오는 중입니다...</div>

                    <div id="petContent" style="display:none;">
                        <div class="pet-row" id="petInfoText"></div>
                        <div class="pet-row">
                            제시된 산책 거리:
                            <span id="petRecommendKm" class="pet-highlight">- km</span>
                        </div>
                        <div class="pet-row">
                            <small id="petReasonText"></small>
                        </div>
                    </div>

                    <div id="petErrorText" style="display:none; color:#d9534f;">
                        반려동물 정보를 불러오지 못했습니다. 로그인을 하거나 반려동물 정보를 등록 후 다시 시도해주세요.
                    </div>
                </div>
            </article>
        </div>
    </div>
</section>

<!-- 하단: 모양별 산책 코스 설정(기존 기능) -->
<section class="map-layout" id="shapeLayout">
    <div class="map-panel">
        <!-- 설정 모드 헤더 -->
        <div id="setupHeader" class="map-panel__header">
            <div>
                <p class="map-panel__eyebrow">AI ASSISTED WALK</p>
                <h2>모양별 산책 코스 설정</h2>
                <p class="map-panel__sub">
                    목표 거리를 정하고, 내 위치 기준으로 도형 코스를 생성해 보세요.<br>
                    도로가 많은 위치에서 목표거리를 5~10km로 설정 후 도형 생성시 제일 예쁜 모양이 나와요.
                </p>
            </div>
        </div>

        <!-- 네비 모드 헤더 -->
        <div id="navHeader" class="map-panel__header" style="display:none;">
            <div>
                <p class="map-panel__eyebrow">LIVE NAVIGATION</p>
                <h2>실시간 산책 네비게이션</h2>
                <p class="map-panel__sub">현재 위치를 따라가며 도형 코스를 얼마나 채웠는지 확인할 수 있어요.</p>
            </div>
            <div class="map-panel__header-actions">
                <button type="button" class="btn btn-secondary btn-sm" onclick="enterSetupMode()">
                    ← 코스 설정으로 돌아가기
                </button>
                <button type="button" class="btn btn-danger btn-sm" onclick="openFinishModal()">
                    코스 완수
                </button>
            </div>
        </div>

        <!-- 설정 모드 툴바 -->
        <div id="setupToolbar" class="map-panel__toolbar">
            <div class="control-box">
                <label>
                    목표 거리(km):
                    <input id="targetKmInput" type="number" step="0.1" value="8.0">
                </label>

                <div style="display:flex; gap:6px; flex-wrap:wrap;">
                    <button type="button" class="control-pill shape-pill is-active" data-shape="heart"
                            onclick="setShapeType('heart')">
                        하트
                    </button>
                    <button type="button" class="control-pill shape-pill" data-shape="circle"
                            onclick="setShapeType('circle')">
                        원
                    </button>
                    <button type="button" class="control-pill shape-pill" data-shape="square"
                            onclick="setShapeType('square')">
                        네모
                    </button>
                    <button type="button" class="control-pill shape-pill" data-shape="triangle"
                            onclick="setShapeType('triangle')">
                        세모
                    </button>
                </div>

                <button type="button" class="control-pill primary" onclick="reloadRoute()">코스 다시 생성</button>

                <button type="button" class="control-pill" onclick="openSavedCourseModal()">저장된 모양 코스 불러오기</button>

                <button type="button" class="control-pill" id="voiceBtn">음성으로 요청</button>
                <span id="voiceSpinner" style="visibility:hidden;">녹음/처리중...</span>

                <button type="button" class="control-pill primary" onclick="goNavigation()">네비게이션 시작</button>
            </div>
        </div>

        <!-- 네비 모드 툴바 -->
        <div id="navToolbar" class="map-panel__toolbar" style="display:none;">
            <div class="toolbar-left">
                <div>
                    <p class="map-stats__label">총 거리</p>
                    <p class="map-stats__value" id="navTotalDist">-</p>
                </div>
                <div>
                    <p class="map-stats__label">예상 시간</p>
                    <p class="map-stats__value" id="navTotalTime">-</p>
                </div>
                <div>
                    <p class="map-stats__label">진행률</p>
                    <p class="map-stats__value" id="navProgress">0%</p>
                </div>
            </div>
            <div class="toolbar-right">
                <p class="toolbar-hint">
                    현재 상태: <span id="navStatus" style="font-weight:600; color:#111827;">위치 확인 중...</span>
                </p>
            </div>
        </div>

        <!-- 지도 -->
        <div class="map-panel__body">
            <div class="map-canvas">
                <div id="map" aria-label="도형 산책 지도"></div>
                <div class="map-canvas__badge" id="mapSelectionBadge">
                    내 위치 기준 도형 코스 준비 중...
                </div>
                <div class="map-legend">
                    <span class="legend-line legend-line--red"></span> 설계된 도형 코스
                    <span class="legend-line legend-line--green" style="margin-left:12px;"></span> 실제 걸은 경로
                </div>
            </div>
        </div>

        <!-- 설정 모드 푸터 -->
        <div id="setupFooter" class="map-panel__footer">
            <div class="map-stats" id="summarySection">
                <div>
                    <p class="map-stats__label">오늘 코스 총 거리</p>
                    <p class="map-stats__value" id="distanceLabel">-</p>
                </div>
                <div>
                    <p class="map-stats__label">예상 소요시간</p>
                    <p class="map-stats__value" id="timeLabel">-</p>
                </div>
            </div>
        </div>

        <!-- 네비 모드 푸터 -->
        <div id="navFooter" class="map-panel__footer" style="display:none;">
            <div class="map-stats">
                <div>
                    <p class="map-stats__label">실제 걸은 거리(추정)</p>
                    <p class="map-stats__value" id="navWalkedKm">-</p>
                </div>
                <div>
                    <p class="map-stats__label">산책 시작 시간</p>
                    <p class="map-stats__value" id="navStartTime">-</p>
                </div>
                <div>
                    <p class="map-stats__label">실제 경과 시간</p>
                    <p class="map-stats__value" id="navElapsedMin">-</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 도형 네비 모드 전용 사이드 패널 -->
    <div class="side-panel" id="shapeSidePanel">
        <div id="navSidePanels" style="display:none;">
            <article class="panel-card">
                <header>
                    <p class="panel-card__eyebrow">WALK STATUS</p>
                    <h3>오늘 산책 진행 현황</h3>
                    <p class="panel-card__desc">
                        도형 코스를 얼마나 채웠는지, 얼마나 걸었는지 실시간으로 확인할 수 있어요.
                    </p>
                </header>
                <div style="margin-top:12px;">
                    <p class="map-stats__label">현재 진행률</p>
                    <p class="map-stats__value" id="sideNavProgress">0%</p>

                    <p class="map-stats__label" style="margin-top:12px;">현재 상태</p>
                    <p class="map-stats__value" id="sideNavStatus" style="font-size:1rem;">위치 확인 중...</p>

                    <button type="button" class="btn btn-primary btn-sm" style="margin-top:18px;"
                            onclick="openFinishModal()">
                        코스 완수하기
                    </button>
                </div>
            </article>
        </div>
    </div>
</section>

<audio id="voiceRouteAudio"></audio>

<!-- 저장된 코스 모달 -->
<div id="savedCourseModal" class="modal-overlay">
    <div class="modal-content">
        <h3>저장된 코스 불러오기</h3>
        <div id="savedCourseList"
             style="max-height:300px; overflow-y:auto; text-align:left; font-size:14px; margin-top:8px;">
        </div>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary btn-sm"
                    onclick="closeSavedCourseModal()">닫기</button>
        </div>
    </div>
</div>

<!-- 산책 완료 모달 -->
<div id="finishModal" class="modal-overlay">
    <div class="modal-content">
        <h3>오늘 산책 완료!</h3>
        <p id="finishMessageMain">수고하셨어요 🎉</p>
        <p id="finishMessageSub" style="font-size: 14px; color:#555;"></p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary btn-sm"
                    onclick="closeFinishModal()">확인</button>
            <button type="button" class="btn btn-primary btn-sm" onclick="saveCourse()">코스 저장하기</button>
        </div>
    </div>
</div>

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
        crossorigin=""></script>

<script>

    const DEFAULT_CENTER_LAT = 36.777381;
    const DEFAULT_CENTER_LON = 127.001764;

    /* ===== 공통 / 도형 산책용 전역 ===== */
    let map;                    // 도형 코스 지도
    let currentPolyline = null; // 전체 도형 코스(빨간색)
    let progressPolyline = null;// 실제 이동 경로(초록색)
    let userMarker = null;

    let lastDistanceKm = null;
    let lastEstimatedMinutes = null;
    let lastRouteData = null;

    let selectedSavedLogId = null;

    let currentShapeType = 'heart';

    let routeLatLngs = [];
    let cumulativeMeters = [];
    let totalMeters = 0;

    let walkingStartedAt = null;
    let walkedMeters = 0;
    let userTrackLatLngs = [];

    const userIcon = L.icon({
        iconUrl: '<c:url value="/images/pno.png"/>',
        iconSize: [40, 40],
        iconAnchor: [20, 40],
        popupAnchor: [0, -40]
    });

    function enterSetupMode() {
        document.getElementById('setupHeader').style.display = '';
        document.getElementById('setupToolbar').style.display = '';
        document.getElementById('setupFooter').style.display = '';

        const setupSide = document.getElementById('setupSidePanels');
        if (setupSide) setupSide.style.display = '';

        document.getElementById('navHeader').style.display = 'none';
        document.getElementById('navToolbar').style.display = 'none';
        document.getElementById('navFooter').style.display = 'none';

        const navSide = document.getElementById('navSidePanels');
        if (navSide) navSide.style.display = 'none';

        const shapeSide = document.getElementById('shapeSidePanel');
        if (shapeSide) shapeSide.style.display = 'none';

        document.getElementById('mapSelectionBadge').textContent = '내 위치 기준 코스 준비 중...';
    }

    function enterNavMode() {
        document.getElementById('setupHeader').style.display = 'none';
        document.getElementById('setupToolbar').style.display = 'none';
        document.getElementById('setupFooter').style.display = 'none';

        const setupSide = document.getElementById('setupSidePanels');
        if (setupSide) setupSide.style.display = 'none';

        document.getElementById('navHeader').style.display = '';
        document.getElementById('navToolbar').style.display = '';
        document.getElementById('navFooter').style.display = '';

        const navSide = document.getElementById('navSidePanels');
        if (navSide) navSide.style.display = '';

        const shapeSide = document.getElementById('shapeSidePanel');
        if (shapeSide) shapeSide.style.display = '';

        document.getElementById('mapSelectionBadge').textContent = '코스를 따라가며 산책 중...';
    }

    function initMap() {
        map = L.map('map').setView([DEFAULT_CENTER_LAT, DEFAULT_CENTER_LON], 14);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);
    }

    function applyRouteData(data) {
        if (!data || !data.points || data.points.length === 0) return;

        lastRouteData = data;

        const latlngs = data.points.map(p => [p.lat, p.lon]);

        routeLatLngs = latlngs.slice();

        if (currentPolyline) {
            map.removeLayer(currentPolyline);
        }
        if (progressPolyline) {
            map.removeLayer(progressPolyline);
            progressPolyline = null;
        }

        currentPolyline = L.polyline(latlngs, {weight: 5, color: '#e91e63'}).addTo(map);
        map.fitBounds(currentPolyline.getBounds());

        if (typeof data.distanceKm === 'number') {
            lastDistanceKm = data.distanceKm;
            document.getElementById('distanceLabel').textContent =
                data.distanceKm.toFixed(2) + ' km';
        }
        if (typeof data.estimatedMinutes === 'number') {
            lastEstimatedMinutes = data.estimatedMinutes;
            document.getElementById('timeLabel').textContent =
                data.estimatedMinutes.toFixed(0) + ' 분';
        }
    }

    function setShapeType(type) {
        currentShapeType = type;

        document.querySelectorAll('.shape-pill').forEach(btn => {
            if (btn.dataset.shape === type) {
                btn.classList.add('is-active');
            } else {
                btn.classList.remove('is-active');
            }
        });

        reloadRoute();
    }

    function reloadRoute() {
        selectedSavedLogId = null;

        const input = document.getElementById('targetKmInput');
        const targetKm = parseFloat(input.value) || 8.0;

        const url =
            '/api/map/shape-route?type=' + encodeURIComponent(currentShapeType) +
            '&centerLat=' + DEFAULT_CENTER_LAT +
            '&centerLon=' + DEFAULT_CENTER_LON +
            '&targetKm=' + targetKm;

        fetch(url)
            .then(res => res.json())
            .then(data => applyRouteData(data))
            .catch(err => console.error('경로 로딩 실패', err));
    }

    // 하버사인 거리 (m 단위)
    function distanceMeters(lat1, lon1, lat2, lon2) {
        const R = 6371000;
        const toRad = x => x * Math.PI / 180;

        const φ1 = toRad(lat1);
        const φ2 = toRad(lat2);
        const Δφ = toRad(lat2 - lat1);
        const Δλ = toRad(lon2 - lon1);

        const a =
            Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ / 2) * Math.sin(Δλ / 2);

        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    function prepareRouteForNavigation(data) {
        routeLatLngs = data.points.map(p => [p.lat, p.lon]);

        cumulativeMeters = [0];
        totalMeters = 0;
        walkingStartedAt = null;
        walkedMeters = 0;
        userTrackLatLngs = [];

        for (let i = 1; i < routeLatLngs.length; i++) {
            const [lat1, lon1] = routeLatLngs[i - 1];
            const [lat2, lon2] = routeLatLngs[i];
            const d = distanceMeters(lat1, lon1, lat2, lon2);
            totalMeters += d;
            cumulativeMeters.push(totalMeters);
        }

        if (currentPolyline) {
            map.removeLayer(currentPolyline);
        }
        if (progressPolyline) {
            map.removeLayer(progressPolyline);
            progressPolyline = null;
        }

        currentPolyline = L.polyline(routeLatLngs, {weight: 6, color: '#e91e63'}).addTo(map);
        map.fitBounds(currentPolyline.getBounds());

        const distKm = totalMeters / 1000;
        document.getElementById('navTotalDist').textContent = distKm.toFixed(2) + ' km';

        const baseMinutes = typeof data.estimatedMinutes === 'number'
            ? data.estimatedMinutes
            : (distKm * 15);
        document.getElementById('navTotalTime').textContent = baseMinutes.toFixed(0) + ' 분';
    }

    function updateNavigation(lat, lon) {
        if (userTrackLatLngs.length === 0) {
            userTrackLatLngs.push([lat, lon]);
        } else {
            const [prevLat, prevLon] = userTrackLatLngs[userTrackLatLngs.length - 1];
            const move = distanceMeters(prevLat, prevLon, lat, lon);

            if (move < 2) {
                return;
            }

            userTrackLatLngs.push([lat, lon]);
            walkedMeters += move;
        }

        if (userTrackLatLngs.length >= 2) {
            if (progressPolyline) {
                progressPolyline.setLatLngs(userTrackLatLngs);
            } else {
                progressPolyline = L.polyline(userTrackLatLngs, {
                    weight: 6,
                    color: '#4caf50'
                }).addTo(map);
            }
        }

        let targetMeters = totalMeters;

        if (!targetMeters || !isFinite(targetMeters) || targetMeters <= 0) {
            const inputKm = parseFloat(document.getElementById('targetKmInput').value) || 0;
            if (inputKm > 0) {
                targetMeters = inputKm * 1000;
            } else if (lastDistanceKm) {
                targetMeters = lastDistanceKm * 1000;
            }
        }

        let progress = 0;
        if (targetMeters > 0 && walkedMeters > 0) {
            progress = Math.min(1, walkedMeters / targetMeters);
        }

        const progressPercent = progress * 100;
        document.getElementById('navProgress').textContent = progressPercent.toFixed(1) + '%';
        document.getElementById('sideNavProgress').textContent = progressPercent.toFixed(1) + '%';

        const walkedKm = walkedMeters / 1000;
        document.getElementById('navWalkedKm').textContent = walkedKm.toFixed(2) + ' km';

        if (walkingStartedAt) {
            const now = new Date();
            const minutes = Math.max(1, Math.round((now - walkingStartedAt) / 60000));
            document.getElementById('navElapsedMin').textContent = minutes + ' 분';
        }

        document.getElementById('navStatus').textContent = '실제 걸은 경로를 기록하고 있어요';
        document.getElementById('sideNavStatus').textContent = '실제 걸은 경로를 기록하고 있어요';

        map.setView([lat, lon], 16);
    }

    function startTracking() {
        if (!navigator.geolocation) {
            alert('이 브라우저는 위치 추적을 지원하지 않습니다.');
            return;
        }

        const options = {
            enableHighAccuracy: false,
            timeout: 30000,
            maximumAge: 10000
        };

        navigator.geolocation.watchPosition(
            (pos) => {
                const lat = pos.coords.latitude;
                const lon = pos.coords.longitude;

                if (!walkingStartedAt) {
                    walkingStartedAt = new Date();
                    document.getElementById('navStartTime').textContent =
                        walkingStartedAt.toLocaleTimeString();
                }

                if (!userMarker) {
                    userMarker = L.marker([lat, lon], {
                        title: '현재 위치',
                        icon: userIcon
                    }).addTo(map);
                } else {
                    userMarker.setLatLng([lat, lon]);
                }

                updateNavigation(lat, lon);
            },
            (err) => {
                console.warn('위치 추적 실패', err);
                let msg = '위치 정보를 가져올 수 없습니다.';
                if (err.code === 1) msg = '위치 권한이 거부되었습니다.';
                if (err.code === 2) msg = '위치 정보를 사용할 수 없습니다.';
                if (err.code === 3) msg = '위치 응답 시간이 너무 오래 걸립니다.';
                document.getElementById('navStatus').textContent = msg;
                document.getElementById('sideNavStatus').textContent = msg;
            },
            options
        );
    }

    async function goNavigation() {
        enterNavMode();

        try {
            let data = null;

            if (selectedSavedLogId) {
                const res = await fetch(`/api/walk/logs/${selectedSavedLogId}`);
                if (!res.ok) throw new Error('saved route load error');
                data = await res.json();
            } else if (lastRouteData) {
                data = lastRouteData;
            } else {
                const targetKm = parseFloat(document.getElementById('targetKmInput').value) || 8.0;
                const url =
                    '/api/map/shape-route?type=' + encodeURIComponent(currentShapeType) +
                    '&centerLat=' + DEFAULT_CENTER_LAT +
                    '&centerLon=' + DEFAULT_CENTER_LON +
                    '&targetKm=' + targetKm;
                const res = await fetch(url);
                data = await res.json();
            }

            prepareRouteForNavigation(data);
            startTracking();
        } catch (e) {
            console.error('네비게이션용 경로 로딩 실패', e);
            alert('경로를 불러오지 못했습니다.');
            enterSetupMode();
        }
    }
</script>

<!-- HERO 버튼 스크롤, 반려동물 추천 연동 -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const generalLayout = document.getElementById('generalLayout');
        const shapeLayout = document.getElementById('shapeLayout');
        const heroGeneralBtn = document.getElementById('heroGeneralBtn');
        const heroShapeBtn = document.getElementById('heroShapeBtn');

        if (heroGeneralBtn && generalLayout) {
            heroGeneralBtn.addEventListener('click', () => {
                generalLayout.scrollIntoView({behavior: 'smooth'});
            });
        }
        if (heroShapeBtn && shapeLayout) {
            heroShapeBtn.addEventListener('click', () => {
                shapeLayout.scrollIntoView({behavior: 'smooth'});
            });
        }
    });
</script>

<!-- 음성으로 도형 코스 요청 -->
<script>
    const voiceBtn = document.getElementById('voiceBtn');
    const voiceSpinner = document.getElementById('voiceSpinner');
    const audioPlayer = document.getElementById('voiceRouteAudio');

    let mediaRecorder = null;
    let audioChunks = [];
    let recording = false;

    voiceBtn.addEventListener('click', async () => {
        if (!recording) {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({audio: true});
                mediaRecorder = new MediaRecorder(stream);
                audioChunks = [];

                mediaRecorder.ondataavailable = e => {
                    if (e.data.size > 0) {
                        audioChunks.push(e.data);
                    }
                };

                mediaRecorder.onstop = () => {
                    const blob = new Blob(audioChunks, {type: 'audio/webm'});
                    stream.getTracks().forEach(t => t.stop());
                    sendVoice(blob);
                };

                mediaRecorder.start();
                recording = true;
                voiceBtn.textContent = '녹음 종료';
                voiceSpinner.style.visibility = 'visible';
            } catch (e) {
                console.error(e);
                alert('마이크 권한이 필요합니다.');
            }
        } else {
            mediaRecorder.stop();
            recording = false;
            voiceBtn.textContent = '음성으로 요청';
        }
    });

    async function sendVoice(blob) {
        try {
            const formData = new FormData();
            formData.append('speech', blob, 'speech.webm');
            formData.append('centerLat', DEFAULT_CENTER_LAT);
            formData.append('centerLon', DEFAULT_CENTER_LON);

            const res = await fetch('/api/map/voice-route', {
                method: 'POST',
                body: formData
            });

            const data = await res.json();
            console.log('voice-route 응답', data);

            selectedSavedLogId = null;

            applyRouteData(data);

            if (typeof data.targetKm === 'number') {
                document.getElementById('targetKmInput').value =
                    data.targetKm.toFixed(1);
            }

            if (data.ttsAudio) {
                audioPlayer.src = 'data:audio/mp3;base64,' + data.ttsAudio;
                audioPlayer.play();
            }
        } catch (e) {
            console.error(e);
            alert('음성 요청 처리 중 오류가 발생했습니다.');
        } finally {
            voiceSpinner.style.visibility = 'hidden';
        }
    }
</script>

<!-- 저장된 코스 모달 관련 -->
<script>
    async function openSavedCourseModal() {
        const modal = document.getElementById('savedCourseModal');
        const listDiv = document.getElementById('savedCourseList');
        listDiv.innerHTML = '불러오는 중...';

        try {
            const res = await fetch('/api/walk/logs');
            if (!res.ok) {
                throw new Error('list error');
            }
            const logs = await res.json();

            if (!logs || logs.length === 0) {
                listDiv.innerHTML = '<p>저장된 코스가 없습니다.</p>';
            } else {
                const ul = document.createElement('ul');
                ul.style.listStyle = 'none';
                ul.style.padding = '0';

                logs.forEach(log => {
                    const li = document.createElement('li');
                    li.style.padding = '8px 4px';
                    li.style.cursor = 'pointer';
                    li.style.borderBottom = '1px solid #eee';

                    li.textContent =
                        `${log.startDate} · ${log.distanceKm.toFixed(2)}km · 약 ${log.minutes}분`;

                    li.onclick = () => {
                        selectSavedCourse(log.id);
                    };

                    ul.appendChild(li);
                });

                listDiv.innerHTML = '';
                ul && listDiv.appendChild(ul);
            }
        } catch (e) {
            console.error(e);
            listDiv.innerHTML = '<p>코스 목록을 불러오는 중 오류가 발생했습니다.</p>';
        }

        modal.style.display = 'flex';
    }

    function closeSavedCourseModal() {
        const modal = document.getElementById('savedCourseModal');
        modal.style.display = 'none';
    }

    async function selectSavedCourse(id) {
        try {
            const res = await fetch(`/api/walk/logs/${id}`);
            if (!res.ok) throw new Error('detail error');

            const data = await res.json();
            applyRouteData(data);

            selectedSavedLogId = id;

            closeSavedCourseModal();
            alert('저장된 코스를 선택했습니다. "네비게이션 시작"을 누르면 이 코스로 안내합니다.');
        } catch (e) {
            console.error(e);
            alert('저장된 코스를 불러오는 중 오류가 발생했습니다.');
        }
    }

    document.getElementById('savedCourseModal').addEventListener('click', (e) => {
        if (e.target.id === 'savedCourseModal') {
            closeSavedCourseModal();
        }
    });
</script>

<!-- 반려동물 산책 거리 추천 -->
<script>
    let selectedPetId = null;
    let hasPetList = false;

    async function loadPetWalkRecommendation() {
        const loadingText = document.getElementById('petLoadingText');
        const contentBox = document.getElementById('petContent');
        const errorText = document.getElementById('petErrorText');
        const infoText = document.getElementById('petInfoText');
        const reasonText = document.getElementById('petReasonText');
        const recommendKmSpan = document.getElementById('petRecommendKm');
        const petSelect = document.getElementById('petSelect');

        loadingText.style.display = 'block';
        contentBox.style.display = 'none';
        errorText.style.display = 'none';

        try {
            // 1) 현재 로그인 사용자의 반려동물 목록 조회
            const resPets = await fetch('/api/pet/my-pets');
            if (!resPets.ok) {
                throw new Error('my-pets error');
            }
            const pets = await resPets.json();

            petSelect.innerHTML = '';

            if (!pets || pets.length === 0) {
                hasPetList = false;
                const opt = document.createElement('option');
                opt.value = '';
                opt.textContent = '등록된 반려동물이 없습니다';
                petSelect.appendChild(opt);

                loadingText.style.display = 'none';
                errorText.style.display = 'block';
                errorText.textContent = '등록된 반려동물이 없습니다. 반려동물을 먼저 등록해 주세요.';
                return;
            }

            hasPetList = true;

            // 셀렉트 박스 채우기
            pets.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.petId;
                opt.textContent = p.name + ' (' + p.type + ')';
                petSelect.appendChild(opt);
            });

            // 기본 선택: 첫 번째 반려동물
            selectedPetId = pets[0].petId;
            petSelect.value = selectedPetId;

            // 셀렉트 변경 시마다 추천 다시 불러오기
            petSelect.addEventListener('change', async () => {
                const v = petSelect.value;
                selectedPetId = v ? parseInt(v) : null;
                if (selectedPetId) {
                    await fetchRecommendForSelectedPet(
                        loadingText, contentBox, errorText, infoText,
                        reasonText, recommendKmSpan
                    );
                }
            });

            // 2) 기본 선택된 반려동물 기준 추천 호출
            await fetchRecommendForSelectedPet(
                loadingText, contentBox, errorText, infoText,
                reasonText, recommendKmSpan
            );

        } catch (e) {
            console.error(e);
            loadingText.style.display = 'none';
            errorText.style.display = 'block';
        }
    }

    async function fetchRecommendForSelectedPet(
        loadingText, contentBox, errorText, infoText, reasonText, recommendKmSpan
    ) {
        if (!selectedPetId) {
            return;
        }

        loadingText.style.display = 'block';
        contentBox.style.display = 'none';
        errorText.style.display = 'none';

        try {
            const res = await fetch('/api/pet/walk-recommend/for-pet/' + selectedPetId);
            if (!res.ok) {
                throw new Error('pet recommend error');
            }

            const data = await res.json();
            const pet = data.pet || {};

            const name = pet.name || '이름 미등록';

            let speciesParts = [];
            if (pet.type) speciesParts.push(pet.type);
            if (pet.customType) speciesParts.push(pet.customType);
            if (pet.breed) speciesParts.push(pet.breed);
            const speciesText = speciesParts.length > 0 ? speciesParts.join(' / ') : '종 미등록';

            const ageText = (pet.age !== null && pet.age !== undefined) ? pet.age + '살' : '나이 미등록';
            const genderText = pet.gender || '성별 미등록';

            let weightText;
            if (typeof pet.weight === 'number') {
                weightText = pet.weight.toFixed(1) + 'kg';
            } else if (pet.weight) {
                weightText = pet.weight + 'kg';
            } else {
                weightText = '체중 미등록';
            }

            infoText.textContent =
                `${name} (${speciesText}, ${ageText}, ${genderText}, 약 ${weightText})`;

            let km = 2.5;
            if (typeof data.recommendedKm === 'number' && !isNaN(data.recommendedKm)) {
                km = data.recommendedKm;
            }

            recommendKmSpan.textContent = km.toFixed(1) + ' km';
            reasonText.textContent =
                data.reason || 'AI가 반려동물의 상태를 바탕으로 산책 거리를 추천했습니다.';

            const heroPlannedKmEl = document.getElementById('heroPlannedKm');
            if (heroPlannedKmEl) {
                heroPlannedKmEl.textContent = km.toFixed(2) + ' km';
            }

            loadingText.style.display = 'none';
            contentBox.style.display = 'block';
        } catch (e) {
            console.error(e);
            loadingText.style.display = 'none';
            errorText.style.display = 'block';
        }
    }
</script>


<!-- 도형 코스 + 실제 코스 저장 -->
<script>
    function openFinishModal() {
        const modal = document.getElementById('finishModal');
        const main = document.getElementById('finishMessageMain');
        const sub = document.getElementById('finishMessageSub');

        let distanceKm = (walkedMeters > 0 ? walkedMeters : totalMeters) / 1000.0;
        if (!isFinite(distanceKm) || distanceKm <= 0) distanceKm = 0;

        const now = new Date();
        let minutes = 0;
        if (walkingStartedAt) {
            minutes = Math.max(1, Math.round((now - walkingStartedAt) / 60000));
        }

        if (distanceKm > 0) {
            main.textContent = '수고하셨어요! 산책을 마치셨어요. 🎉';
            sub.textContent =
                `오늘은 약 ${distanceKm.toFixed(2)}km, ${minutes}분 정도 산책하셨어요.`;
        } else {
            main.textContent = '코스 정보가 없습니다.';
            sub.textContent = '먼저 네비게이션을 따라 산책한 뒤 완료를 눌러 주세요.';
        }

        window._finishDistanceKm = distanceKm;
        window._finishMinutes = minutes;

        modal.style.display = 'flex';
    }

    function closeFinishModal() {
        document.getElementById('finishModal').style.display = 'none';
    }

    async function saveCourse() {
        const hasPlanned = routeLatLngs && routeLatLngs.length >= 2;
        const hasWalked = userTrackLatLngs && userTrackLatLngs.length >= 2;

        if (!hasPlanned && !hasWalked) {
            alert('저장할 코스가 없습니다.');
            return;
        }

        const now = new Date();
        const startTime = walkingStartedAt || now;
        const endTime = now;

        let plannedDistanceKm = 0;
        if (hasPlanned) {
            if (totalMeters && totalMeters > 0) {
                plannedDistanceKm = totalMeters / 1000.0;
            } else if (lastDistanceKm && lastDistanceKm > 0) {
                plannedDistanceKm = lastDistanceKm;
            }
        }

        let walkedDistanceKm = 0;
        if (walkedMeters && walkedMeters > 0) {
            walkedDistanceKm = walkedMeters / 1000.0;
        } else if (window._finishDistanceKm && window._finishDistanceKm > 0) {
            walkedDistanceKm = window._finishDistanceKm;
        }

        let targetKm = null;
        const targetInput = document.getElementById('targetKmInput');
        if (targetInput) {
            const v = parseFloat(targetInput.value);
            if (!isNaN(v) && v > 0) {
                targetKm = v;
            }
        }

        let plannedRoute = null;
        if (hasPlanned) {
            plannedRoute = {
                distanceKm: plannedDistanceKm,
                points: routeLatLngs.map(ll => ({
                    lat: ll[0],
                    lon: ll[1]
                }))
            };
        }

        let walkedRoute = null;
        if (hasWalked) {
            walkedRoute = {
                distanceKm: walkedDistanceKm,
                points: userTrackLatLngs.map(ll => ({
                    lat: ll[0],
                    lon: ll[1]
                }))
            };
        }

        const body = {
            shapeType: currentShapeType,
            targetKm: targetKm,
            plannedRoute: plannedRoute,
            walkedRoute: walkedRoute,
            startTimeIso: startTime.toISOString(),
            endTimeIso: endTime.toISOString(),
            // ★ 추가
            petId: selectedPetId
        };

        try {
            const res = await fetch('/api/walk/logs', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(body)
            });

            if (!res.ok) {
                console.error('saveCourse 응답 에러:', res.status);
                alert('코스 저장 중 오류가 발생했습니다. 로그인 후 다시 시도하세요.');
                return;
            }

            const data = await res.json();
            console.log('saveCourse result', data);
            alert('코스를 저장했습니다. (도형 + 실제 경로 기준)');
            closeFinishModal();
        } catch (e) {
            console.error(e);
            alert('코스 저장 중 오류가 발생했습니다. 로그인 후 다시 시도하세요.');
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const modal = document.getElementById('finishModal');
        if (modal) {
            modal.addEventListener('click', (e) => {
                if (e.target.id === 'finishModal') {
                    closeFinishModal();
                }
            });
        }
    });
</script>

<!-- 일반 산책(위 카드) 전용 네비/저장 -->
<script>
    let freeMap;
    let freeUserMarker = null;
    let freePolyline = null;
    let freeTrackLatLngs = [];
    let freeWalkedMeters = 0;
    let freeWalkingStartedAt = null;
    let freeWatchId = null;

    function initFreeMap() {
        const el = document.getElementById('mapFree');
        if (!el) return;

        freeMap = L.map('mapFree').setView([DEFAULT_CENTER_LAT, DEFAULT_CENTER_LON], 14);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(freeMap);
    }

    function updateFreeNavigation(lat, lon) {
        if (freeTrackLatLngs.length === 0) {
            // 첫 지점은 무조건 추가
            freeTrackLatLngs.push([lat, lon]);
        } else {
            const [prevLat, prevLon] = freeTrackLatLngs[freeTrackLatLngs.length - 1];
            const move = distanceMeters(prevLat, prevLon, lat, lon);

            // ★ 이동 거리가 2m 미만이면 "거리/경로"만 업데이트 안 하고,
            //    아래 시간/마커 갱신은 그대로 진행하도록 변경
            if (move >= 2) {
                freeTrackLatLngs.push([lat, lon]);
                freeWalkedMeters += move;
            }
        }

        // ★ 현재 위치 마커는 항상 갱신
        if (!freeUserMarker) {
            freeUserMarker = L.marker([lat, lon], {
                title: '현재 위치',
                icon: userIcon
            }).addTo(freeMap);
        } else {
            freeUserMarker.setLatLng([lat, lon]);
        }

        // ★ 경로 polyline 은 실제로 이동이 있을 때만 갱신
        if (freeTrackLatLngs.length >= 2) {
            if (freePolyline) {
                freePolyline.setLatLngs(freeTrackLatLngs);
            } else {
                freePolyline = L.polyline(freeTrackLatLngs, {
                    weight: 5,
                    color: '#22c55e'
                }).addTo(freeMap);
            }
        }

        freeMap.setView([lat, lon], 16);

        const km = freeWalkedMeters / 1000;
        document.getElementById('generalDistanceLabel').textContent = km.toFixed(2) + ' km';

        // ★ 여기 시간 부분은 이동 거리와 상관없이 항상 갱신되게 유지
        if (freeWalkingStartedAt) {
            const now = new Date();
            const minutes = Math.max(1, Math.round((now - freeWalkingStartedAt) / 60000));
            document.getElementById('generalTimeLabel').textContent = minutes + ' 분';
        }
    }


    function startGeneralWalk() {
        if (!navigator.geolocation) {
            alert('이 브라우저는 위치 추적을 지원하지 않습니다.');
            return;
        }
        if (freeWatchId !== null) {
            alert('이미 일반 산책 네비게이션이 진행 중입니다.');
            return;
        }

        freeTrackLatLngs = [];
        freeWalkedMeters = 0;
        freeWalkingStartedAt = null;

        freeWatchId = navigator.geolocation.watchPosition(
            (pos) => {
                const lat = pos.coords.latitude;
                const lon = pos.coords.longitude;
                if (!freeWalkingStartedAt) {
                    freeWalkingStartedAt = new Date();
                }
                updateFreeNavigation(lat, lon);
            },
            (err) => {
                console.warn('일반 산책 위치 추적 실패', err);
                alert('일반 산책 위치 정보를 가져올 수 없습니다.');
            },
            {
                enableHighAccuracy: false,
                maximumAge: 10000,
                timeout: 30000
            }
        );
    }

    async function finishGeneralWalk() {
        // ★ "네비게이션 시작" 버튼만 누르면, 0km여도 종료 가능하게 변경
        if (!freeWalkingStartedAt) {
            alert('아직 일반 산책 네비게이션이 시작되지 않았습니다. 먼저 네비게이션을 시작해 주세요.');
            return;
        }

        if (freeWatchId !== null) {
            navigator.geolocation.clearWatch(freeWatchId);
            freeWatchId = null;
        }

        const startTime = freeWalkingStartedAt;
        const endTime = new Date();
        const distanceKm = freeWalkedMeters / 1000;

        // ★ 0km 여부에 따라 walkedRoute를 null 로 보낼지 결정
        const hasWalked =
            freeTrackLatLngs && freeTrackLatLngs.length >= 2 && distanceKm > 0;

        let walkedRoutePayload = null;
        if (hasWalked) {
            walkedRoutePayload = {
                distanceKm: distanceKm,
                points: freeTrackLatLngs.map(ll => ({
                    lat: ll[0],
                    lon: ll[1]
                }))
            };
        } else {
            // 0km인 경우: walkedRoute = null → DB의 walked_distance / walked_route_data 는 null로 들어감
            walkedRoutePayload = null;
        }

        const body = {
            // ★ 일반 산책은 항상 "normal" 로 저장 (기존 shape_type null 문제 해결)
            shapeType: 'normal',
            targetKm: null,
            plannedRoute: null,
            walkedRoute: walkedRoutePayload,
            startTimeIso: startTime.toISOString(),
            endTimeIso: endTime.toISOString(),

            // ★ 선택된 펫 id 전달
            petId: selectedPetId
        };

        try {
            const res = await fetch('/api/walk/logs', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(body)
            });

            if (!res.ok) {
                console.error('일반 산책 저장 에러:', res.status);
                alert('일반 산책 기록 저장 중 오류가 발생했습니다.');
                return;
            }

            const data = await res.json();
            console.log('free walk saved', data);
            alert('일반 산책 기록을 저장했습니다.');
        } catch (e) {
            console.error(e);
            alert('일반 산책 기록 저장 중 오류가 발생했습니다.');
        }
    }

</script>

<!-- 초기화 -->
<script>
    window.addEventListener('load', () => {
        initFreeMap();          // 일반 산책 지도
        initMap();              // 도형 산책 지도
        reloadRoute();          // 기본 도형 코스 생성
        loadPetWalkRecommendation();
        enterSetupMode();
    });
</script>

</body>
</html>
