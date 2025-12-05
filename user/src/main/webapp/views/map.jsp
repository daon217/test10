<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>

<link rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Jua&family=Gamja+Flower&display=swap">


<style>
  /* ✅ index.jsp 의 :root, body 에 영향 안 가도록
     이 페이지 안에서만 쓰는 테마 변수 */
  .pet-map-theme {
    --primary-color: #6366f1;
    --accent-pink: #ff7ab8;
    --bg-soft: #f9fafb;
    --card-radius: 20px;
    --shadow-soft: 0 22px 50px rgba(15, 23, 42, 0.08);
  }

  /* 이 페이지 안 레이아웃 전용 */
  .pet-map-theme .map-page-wrapper {
    padding: 40px 16px 80px;
    display: flex;
    justify-content: center;
    background: radial-gradient(circle at top left, #ffe4f3 0, transparent 55%),
    radial-gradient(circle at top right, #e0f2fe 0, transparent 55%),
    #f5f7fb;
  }

  .pet-map-theme .map-page-container {
    width: min(1200px, 100%);
  }

  .pet-map-theme .map-page-header {
    text-align: center;
    margin-bottom: 24px;
  }

  .pet-map-theme .map-page-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 12px;
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid #e5e7eb;
    margin-bottom: 10px;
    color: #6b7280;
  }

  .pet-map-theme .map-page-badge span {
    font-size: 14px;
  }

  .pet-map-theme .map-page-header h1 {
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 8px;
    background: linear-gradient(120deg, #6366f1, #ec4899);
    -webkit-background-clip: text;
    color: transparent;
  }

  .pet-map-theme .map-page-header .subtitle {
    color: #6b7280;
    font-size: 14px;
    line-height: 1.7;
  }

  .pet-map-theme .map-notice-card {
    background: #fff7e6;
    border-radius: 16px;
    padding: 14px 18px;
    border: 1px solid #ffe3a2;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 13px;
    margin-bottom: 20px;
  }

  .pet-map-theme .map-notice-icon {
    font-size: 18px;
    margin-top: 2px;
    color: #f97316;
  }

  .pet-map-theme .map-notice-text strong {
    display: block;
    margin-bottom: 2px;
  }

  .pet-map-theme .map-main-card {
    background: #ffffff;
    border-radius: var(--card-radius);
    box-shadow: var(--shadow-soft);
    padding: 20px 20px 22px;
    border: 1px solid #e5e7eb;
    position: relative;
    overflow: hidden;
  }

  .pet-map-theme .map-main-card::before {
    content: "";
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at top right,
    rgba(251, 207, 232, 0.6) 0,
    transparent 60%);
    opacity: 0.7;
    pointer-events: none;
  }

  .pet-map-theme .map-main-inner {
    position: relative; /* overlay 위에 콘텐츠 올라오도록 */
  }

  .pet-map-theme .map-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
    gap: 10px;
  }

  .pet-map-theme .map-card-title {
    font-weight: 700;
    font-size: 16px;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .pet-map-theme .map-card-title-icon {
    width: 22px;
    height: 22px;
    border-radius: 999px;
    background: #fef3c7;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
  }

  .pet-map-theme .map-card-caption {
    font-size: 12px;
    color: #777;
  }

  /* === 기존 map-container를 카드 안에서만 쓰도록 재정의 === */
  .pet-map-theme .map-container {
    display: flex;
    flex-direction: row;
    width: 100%;
    height: 520px;
    background: transparent;
    border-top: none;
    gap: 16px;
  }

  .pet-map-theme #map {
    flex: 7;
    min-height: 260px;
    height: 100%;
    background: #e5e7eb;
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid #e5e7eb;
  }

  .pet-map-theme .info-panel {
    flex: 5;
    display: flex;
    flex-direction: column;
    background: #fff;
    min-width: 280px;
    border-radius: 16px;
    border: 1px solid #e5e7eb;
    padding: 8px 8px 10px;
    backdrop-filter: blur(6px);
    background-color: rgba(255, 255, 255, 0.95);
  }

  /* 탭 */
  .pet-map-theme .tab-head {
    display: flex;
    height: 40px;
    margin-bottom: 8px;
    border-radius: 999px;
    background: #eef2ff;
    padding: 4px;
    overflow: hidden;
  }

  .pet-map-theme .tab-head div {
    flex: 1;
    text-align: center;
    line-height: 32px;
    font-weight: 600;
    cursor: pointer;
    background: transparent;
    font-size: 13px;
    border-radius: 999px;
    color: #4b5563;
    transition: background 0.18s, color 0.18s, box-shadow 0.18s, transform 0.12s;
    white-space: nowrap;
  }

  .pet-map-theme .tab-head .active {
    background: linear-gradient(120deg, #6366f1, #ec4899);
    color: #fff;
    box-shadow: 0 6px 18px rgba(129, 140, 248, 0.5);
    transform: translateY(-1px);
  }

  /* 직접 검색 영역 */
  .pet-map-theme #searchBox {
    display: none;
    padding: 8px 10px;
    border-bottom: 1px solid #f3f4f6;
    background: #fafafa;
    border-radius: 12px;
    margin-bottom: 8px;
  }

  .pet-map-theme #searchBox input {
    width: 70%;
    padding: 7px 9px;
    border-radius: 10px;
    border: 1px solid #e5e7eb;
    font-size: 13px;
    outline: none;
  }

  .pet-map-theme #searchBox input:focus {
    border-color: #a5b4fc;
    box-shadow: 0 0 0 2px rgba(129, 140, 248, 0.25);
  }

  .pet-map-theme #searchBox button {
    padding: 7px 14px;
    margin-left: 6px;
    background: var(--primary-color);
    color: #fff;
    border: none;
    border-radius: 999px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
  }

  .pet-map-theme #infoList {
    flex: 1;
    overflow-y: auto;
    padding: 6px;
    background: transparent;
  }

  .pet-map-theme .info-empty {
    padding: 16px;
    font-size: 13px;
    color: #9ca3af;
    text-align: center;
  }

  .pet-map-theme .info-card {
    padding: 11px 12px;
    border: 2px solid #e5e7eb;
    background: #f9fafb;
    border-radius: 14px;
    margin-bottom: 9px;
    font-size: 13px;
    cursor: pointer;
    transition: border-color 0.18s, background 0.18s, transform 0.12s, box-shadow 0.12s;
    position: relative;
  }

  .pet-map-theme .info-card::before {
    content: "🐾";
    position: absolute;
    right: 10px;
    top: 10px;
    font-size: 14px;
    opacity: 0.7;
  }

  .pet-map-theme .info-card:hover {
    border-color: #c7d2fe;
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(148, 163, 184, 0.3);
    background: #ffffff;
  }

  .pet-map-theme .info-card b {
    font-size: 14px;
    display: inline-block;
    margin-bottom: 2px;
  }

  .pet-map-theme .info-card small {
    display: block;
    font-size: 11px;
    color: #9ca3af;
    margin-bottom: 4px;
  }

  .pet-map-theme .info-card.active-card {
    border: 2px solid var(--accent-pink);
    background: #fff0f6;
    box-shadow: 0 10px 24px rgba(236, 72, 153, 0.35);
  }

  .pet-map-theme .route-btn {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    margin-top: 6px;
    background: var(--accent-pink);
    color: #fff;
    border: none;
    border-radius: 999px;
    padding: 6px 14px;
    font-size: 12px;
    cursor: pointer;
    font-weight: 600;
  }

  .pet-map-theme .route-btn::before {
    content: "📍";
    font-size: 12px;
  }

  /* 반응형 */
  @media (max-width: 900px) {
    .pet-map-theme .map-container {
      flex-direction: column;
      height: auto;
    }
    .pet-map-theme #map {
      flex: none;
      height: 320px;
    }
    .pet-map-theme .info-panel {
      flex: 1;
      max-height: 360px;
      min-width: 100%;
    }
  }
  /*!* 전체 기본 폰트 – 이 페이지 래퍼 안에서만 적용 *!*/
  /*.pet-map-theme {*/
  /*  font-family: 'Jua', -apple-system, BlinkMacSystemFont,*/
  /*  'Segoe UI', system-ui, sans-serif;*/
  /*}*/

  /*!* 제목/메인 타이틀은 더 동글동글한 폰트 *!*/
  /*.pet-map-theme h1,*/
  /*.pet-map-theme .map-card-title {*/
  /*'Segoe UI', system-ui, sans-serif;*/
  /*}*/

  /*!* 탭/버튼도 살짝 통통한 느낌 유지 *!*/
  /*.pet-map-theme .tab-head div,*/
  /*.pet-map-theme .route-btn,*/
  /*.pet-map-theme .map-page-badge {*/
  /*  font-family: 'Jua', system-ui, sans-serif;*/
  /*}*/
  /* === 글자 조금씩 키우는 오버라이드 === */
  .pet-map-theme .map-page-header h1 {
    font-size: 38px;            /* 28 → 32 */
  }

  .pet-map-theme .map-page-header .subtitle {
    font-size: 17px;            /* 14 → 15 */
  }

  .pet-map-theme .map-page-badge {
    font-size: 15px;            /* 12 → 13 */
  }

  .pet-map-theme .map-card-title {
    font-size: 20px;            /* 16 → 18 */
  }

  .pet-map-theme .map-card-caption {
    font-size: 15px;            /* 12 → 13 */
  }

  .pet-map-theme .tab-head div {
    font-size: 16px;            /* 13 → 14 */
  }

  .pet-map-theme #searchBox input,
  .pet-map-theme #searchBox button {
    font-size: 16px;            /* 13 → 14 */
  }

  .pet-map-theme .info-card {
    font-size: 16px;            /* 13 → 14 */
  }

  .pet-map-theme .info-card b {
    font-size: 17px;            /* 14 → 15 */
  }

  .pet-map-theme .route-btn {
    font-size: 15px;            /* 12 → 13 */
  }
  @media (max-width: 600px) {
    .pet-map-theme .map-page-wrapper {
      padding-top: 24px;
    }
    .pet-map-theme .map-main-card {
      padding: 16px 14px 18px;
    }
  }

  /* 이 페이지 안 요소만 박스사이징統一 */
  .pet-map-theme .map-page-container * {
    box-sizing: border-box;
  }
</style>

<div class="pet-map-theme">
  <div class="map-page-wrapper">
    <div class="map-page-container">
      <!-- 상단 타이틀 / 설명 -->
      <div class="map-page-header">
        <div class="map-page-badge">
          <span>🐶</span> 펫 전용 주변 시설 안내
        </div>
        <h1>주변 펫 시설 찾기</h1>
        <p class="subtitle">
          현재 위치 기준으로 동물병원 · 애견카페 · 애견호텔을 검색합니다.<br>
          시설을 선택하면 카카오맵 길찾기로 바로 이동할 수 있어요.
        </p>
      </div>

      <!-- 안내 카드 -->
      <div class="map-notice-card">
        <div class="map-notice-icon">⚠️</div>
        <div class="map-notice-text">
          <strong>표시되는 정보는 카카오맵 데이터를 기반으로 합니다.</strong>
          실제 영업 여부·시간·휴무일 등은 방문 전 반드시 전화 등으로 재확인해주세요.
        </div>
      </div>

      <!-- 메인 카드 -->
      <div class="map-main-card">
        <div class="map-main-inner">
          <div class="map-card-header">
            <div>
              <div class="map-card-title">
                <div class="map-card-title-icon">🐾</div>
                내 주변 펫 전용 시설
              </div>
              <div class="map-card-caption">탭을 눌러 시설 종류를 바꾸거나, 직접 검색해보세요.</div>
            </div>
          </div>

          <!-- 여기부터는 원래 구조 그대로 (id/class 유지) -->
          <div class="map-container">
            <div id="map"></div>

            <div class="info-panel">
              <div class="tab-head">
                <div id="tab-hospital" class="active">동물병원</div>
                <div id="tab-cafe">애견카페</div>
                <div id="tab-hotel">애견호텔</div>
                <div id="tab-search">직접 검색</div>
              </div>

              <div id="searchBox">
                <input id="searchKeyword" type="text" placeholder="예: 서울 애견카페, 강남 동물병원 등">
                <button id="searchBtn" type="button">검색</button>
              </div>

              <div id="infoList"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Kakao Map SDK -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=55e3779d3a4e94654971764756e0a939&libraries=services"></script>

<script>
  /* ==== 여기부터는 네가 올린 '기능 코드 원본' 그대로 ==== */

  let map;
  let ps;
  let markers = [];
  let infowindow;
  let placesData = [];

  // 출발지 기본값 = 선문대
  const DEFAULT_LAT = 36.800233;
  const DEFAULT_LNG = 127.075569;

  // geolocation 위치 (기본은 선문대)
  let userLat = DEFAULT_LAT;
  let userLng = DEFAULT_LNG;

  // 출발지 이름 (역지오코딩으로 갱신)
  let originName = "선문대학교 아산캠퍼스";
  let geocoder;

  // ===== 거리 계산 =====
  function calcDistanceKm(lat1, lng1, lat2, lng2) {
    const R = 6371;
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLng = (lng2 - lng1) * Math.PI / 180;
    const a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) *
            Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  function formatDistance(lat1, lng1, lat2, lng2) {
    const km = calcDistanceKm(lat1, lng1, lat2, lng2);
    if (isNaN(km)) return "거리 정보 없음";
    if (km < 1) return Math.round(km * 1000) + "m";
    return km.toFixed(1) + "km";
  }

  // ===== 출발지 이름을 geolocation 기준으로 갱신 (역지오코딩) =====
  function updateOriginNameFromCurrentLocation() {
    if (!geocoder) return;

    const lng = userLng;
    const lat = userLat;

    geocoder.coord2Address(lng, lat, function (result, status) {
      if (status === kakao.maps.services.Status.OK && result[0]) {
        const addr = result[0];

        if (addr.road_address) {
          if (addr.road_address.building_name) {
            originName = addr.road_address.building_name;
          } else {
            originName = addr.road_address.address_name;
          }
        } else if (addr.address) {
          originName = addr.address.address_name;
        }

        console.log("[ORIGIN] 출발지 이름 갱신:", originName);
      } else {
        console.log("[ORIGIN] 역지오코딩 실패, 기본값 유지:", originName);
      }
    });
  }

  function closeInfoWindow() {
    if (infowindow) infowindow.close();
  }

  function deactivateCards() {
    document.querySelectorAll(".info-card").forEach(c => c.classList.remove("active-card"));
  }

  function clearMarkers() {
    markers.forEach(m => m.setMap(null));
    markers = [];
  }

  // ✅ 길찾기: 출발 이름 = originName(내 위치 기반), 도착 이름 = 선택 시설 이름
  function goRoute(index) {
    const place = placesData[index];
    if (!place) return;

    const url =
            "https://map.kakao.com/?" +
            "sName=" + encodeURIComponent(originName || "내 위치") +
            "&eName=" + encodeURIComponent(place.place_name);

    console.log("[ROUTE]", originName, "→", place.place_name);
    window.open(url, "_blank");
  }
  window.goRoute = goRoute;

  function showMarkerInfo(index) {
    const place = placesData[index];
    const marker = markers[index];
    if (!place || !marker) return;

    const address = place.address_name || "주소 정보 없음";

    const content =
            `<div style="padding:8px 10px 16px; padding-bottom:30px; max-width:220px; font-size:13px;">
         <div style="font-weight:700; margin-bottom:4px;">${place.place_name}</div>
         <div style="margin-bottom:8px;">${address}</div>
         <div style="text-align:center;">
           <button type="button"
                   style="background:#ff4fa3;color:#fff;border:none;border-radius:6px;padding:6px 14px;font-size:12px;cursor:pointer;display:inline-block;"
                   onclick="goRoute(${index})">
             길찾기
           </button>
         </div>
       </div>`;

    closeInfoWindow();
    infowindow.setContent(content);
    infowindow.open(map, marker);
    map.panTo(marker.getPosition());
  }

  function renderList(places) {
    const list = document.getElementById("infoList");
    list.innerHTML = "";

    if (!places || places.length === 0) {
      list.innerHTML = "<div class='info-empty'>검색 결과가 없습니다.</div>";
      return;
    }

    places.forEach((p, idx) => {
      const address = p.address_name || "주소 정보 없음";

      const card = document.createElement("div");
      card.className = "info-card";
      card.id = "place-" + idx;

      card.innerHTML = `
        <div><b>${p.place_name}</b></div>
        <div>${address}</div>
        <button type="button" class="route-btn"
                onclick="goRoute(${idx}); event.stopPropagation && event.stopPropagation();">
          길찾기
        </button>
      `;

      card.onclick = () => {
        deactivateCards();
        card.classList.add("active-card");
        showMarkerInfo(idx);
        card.scrollIntoView({ behavior: "smooth", block: "center" });
      };

      list.appendChild(card);
    });
  }

  function displayPlaces(data, status) {
    if (status !== kakao.maps.services.Status.OK) {
      clearMarkers();
      placesData = [];
      renderList([]);
      closeInfoWindow();
      return;
    }

    placesData = data;
    clearMarkers();
    deactivateCards();
    closeInfoWindow();

    data.forEach((p, idx) => {
      const marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(p.y, p.x)
      });
      markers.push(marker);

      kakao.maps.event.addListener(marker, () => {
        deactivateCards();
        const card = document.getElementById("place-" + idx);
        if (card) {
          card.classList.add("active-card");
          card.scrollIntoView({ behavior: "smooth", block: "center" });
        }
        showMarkerInfo(idx);
      });
    });

    renderList(data);
  }

  // useLocal: true → 내 위치 기준 / false → 전국 검색
  function searchKeyword(keyword, useLocal) {
    if (!ps) return;

    closeInfoWindow();
    deactivateCards();

    if (useLocal) {
      const center = new kakao.maps.LatLng(userLat, userLng);
      const options = {
        location: center,
        radius: 5000,
        sort: kakao.maps.services.SortBy.DISTANCE
      };
      ps.keywordSearch(keyword, displayPlaces, options);
    } else {
      ps.keywordSearch(keyword, displayPlaces);
    }
  }

  function activateTab(tabId) {
    document.querySelectorAll(".tab-head div")
            .forEach(el => el.classList.remove("active"));
    document.getElementById("tab-" + tabId).classList.add("active");

    document.getElementById("searchBox").style.display =
            (tabId === "search" ? "block" : "none");
  }

  document.addEventListener("DOMContentLoaded", function () {

    map = new kakao.maps.Map(document.getElementById('map'), {
      center: new kakao.maps.LatLng(DEFAULT_LAT, DEFAULT_LNG),
      level: 5
    });

    ps = new kakao.maps.services.Places();
    infowindow = new kakao.maps.InfoWindow({ zIndex: 3 });
    geocoder = new kakao.maps.services.Geocoder();

    kakao.maps.event.addListener(map, "click", () => {
      closeInfoWindow();
      deactivateCards();
    });

    setTimeout(() => {
      kakao.maps.event.trigger(map, "resize");
      map.setCenter(new kakao.maps.LatLng(DEFAULT_LAT, DEFAULT_LNG));
    }, 400);

    // Geolocation 시도
    if (navigator.geolocation) {
      console.log("[GEO] 지원됨");
      navigator.geolocation.getCurrentPosition(
              (pos) => {
                console.log("[GEO] 성공", pos.coords);
                userLat = pos.coords.latitude;
                userLng = pos.coords.longitude;
                const loc = new kakao.maps.LatLng(userLat, userLng);
                map.setCenter(loc);

                // 내 위치 기준 출발지 이름 갱신
                updateOriginNameFromCurrentLocation();

                // 내 위치 주변 동물병원
                searchKeyword("동물병원", true);
              },
              (err) => {
                console.warn("[GEO] 실패:", err);
                userLat = DEFAULT_LAT;
                userLng = DEFAULT_LNG;
                map.setCenter(new kakao.maps.LatLng(DEFAULT_LAT, DEFAULT_LNG));
                // 출발지 이름은 기본값(선문대) 유지
                searchKeyword("동물병원", true);
              },
              { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );
    } else {
      console.log("[GEO] 미지원");
      userLat = DEFAULT_LAT;
      userLng = DEFAULT_LNG;
      map.setCenter(new kakao.maps.LatLng(DEFAULT_LAT, DEFAULT_LNG));
      searchKeyword("동물병원", true);
    }

    // 탭 이벤트
    document.getElementById("tab-hospital").onclick = () => {
      activateTab("hospital");
      searchKeyword("동물병원", true);
    };

    document.getElementById("tab-cafe").onclick = () => {
      activateTab("cafe");
      searchKeyword("애견카페", true);
    };

    document.getElementById("tab-hotel").onclick = () => {
      activateTab("hotel");
      searchKeyword("애견호텔", true);
    };

    document.getElementById("tab-search").onclick = () => {
      activateTab("search");
      closeInfoWindow();
      deactivateCards();
      document.getElementById("infoList").innerHTML =
              "<div class='info-empty'>검색어를 입력한 후 검색 버튼을 눌러주세요.</div>";
    };

    // 직접 검색 → 전국 검색
    document.getElementById("searchBtn").onclick = () => {
      const keyword = document.getElementById("searchKeyword").value.trim();
      if (!keyword) {
        alert("검색어를 입력해주세요.");
        return;
      }
      searchKeyword(keyword, false);
    };
  });
</script>
