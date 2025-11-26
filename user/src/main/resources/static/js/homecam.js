document.addEventListener('DOMContentLoaded', () => {
    const video = document.getElementById('homecam-video');
    const cameraStatus = document.getElementById('camera-status');
    const aiStatus = document.getElementById('ai-status');
    const overlay = document.getElementById('homecam-overlay');
    const overlayText = document.getElementById('analysis-overlay-text');
    const toggleButton = document.getElementById('analysis-toggle');
    const manualButton = document.getElementById('manual-capture');
    const analysisLog = document.getElementById('analysis-log');
    const highlight = document.getElementById('alert-highlight');
    const highlightTitle = document.getElementById('highlight-title');
    const highlightDesc = document.getElementById('highlight-desc');
    const riskChip = document.getElementById('risk-indicator');
    const questionInput = document.getElementById('analysis-question');

    let mediaStream;
    let analysisTimer;
    const ANALYSIS_INTERVAL = 20000; // 20초

    const setOverlay = (text, state = 'on') => {
        overlayText.textContent = text;
        overlay.dataset.state = state;
    };

    const updateCameraStatus = (text, stateClass) => {
        cameraStatus.textContent = text;
        cameraStatus.className = `status-badge ${stateClass}`.trim();
    };

    const updateAiStatus = (text, stateClass) => {
        aiStatus.textContent = text;
        aiStatus.className = `status-badge ${stateClass}`.trim();
    };

    const updateHighlight = (title, desc, level = 'safe') => {
        highlightTitle.textContent = title;
        highlightDesc.textContent = desc;
        highlight.classList.toggle('alert', level === 'alert');
        riskChip.textContent = level === 'alert' ? '경보' : '안정';
        riskChip.className = `risk-chip ${level === 'alert' ? 'alert' : 'safe'}`;
    };

    const appendLog = (message) => {
        const timestamp = new Date().toLocaleTimeString('ko-KR', { hour12: false });
        const item = document.createElement('li');
        item.innerHTML = `<span class="time">${timestamp}</span><span class="text">${message}</span>`;

        if (analysisLog.firstElementChild && analysisLog.firstElementChild.classList.contains('placeholder')) {
            analysisLog.innerHTML = '';
        }

        analysisLog.prepend(item);
        while (analysisLog.children.length > 10) {
            analysisLog.removeChild(analysisLog.lastElementChild);
        }
    };

    const captureFrame = () => {
        return new Promise((resolve, reject) => {
            if (!video.videoWidth) {
                return reject(new Error('비디오 프레임을 아직 불러오지 못했습니다.'));
            }

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

            canvas.toBlob((blob) => {
                if (blob) {
                    resolve(blob);
                } else {
                    reject(new Error('프레임을 캡처하지 못했습니다.'));
                }
            }, 'image/png');
        });
    };

    const handleLine = (line) => {
        if (!line) return;
        appendLog(line);

        if (line.includes('NO_DISASTER_DETECTED')) {
            updateHighlight('정상 상태', '반려동물과 공간에 이상이 없어요.', 'safe');
        } else {
            updateHighlight('⚠️ 위험 감지', line, 'alert');
        }
    };

    const readStream = async (body) => {
        const reader = body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';

        while (true) {
            const { value, done } = await reader.read();
            if (done) break;

            buffer += decoder.decode(value, { stream: true });
            const lines = buffer.split('\n');
            buffer = lines.pop();
            lines.forEach((line) => handleLine(line.trim()));
        }

        if (buffer.trim()) {
            handleLine(buffer.trim());
        }
    };

    const analyze = async () => {
        if (!mediaStream) return;

        updateAiStatus('AI 분석 중', 'processing');
        setOverlay('AI가 화면을 분석하고 있어요...', 'processing');

        try {
            const blob = await captureFrame();
            const formData = new FormData();
            formData.append('question', questionInput.value || '');
            formData.append('attach', blob, 'frame.png');

            const response = await fetch('/homecam/api/analysis', {
                method: 'POST',
                body: formData
            });

            if (!response.ok || !response.body) {
                throw new Error('서버 응답을 받을 수 없습니다.');
            }

            await readStream(response.body);
            updateAiStatus('분석 완료', 'on');
            setOverlay('AI가 실시간으로 감시 중입니다.', 'on');
        } catch (err) {
            console.error(err);
            updateAiStatus('분석 실패', 'error');
            setOverlay(err.message, 'error');
            appendLog(`오류: ${err.message}`);
        }
    };

    const startAnalysisLoop = () => {
        if (analysisTimer) clearInterval(analysisTimer);
        analyze();
        analysisTimer = setInterval(analyze, ANALYSIS_INTERVAL);
        toggleButton.dataset.running = 'true';
        toggleButton.innerHTML = '<i class="fas fa-pause-circle mr-1"></i> 분석 일시정지';
    };

    const stopAnalysisLoop = () => {
        if (analysisTimer) clearInterval(analysisTimer);
        analysisTimer = null;
        toggleButton.dataset.running = 'false';
        toggleButton.innerHTML = '<i class="fas fa-play-circle mr-1"></i> 분석 재개';
        updateAiStatus('AI 대기', 'neutral');
        setOverlay('AI 분석이 일시정지되었습니다.', 'processing');
    };

    const initCamera = async () => {
        try {
            mediaStream = await navigator.mediaDevices.getUserMedia({
                video: { facingMode: { ideal: 'environment' } },
                audio: false
            });

            video.srcObject = mediaStream;
            updateCameraStatus('카메라 연결됨', 'on');
            setOverlay('AI가 실시간으로 감시 중입니다.', 'on');
            startAnalysisLoop();
        } catch (err) {
            console.error(err);
            updateCameraStatus('카메라 오류', 'error');
            setOverlay('카메라 접근 권한을 확인해주세요.', 'error');
            appendLog('카메라에 접근할 수 없습니다. 권한을 허용해주세요.');
        }
    };

    toggleButton.addEventListener('click', () => {
        const running = toggleButton.dataset.running === 'true';
        if (running) {
            stopAnalysisLoop();
        } else {
            startAnalysisLoop();
        }
    });

    manualButton.addEventListener('click', () => {
        analyze();
    });

    initCamera();
});