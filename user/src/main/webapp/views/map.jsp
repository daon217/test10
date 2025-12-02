<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>

<style>
  .map-container {
    display: flex;
    width: 100%;
    height: calc(100vh - 120px); /* 상단 navbar 제외 전체 */
    border-top: 1px solid #ddd;
  }

  #map {
    flex: 2;
    height: 100%;
    background: #eee;
  }

  .info-panel {
    flex: 1;
    display: flex;
    flex-direction: column;
    border-left: 1px solid #ddd;
    background: #fff;
  }

  .tab-header {
    display: flex;
    height: 50px;
    border-bottom: 1px solid #ddd;
  }

  .tab-header div {
    flex: 1;
    text-align: center;
    line-height: 50px;
    font-weight: 600;
    cursor: pointer;
    background: #f3f3f3;
  }

  .tab-header .active {
    background: #1d4ed8;
    color: white;
  }

  #infoList {
    flex: 1;
    overflow-y: auto;
    padding: 12px;
  }

  .info-card {
    padding: 12px;
    border: 1px solid #ddd;
    background: #fafafa;
    border-radius: 8px;
    margin-bottom: 10px;
  }
</style>

<div class="map-container">
  <div id="map"></div>

  <div class="info-panel">

    <div class="tab-header">
      <div id="tab-hospital" class="active">동물병원</div>
      <div id="tab-cafe">애견카페</div>
      <div id="tab-hotel">애견호텔</div>
    </div>

    <div id="infoList"></div>

  </div>
</div>

<!-- 카카오 지도 -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=55e3779d3a4e94654971764756e0a939&libraries=services"></script>

<script>
  window.onload = function() {

    const animalHospitals = [
      { name: "스마일동물병원", lat: 37.498, lng: 127.027, desc: "24시간 운영" },
      { name: "강남동물병원",  lat: 37.497, lng: 127.030, desc: "입원 진료" }
    ];
    const petCafes = [
      { name: "우주애견카페", lat: 37.495, lng: 127.031, desc: "애견 놀이터 보유" }
    ];
    const petHotels = [
      { name: "럭셔리애견호텔", lat: 37.496, lng: 127.028, desc: "CCTV 제공" }
    ];

    let map = new kakao.maps.Map(document.getElementById('map'), {
      center: new kakao.maps.LatLng(37.4979, 127.0276),
      level: 5
    });

    let markers = [];

    function renderFacilities(list) {
      clearMarkers();
      const info = document.getElementById("infoList");
      info.innerHTML = "";

      list.forEach(item => {
        info.innerHTML += `
            <div class="info-card">
                <b>${item.name}</b><br>
                ${item.desc}
            </div>
          `;

        const marker = new kakao.maps.Marker({
          map: map,
          position: new kakao.maps.LatLng(item.lat, item.lng)
        });

        markers.push(marker);
      });
    }

    function clearMarkers() {
      markers.forEach(m => m.setMap(null));
      markers = [];
    }

    // 기본 렌더링
    renderFacilities(animalHospitals);

    // 탭 클릭 이벤트
    document.getElementById("tab-hospital").onclick = () => {
      activate("hospital");
      renderFacilities(animalHospitals);
    };
    document.getElementById("tab-cafe").onclick = () => {
      activate("cafe");
      renderFacilities(petCafes);
    };
    document.getElementById("tab-hotel").onclick = () => {
      activate("hotel");
      renderFacilities(petHotels);
    };

    function activate(tab) {
      document.getElementById("tab-hospital").classList.remove("active");
      document.getElementById("tab-cafe").classList.remove("active");
      document.getElementById("tab-hotel").classList.remove("active");

      document.getElementById("tab-" + tab).classList.add("active");
    }

  };
</script>
