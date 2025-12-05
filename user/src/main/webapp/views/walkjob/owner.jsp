<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<link rel="stylesheet"
      href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<style>
  /* ===== 색상 팔레트 (산책 알바 매칭 페이지 톤 참고) ===== */
  .walkjob-owner-page {
    --wj-bg: #f3f4f6;
    --wj-card: #ffffff;
    --wj-border-soft: #e5e7eb;
    --wj-shadow-soft: 0 18px 40px rgba(15, 23, 42, 0.06);

    --wj-primary: #10b981;      /* 메인 초록 */
    --wj-primary-soft: #dcfce7;
    --wj-accent: #f97373;       /* 상단 버튼/포인트 색 */
    --wj-accent-soft: #fee2e2;
    --wj-info: #2563eb;
    --wj-muted: #6b7280;
    --wj-title: #111827;
  }

  /* 전역 body 건드리지 않고 페이지 안에서만 배경 */
  .walkjob-owner-page {
    width: min(960px, 94vw);
    margin: 40px auto 80px;
    padding: 24px 26px 28px;
    border-radius: 28px;
    background: var(--wj-card);
    box-shadow: var(--wj-shadow-soft);
    border: 1px solid var(--wj-border-soft);
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  }

  .walkjob-owner-header {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    align-items: center;
    margin-bottom: 18px;
  }

  .walkjob-owner-header-left h1 {
    font-size: 1.6rem;
    font-weight: 700;
    color: var(--wj-title);
    margin: 4px 0 6px;
  }

  .walkjob-owner-header-left p {
    margin: 0;
    font-size: 0.9rem;
    color: var(--wj-muted);
  }

  .walkjob-owner-header-right {
    text-align: right;
  }

  .walkjob-owner-page .badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 999px;
    font-size: 0.75rem;
    background: var(--wj-primary-soft);
    color: var(--wj-primary);
    font-weight: 600;
  }

  .walkjob-owner-page .badge::before {
    content: "🤝";
    font-size: 0.95rem;
  }

  .walkjob-owner-sublabel {
    font-size: 0.8rem;
    color: var(--wj-muted);
    padding: 4px 10px;
    border-radius: 999px;
    background: #f9fafb;
    border: 1px dashed #d1d5db;
    display: inline-block;
    margin-top: 4px;
  }

  /* ===== 반려동물 선택 섹션 (★ 추가) ===== */
  .owner-pet-select {
    margin-top: 12px;
    margin-bottom: 10px;
    padding: 12px 14px;
    border-radius: 18px;
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    font-size: 0.9rem;
  }

  .owner-pet-select-title {
    font-weight: 600;
    margin-bottom: 4px;
  }

  .owner-pet-select-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    align-items: center;
    margin-top: 6px;
  }

  .owner-pet-select-row select {
    flex: 1 1 160px;
    padding: 6px 10px;
    border-radius: 999px;
    border: 1px solid #d1d5db;
    font-size: 0.9rem;
  }

  .owner-pet-select-row button {
    padding: 6px 14px;
    border-radius: 999px;
    border: none;
    background: #22c55e;
    color: #fff;
    font-size: 0.86rem;
    cursor: pointer;
  }

  .owner-pet-select-row button:disabled {
    opacity: .6;
    cursor: default;
  }

  .owner-pet-selected-label {
    margin-top: 6px;
    font-size: 0.8rem;
    color: #6b7280;
  }

  /* ===== 지도 카드 ===== */
  .walkjob-owner-page .map-wrap {
    margin-top: 10px;
    border-radius: 22px;
    overflow: hidden;
    border: 1px solid var(--wj-border-soft);
    box-shadow: 0 12px 24px rgba(15,23,42,0.08);
  }

  .walkjob-owner-page #map {
    height: 420px;
  }

  /* ===== 하단 정보 영역 ===== */
  .walkjob-footer-row {
    display: flex;
    flex-wrap: wrap;
    gap: 18px;
    justify-content: space-between;
    margin-top: 18px;
  }

  .walkjob-owner-page .stats {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
    flex: 1 1 260px;
  }

  .walkjob-owner-page .stat-card {
    flex: 1 1 120px;
    min-width: 120px;
    padding: 10px 12px;
    border-radius: 14px;
    background: #f9fafb;
    border: 1px solid #e5e7eb;
  }

  .walkjob-owner-page .stat-label {
    font-size: 0.8rem;
    color: var(--wj-muted);
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .walkjob-owner-page .stat-label span.icon {
    font-size: 1rem;
  }

  .walkjob-owner-page .stat-value {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--wj-title);
  }

  /* 각 카드별 색 포인트 */
  .walkjob-owner-page .stat-card.dist .stat-value { color: var(--wj-primary); }
  .walkjob-owner-page .stat-card.time .stat-value { color: var(--wj-info); }
  .walkjob-owner-page .stat-card.kcal .stat-value { color: #f97316; }
  .walkjob-owner-page .stat-card.pace .stat-value { color: #ec4899; }

  /* ===== 상태 뱃지 ===== */
  .walkjob-owner-page .status {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.9rem;
    color: var(--wj-muted);
    flex: 0 0 auto;
  }

  .walkjob-owner-page .status-label {
    font-weight: 500;
  }

  .walkjob-owner-page .status-chip {
    padding: 6px 12px;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 600;
    border: 1px solid transparent;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }

  .walkjob-owner-page .status-chip::before {
    content: "●";
    font-size: 0.55rem;
  }

  .walkjob-owner-page .status-wait {
    background: var(--wj-accent-soft);
    border-color: #fecaca;
    color: #b91c1c;
  }

  .walkjob-owner-page .status-active {
    background: var(--wj-primary-soft);
    border-color: #bbf7d0;
    color: var(--wj-primary);
  }

  .walkjob-owner-page .status-finish {
    background: #e0f2fe;
    border-color: #bfdbfe;
    color: #1d4ed8;
  }

  .walkjob-owner-page .status-error {
    background: #fee2e2;
    border-color: #fecaca;
    color: #b91c1c;
  }

  @media (max-width: 768px) {
    .walkjob-owner-page {
      padding: 18px 16px 22px;
      border-radius: 20px;
    }
    .walkjob-owner-header {
      flex-direction: column;
      align-items: flex-start;
    }
    .walkjob-owner-header-right {
      text-align: left;
    }
    .walkjob-footer-row {
      flex-direction: column;
      align-items: stretch;
    }
    .walkjob-owner-page .status {
      justify-content: flex-start;
    }
  }
</style>

<br>
<div class="walkjob-owner-page">
  <header class="walkjob-owner-header">
    <div class="walkjob-owner-header-left">
      <div class="badge">산책 알바 · 반려인 화면</div>
      <h1>내 반려동물 산책 모니터링</h1>
      <p>알바생이 산책을 시작하면 이 화면에서 실시간 경로와 정보를 확인할 수 있습니다.</p>
    </div>
    <div class="walkjob-owner-header-right">
      <div class="walkjob-owner-sublabel">
        현재 진행 중인 산책을 실시간으로 추적하고, 거리·시간·칼로리를 한눈에 확인해요.
      </div>
    </div>
  </header>

  <!-- ★ 오늘 산책할 반려동물 선택 섹션 -->
  <section class="owner-pet-select">
    <div class="owner-pet-select-title">오늘 산책할 반려동물 선택</div>
    <p style="margin:0; font-size:0.82rem; color:#6b7280;">
      여러 마리의 반려동물이 있는 경우, 오늘 알바생이 산책시킬 반려동물을 먼저 선택해 주세요.
    </p>
    <div class="owner-pet-select-row">
      <select id="ownerPetSelect">
        <option value="">반려동물 목록을 불러오는 중입니다...</option>
      </select>
      <button id="ownerPetSelectBtn" type="button">선택 완료</button>
    </div>
    <p id="ownerSelectedPetLabel" class="owner-pet-selected-label">
      아직 오늘 산책할 반려동물이 선택되지 않았습니다.
    </p>
  </section>

  <div class="map-wrap">
    <div id="map"></div>
  </div>

  <div class="walkjob-footer-row">
    <div class="stats">
      <div class="stat-card dist">
        <p class="stat-label"><span class="icon">📏</span>현재 걸은 거리</p>
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

    <div class="status">
      <span class="status-label">상태</span>
      <span id="statusText" class="status-chip status-wait">
        알바생 연결 대기 중...
      </span>
    </div>
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

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>



<script>
  let map, routePolyline, lastPoints = [], currentMarker;

  // 칼로리/페이스 계산용 상수
  const AVG_WEIGHT_KG = 70;   // 평균 체중 가정
  const WALK_MET = 3.5;       // 보통 걷기 MET 값

  function calcKcal(distanceKm, elapsedSec) {
    if (!distanceKm || !elapsedSec) return 0;
    const hours = elapsedSec / 3600;
    return WALK_MET * AVG_WEIGHT_KG * hours;
  }

  function formatPace(distanceKm, elapsedSec) {
    if (!distanceKm || distanceKm <= 0 || !elapsedSec || elapsedSec <= 0) return "-";
    const paceSecPerKm = elapsedSec / distanceKm;
    const min = Math.floor(paceSecPerKm / 60);
    const sec = Math.round(paceSecPerKm % 60);
    const secStr = String(sec).padStart(2, "0");
    return `${min}'${secStr}"/km`;
  }

  // ★ 경과 시간(초)을 "mm분 ss초" 스타일 문자열로 변환
  function formatDuration(sec) {
    if (!sec || sec <= 0) return "0초";
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    if (m <= 0) return `${s}초`;
    return `${m}분 ${s}초`;
  }

  function initMap() {
    map = L.map('map').setView([36.777381, 127.001764], 14);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(map);
  }

  function applyUpdate(data) {
    // data: { distanceKm, elapsedSec, points: [{lat,lon}, ...] }
    const distanceKm = data.distanceKm || 0;
    const elapsedSec = data.elapsedSec || 0;

    document.getElementById('distLabel').textContent =
            distanceKm.toFixed(2) + ' km';
    document.getElementById('timeLabel').textContent =
            elapsedSec + '초';

    const kcal = calcKcal(distanceKm, elapsedSec);
    document.getElementById('kcalLabel').textContent = kcal.toFixed(0) + ' kcal';
    document.getElementById('paceLabel').textContent = formatPace(distanceKm, elapsedSec);

    if (data.points && data.points.length > 0) {
      lastPoints = data.points.map(p => [p.lat, p.lon]);

      if (!routePolyline) {
        routePolyline = L.polyline(lastPoints, {weight: 5, color: '#10b981'}).addTo(map);
      } else {
        routePolyline.setLatLngs(lastPoints);
      }

      const last = lastPoints[lastPoints.length - 1];

      if (!currentMarker) {
        currentMarker = L.marker(last).addTo(map);
      } else {
        currentMarker.setLatLng(last);
      }

      map.setView(last, 16);
    }
  }

  // ★ 산책 종료 요약 모달 표시 + 확인 시 채팅방으로 이동
  function redirectToChatRoom() {
    // 항상 채팅 목록으로 이동
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

  function connectSse() {
    const eventSource = new EventSource('<c:url value="/api/walkjob/stream"/>');
    const statusEl = document.getElementById('statusText');

    eventSource.addEventListener('init', (e) => {
      statusEl.textContent = '준비 완료 · 알바생 대기 중...';
      statusEl.className = 'status-chip status-wait';
      const data = JSON.parse(e.data);
      applyUpdate(data);
    });

    eventSource.addEventListener('update', (e) => {
      statusEl.textContent = '산책 중...';
      statusEl.className = 'status-chip status-active';
      const data = JSON.parse(e.data);
      applyUpdate(data);
    });

    // ★ 반려인이 보는 화면도 finish 이벤트에서 요약 모달 표시
    eventSource.addEventListener('finish', (e) => {
      const data = JSON.parse(e.data);
      applyUpdate({
        distanceKm: data.distanceKm,
        elapsedSec: data.elapsedSec,
        points: data.points
      });
      statusEl.textContent = '산책 종료!';
      statusEl.className = 'status-chip status-finish';
      eventSource.close();

      const distKm = data.distanceKm || 0;
      const elapsedSec = data.elapsedSec || 0;
      showFinishSummary(distKm, elapsedSec);
    });

    eventSource.onerror = (e) => {
      console.error('SSE error', e);
      statusEl.textContent = '연결 끊김 (새로고침으로 재연결)';
      statusEl.className = 'status-chip status-error';
    };
  }

  // ★ 반려인의 반려동물 목록 불러오기
  async function loadOwnerPets() {
    const selectEl = document.getElementById('ownerPetSelect');
    const btnEl = document.getElementById('ownerPetSelectBtn');
    const labelEl = document.getElementById('ownerSelectedPetLabel');

    try {
      const res = await fetch('<c:url value="/api/walkjob/owner-pets"/>');
      if (!res.ok) throw new Error('owner-pets error');

      const pets = await res.json();

      if (!pets || pets.length === 0) {
        selectEl.innerHTML = '<option value="">등록된 반려동물이 없습니다.</option>';
        selectEl.disabled = true;
        btnEl.disabled = true;
        labelEl.textContent = '먼저 마이페이지에서 반려동물을 등록해 주세요.';
        return;
      }

      selectEl.innerHTML = pets.map(p => {
        const sub = [p.type, p.customType, p.breed].filter(Boolean).join(' / ');
        const age = (p.age != null) ? `${p.age}살` : '';
        const label = `${p.name}${sub ? ' (' + sub + ')' : ''}${age ? ', ' + age : ''}`;
        return `<option value="${p.petId}">${label}</option>`;
      }).join('');
    } catch (e) {
      console.error(e);
      selectEl.innerHTML = '<option value="">반려동물 정보를 불러오지 못했습니다.</option>';
      selectEl.disabled = true;
      btnEl.disabled = true;
      labelEl.textContent = '나중에 다시 시도해 주세요.';
    }
  }

  // ★ 반려동물 선택 완료 → 서버에 petId 전달
  async function selectOwnerPet() {
    const selectEl = document.getElementById('ownerPetSelect');
    const labelEl = document.getElementById('ownerSelectedPetLabel');
    const petId = selectEl.value;

    if (!petId) {
      alert('오늘 산책할 반려동물을 선택해 주세요.');
      return;
    }

    try {
      const res = await fetch('<c:url value="/api/walkjob/select-pet"/>' + '?petId=' + encodeURIComponent(petId), {
        method: 'POST'
      });
      if (!res.ok) throw new Error('select-pet error');

      const text = selectEl.options[selectEl.selectedIndex].text;
      labelEl.textContent = `오늘 산책할 반려동물: ${text}`;
      alert('반려동물을 선택했습니다.\n이제 알바생이 산책을 시작할 수 있습니다.');
    } catch (e) {
      console.error(e);
      alert('반려동물 선택 중 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    initMap();
    connectSse();
    loadOwnerPets();

    const btn = document.getElementById('ownerPetSelectBtn');
    if (btn) {
      btn.addEventListener('click', selectOwnerPet);
    }

    const okBtn = document.getElementById('walkjobFinishSummaryOkBtn');
    if (okBtn) {
      okBtn.addEventListener('click', () => {
        document.getElementById('walkjobFinishSummaryModal').style.display = 'none';
        redirectToChatRoom();
      });
    }
  });
</script>
