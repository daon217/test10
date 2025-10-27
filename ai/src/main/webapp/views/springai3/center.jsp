<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    const center = {
        CAPTURE_INTERVAL_MS: 30000,
        DEFAULT_QUESTION: "지금 화면에 보이는 상황을 3문장 이상으로 설명하고 잠재적 위험을 강조한 뒤 마지막에 현재 시각을 알려주세요.",
        stream: null,
        captureTimer: null,
        videoElement: null,
        statusElement: null,
        adminEndpoint: '${adminserver}ai/monitor/frame',

        init() {
            this.videoElement = document.getElementById('cameraPreview');
            this.statusElement = document.getElementById('statusMessage');

            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                this.updateStatus(' 이 브라우저에서는 카메라 접근을 지원하지 않습니다.');
                return;
            }

            this.updateStatus('카메라 초기화 중...');
            navigator.mediaDevices.getUserMedia({ video: true, audio: false })
                .then(stream => {
                    this.stream = stream;
                    this.videoElement.srcObject = stream;
                    this.videoElement.play();
                    this.updateStatus('카메라가 연결되었습니다. 30초마다 자동으로 분석을 진행합니다.');
                    this.startCaptureLoop();
                })
                .catch(error => {
                    console.error('카메라 접근 실패:', error);
                    this.updateStatus(`카메라를 사용할 수 없습니다. (${error.name})`);
                });
        },

        startCaptureLoop() {
            if (this.captureTimer) {
                clearInterval(this.captureTimer);
            }
            this.captureAndSend();
            this.captureTimer = setInterval(() => this.captureAndSend(), this.CAPTURE_INTERVAL_MS);
        },

        async captureAndSend() {
            const frame = await this.captureFrame();
            if (!frame) {
                this.updateStatus('카메라 영상이 준비되지 않아 캡쳐를 건너뜁니다.');
                return;
            }

            this.updateStatus('영상 프레임을 분석 서버로 전송 중...');
            const formData = new FormData();
            formData.append('frame', frame, 'frame.png');
            formData.append('question', this.DEFAULT_QUESTION);

            try {
                const response = await fetch(this.adminEndpoint, {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }

                const data = await response.json();
                const { message, timestamp } = data;
                const timeText = timestamp ? new Date(timestamp).toLocaleString() : new Date().toLocaleString();
                const confirmation = message ? '관리자 센터로 분석 결과를 전송했습니다.' : '분석 결과가 비어 있어 관리자 센터로 전송하지 못했습니다.';
                this.updateStatus(`마지막 분석 완료: ${timeText} · ${confirmation}`);
            } catch (error) {
                console.error('분석 요청 실패:', error);
                this.updateStatus(`분석 요청에 실패했습니다: ${error.message}`);
            }
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

        updateStatus(message) {
            if (this.statusElement) {
                this.statusElement.textContent = message;
            }
        }
    };

    document.addEventListener('DOMContentLoaded', () => center.init());
</script>

<div class="col-sm-10">
    <h2>AI3 영상 자동 분석</h2>
    <h5>관리 서버: ${adminserver}</h5>

    <div class="row mt-4">
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">실시간 카메라</h5>
                    <video id="cameraPreview" class="w-100 rounded" autoplay muted playsinline></video>
                    <p id="statusMessage" class="mt-3 text-muted small"></p>
                </div>
            </div>
        </div>
    </div>
</div>
