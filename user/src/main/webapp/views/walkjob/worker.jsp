<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet"
      href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<style>
  /* ===== 공통 팔레트 (산책 알바 매칭 톤) ===== */
  .walkjob-worker-page {
    --wj-bg: #f3f4f6;
    --wj-card: #ffffff;
    --wj-border-soft: #e5e7eb;
    --wj-shadow-soft: 0 18px 40px rgba(15, 23, 42, 0.06);

    --wj-primary: #10b981;
    --wj-primary-soft: #dcfce7;
    --wj-accent: #f97373;
    --wj-accent-soft: #fee2e2;
    --wj-info: #2563eb;
    --wj-muted: #6b7280;
    --wj-title: #111827;
  }

  /* ✔ index.jsp의 body, .container 를 건드리지 않고
     이 페이지 전용 래퍼 클래스만 사용 */
  .walkjob-worker-page {
    width: min(960px, 94vw);
    margin: 40px auto 80px;
    padding: 24px 26px 28px;
    border-radius: 28px;
    background: var(--wj-card);
    box-shadow: var(--wj-shadow-soft);
    border: 1px solid var(--wj-border-soft);
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  }

  .walkjob-worker-header {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    align-items: center;
    margin-bottom: 18px;
  }

  .walkjob-worker-header-left h1 {
    margin: 4px 0 6px;
    font-size: 1.6rem;
    font-weight: 700;
    color: var(--wj-title);
  }

  .walkjob-worker-header-left p {
    margin: 0;
    font-size: 0.9rem;
    color: var(--wj-muted);
  }

  .walkjob-worker-header-right {
    text-align: right;
  }

  .walkjob-worker-page .badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 999px;
    font-size: 0.75rem;
    background: #dbeafe;
    color: #1d4ed8;
    font-weight: 600;
  }

  .walkjob-worker-page .badge::before {
    content: "🦮";
    font-size: 0.95rem;
  }

  .walkjob-worker-sublabel {
    font-size: 0.8rem;
    color: var(--wj-muted);
    padding: 4px 10px;
    border-radius: 999px;
    background: #f9fafb;
    border: 1px dashed #d1d5db;
    display: inline-block;
    margin-top: 4px;
  }

  .walkjob-worker-page .pet-info-card {
    margin-top: 10px;
    padding: 14px 18px;
    border-radius: 18px;
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    box-shadow: 0 10px 24px rgba(15,23,42,0.06);
    font-size: 0.9rem;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .pet-info-title-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    margin-bottom: 4px;
  }

  .walkjob-worker-page .pet-info-card h2 {
    margin: 0;
    font-size: 1rem;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .walkjob-worker-page .pet-info-card h2::before {
    content: "🐾";
    font-size: 1.05rem;
  }

  .walkjob-worker-page .pet-info-chip {
    font-size: 0.78rem;
    padding: 4px 10px;
    border-radius: 999px;
    background: #eef2ff;
    color: #4f46e5;
  }

  .walkjob-worker-page .pet-info-card strong {
    font-weight: 600;
  }

  .walkjob-worker-page .pet-info-card p {
    margin: 0;
  }

  .walkjob-worker-page .map-wrap {
    margin-top: 16px;
    border-radius: 22px;
    overflow: hidden;
    border: 1px solid #e5e7eb;
    box-shadow: 0 12px 30px rgba(15,23,42,0.12);
  }

  .walkjob-worker-page #map {
    height: 420px;
  }

  /* ===== 컨트롤 + 상태 ===== */
  .walkjob-worker-page .controls-row {
    margin-top: 16px;
    display: flex;
    justify-content: space-between;
    gap: 16px;
    flex-wrap: wrap;
    align-items: center;
  }

  .walkjob-worker-page .controls {
    display: flex;
    gap: 10px;
    align-items: center;
    flex-wrap: wrap;
  }

  .walkjob-worker-page .btn {
    border-radius: 999px;
    border: 1px solid #d1d5db;
    padding: 8px 16px;
    font-size: 0.9rem;
    cursor: pointer;
    background: #fff;
    font-weight: 500;
    transition: transform 0.05s ease, box-shadow 0.1s ease, background 0.1s ease;
  }

  .walkjob-worker-page .btn:hover:enabled {
    transform: translateY(-1px);
    box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12);
  }

  .walkjob-worker-page .btn:disabled {
    opacity: 0.55;
    cursor: default;
    box-shadow: none;
  }

  .walkjob-worker-page .btn-primary {
    background: #22c55e;
    border-color: #16a34a;
    color: white;
  }

  .walkjob-worker-page .btn-danger {
    background: #ef4444;
    border-color: #b91c1c;
    color: #fff;
  }

  .walkjob-worker-page .status-box {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.86rem;
  }

  .walkjob-worker-page .status-label {
    color: var(--wj-muted);
    font-weight: 500;
  }

  .walkjob-worker-page .status-pill {
    padding: 6px 12px;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 600;
    border: 1px solid transparent;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }

  .walkjob-worker-page .status-pill::before {
    content: "●";
    font-size: 0.55rem;
  }

  .walkjob-worker-page .status-waiting {
    background: var(--wj-accent-soft);
    border-color: #fecaca;
    color: #b91c1c;
  }

  .walkjob-worker-page .status-active {
    background: var(--wj-primary-soft);
    border-color: #bbf7d0;
    color: var(--wj-primary);
  }

  .walkjob-worker-page .status-end {
    background: #e0f2fe;
    border-color: #bfdbfe;
    color: #1d4ed8;
  }

  .walkjob-worker-page .status-error {
    background: #fee2e2;
    border-color: #fecaca;
    color: #b91c1c;
  }

  /* ===== 통계 카드 ===== */
  .walkjob-worker-footer {
    margin-top: 18px;
  }

  .walkjob-worker-page .stats {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
    font-size: 0.9rem;
  }

  .walkjob-worker-page .stat-card {
    flex: 1 1 120px;
    min-width: 120px;
    padding: 10px 12px;
    border-radius: 14px;
    background: #f9fafb;
    border: 1px solid #e5e7eb;
  }

  .walkjob-worker-page .stat-label {
    font-size: 0.8rem;
    color: var(--wj-muted);
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .walkjob-worker-page .stat-label span.icon {
    font-size: 1rem;
  }

  .walkjob-worker-page .stat-value {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--wj-title);
  }

  .walkjob-worker-page .stat-card.dist .stat-value { color: var(--wj-primary); }
  .walkjob-worker-page .stat-card.time .stat-value { color: var(--wj-info); }
  .walkjob-worker-page .stat-card.kcal .stat-value { color: #f97316; }
  .walkjob-worker-page .stat-card.pace .stat-value { color: #ec4899; }

  .walkjob-worker-page .note {
    margin-top: 10px;
    font-size: 0.8rem;
    color: #6b7280;
  }

  @media (max-width: 768px) {
    .walkjob-worker-page {
      padding: 18px 16px 22px;
      border-radius: 20px;
    }
    .walkjob-worker-header {
      flex-direction: column;
      align-items: flex-start;
    }
    .walkjob-worker-header-right {
      text-align: left;
    }
    .walkjob-worker-page .controls-row {
      flex-direction: column;
      align-items: flex-start;
    }
    .walkjob-worker-page .pet-info-card {
      padding: 12px 14px;
    }
  }
</style>

<br>
<div class="walkjob-worker-page">
  <header class="walkjob-worker-header">
    <div class="walkjob-worker-header-left">
      <div class="badge">산책 알바 · 알바생 화면</div>
      <h1>반려동물과 산책하기</h1>
      <p>산책 시작을 누르면 이동 경로와 거리 정보가 반려인 화면으로 실시간 전송됩니다.</p>
    </div>
    <div class="walkjob-worker-header-right">
      <div class="walkjob-worker-sublabel">
        산책 전 반려동물 정보를 확인하고, 추천 거리 안에서 안전하게 산책해 주세요.
      </div>
    </div>
  </header>

  <div class="map-wrap">
    <div id="map"></div>
  </div>

  <div class="controls-row">
    <div class="controls">
      <button id="startBtn" class="btn btn-primary">산책 시작</button>
      <button id="stopBtn" class="btn btn-danger" disabled>산책 종료</button>
    </div>
    <div class="status-box">
      <span class="status-label">상태</span>
      <span id="statusText" class="status-pill status-waiting">대기 중...</span>
    </div>
  </div>

  <div class="walkjob-worker-footer">
    <div class="stats">
      <div class="stat-card dist">
        <p class="stat-label"><span class="icon">📏</span>걸은 거리</p>
        <p class="stat-value"><span id="distLabel">0.00 km</span></p>
      </div>
      <div class="stat-card time">
        <p class="stat-label"><span class="icon">⏱</span>경과 시간</p>
        <p class="stat-value"><span id="timeLabel">0초</span></p>
      </div>
      <div class="stat-card kcal">
        <p class="stat-label"><span class="icon">🔥</span>소모 칼로리</p>
        <p class="stat-value"><span id="kcalLabel">0 kcal</span></p>
      </div>
      <div class="stat-card pace">
        <p class="stat-label"><span class="icon">🚶‍♂️</span>평균 페이스</p>
        <p class="stat-value"><span id="paceLabel">0'00"/km</span></p>
      </div>
    </div>

    <p class="note">
      위치 권한 허용이 필요합니다. GPS 상태에 따라 실제 거리와 일부 차이가 발생할 수 있습니다.
    </p>
  </div>
</div>

<!-- ★ 산책 종료 후 요약 모달 -->
<div id="walkjobFinishSummaryModal"
     style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); z-index:10000;
            align-items:center; justify-content:center;">
  <div style="background:#fff; padding:20px 24px; border-radius:16px; max-width:320px; width:90%;">
    <h3 style="margin-top:0; margin-bottom:10px; font-size:1.1rem;">산책이 끝났습니다!</h3>
    <p id="walkjobFinishSummaryText"
       style="font-size:0.9rem; color:#374151; margin-bottom:16px;">
      거리 0.00 km, 소요시간 0초, 칼로리 0 kcal
    </p>
    <div style="display:flex; justify-content:flex-end; gap:8px;">
      <button id="walkjobFinishSummaryOkBtn"
              style="padding:6px 12px; border-radius:999px; border:none; background:#2563eb; color:#fff;">
        확인
      </button>
    </div>
  </div>
</div>

<script>
  const OWNER_USER_ID = ${ownerUserId != null ? ownerUserId : -1};
</script>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
  let map, userMarker, routePolyline;
  let watchId = null;
  let isWalking = false;
  let startTime = null;
  let lastLat = null, lastLon = null;
  let distanceMeters = 0;
  let routePoints = [];

  // ★ 반려인이 pet을 선택했는지 여부
  let petSelected = false;

  // ★ 1초마다 UI/서버 갱신용 타이머
  let tickTimerId = null;

  const AVG_WEIGHT_KG = 70;
  const WALK_MET = 3.5;

  function calcKcal(distanceKm, elapsedSec) {
    if (!distanceKm || !elapsedSec) return 0;
    const hours = elapsedSec / 3600;
    return WALK_MET * AVG_WEIGHT_KG * hours;
  }

  function formatPace(distanceKm, elapsedSec) {
    if (!distanceKm || distanceKm <= 0 || !elapsedSec || elapsedSec <= 0) return '-';
    const paceSecPerKm = elapsedSec / distanceKm;
    const min = Math.floor(paceSecPerKm / 60);
    const sec = Math.round(paceSecPerKm % 60);
    const secStr = String(sec).padStart(2, '0');
    return `${min}'${secStr}"/km`;
  }

  function formatDuration(sec) {
    if (!sec || sec <= 0) return "0초";
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    if (m <= 0) return `${s}초`;
    return `${m}분 ${s}초`;
  }

  function initMap() {
    map = L.map('map').setView([36.777381, 127.001764], 15);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(map);
  }

  function redirectToChatRoom() {
    window.location.href = '<c:url value="/chat/list"/>';
  }

  function showFinishSummary(distanceKm, elapsedSec) {
    const modal = document.getElementById('walkjobFinishSummaryModal');
    const textEl = document.getElementById('walkjobFinishSummaryText');
    const kcal = calcKcal(distanceKm, elapsedSec);
    const timeStr = formatDuration(elapsedSec);

    textEl.textContent =
            `거리 ${distanceKm.toFixed(2)} km, 소요시간 ${timeStr}, 칼로리 약 ${kcal.toFixed(0)} kcal`;
    modal.style.display = 'flex';
  }

  // 하버사인으로 두 좌표 간 거리(m) 계산
  function distanceMetersH(lat1, lon1, lat2, lon2) {
    const R = 6371000;
    const toRad = x => x * Math.PI / 180;
    const φ1 = toRad(lat1);
    const φ2 = toRad(lat2);
    const Δφ = toRad(lat2 - lat1);
    const Δλ = toRad(lon2 - lon1);
    const a =
            Math.sin(Δφ/2) * Math.sin(Δφ/2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
  }

  // 서버로 현재 위치/거리 전송 → SSE로 반려인에게 브로드캐스트됨
  async function sendUpdate(lat, lon, elapsedSec) {
    if (!isWalking) return;
    if (lat == null || lon == null) return;

    const body = {
      lat: lat,
      lon: lon,
      distanceKm: distanceMeters / 1000.0,
      elapsedSec: elapsedSec
    };

    try {
      await fetch('<c:url value="/api/walkjob/update"/>', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });
    } catch (e) {
      console.error(e);
    }
  }

  // ★ 1초마다 호출되는 타이머: UI + 서버 전송
  function startTickTimer() {
    if (tickTimerId != null) {
      clearInterval(tickTimerId);
    }
    tickTimerId = setInterval(() => {
      if (!isWalking || !startTime) return;

      const now = new Date();
      const elapsedSec = Math.round((now - startTime) / 1000);
      const distKm = distanceMeters / 1000.0;

      // 1) 알바생 화면 UI 갱신
      document.getElementById('distLabel').textContent = distKm.toFixed(2) + ' km';
      document.getElementById('timeLabel').textContent = elapsedSec + '초';

      const kcal = calcKcal(distKm, elapsedSec);
      document.getElementById('kcalLabel').textContent = kcal.toFixed(0) + ' kcal';
      document.getElementById('paceLabel').textContent = formatPace(distKm, elapsedSec);

      // 2) 3초에 한 번 정도씩 서버에도 상태 전송
      if (elapsedSec % 3 === 0 && lastLat != null && lastLon != null) {
        sendUpdate(lastLat, lastLon, elapsedSec);
      }
    }, 1000);
  }

  function stopTickTimer() {
    if (tickTimerId != null) {
      clearInterval(tickTimerId);
      tickTimerId = null;
    }
  }

  function startWalk() {
    // ★ 반려인이 pet을 아직 선택하지 않았다면 시작 불가
    if (!petSelected) {
      alert('반려인이 오늘 산책할 반려동물을 아직 선택하지 않았습니다.\n반려인에게 먼저 반려동물 선택을 요청해 주세요.');
      return;
    }

    if (!navigator.geolocation) {
      alert('이 브라우저는 위치 정보를 지원하지 않습니다.');
      return;
    }
    if (isWalking) return;

    isWalking = true;
    startTime = new Date();
    distanceMeters = 0;
    routePoints = [];
    lastLat = lastLon = null;

    document.getElementById('startBtn').disabled = true;
    document.getElementById('stopBtn').disabled = false;

    const statusEl = document.getElementById('statusText');
    statusEl.textContent = '산책 중...';
    statusEl.className = 'status-pill status-active';

    // 표시 리셋
    document.getElementById('distLabel').textContent = '0.00 km';
    document.getElementById('timeLabel').textContent = '0초';
    document.getElementById('kcalLabel').textContent = '0 kcal';
    document.getElementById('paceLabel').textContent = '0\'00"/km';

    // ★ 1초마다 UI/서버 갱신 시작
    startTickTimer();

    // ★ GPS는 "거리/경로/지도"만 담당
    watchId = navigator.geolocation.watchPosition(
            (pos) => {
              const lat = pos.coords.latitude;
              const lon = pos.coords.longitude;

              if (lastLat !== null && lastLon !== null) {
                const d = distanceMetersH(lastLat, lastLon, lat, lon);
                if (d > 2) { // 2m 이하 잡음 제거
                  distanceMeters += d;
                }
              }

              lastLat = lat;
              lastLon = lon;
              routePoints.push([lat, lon]);

              // 지도 갱신
              if (!userMarker) {
                userMarker = L.marker([lat, lon]).addTo(map);
              } else {
                userMarker.setLatLng([lat, lon]);
              }
              if (!routePolyline) {
                routePolyline = L.polyline(routePoints, {weight: 5, color: '#10b981'}).addTo(map);
              } else {
                routePolyline.setLatLngs(routePoints);
              }
              map.setView([lat, lon], 16);
            },
            (err) => {
              console.warn('위치 추적 실패', err);
              const statusEl = document.getElementById('statusText');
              statusEl.textContent = '위치 추적 실패';
              statusEl.className = 'status-pill status-error';
            },
            {
              enableHighAccuracy: true,
              maximumAge: 3000,
              timeout: 10000
            }
    );
  }

  // 🔴 “산책 종료 요청만 보내고 실제 종료는 안 하는” 부분 (기존 로직 유지)
  async function stopWalk() {
    if (!isWalking) {
      // 이미 산책 중이 아니면 아무 것도 안 함
      return;
    }

    const statusEl = document.getElementById('statusText');
    statusEl.textContent = '산책 종료 요청 중 (반려인 승인 대기)...';
    statusEl.className = 'status-pill status-end';

    try {
      const res = await fetch('<c:url value="/api/walkjob/finish-request"/>', {
        method: 'POST'
      });
      if (!res.ok) throw new Error('finish-request error');

      alert('반려인에게 산책 종료 요청을 보냈습니다.\n반려인이 승인하면 산책이 종료됩니다.');
    } catch (e) {
      console.error(e);
      alert('산책 종료 요청 중 오류가 발생했습니다.');
      statusEl.className = 'status-pill status-error';
      statusEl.textContent = '종료 요청 실패 (다시 시도해 주세요)';
    }
  }

  // 🔹 알바생 화면 진입 시 반려인의 반려동물 정보 + 추천 거리 불러오기 (기존 기능 그대로)
  async function loadOwnerPetRecommend() {
    const infoEl = document.getElementById('petInfoText');
    const recommendEl = document.getElementById('petRecommendKm');
    const reasonEl = document.getElementById('petReasonText');

    if (!infoEl || !recommendEl || !reasonEl) {
      // 해당 섹션이 주석 처리된 경우 그냥 리턴
      return;
    }

    if (typeof OWNER_USER_ID === 'undefined' || OWNER_USER_ID <= 0) {
      infoEl.textContent = '연결된 반려인 정보가 없어 반려동물 정보를 불러올 수 없습니다.';
      recommendEl.textContent = '- km';
      reasonEl.textContent = '';
      return;
    }

    infoEl.textContent = '반려동물 정보를 불러오는 중입니다...';
    recommendEl.textContent = '- km';
    reasonEl.textContent = '';

    try {
      const url = '<c:url value="/api/pet/walk-recommend/for-user"/>' + '/' + OWNER_USER_ID;
      const res = await fetch(url);
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

      const ageText =
              (pet.age !== null && pet.age !== undefined) ? pet.age + '살' : '나이 미등록';
      const genderText = pet.gender || '성별 미등록';

      let weightText;
      if (typeof pet.weight === 'number') {
        weightText = pet.weight.toFixed(1) + 'kg';
      } else if (pet.weight) {
        weightText = pet.weight + 'kg';
      } else {
        weightText = '체중 미등록';
      }

      infoEl.textContent =
              `${name} (${speciesText}, ${ageText}, ${genderText}, 약 ${weightText})`;

      let km = 0;
      if (typeof data.recommendedKm === 'number' && !isNaN(data.recommendedKm)) {
        km = data.recommendedKm;
      }
      recommendEl.textContent = km > 0 ? km.toFixed(1) + ' km' : '- km';

      reasonEl.textContent =
              data.reason || 'AI가 반려동물 정보를 바탕으로 산책 거리를 추천했습니다.';
    } catch (e) {
      console.error(e);
      infoEl.textContent = '반려동물 정보를 불러오지 못했습니다.';
      recommendEl.textContent = '- km';
      reasonEl.textContent = '나중에 다시 시도해 주세요.';
    }
  }

  // 🔹 알바생용 SSE – 반려인이 "예" 눌러서 실제 산책 종료가 확정되면 받는 채널
  function connectWorkerSse() {
    const eventSource = new EventSource('<c:url value="/api/walkjob/worker-stream"/>');
    const statusEl = document.getElementById('statusText');

    // ★ 반려인이 pet 선택하면 petSelected 이벤트 수신
    eventSource.addEventListener('petSelected', (e) => {
      const data = JSON.parse(e.data); // {petId, name}
      petSelected = true;
      if (statusEl) {
        statusEl.textContent = `반려동물 선택 완료: ${data.name}`;
        statusEl.className = 'status-pill status-waiting';
      }
    });

    eventSource.addEventListener('finish', (e) => {
      const data = JSON.parse(e.data);

      // 🔸 타이머/위치 추적 정지
      isWalking = false;
      stopTickTimer();
      if (watchId != null) {
        navigator.geolocation.clearWatch(watchId);
        watchId = null;
      }

      const distKm = data.distanceKm || 0;
      const elapsedSec = data.elapsedSec || 0;

      distanceMeters = distKm * 1000;
      routePoints = (data.points || []).map(p => [p.lat, p.lon]);

      // UI 수치 갱신
      document.getElementById('distLabel').textContent = distKm.toFixed(2) + ' km';
      document.getElementById('timeLabel').textContent = elapsedSec + '초';
      const kcal = calcKcal(distKm, elapsedSec);
      document.getElementById('kcalLabel').textContent = kcal.toFixed(0) + ' kcal';
      document.getElementById('paceLabel').textContent = formatPace(distKm, elapsedSec);

      // 지도 그리기
      if (routePoints.length > 0) {
        if (!routePolyline) {
          routePolyline = L.polyline(routePoints, {weight: 5, color: '#10b981'}).addTo(map);
        } else {
          routePolyline.setLatLngs(routePoints);
        }
        const last = routePoints[routePoints.length - 1];
        if (!userMarker) {
          userMarker = L.marker(last).addTo(map);
        } else {
          userMarker.setLatLng(last);
        }
        map.setView(last, 16);
      }

      statusEl.textContent = '산책 종료!';
      statusEl.className = 'status-pill status-end';

      document.getElementById('startBtn').disabled = false;
      document.getElementById('stopBtn').disabled = true;

      eventSource.close();

      // ★ 요약 모달 표시 후 확인 시 채팅방으로 이동
      showFinishSummary(distKm, elapsedSec);
    });

    eventSource.onerror = (e) => {
      console.error('worker SSE error', e);
    };
  }

  // 🔹 페이지 재진입 시 진행 중 산책 복구 + pet 선택 여부 확인
  async function restoreWalkIfExists() {
    try {
      const res = await fetch('<c:url value="/api/walkjob/state"/>');
      if (!res.ok) return;
      const snap = await res.json();

      if (!snap || !snap.status) return;

      // ★ petId가 이미 선택된 상태라면 플래그 세팅
      if (snap.petId != null) {
        petSelected = true;
        const statusEl = document.getElementById('statusText');
        if (statusEl && snap.status === 'IDLE') {
          statusEl.textContent = '반려인이 반려동물을 선택했습니다. 산책을 시작할 수 있습니다.';
          statusEl.className = 'status-pill status-waiting';
        }
      }

      if (snap.status === 'IDLE' || snap.status === 'FINISHED') {
        return;
      }

      const distKm = snap.distanceKm || 0;
      const elapsedSec = snap.elapsedSec || 0;
      const points = (snap.points || []).map(p => [p.lat, p.lon]);

      if (distKm <= 0 && elapsedSec <= 0 && points.length === 0) {
        return;
      }

      isWalking = true; // WALKING / FINISH_REQUESTED 둘 다 "진행 중"으로 본다
      distanceMeters = distKm * 1000;
      routePoints = points;

      // startTime 재구성 (현재 시각 - elapsedSec)
      if (elapsedSec > 0) {
        const now = new Date();
        startTime = new Date(now.getTime() - elapsedSec * 1000);
      } else {
        startTime = new Date();
      }

      // 지도 복원
      if (routePoints.length > 0) {
        const last = routePoints[routePoints.length - 1];
        lastLat = last[0];
        lastLon = last[1];

        if (!routePolyline) {
          routePolyline = L.polyline(routePoints, {weight: 5, color: '#10b981'}).addTo(map);
        } else {
          routePolyline.setLatLngs(routePoints);
        }
        if (!userMarker) {
          userMarker = L.marker(last).addTo(map);
        } else {
          userMarker.setLatLng(last);
        }
        map.setView(last, 16);
      }

      // 수치 복원
      document.getElementById('distLabel').textContent = distKm.toFixed(2) + ' km';
      document.getElementById('timeLabel').textContent = elapsedSec + '초';
      const kcal = calcKcal(distKm, elapsedSec);
      document.getElementById('kcalLabel').textContent = kcal.toFixed(0) + ' kcal';
      document.getElementById('paceLabel').textContent = formatPace(distKm, elapsedSec);

      const statusEl = document.getElementById('statusText');
      if (snap.status === 'WALKING') {
        statusEl.textContent = '산책 중...';
        statusEl.className = 'status-pill status-active';
      } else if (snap.status === 'FINISH_REQUESTED') {
        statusEl.textContent = '산책 종료 요청 중 (반려인 승인 대기)...';
        statusEl.className = 'status-pill status-end';
      }

      document.getElementById('startBtn').disabled = true;
      document.getElementById('stopBtn').disabled = false;

      // 타이머 재시작
      startTickTimer();

      // 위치 추적 재시작
      if (navigator.geolocation) {
        watchId = navigator.geolocation.watchPosition(
                (pos) => {
                  const lat = pos.coords.latitude;
                  const lon = pos.coords.longitude;

                  if (lastLat !== null && lastLon !== null) {
                    const d = distanceMetersH(lastLat, lastLon, lat, lon);
                    if (d > 2) {
                      distanceMeters += d;
                    }
                  }
                  lastLat = lat;
                  lastLon = lon;
                  routePoints.push([lat, lon]);

                  if (!userMarker) {
                    userMarker = L.marker([lat, lon]).addTo(map);
                  } else {
                    userMarker.setLatLng([lat, lon]);
                  }
                  if (!routePolyline) {
                    routePolyline = L.polyline(routePoints, {weight: 5, color: '#10b981'}).addTo(map);
                  } else {
                    routePolyline.setLatLngs(routePoints);
                  }
                  map.setView([lat, lon], 16);
                },
                (err) => console.warn('위치 추적 실패(복구)', err),
                { enableHighAccuracy: true, maximumAge: 3000, timeout: 10000 }
        );
      }
    } catch (e) {
      console.error('restoreWalkIfExists error', e);
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    initMap();
    document.getElementById('startBtn').addEventListener('click', startWalk);
    document.getElementById('stopBtn').addEventListener('click', stopWalk);

    // 기존 AI 추천 반려동물 정보 (주석이면 자동 skip)
    loadOwnerPetRecommend();

    // 알바생 SSE 연결 (반려인 승인 후 종료/펫선택 통지)
    connectWorkerSse();

    // 진행 중 산책이 있으면 화면 복구 및 pet 선택 여부 반영
    restoreWalkIfExists();

    const okBtn = document.getElementById('walkjobFinishSummaryOkBtn');
    if (okBtn) {
      okBtn.addEventListener('click', () => {
        document.getElementById('walkjobFinishSummaryModal').style.display = 'none';
        redirectToChatRoom();
      });
    }
  });
</script>
