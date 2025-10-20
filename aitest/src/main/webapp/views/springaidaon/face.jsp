<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  const faceCoach = {
    videoElement: null,
    statusElement: null,
    startButton: null,
    resultContainer: null,
    thumbnailContainer: null,
    countdownElement: null,
    stream: null,
    isScanning: false,
    capturedBlobs: {},
    steps: [
      { key: 'front', label: '정면', message: '정면을 바라봐주세요.' },
      { key: 'left', label: '좌측', message: '얼굴을 왼쪽으로 돌려주세요.' },
      { key: 'right', label: '우측', message: '얼굴을 오른쪽으로 돌려주세요.' },
      { key: 'up', label: '위쪽', message: '시선을 위로 올려주세요.' },
      { key: 'down', label: '아래쪽', message: '턱을 살짝 숙여 아래를 바라봐주세요.' }
    ],
    analysisEndpoint: '<c:url value="/aidaon/face/analyze" />',

    init() {
      this.videoElement = document.getElementById('faceCamera');
      this.statusElement = document.getElementById('faceStatus');
      this.startButton = document.getElementById('faceScanButton');
      this.resultContainer = document.getElementById('analysisResult');
      this.thumbnailContainer = document.getElementById('capturedThumbnails');
      this.countdownElement = document.getElementById('scanCountdown');

      this.startButton.addEventListener('click', () => this.startScan());
      this.prepareCamera();
    },

    async prepareCamera() {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        this.updateStatus('이 브라우저에서는 카메라 접근을 지원하지 않습니다.');
        this.startButton.disabled = true;
        return;
      }

      try {
        this.updateStatus('카메라를 준비하는 중입니다...');
        this.stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
        this.videoElement.srcObject = this.stream;
        await this.videoElement.play();
        this.updateStatus('카메라가 준비되었습니다. "스캔 시작" 버튼을 눌러주세요.');
      } catch (error) {
        console.error('카메라 접근 실패', error);
        this.updateStatus('카메라를 사용할 수 없습니다. 권한을 확인해주세요.');
        this.startButton.disabled = true;
      }
    },

    async startScan() {
      if (this.isScanning) {
        return;
      }
      this.isScanning = true;
      this.capturedBlobs = {};
      this.startButton.disabled = true;
      this.clearResults();

      for (const step of this.steps) {
        const captured = await this.captureStep(step);
        if (!captured) {
          this.updateStatus(`${step.label} 촬영에 실패했습니다. 다시 시도해주세요.`);
          this.isScanning = false;
          this.startButton.disabled = false;
          return;
        }
        this.capturedBlobs[step.key] = captured;
      }

      await this.sendForAnalysis();
      this.isScanning = false;
      this.startButton.disabled = false;
    },

    async captureStep(step) {
      this.updateStatus(step.message);
      await this.showCountdown(3);
      const frame = await this.captureFrame();
      if (!frame) {
        return null;
      }
      this.renderThumbnail(step, frame);
      return frame;
    },

    showCountdown(seconds) {
      return new Promise(resolve => {
        let remaining = seconds;
        this.countdownElement.textContent = `${remaining}`;
        this.countdownElement.classList.remove('d-none');

        const timer = setInterval(() => {
          remaining -= 1;
          if (remaining <= 0) {
            clearInterval(timer);
            this.countdownElement.textContent = '';
            this.countdownElement.classList.add('d-none');
            resolve();
          } else {
            this.countdownElement.textContent = `${remaining}`;
          }
        }, 1000);
      });
    },

    captureFrame() {
      const video = this.videoElement;
      if (!video || video.videoWidth === 0 || video.videoHeight === 0) {
        return Promise.resolve(null);
      }

      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0, canvas.width, canvas.height);

      return new Promise(resolve => {
        canvas.toBlob(blob => resolve(blob), 'image/png');
      });
    },

    renderThumbnail(step, blob) {
      const url = URL.createObjectURL(blob);
      let card = document.querySelector(`[data-angle="${step.key}"]`);
      if (!card) {
        card = document.createElement('div');
        card.className = 'col-md-4 col-lg-2';
        card.dataset.angle = step.key;
        card.innerHTML = `
                    <div class="card shadow-sm">
                        <img class="card-img-top" alt="${step.label} 캡쳐 이미지" />
                        <div class="card-body p-2">
                            <p class="card-text text-center small mb-0">${step.label}</p>
                        </div>
                    </div>
                `;
        this.thumbnailContainer.appendChild(card);
      }
      const img = card.querySelector('img');
      img.src = url;
    },

    async sendForAnalysis() {
      this.updateStatus('촬영한 이미지를 분석 중입니다...');
      const formData = new FormData();
      Object.entries(this.capturedBlobs).forEach(([key, blob]) => {
        const file = new File([blob], `${key}.png`, { type: 'image/png' });
        formData.append(key, file);
      });

      try {
        const response = await fetch(this.analysisEndpoint, {
          method: 'POST',
          body: formData
        });

        if (!response.ok) {
          const error = await response.json().catch(() => ({}));
          const message = error.error || '분석 요청에 실패했습니다.';
          this.updateStatus(message);
          return;
        }

        const data = await response.json();
        this.displayResults(data);
        this.updateStatus('분석이 완료되었습니다. 결과를 확인해주세요.');
      } catch (error) {
        console.error('분석 호출 실패', error);
        this.updateStatus('분석 서버와 통신 중 오류가 발생했습니다.');
      }
    },

    displayResults(data) {
      this.resultContainer.innerHTML = '';

      if (data.summary) {
        const summaryCard = document.createElement('div');
        summaryCard.className = 'card mb-3 border-success';
        summaryCard.innerHTML = `
                    <div class="card-header bg-success text-white">종합 코칭 요약</div>
                    <div class="card-body">
                        <p class="card-text">${this.formatText(data.summary)}</p>
                    </div>
                `;
        this.resultContainer.appendChild(summaryCard);
      }

      if (data.angles) {
        const detailContainer = document.createElement('div');
        detailContainer.className = 'row g-3';
        Object.entries(data.angles).forEach(([key, text]) => {
          const step = this.steps.find(item => item.key === key);
          const label = step ? step.label : key;
          const col = document.createElement('div');
          col.className = 'col-md-6';
          col.innerHTML = `
                        <div class="card h-100">
                            <div class="card-header">${label} 분석</div>
                            <div class="card-body">
                                <p class="card-text">${this.formatText(text)}</p>
                            </div>
                        </div>
                    `;
          detailContainer.appendChild(col);
        });
        this.resultContainer.appendChild(detailContainer);
      }
    },

    formatText(text) {
      if (!text) {
        return '';
      }
      return text
              .replaceAll('\n\n', '</p><p class="card-text">')
              .replaceAll('\n', '<br/>');
    },

    clearResults() {
      this.resultContainer.innerHTML = '';
      this.thumbnailContainer.innerHTML = '';
    },

    updateStatus(message) {
      if (this.statusElement) {
        this.statusElement.textContent = message;
      }
    }
  };

  document.addEventListener('DOMContentLoaded', () => faceCoach.init());
</script>

<div class="col-sm-10">
  <h2 class="mb-3">AI 얼굴 코칭</h2>
  <p class="text-muted">정면과 다양한 각도를 촬영해 맞춤형 뷰티 코칭을 받아보세요.</p>

  <div class="row g-4">
    <div class="col-lg-6">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">실시간 카메라 미리보기</h5>
          <video id="faceCamera" class="w-100 rounded" autoplay muted playsinline></video>
          <div class="text-center mt-3">
            <span id="scanCountdown" class="display-5 fw-bold text-primary d-none"></span>
          </div>
          <p id="faceStatus" class="text-muted small mt-3">카메라 초기화 중...</p>
          <button id="faceScanButton" class="btn btn-primary w-100">스캔 시작</button>
        </div>
      </div>
    </div>
    <div class="col-lg-6">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">촬영된 각도</h5>
          <p class="text-muted small">각 촬영 단계마다 미리보기가 표시됩니다.</p>
          <div id="capturedThumbnails" class="row g-3"></div>
        </div>
      </div>
    </div>
  </div>

  <div class="mt-4" id="analysisResult"></div>
</div>
