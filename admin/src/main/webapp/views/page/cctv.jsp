<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<script src="/vendors/scripts/core.js"></script>
<script src="/vendors/scripts/script.min.js"></script>
<script src="/vendors/scripts/process.js"></script>
<script src="/vendors/scripts/layout-settings.js"></script>

<div class="main-container">
  <div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
      <div class="page-header">
        <div class="row">
          <div class="col-md-12 col-sm-12">
            <div class="title">
              <h4>CCTV 통합 관제 센터</h4>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="ai-analysis-card">
            <div class="ai-analysis-header">
              <h5 class="mb-1">AI 통합 재난 감지 로그</h5>
              <span id="global-status" class="status waiting">서버 연결 대기 중...</span>
            </div>
            <ul id="ai-analysis-history" class="ai-analysis-history placeholder">
              <li>아직 수신된 분석 결과가 없습니다.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="row" id="cctv-grid-container">
      </div>

      <div class="row mt-3">
        <div class="col-12 text-center">
          <button id="connectBtn" class="btn btn-primary btn-lg" onclick="startMonitoring()">
            <i class="fa fa-refresh"></i> 시스템 재연결
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .ai-analysis-card {
    background: #101322;
    border-radius: 20px;
    padding: 24px;
    color: #f7f9ff;
    box-shadow: 0 20px 45px rgba(10, 12, 24, 0.45);
    border: 1px solid rgba(255,255,255,0.05);
    margin-bottom: 20px;
  }
  .ai-analysis-header { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 15px;}
  .ai-analysis-history { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 8px; }
  .ai-analysis-history.placeholder { color: rgba(255,255,255,0.5); }
  .ai-analysis-history li { background: rgba(255,255,255,0.08); border-radius: 14px; padding: 8px 14px; font-size: 0.85rem; display: flex; gap: 10px; }
  .ai-analysis-history li .time { font-weight: 600; color: rgba(255,255,255,0.9); }

  .status { font-size: 0.9rem; padding: 6px 14px; border-radius: 999px; background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.9); font-weight: 600; }
  .status.waiting { background: rgba(255,255,255,0.12); }
  .status.safe { background: rgba(62, 201, 144, 0.15); color: #85f0c0; }
  .status.alert { background: rgba(255, 94, 94, 0.18); color: #ff9494; }
  .status.error { background: rgba(255, 173, 66, 0.2); color: #ffdd9b; }

  .text-danger { color: #ff9494 !important; }
  .text-warning { color: #ffdd9b !important; }
  .text-success { color: #85f0c0 !important; }

  .cctv-col { margin-bottom: 20px; }
  .cctv-card {
    background: #000;
    border-radius: 15px;
    overflow: hidden;
    position: relative;
    aspect-ratio: 16 / 9;
    border: 2px solid #333;
    box-shadow: 0 10px 20px rgba(0,0,0,0.5);
  }
  .cctv-card video { width: 100%; height: 100%; object-fit: contain; }
  .cctv-label {
    position: absolute; top: 15px; left: 15px;
    background: rgba(0,0,0,0.7); color: #fff;
    padding: 5px 10px; border-radius: 6px;
    font-weight: bold; font-size: 0.9rem; z-index: 10;
  }
  .cctv-status-overlay { position: absolute; bottom: 15px; right: 15px; z-index: 10; }
</style>

<script>
  (function() {
    // [핵심 해결] dashboard3.js 에러 방지용 더미 함수
    // 만약 dashboard3.js가 실행되더라도 에러가 나지 않도록 막습니다.
    if(typeof ApexCharts !== 'undefined') {
      ApexCharts.exec = function() {};
    }

    const historyEl = document.getElementById('ai-analysis-history');
    const globalStatusEl = document.getElementById('global-status');
    const connectBtn = document.getElementById('connectBtn');
    const gridContainer = document.getElementById('cctv-grid-container');

    const SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.hostname + ':8444/signal';

    let socket;
    const peerConnections = new Map();

    const rtcConfig = {
      iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
    };

    const addHistory = (timeText, summary, accentClass, cctvId) => {
      if (historyEl.classList.contains('placeholder')) {
        historyEl.innerHTML = '';
        historyEl.classList.remove('placeholder');
      }
      const item = document.createElement('li');
      if (accentClass) item.classList.add(accentClass);
      const sourceLabel = cctvId ? `[${cctvId}] ` : '';
      item.innerHTML = `<span class="time">${timeText}</span><span class="message">${sourceLabel}${summary}</span>`;
      historyEl.prepend(item);
      while (historyEl.children.length > 10) {
        historyEl.removeChild(historyEl.lastElementChild);
      }
    };

    window.startMonitoring = function() {
      connectBtn.style.display = 'none';
      globalStatusEl.textContent = '서버 연결 중...';

      socket = new WebSocket(SIGNALING_URL);

      socket.onopen = () => {
        globalStatusEl.textContent = '모니터링 활성화';
        globalStatusEl.className = 'status safe';
        socket.send(JSON.stringify({ type: 'viewer_joined' }));
      };

      socket.onmessage = async (event) => {
        const msg = JSON.parse(event.data);

        if (msg.type === 'CCTV_ANALYSIS_RESULT') {
          handleAnalysisResult(msg.payload);
          return;
        }

        const cctvId = msg.id || 'unknown_camera';

        if (msg.type === 'offer') {
          await handleOffer(cctvId, msg);
        }
        else if (msg.type === 'candidate') {
          const pc = peerConnections.get(cctvId);
          if (pc && msg.candidate) {
            await pc.addIceCandidate(new RTCIceCandidate(msg.candidate));
          }
        }
      };

      socket.onclose = () => {
        globalStatusEl.textContent = '서버 연결 끊김';
        globalStatusEl.className = 'status error';
        connectBtn.style.display = 'inline-block';
        peerConnections.forEach(pc => pc.close());
        peerConnections.clear();
        gridContainer.innerHTML = '';
      };
    };

    async function handleOffer(cctvId, msg) {
      if (peerConnections.has(cctvId)) {
        peerConnections.get(cctvId).close();
        peerConnections.delete(cctvId);
        const existingCard = document.getElementById(`card-${cctvId}`);
        if(existingCard) existingCard.remove();
      }

      createVideoElement(cctvId);

      const pc = new RTCPeerConnection(rtcConfig);
      peerConnections.set(cctvId, pc);

      pc.ontrack = (event) => {
        const videoEl = document.getElementById(`video-${cctvId}`);
        const statusEl = document.getElementById(`status-${cctvId}`);
        if (videoEl) {
          videoEl.srcObject = event.streams[0];
          if(statusEl) {
            statusEl.textContent = 'LIVE';
            statusEl.className = 'status safe';
          }
        }
      };

      pc.onicecandidate = (event) => {
        if (event.candidate) {
          socket.send(JSON.stringify({
            type: 'candidate',
            id: cctvId,
            candidate: event.candidate
          }));
        }
      };

      await pc.setRemoteDescription(new RTCSessionDescription(msg));
      const answer = await pc.createAnswer();
      await pc.setLocalDescription(answer);

      socket.send(JSON.stringify({
        type: 'answer',
        id: cctvId,
        sdp: answer.sdp
      }));
    }

    function createVideoElement(cctvId) {
      if (document.getElementById(`card-${cctvId}`)) return;

      const colDiv = document.createElement('div');
      colDiv.className = 'col-xl-4 col-lg-4 col-md-6 col-sm-12 cctv-col';
      colDiv.id = `card-${cctvId}`;

      colDiv.innerHTML = `
            <div class="cctv-card">
                <span class="cctv-label"><i class="fa fa-video-camera"></i> ${cctvId}</span>
                <video id="video-${cctvId}" autoplay playsinline controls muted></video>
                <div class="cctv-status-overlay">
                    <span id="status-${cctvId}" class="status waiting">연결 중...</span>
                </div>
            </div>
        `;
      gridContainer.appendChild(colDiv);
    }

    function handleAnalysisResult(payload) {
      const timestamp = payload.timestamp ? new Date(payload.timestamp) : new Date();
      const timeText = timestamp.toLocaleTimeString('ko-KR', { hour12: false });
      const severity = payload.severity || 'info';
      const message = payload.message || '상세 정보 없음';
      const sourceId = payload.cctvId || 'Unknown';

      if (severity === 'alert') {
        addHistory(timeText, message, 'text-danger', sourceId);
        const statusEl = document.getElementById(`status-${sourceId}`);
        if(statusEl) {
          statusEl.textContent = '위험 감지';
          statusEl.className = 'status alert';
        }
      } else if (severity === 'normal') {
        const statusEl = document.getElementById(`status-${sourceId}`);
        if(statusEl && statusEl.textContent === '위험 감지') {
          statusEl.textContent = 'LIVE';
          statusEl.className = 'status safe';
        }
      }
    }

    startMonitoring();

  })();
</script>