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

    <style>
        :root {
            --map-hero-gradient: linear-gradient(135deg, rgba(15, 173, 176, 0.18) 0%, rgba(34, 199, 201, 0.12) 42%, rgba(207, 166, 74, 0.18) 100%);
            --map-panel-bg: var(--bg-card, #ffffff);
            --map-panel-border: var(--border-light, #e5e7eb);
            --map-panel-shadow: var(--shadow-lg, 0 18px 40px rgba(15, 23, 42, 0.12));
            --map-muted: var(--text-secondary, #6b7280);
            --map-safe: var(--primary-teal, #0ea5e9);
            --map-relaxed: var(--accent-dancheong-green, #16a34a);
            --map-warm-layer: rgba(253, 243, 227, 0.7);
            --map-zone-soft: rgba(45, 53, 83, 0.05);
            --map-zone-relaxed: rgba(74, 222, 128, 0.12);
            --map-zone-safe: rgba(56, 189, 248, 0.12);
            --primary-dark: #111827;
        }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            padding: 0;
            background: #f3f4f6;
        }

        .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            border: 0;
        }

        /* ===== HERO ===== */
        .map-hero,
        .map-layout {
            width: min(1180px, 92vw);
            margin: 0 auto 48px auto;
        }

        .map-hero {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 32px;
            padding-top: 80px;
            align-items: center;
        }

        .map-hero__eyebrow {
            font-size: 0.85rem;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--map-muted);
            margin-bottom: 10px;
        }

        .map-hero__title {
            font-size: clamp(2rem, 5vw, 3.0rem);
            font-weight: 600;
            margin-bottom: 12px;
            color: var(--primary-dark);
        }

        .map-hero__desc {
            color: var(--map-muted);
            line-height: 1.7;
        }

        .map-hero__actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 28px;
        }

        .map-hero__actions .btn {
            min-width: 180px;
        }

        .map-hero__illustration {
            position: relative;
            min-height: 260px;
            border-radius: 32px;
            background: var(--map-hero-gradient);
            border: 1px solid var(--map-panel-border);
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.12);
            overflow: hidden;
        }

        .pulse,
        .pulse.delay {
            position: absolute;
            border: 2px solid rgba(15, 173, 176, 0.25);
            border-radius: 50%;
            width: 220px;
            height: 220px;
            top: 45%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 5s infinite;
        }

        .pulse.delay {
            animation-delay: 1.5s;
            border-color: rgba(207, 166, 74, 0.25);
        }

        @keyframes pulse {
            0% {
                opacity: 0.7;
                transform: translate(-50%, -50%) scale(0.6);
            }
            100% {
                opacity: 0;
                transform: translate(-50%, -50%) scale(1.7);
            }
        }

        .hero-card {
            position: absolute;
            bottom: 24px;
            right: 24px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 20px;
            min-width: 190px;
            border: 1px solid var(--map-panel-border);
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.12);
        }

        .hero-card__title {
            color: var(--map-muted);
            font-size: 0.85rem;
        }

        .hero-card__value {
            font-size: 2.0rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin: 6px 0;
        }

        /* ===== LAYOUT ===== */
        .map-layout {
            display: grid;
            grid-template-columns: minmax(0, 3fr) minmax(280px, 2fr);
            gap: 24px;
            margin-bottom: 80px;
        }

        .map-panel,
        .panel-card {
            background: var(--map-panel-bg);
            border: 1px solid var(--map-panel-border);
            border-radius: 28px;
            padding: 24px 24px 22px;
            box-shadow: var(--map-panel-shadow);
        }

        .side-panel {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .map-panel__header {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 16px;
            align-items: center;
        }

        .map-panel__eyebrow,
        .panel-card__eyebrow {
            font-size: 0.8rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: var(--map-muted);
            margin-bottom: 6px;
        }

        .map-panel__sub {
            color: var(--map-muted);
            font-size: 0.9rem;
            margin-top: 4px;
        }

        .map-panel__toolbar {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 16px;
        }

        .toolbar-left {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .toolbar-left label {
            font-size: 0.9rem;
            color: var(--primary-dark);
        }

        .distance-label {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #111827;
        }

        .distance-label-text {
            font-weight: 500;
        }

        .control-box input[type="number"] {
            width: 72px;
            padding: 6px 10px;
            font-size: 14px;
            border-radius: 999px;
            border: 1px solid #d0d4e4;
            background: #ffffff;
            box-shadow: inset 0 1px 2px rgba(15, 23, 42, 0.08);
            text-align: center;
        }

        .control-box input[type="number"]:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow:
                    0 0 0 1px rgba(26, 115, 232, 0.15),
                    inset 0 1px 2px rgba(15, 23, 42, 0.08);
        }

        .control-box input[type="number"]::-webkit-outer-spin-button,
        .control-box input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .control-box input[type="number"] {
            -moz-appearance: textfield;
        }

        .toolbar-right {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            justify-content: flex-end;
        }

        .toolbar-hint {
            color: var(--map-muted);
            font-size: 0.8rem;
        }

        .map-panel__body {
            margin: 18px 0;
        }

        .map-canvas {
            position: relative;
            border-radius: 24px;
            min-height: 420px;
            border: 1px solid var(--map-panel-border);
            background: #e5e7eb;
            overflow: hidden;
        }

        #map {
            position: absolute;
            inset: 0;
            z-index: 1;
        }

        .map-canvas__badge {
            position: absolute;
            top: 16px;
            right: 16px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 8px 14px;
            font-size: 0.85rem;
            color: var(--primary-dark);
            border: 1px solid var(--map-panel-border);
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.15);
            z-index: 10;
        }

        .map-canvas__legend {
            position: absolute;
            bottom: 16px;
            left: 16px;
            font-size: 0.85rem;
            color: var(--primary-dark);
            background: rgba(255, 255, 255, 0.94);
            border-radius: 999px;
            padding: 8px 16px;
            border: 1px solid var(--map-panel-border);
            z-index: 10;
        }

        .map-canvas__legend span {
            color: var(--map-safe);
        }

        .map-panel__footer {
            margin-top: 8px;
        }

        .map-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 14px;
        }

        .map-stats__label {
            color: var(--map-muted);
            font-size: 0.8rem;
        }

        .map-stats__value {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-dark);
        }

        .panel-card__desc {
            color: var(--map-muted);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .btn {
            border-radius: 999px;
            border: 1px solid #e5e7eb;
            padding: 8px 16px;
            font-size: 0.9rem;
            cursor: pointer;
            background: #ffffff;
            color: #111827;
            font-weight: 500;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
        }

        .btn-primary {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #ffffff;
        }

        .btn-secondary {
            background: #e5e7eb;
            border-color: #d1d5db;
            color: #111827;
        }

        .btn-outline {
            background: transparent;
            border-color: #d1d5db;
        }

        .btn-danger {
            background: #fee2e2;
            border-color: #fecaca;
            color: #b91c1c;
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: default;
        }

        .control-box {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            font-size: 14px;
        }

        .control-pill {
            border-radius: 999px;
            padding: 8px 16px;
            border: 1px solid #d0d4e4;
            background: rgba(255,255,255,0.9);
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            color: #1f2933;
            transition: background 0.15s ease, border-color 0.15s ease, color 0.15s ease,
            box-shadow 0.15s ease, transform 0.05s ease;
        }

        .control-pill:hover,
        .control-pill:focus {
            border-color: #1a73e8;
            background: rgba(26,115,232,0.06);
            color: #0f172a;
            box-shadow: 0 0 0 1px rgba(26,115,232,0.15);
        }

        .control-pill:active {
            transform: translateY(1px);
            box-shadow: none;
        }

        .control-pill.primary {
            background: #1a73e8;
            border-color: #1a73e8;
            color: #fff;
            box-shadow: 0 10px 20px rgba(26,115,232,0.25);
        }

        .control-pill.primary:hover,
        .control-pill.primary:focus {
            background: #1557b0;
            border-color: #1557b0;
        }

        .control-pill.is-active {
            background: #1a73e8;
            border-color: #1a73e8;
            color: #fff;
        }

        .pet-box {
            background: #ffffff;
            border-radius: 18px;
            padding: 14px 18px;
            margin-bottom: 12px;
            border: 1px solid rgba(15,23,42,0.08);
            font-size: 14px;
            box-shadow: 0 10px 24px rgba(15,23,42,0.12);
        }

        .pet-box-title {
            font-weight: 700;
            margin-bottom: 4px;
        }

        .pet-box small {
            color: #666;
        }

        .pet-box span.pet-highlight {
            font-weight: 700;
            color: #ff7a00;
        }

        .pet-box .pet-row {
            margin-top: 4px;
        }

        .pet-box button {
            margin-top: 8px;
        }

        #voiceRouteAudio {
            display: none;
        }

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .modal-content {
            background: #ffffff;
            border-radius: 20px;
            padding: 24px 26px;
            max-width: 420px;
            width: 90%;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.28);
        }

        .modal-content h3 {
            margin: 0 0 8px;
            font-size: 1.4rem;
        }

        .modal-content p {
            margin: 4px 0;
            font-size: 0.95rem;
        }

        .modal-actions {
            margin-top: 18px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        @media (max-width: 960px) {
            .map-layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .map-hero {
                padding-top: 60px;
            }

            .map-hero__actions {
                flex-direction: column;
            }

            .map-hero__actions .btn {
                width: 100%;
            }

            .map-panel,
            .panel-card {
                border-radius: 22px;
                padding: 20px;
            }

            .map-canvas {
                min-height: 320px;
            }
        }
    </style>
</head>
<body>

<section class="map-hero">
    <div class="map-hero__content">
        <p class="map-hero__eyebrow">Pet Walking Experience</p>
        <h1 class="map-hero__title">내 주변 모양별 산책 코스</h1>
        <p class="map-hero__desc">
            현재 위치를 기준으로 예쁜 도형 모양 산책 코스를 자동으로 만들어줘요.
            반려동물 정보 기반 AI 제시 거리, 음성으로 코스 요청, 저장된 코스 네비게이션까지
            한 화면에서 이용해 보세요.
        </p>
        <div class="map-hero__actions">
            <button type="button" class="btn btn-primary btn-lg" id="mockMapClick">
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

<section class="map-layout" id="mapLayout">
    <div class="map-panel">
        <div id="setupHeader" class="map-panel__header">
            <div>
                <p class="map-panel__eyebrow">AI Assisted Walk</p>
                <h2>모양별 산책 코스 설정</h2>
                <p class="map-panel__sub">목표 거리를 정하고, 내 위치 기준으로 도형 코스를 생성해 보세요.<br>
                도로가 많은 위치에서 목표거리를 5~10km로 설정 후 도형 생성시 제일 예쁜 모양이 나와요.</p>
            </div>
        </div>

        <div id="navHeader" class="map-panel__header" style="display:none;">
            <div>
                <p class="map-panel__eyebrow">Live Navigation</p>
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

        <div id="setupToolbar" class="map-panel__toolbar">
            <div class="control-box">
                <label>
                    목표 거리(km):
                    <input id="targetKmInput" type="number" step="0.1" value="8.0">
                </label>

                <!-- 모양 선택 -->
                <div style="display:flex; gap:6px; flex-wrap:wrap;">
                    <button type="button"
                            class="control-pill shape-pill is-active"
                            data-shape="heart"
                            onclick="setShapeType('heart')">
                        하트
                    </button>
                    <button type="button"
                            class="control-pill shape-pill"
                            data-shape="circle"
                            onclick="setShapeType('circle')">
                        원
                    </button>
                    <button type="button"
                            class="control-pill shape-pill"
                            data-shape="square"
                            onclick="setShapeType('square')">
                        네모
                    </button>
                    <button type="button"
                            class="control-pill shape-pill"
                            data-shape="triangle"
                            onclick="setShapeType('triangle')">
                        세모
                    </button>
                </div>

                <button type="button" class="control-pill primary"
                        onclick="reloadRoute()">코스 다시 생성</button>

                <button type="button" class="control-pill"
                        onclick="openSavedCourseModal()">저장된 코스 불러오기</button>

                <button type="button" class="control-pill"
                        id="voiceBtn">음성으로 요청</button>
                <span id="voiceSpinner" style="visibility:hidden;">녹음/처리중...</span>

                <button type="button" class="control-pill primary"
                        onclick="goNavigation()">네비게이션 시작</button>
            </div>
        </div>

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

        <div class="map-panel__body">
            <div class="map-canvas">
                <div id="map" aria-label="산책 지도"></div>
                <div class="map-canvas__badge" id="mapSelectionBadge">
                    내 위치 기준 도형 코스 준비 중...
                </div>
<%--                <div class="map-canvas__legend">--%>
<%--                    <span>●</span> 코스 전체 &nbsp;|&nbsp; <span>●</span> 진행한 구간(초록색)--%>
<%--                </div>--%>
            </div>
        </div>

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

    <div class="side-panel">
        <div id="setupSidePanels">
            <article class="panel-card">
                <header>
                    <p class="panel-card__eyebrow">Pet Recommendation</p>
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
                        <button type="button" class="btn btn-primary btn-sm" id="petApplyBtn" disabled>
                            제시된 거리로 코스 생성
                        </button>
                    </div>

                    <div id="petErrorText" style="display:none; color:#d9534f;">
                        반려동물 정보를 불러오지 못했습니다. 나중에 다시 시도해주세요.
                    </div>
                </div>
            </article>
        </div>

        <div id="navSidePanels" style="display:none;">
            <article class="panel-card">
                <header>
                    <p class="panel-card__eyebrow">Walk Status</p>
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

<div id="savedCourseModal" class="modal-overlay">
    <div class="modal-content">
        <h3>저장된 코스 불러오기</h3>
        <div id="savedCourseList"
             style="max-height:300px; overflow-y:auto; text-align:left; font-size:14px; margin-top:8px;">
        </div>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary btn-sm" onclick="closeSavedCourseModal()">닫기</button>
        </div>
    </div>
</div>

<div id="finishModal" class="modal-overlay">
    <div class="modal-content">
        <h3>오늘 산책 완료!</h3>
        <p id="finishMessageMain">수고하셨어요 🎉</p>
        <p id="finishMessageSub" style="font-size: 14px; color:#555;"></p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary btn-sm" onclick="closeFinishModal()">확인</button>
            <button type="button" class="btn btn-primary btn-sm" onclick="saveCourse()">코스 저장하기</button>
        </div>
    </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
        crossorigin=""></script>

<script>
    const DEFAULT_CENTER_LAT = 36.777381;
    const DEFAULT_CENTER_LON = 127.001764;

    let centerLat = DEFAULT_CENTER_LAT;
    let centerLon = DEFAULT_CENTER_LON;

    let map;
    let currentPolyline = null;
    let progressPolyline = null;
    let userMarker = null;

    let lastDistanceKm = null;
    let lastEstimatedMinutes = null;
    let lastRouteData = null;

    let selectedSavedLogId = null;

    // heart / circle / square / triangle
    let currentShapeType = 'heart';

    let routeLatLngs = [];
    let cumulativeMeters = [];
    let totalMeters = 0;
    let walkingStartedAt = null;
    let walkedMeters = 0;

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
        document.getElementById('setupSidePanels').style.display = '';

        document.getElementById('navHeader').style.display = 'none';
        document.getElementById('navToolbar').style.display = 'none';
        document.getElementById('navFooter').style.display = 'none';
        document.getElementById('navSidePanels').style.display = 'none';

        document.getElementById('mapSelectionBadge').textContent = '내 위치 기준 코스 준비 중...';
    }

    function enterNavMode() {
        document.getElementById('setupHeader').style.display = 'none';
        document.getElementById('setupToolbar').style.display = 'none';
        document.getElementById('setupFooter').style.display = 'none';
        document.getElementById('setupSidePanels').style.display = 'none';

        document.getElementById('navHeader').style.display = '';
        document.getElementById('navToolbar').style.display = '';
        document.getElementById('navFooter').style.display = '';
        document.getElementById('navSidePanels').style.display = '';

        document.getElementById('mapSelectionBadge').textContent = '코스를 따라가며 산책 중...';
    }

    function initMap() {
        map = L.map('map').setView([centerLat, centerLon], 14);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);
    }

    function initUserLocation() {
        if (!navigator.geolocation) {
            console.warn('이 브라우저는 Geolocation을 지원하지 않습니다.');
            reloadRoute();
            return;
        }

        navigator.geolocation.getCurrentPosition(
            (pos) => {
                centerLat = pos.coords.latitude;
                centerLon = pos.coords.longitude;

                map.setView([centerLat, centerLon], 15);

                userMarker = L.marker([centerLat, centerLon], {
                    title: '내 현재 위치',
                    icon: userIcon
                }).addTo(map);

                navigator.geolocation.watchPosition(
                    (p) => {
                        const lat = p.coords.latitude;
                        const lon = p.coords.longitude;
                        if (userMarker) {
                            userMarker.setLatLng([lat, lon]);
                        }
                    },
                    (err) => {
                        console.warn('현재 위치를 가져오지 못했습니다.', err);
                    },
                    {
                        enableHighAccuracy: true,
                        maximumAge: 2000,
                        timeout: 10000
                    }
                );

                reloadRoute();
            },
            (err) => {
                console.warn('초기 위치를 가져오지 못했습니다. 기본 위치로 코스 생성.', err);
                reloadRoute();
            },
            {
                enableHighAccuracy: true,
                maximumAge: 0,
                timeout: 15000
            }
        );
    }

    function applyRouteData(data) {
        if (!data || !data.points || data.points.length === 0) return;

        lastRouteData = data;

        const latlngs = data.points.map(p => [p.lat, p.lon]);

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
            '&centerLat=' + centerLat +
            '&centerLon=' + centerLon +
            '&targetKm=' + targetKm;

        fetch(url)
            .then(res => res.json())
            .then(data => applyRouteData(data))
            .catch(err => console.error('경로 로딩 실패', err));
    }

    function distanceMeters(lat1, lon1, lat2, lon2) {
        const R = 6371000;
        const toRad = Math.PI / 180;
        const dLat = (lat2 - lat1) * toRad;
        const dLon = (lon2 - lon1) * toRad;
        const a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * toRad) * Math.cos(lat2 * toRad) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    function prepareRouteForNavigation(data) {
        routeLatLngs = data.points.map(p => [p.lat, p.lon]);

        cumulativeMeters = [0];
        totalMeters = 0;
        walkingStartedAt = null;
        walkedMeters = 0;

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
        if (!routeLatLngs || routeLatLngs.length === 0) return;

        let bestIdx = 0;
        let bestDist = Infinity;

        for (let i = 0; i < routeLatLngs.length; i++) {
            const [rlat, rlon] = routeLatLngs[i];
            const d = distanceMeters(lat, lon, rlat, rlon);
            if (d < bestDist) {
                bestDist = d;
                bestIdx = i;
            }
        }

        const onRoute = bestDist < 25;

        const progress = (totalMeters > 0)
            ? (cumulativeMeters[bestIdx] / totalMeters)
            : 0.0;

        walkedMeters = cumulativeMeters[bestIdx];

        const progressPercent = (progress * 100);
        document.getElementById('navProgress').textContent = progressPercent.toFixed(1) + '%';
        document.getElementById('sideNavProgress').textContent = progressPercent.toFixed(1) + '%';

        const statusText = onRoute
            ? '코스 위에서 걷는 중 (오차 ~' + bestDist.toFixed(0) + 'm)'
            : '코스에서 약 ' + bestDist.toFixed(0) + 'm 벗어났어요';

        document.getElementById('navStatus').textContent = statusText;
        document.getElementById('sideNavStatus').textContent = statusText;

        if (progressPolyline) {
            map.removeLayer(progressPolyline);
        }
        if (bestIdx > 0) {
            const walked = routeLatLngs.slice(0, bestIdx + 1);
            progressPolyline = L.polyline(walked, {weight: 6, color: '#4caf50'}).addTo(map);
        }

        map.setView([lat, lon], 16);

        const walkedKm = walkedMeters / 1000;
        document.getElementById('navWalkedKm').textContent = walkedKm.toFixed(2) + ' km';

        if (walkingStartedAt) {
            const now = new Date();
            const minutes = Math.max(1, Math.round((now - walkingStartedAt) / 60000));
            document.getElementById('navElapsedMin').textContent = minutes + ' 분';
        }
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
                    '&centerLat=' + centerLat +
                    '&centerLon=' + centerLon +
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

    document.addEventListener('DOMContentLoaded', () => {
        const mapLayout = document.getElementById('mapLayout');
        const summarySection = document.getElementById('summarySection');
        const mockBtn = document.getElementById('mockMapClick');
        const scrollSummaryBtn = document.getElementById('scrollToSummary');

        if (mockBtn && mapLayout) {
            mockBtn.addEventListener('click', () => {
                mapLayout.scrollIntoView({behavior: 'smooth'});
            });
        }
        if (scrollSummaryBtn && summarySection) {
            scrollSummaryBtn.addEventListener('click', () => {
                summarySection.scrollIntoView({behavior: 'smooth'});
            });
        }
    });
</script>

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
            formData.append('centerLat', centerLat);
            formData.append('centerLon', centerLon);

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
                listDiv.appendChild(ul);
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

<script>
    async function loadPetWalkRecommendation() {
        const loadingText      = document.getElementById('petLoadingText');
        const contentBox       = document.getElementById('petContent');
        const errorText        = document.getElementById('petErrorText');
        const infoText         = document.getElementById('petInfoText');
        const reasonText       = document.getElementById('petReasonText');
        const recommendKmSpan  = document.getElementById('petRecommendKm');
        const applyBtn         = document.getElementById('petApplyBtn');

        loadingText.style.display = 'block';
        contentBox.style.display  = 'none';
        errorText.style.display   = 'none';
        applyBtn.disabled         = true;

        try {
            const res = await fetch('/api/pet/walk-recommend');
            if (!res.ok) {
                throw new Error('pet recommend error');
            }

            const data = await res.json();

            const pet = data.pet || {};

            const name    = pet.petName || '이름 미등록';
            const species = pet.species || '종 미등록';
            const age     = (pet.age !== null && pet.age !== undefined) ? pet.age : '?';
            const gender  = pet.gender || '성별 미등록';

            let weightText;
            if (typeof pet.weight === 'number') {
                weightText = pet.weight.toFixed(1) + 'kg';
            } else if (pet.weight) {
                weightText = pet.weight + 'kg';
            } else {
                weightText = '체중 미등록';
            }

            infoText.textContent =
                `${name} (${species}, ${age}살, ${gender}, 약 ${weightText})`;

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

            applyBtn.dataset.recommendKm = km;
            applyBtn.disabled = false;

            loadingText.style.display = 'none';
            contentBox.style.display  = 'block';
        } catch (e) {
            console.error(e);
            loadingText.style.display = 'none';
            errorText.style.display   = 'block';
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const applyBtn = document.getElementById('petApplyBtn');
        applyBtn.addEventListener('click', () => {
            const km = parseFloat(applyBtn.dataset.recommendKm || '0');
            if (!km || km <= 0) return;

            const input = document.getElementById('targetKmInput');
            input.value = km.toFixed(1);

            reloadRoute();
        });
    });
</script>

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
        if (!routeLatLngs || routeLatLngs.length === 0) {
            alert('저장할 코스가 없습니다.');
            return;
        }

        const distanceKm = window._finishDistanceKm || (totalMeters / 1000.0);
        const now = new Date();
        const startIso = (walkingStartedAt || now).toISOString();
        const endIso = now.toISOString();

        const body = {
            distanceKm: distanceKm,
            startTimeIso: startIso,
            endTimeIso: endIso,
            points: routeLatLngs.map(ll => ({ lat: ll[0], lon: ll[1] }))
        };

        try {
            const res = await fetch('/api/walk/logs', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });

            if (!res.ok) {
                throw new Error('save error');
            }

            const data = await res.json();
            console.log('saveCourse result', data);
            alert('코스를 저장했습니다.');
            closeFinishModal();
        } catch (e) {
            console.error(e);
            alert('코스 저장 중 오류가 발생했습니다.');
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

<script>
    window.addEventListener('load', () => {
        initMap();
        // initUserLocation();      // 실제 geolocation으로 하는ㄱ
        reloadRoute();              // test용
        loadPetWalkRecommendation();
        enterSetupMode();
    });
</script>

</body>
</html>
