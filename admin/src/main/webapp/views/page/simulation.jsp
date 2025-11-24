<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<div class="main-container">
  <div class="pd-ltr-20">
    <div class="min-height-200px">
      <div class="page-header" style="margin-bottom: 20px;">
        <div class="row">
          <div class="col-12">
            <div class="title">
              <h4>빌딩 시뮬레이션 및 제어</h4>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-8 cctv-col">
          <div class="cctv-card" style="aspect-ratio: 16 / 9; height: 500px;">
            <canvas id="renderCanvas" style="width: 100%; height: 100%; touch-action: none;"></canvas>
            <span class="cctv-label">시뮬레이션 상태: <span id="sim-status">연결 대기 중...</span></span>
          </div>
        </div>

        <div class="col-lg-4">
          <div class="card card-box mb-30" style="padding: 20px;">
            <h5 class="h4 text-blue mb-20">장치 제어 패널</h5>

            <div class="mb-3">
              <label class="d-block mb-2">사무실 조명 (Light_01)</label>
              <button class="btn btn-success" onclick="sendCommand('Light_01', 'ON')">
                <i class="fa fa-lightbulb-o"></i> 켜기
              </button>
              <button class="btn btn-danger" onclick="sendCommand('Light_01', 'OFF')">
                <i class="fa fa-lightbulb-o"></i> 끄기
              </button>
            </div>

            <div class="mb-3">
              <label class="d-block mb-2">히터 (Heater_02)</label>
              <button class="btn btn-warning" onclick="sendCommand('Heater_02', 'HEAT')">
                <i class="fa fa-fire"></i> 가동
              </button>
              <button class="btn btn-secondary" onclick="sendCommand('Heater_02', 'OFF')">
                <i class="fa fa-power-off"></i> 정지
              </button>
            </div>

            <div class="mt-3">
              <p class="text-info" id="last-command">최근 전송 명령: 없음</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.babylonjs.com/babylon.js"></script>

<script>
  // --- 3D 시뮬레이션 (Babylon.js) 로직 시작 ---

  const canvas = document.getElementById("renderCanvas");
  const engine = new BABYLON.Engine(canvas, true);
  const simStatusEl = document.getElementById("sim-status");
  let controllableMeshes = {};

  const createScene = function () {
    const scene = new BABYLON.Scene(engine);

    // 씬 설정
    scene.clearColor = new BABYLON.Color3(0.5, 0.5, 0.5);

    // 카메라 설정
    const camera = new BABYLON.ArcRotateCamera("camera", -Math.PI / 2, Math.PI / 2.5, 30, BABYLON.Vector3.Zero(), scene);
    camera.attachControl(canvas, true);

    // 조명 설정 (환경광)
    const light = new BABYLON.HemisphericLight("light", new BABYLON.Vector3(0, 1, 0), scene);
    light.intensity = 0.7;

    // === 제어 대상 3D 오브젝트 생성 및 초기 설정 ===

    // 1. 조명 (Light_01) - 초기: 꺼짐 (어둡게)
    const lightMesh = BABYLON.MeshBuilder.CreateBox("Light_01", { size: 4, height: 1 }, scene);
    lightMesh.position = new BABYLON.Vector3(0, 10, 5);

    const lightMat = new BABYLON.StandardMaterial("lightMat", scene);
    lightMat.diffuseColor = new BABYLON.Color3(0.1, 0.1, 0.1);
    lightMat.emissiveColor = new BABYLON.Color3(0.05, 0.05, 0.05);
    lightMesh.material = lightMat;

    // 2. 히터 (Heater_02) - 초기: 정지 (파란색)
    const heaterMesh = BABYLON.MeshBuilder.CreateBox("Heater_02", { width: 3, height: 2, depth: 1 }, scene);
    heaterMesh.position = new BABYLON.Vector3(5, 1, -5);

    const heaterMat = new BABYLON.StandardMaterial("heaterMat", scene);
    heaterMat.diffuseColor = new BABYLON.Color3(0, 0, 1);
    heaterMat.emissiveColor = new BABYLON.Color3(0, 0, 0.5);
    heaterMesh.material = heaterMat;

    // 3. 바닥 (참고용)
    const ground = BABYLON.MeshBuilder.CreateGround("ground", { width: 40, height: 40 }, scene);
    ground.material = new BABYLON.StandardMaterial("groundMat", scene);
    ground.material.diffuseColor = new BABYLON.Color3(0.8, 0.8, 0.8);

    controllableMeshes["Light_01"] = lightMesh;
    controllableMeshes["Heater_02"] = heaterMesh;

    return scene;
  };

  const scene = createScene();

  engine.runRenderLoop(function () {
    scene.render();
  });

  window.addEventListener("resize", function () {
    engine.resize();
  });

  // 장치 상태를 시각적으로 업데이트하는 함수 (웹소켓 명령 수신 시 실행)
  function updateDeviceVisual(deviceId, state) {
    const mesh = controllableMeshes[deviceId];
    if (!mesh) return;

    const material = mesh.material;

    if (deviceId === 'Light_01') {
      if (state === 'ON') {
        material.emissiveColor = new BABYLON.Color3(1, 1, 0); // 켜짐: 밝은 노란색
        material.diffuseColor = new BABYLON.Color3(0.8, 0.8, 0.1);
      } else if (state === 'OFF') {
        material.emissiveColor = new BABYLON.Color3(0.05, 0.05, 0.05); // 꺼짐: 어둡게
        material.diffuseColor = new BABYLON.Color3(0.1, 0.1, 0.1);
      }
    } else if (deviceId === 'Heater_02') {
      if (state === 'HEAT') {
        material.diffuseColor = new BABYLON.Color3(1, 0, 0); // 가동: 빨간색
        material.emissiveColor = new BABYLON.Color3(1, 0, 0);
      } else if (state === 'OFF') {
        material.diffuseColor = new BABYLON.Color3(0, 0, 1); // 정지: 파란색
        material.emissiveColor = new BABYLON.Color3(0, 0, 0.5);
      }
    }

    console.log(`[SIM] ${deviceId} 상태가 ${state}로 변경되었습니다.`);
  }

  // --- 3D 시뮬레이션 로직 종료 ---


  // --- 웹소켓 클라이언트 및 버튼 동작 로직 시작 ---

  // CSRF 토큰 값 읽기 (index.jsp에 추가한 메타 태그에서 값을 가져옵니다.)
  const csrfTokenElement = document.querySelector('meta[name="_csrf"]');
  const csrfHeaderElement = document.querySelector('meta[name="_csrf_header"]');

  const csrfToken = csrfTokenElement ? csrfTokenElement.content : null;
  const csrfHeader = csrfHeaderElement ? csrfHeaderElement.content : null;

  var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
  var SIGNALING_URL = protocol + location.hostname + ':8444/signal';

  var socket;

  function startWebSocket() {
    socket = new WebSocket(SIGNALING_URL);

    socket.onopen = function() {
      simStatusEl.textContent = "연결됨";
      simStatusEl.style.color = "green";
      socket.send(JSON.stringify({ "type": "simulator_joined" }));
    };

    socket.onmessage = function(event) {
      try {
        var msg = JSON.parse(event.data);

        if (msg.type === 'CONTROL_COMMAND') {
          const deviceId = msg.deviceId;
          const state = msg.state;
          updateDeviceVisual(deviceId, state);
          return;
        }

      } catch (e) {
        console.error("웹소켓 메시지 처리 오류:", e);
      }
    };

    socket.onclose = function() {
      simStatusEl.textContent = "연결 끊김";
      simStatusEl.style.color = "red";
    };

    socket.onerror = function(error) {
      console.error("웹소켓 오류 발생:", error);
      simStatusEl.textContent = "오류 발생";
      simStatusEl.style.color = "red";
    };
  }

  // [⭐버튼 클릭 시 실행⭐] 백엔드 REST API로 명령을 전송하는 함수
  function sendCommand(deviceId, state) {
    document.getElementById('last-command').textContent = `최근 전송 명령: ${deviceId} - ${state}`;

    const headers = {};
    if (csrfToken && csrfHeader) {
      // [⭐핵심 수정⭐] CSRF 토큰을 헤더에 추가하여 보안 오류(403) 방지
      headers[csrfHeader] = csrfToken;
    }

    fetch(`/api/control/${deviceId}/${state}`, {
      method: 'POST',
      headers: headers
    })
            .then(response => {
              if (response.ok) {
                console.log("제어 명령 REST 요청 성공. 웹소켓으로 브로드캐스트됨.");
              } else if (response.status === 403) {
                alert("제어 명령 전송 실패: 접근 권한이 없습니다. (403 Forbidden - CSRF 문제일 수 있음)");
                console.error("API 요청 실패: 403 Forbidden. CSRF 토큰 확인 필요.");
              } else {
                alert("제어 명령 전송 실패: 서버 오류 (HTTP " + response.status + ")");
                console.error("API 요청 실패:", response.status);
              }
            })
            .catch(error => {
              console.error('REST API 통신 오류:', error);
              alert("REST API 통신 중 오류가 발생했습니다. (서버가 실행 중인지 확인하세요.)");
            });
  }

  startWebSocket();

</script>