<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="main-container">
  <div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
      <div class="page-header">
        <div class="row">
          <div class="col-md-12 col-sm-12">
            <div class="title">
              <h4>CCTV 모니터링</h4>
            </div>
            <p class="text-muted">
              WebRTC 기반 IoT 장비(cctv 모듈)의 실시간 화면을 불러옵니다. 장비 서버가 실행 중인지 확인해주세요.
            </p>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="ai-analysis-card">
            <div class="ai-analysis-header">
              <h5 class="mb-1">AI 재난 감지 상태</h5>
              <span id="ai-analysis-status" class="status waiting">분석 대기 중</span>
            </div>
            <p id="ai-analysis-detail" class="ai-analysis-detail">
              CCTV 장비가 30초마다 프레임을 전송하여 화재, 지진, 인명 사고 등 재난 징후를 자동으로 분석합니다.
            </p>
            <ul id="ai-analysis-history" class="ai-analysis-history placeholder">
              <li>아직 수신된 분석 결과가 없습니다.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="card-box p-0">
            <iframe
                    id="cctvFrame"
                    src="http://localhost:8090"
                    title="Mun'cok CCTV"
                    class="cctv-frame"
                    allow="camera; microphone; fullscreen"
            ></iframe>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="alert alert-info mt-3">
            <h5 class="mb-2">연결 방법</h5>
            <ol class="mb-0 pl-3">
              <li><code>test10/cctv</code> 모듈에서 <code>npm install</code>, <code>npm start</code>를 실행합니다. (기본 포트: <code>8090</code>)</li>
              <li>브라우저가 카메라 접근 권한을 요청하면 허용합니다.</li>
              <li>이 페이지를 새로고침하면 CCTV 프리뷰가 자동으로 나타납니다.</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .cctv-frame {
    width: 100%;
    min-height: 580px;
    border: none;
    border-radius: 20px;
    background-color: #000;
  }

  .ai-analysis-card {
  background: #101322;
  border-radius: 20px;
  padding: 24px;
  color: #f7f9ff;
  box-shadow: 0 20px 45px rgba(10, 12, 24, 0.45);
  border: 1px solid rgba(255,255,255,0.05);
  margin-bottom: 20px;
  }

  .ai-analysis-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  }

  .ai-analysis-detail {
  margin-bottom: 12px;
  color: rgba(255,255,255,0.75);
  }

  .ai-analysis-history {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  }

  .ai-analysis-history.placeholder {
  color: rgba(255,255,255,0.5);
  }

  .ai-analysis-history li {
  background: rgba(255,255,255,0.08);
  border-radius: 14px;
  padding: 8px 14px;
  font-size: 0.85rem;
  display: flex;
  gap: 10px;
  }

  .ai-analysis-history li .time {
  font-weight: 600;
  color: rgba(255,255,255,0.9);
  }

  .status {
  font-size: 0.9rem;
  padding: 6px 14px;
  border-radius: 999px;
  background: rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.9);
  font-weight: 600;
  }

  .status.waiting {
  background: rgba(255,255,255,0.12);
  }

  .status.safe {
  background: rgba(62, 201, 144, 0.15);
  color: #85f0c0;
  }

  .status.alert {
  background: rgba(255, 94, 94, 0.18);
  color: #ff9494;
  }

  .status.error {
  background: rgba(255, 173, 66, 0.2);
  color: #ffdd9b;
  }
</style>

<script>
  (function() {
    const iframe = document.getElementById('cctvFrame');
    const statusEl = document.getElementById('ai-analysis-status');
    const detailEl = document.getElementById('ai-analysis-detail');
    const historyEl = document.getElementById('ai-analysis-history');

    const updateStatus = (state, text, detail) => {
      statusEl.textContent = text;
      statusEl.className = `status ${state}`;
      detailEl.textContent = detail;
    };

    const addHistory = (timeText, summary, accentClass) => {
      if (historyEl.classList.contains('placeholder')) {
        historyEl.innerHTML = '';
        historyEl.classList.remove('placeholder');
      }
      const item = document.createElement('li');
      if (accentClass) {
        item.classList.add(accentClass);
      }
      item.innerHTML = `<span class="time">${timeText}</span><span class="message">${summary}</span>`;
      historyEl.prepend(item);
      while (historyEl.children.length > 5) {
        historyEl.removeChild(historyEl.lastElementChild);
      }
    };

    updateStatus('waiting', '분석 대기 중', 'CCTV 장비의 분석 신호를 대기하고 있습니다.');

    window.addEventListener('message', (event) => {
      if (!event.data || event.data.type !== 'CCTV_ANALYSIS_RESULT') {
        return;
      }

      let expectedOrigin = null;
      if (iframe && iframe.src) {
        try {
          expectedOrigin = new URL(iframe.src).origin;
        } catch (err) {
          expectedOrigin = null;
        }
      }
      if (expectedOrigin && event.origin !== expectedOrigin) {
        return;
      }

      const payload = event.data.payload || {};
      const timestamp = payload.timestamp ? new Date(payload.timestamp) : new Date();
      const timeText = timestamp.toLocaleTimeString('ko-KR', { hour12: false });
      const severity = payload.severity || 'info';
      const message = payload.message || '상세 정보 없음';

      if (severity === 'alert') {
        updateStatus('alert', '🚨 재난 징후 감지', message);
        addHistory(timeText, message, 'text-danger');
      } else if (severity === 'error') {
        updateStatus('error', '⚠️ 분석 오류', message);
        addHistory(timeText, message, 'text-warning');
      } else {
        updateStatus('safe', '✅ 이상 징후 없음', `최근 분석(${timeText}) 기준 이상 징후가 감지되지 않았습니다.`);
        addHistory(timeText, '이상 없음', 'text-success');
      }
    });
  })();
</script>