<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/health-check.css'/>">
<style>
    .symptom-input-section {
        margin-top: 20px;
        margin-bottom: 20px;
    }

    .symptom-textarea {
        width: 100%;
        min-height: 100px;
        padding: 15px;
        border: 2px solid #e0e0e0;
        border-radius: 12px;
        resize: vertical;
        font-size: 1rem;
        transition: border-color 0.3s;
    }

    .symptom-textarea:focus {
        border-color: var(--primary-color);
        outline: none;
    }

    .input-label {
        font-weight: 600;
        margin-bottom: 10px;
        display: block;
        color: #333;
    }
</style>

<script>
(function () {
    const mapUrl = '<c:url value="/map"/>';
    let selectedFile = null;
    let cameraStream = null;

    function isMobile() {
        return /Mobi|Android|iPhone|iPad|iPod/i.test(navigator.userAgent);
    }

    function startCamera() {
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            alert('이 브라우저에서는 카메라를 사용할 수 없습니다.');
            return;
        }

        const video = document.getElementById('cameraVideo');
        const constraints = {
            video: isMobile()
                ? { width: { ideal: 1280 }, height: { ideal: 720 }, facingMode: { ideal: 'environment' } }
                : { width: { ideal: 1280 }, height: { ideal: 720 } }
        };

        navigator.mediaDevices.getUserMedia(constraints)
            .then(function (stream) {
                cameraStream = stream;
                video.srcObject = stream;
                video.play();
                document.getElementById('cameraSection').style.display = 'block';
                document.getElementById('uploadSection').style.display = 'none';
            })
            .catch(function (err) {
                console.error('카메라 오류:', err);
                alert('카메라 접근에 실패했습니다.');
            });
    }

    function stopCamera() {
        if (cameraStream) {
            cameraStream.getTracks().forEach(track => track.stop());
            cameraStream = null;
        }
        const video = document.getElementById('cameraVideo');
        if (video) video.srcObject = null;
        document.getElementById('cameraSection').style.display = 'none';
        document.getElementById('uploadSection').style.display = 'block';
    }

    function capturePhoto() {
        const video = document.getElementById('cameraVideo');
        if (!video || !cameraStream) {
            alert('카메라가 준비되지 않았습니다.');
            return;
        }

        const canvas = document.createElement('canvas');
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        canvas.getContext('2d').drawImage(video, 0, 0);

        canvas.toBlob(function (blob) {
            if (blob) {
                const file = new File([blob], 'camera-photo.jpg', { type: 'image/jpeg' });
                stopCamera();
                handleFileSelect(file);
            }
        }, 'image/jpeg', 0.9);
    }

    function handleFileSelect(file) {
        if (!file) return;

        if (!file.type.match('image/(jpeg|png)')) {
            alert('JPG 또는 PNG 파일만 업로드 가능합니다.');
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('파일 크기는 10MB 이하여야 합니다.');
            return;
        }

        selectedFile = file;

        const reader = new FileReader();
        reader.onload = function (e) {
            const preview = document.getElementById('previewImage');
            const container = document.getElementById('previewContainer');
            preview.src = e.target.result;
            container.style.display = 'block';
            document.getElementById('uploadSection').style.display = 'none';
        };
        reader.readAsDataURL(file);

        updateAnalyzeButton();
    }

    function resetUpload() {
        selectedFile = null;

        document.getElementById('imageInput').value = '';
        document.getElementById('previewImage').src = '';
        document.getElementById('previewContainer').style.display = 'none';
        document.getElementById('uploadSection').style.display = 'block';
        document.getElementById('resultsSection').classList.remove('active');

        updateAnalyzeButton();
    }

    function updateAnalyzeButton() {
        const btn = document.getElementById('analyzeBtn');
        const textInput = document.getElementById('symptomText');
        const textValue = textInput ? textInput.value.trim() : '';

        if (btn) {
            // Enable if either file is selected OR text is entered
            btn.disabled = !(selectedFile || textValue.length > 0);
        }
    }

    function performAnalysis() {
        const textInput = document.getElementById('symptomText');
        const textValue = textInput ? textInput.value.trim() : '';

        if (!selectedFile && !textValue) return;

        document.getElementById('loadingOverlay').classList.add('active');

        const formData = new FormData();
        if (selectedFile) {
            formData.append('image', selectedFile);
        }
        if (textValue) {
            formData.append('text', textValue);
        }

        fetch('<c:url value="/api/health-check/analyze"/>', {
            method: 'POST',
            body: formData
        })
            .then(res => {
                if (!res.ok) throw new Error('Network response was not ok');
                return res.json();
            })
            .then(data => displayResults(data))
            .catch(err => {
                console.error('분석 오류:', err);
                alert('AI 분석 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            })
            .finally(() => document.getElementById('loadingOverlay').classList.remove('active'));
    }

    function displayResults(data) {
        if (!data || data.error) {
            alert('분석 결과를 가져오지 못했습니다.');
            return;
        }

        const levelConfig = {
            'caution': { icon: '⚠️', text: '주의 관찰' },
            'observation': { icon: '👀', text: '지속 관찰 필요' },
            'hospital-recommended': { icon: '🏥', text: '병원 방문 권장' }
        };

        const config = levelConfig[data.level] || { icon: '❓', text: '분석 결과' };

        document.getElementById('levelBadge').className = 'level-badge ' + (data.level || '');
        document.getElementById('levelIcon').textContent = config.icon;
        document.getElementById('levelText').textContent = config.text;
        document.getElementById('diagnosisFindings').innerHTML = data.findings || '';
        document.getElementById('recommendations').innerHTML = data.recommendations || '';
        document.getElementById('confidenceValue').textContent = (data.confidence || 0) + '%';

        setTimeout(() => {
            document.getElementById('confidenceFill').style.width = (data.confidence || 0) + '%';
        }, 100);

        const hospitalSection = document.getElementById('hospitalSection');
        if (data.level === 'hospital-recommended') {
            hospitalSection.classList.add('active');
            if (data.costs) {
                document.getElementById('initialCost').textContent = data.costs.initial || '';
                document.getElementById('followUpCost').textContent = data.costs.followUp || '';
                document.getElementById('estimatedCost').textContent = data.costs.estimated || '';
            }
        } else {
            hospitalSection.classList.remove('active');
        }

        document.getElementById('resultsSection').classList.add('active');
        setTimeout(() => {
            document.getElementById('resultsSection').scrollIntoView({ behavior: 'smooth' });
        }, 300);

        saveToHistory(data);
    }

    function saveToHistory(data) {
        fetch('<c:url value="/api/health-check/history"/>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                level: data.level,
                findings: data.findings,
                recommendations: data.recommendations,
                confidence: data.confidence,
                timestamp: new Date().toISOString()
            })
        })
            .then(res => res.json())
            .then(result => console.log('저장 완료:', result))
            .catch(err => console.error('저장 오류:', err));
    }

    window.addEventListener('DOMContentLoaded', function () {
        document.getElementById('openFileBtn').addEventListener('click', function () {
            document.getElementById('imageInput').click();
        });

        document.getElementById('openCameraBtn').addEventListener('click', startCamera);
        document.getElementById('captureBtn').addEventListener('click', capturePhoto);
        document.getElementById('closeCameraBtn').addEventListener('click', stopCamera);

        document.getElementById('imageInput').addEventListener('change', function (e) {
            handleFileSelect(e.target.files[0]);
        });

        const dragArea = document.getElementById('uploadDragArea');
        dragArea.addEventListener('dragover', function (e) {
            e.preventDefault();
            dragArea.classList.add('drag-over');
        });
        dragArea.addEventListener('dragleave', function (e) {
            e.preventDefault();
            dragArea.classList.remove('drag-over');
        });
        dragArea.addEventListener('drop', function (e) {
            e.preventDefault();
            dragArea.classList.remove('drag-over');
            if (e.dataTransfer.files.length > 0) {
                handleFileSelect(e.dataTransfer.files[0]);
            }
        });

        document.getElementById('removeImageBtn').addEventListener('click', function (e) {
            e.stopPropagation();
            resetUpload();
        });

        document.getElementById('symptomText').addEventListener('input', updateAnalyzeButton);

        document.getElementById('analyzeBtn').addEventListener('click', function () {
            performAnalysis();
        });

        document.getElementById('findHospitalBtn').addEventListener('click', function () {
            window.location.href = mapUrl;
        });
    });
})();
</script>

<div class="health-check-container">
    <div class="container">
        <div class="health-check-header">
            <h1><i class="fas fa-heartbeat" style="color: var(--primary-color);"></i> AI 가상 진단</h1>
            <p class="subtitle">
                반려동물의 건강 상태를 AI가 빠르게 예비 진단합니다<br>
                사진을 업로드하거나 증상을 입력해주세요
            </p>
        </div>

        <div class="medical-disclaimer">
            <div class="disclaimer-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h5><i class="fas fa-info-circle"></i> 중요 안내</h5>
            <p>
                <strong>본 서비스는 실제 의학적 진단이 아닌 참고용 정보입니다.</strong><br>
                AI 분석 결과는 예비 판단이며, 정확한 진단과 치료를 위해서는 반드시 전문 수의사의 진료를 받으시기 바랍니다.
            </p>
        </div>

        <div class="upload-section">
            <div id="uploadSection">
                <div class="upload-method-header">
                    <h3><i class="fas fa-images"></i> 이미지 선택 (선택사항)</h3>
                    <p>사진이 있으면 더 정확한 분석이 가능합니다</p>
                </div>

                <div class="upload-actions">
                    <button type="button" class="btn btn-light btn-lg" id="openFileBtn">
                        <i class="fas fa-folder-open"></i>
                        <span>앨범에서 선택</span>
                    </button>
                    <button type="button" class="btn btn-primary btn-lg" id="openCameraBtn">
                        <i class="fas fa-camera"></i>
                        <span>카메라로 촬영</span>
                    </button>
                </div>

                <input type="file" id="imageInput" accept="image/jpeg,image/png" style="display:none;">

                <div class="upload-drag-area" id="uploadDragArea">
                    <div class="drag-area-content">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p>또는 여기에 파일을 드래그하세요</p>
                        <small class="text-muted">JPG, PNG 파일 (최대 10MB)</small>
                    </div>
                </div>
            </div>

            <div id="cameraSection" style="display:none;">
                <div class="camera-preview">
                    <video id="cameraVideo" autoplay playsinline muted></video>
                </div>
                <div class="camera-controls">
                    <button type="button" class="btn btn-success btn-lg" id="captureBtn">
                        <i class="fas fa-camera"></i> 사진 촬영
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-lg" id="closeCameraBtn">
                        <i class="fas fa-times"></i> 닫기
                    </button>
                </div>
            </div>

            <div id="previewContainer" class="image-preview-container" style="display:none;">
                <div class="image-preview">
                    <img id="previewImage" src="" alt="Preview">
                    <button class="remove-image-btn" id="removeImageBtn">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>

            <div class="symptom-input-section">
                <label for="symptomText" class="input-label">
                    <i class="fas fa-comment-medical"></i> 증상 설명 (선택사항)
                </label>
                <textarea id="symptomText" class="symptom-textarea"
                    placeholder="반려동물의 증상을 자세히 적어주세요. (예: 3일 전부터 밥을 안 먹고 기운이 없어요)"></textarea>
            </div>

            <button class="analyze-btn" id="analyzeBtn" disabled>
                <i class="fas fa-search-plus mr-2"></i>
                AI 분석 시작하기
            </button>
        </div>

        <div class="results-section" id="resultsSection">
            <div class="result-card">
                <div class="diagnosis-level">
                    <div class="level-badge" id="levelBadge">
                        <span class="level-icon" id="levelIcon"></span>
                        <span id="levelText">분석 결과</span>
                    </div>
                </div>

                <div class="analysis-details">
                    <h4 style="text-align: center; margin-bottom: var(--space-6);">
                        <i class="fas fa-chart-bar"></i> AI 분석 결과
                    </h4>

                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-stethoscope"></i>
                            <span>진단 소견</span>
                        </div>
                        <div class="detail-value" id="diagnosisFindings"></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-clipboard-check"></i>
                            <span>권장 조치사항</span>
                        </div>
                        <div class="detail-value" id="recommendations"></div>
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span><i class="fas fa-chart-line"></i> 분석 신뢰도</span>
                            <span id="confidenceValue">0%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" id="confidenceFill" style="width: 0%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="hospital-section" id="hospitalSection">
                <div class="hospital-header">
                    <h3><i class="fas fa-hospital"></i> 병원 방문을 권장합니다</h3>
                    <p>AI 분석 결과, 전문 수의사의 진료가 필요할 수 있습니다.</p>
                </div>

                <button class="find-hospital-btn" id="findHospitalBtn">
                    <i class="fas fa-map-marked-alt mr-2"></i>
                    주변 병원 보기
                </button>

                <div class="cost-info">
                    <div class="cost-header">
                        <i class="fas fa-won-sign"></i>
                        <h4>해당 지역 평균 진료비</h4>
                    </div>
                    <div class="cost-table">
                        <div class="cost-row">
                            <span class="cost-type">초진 진료</span>
                            <span class="cost-amount" id="initialCost">-</span>
                        </div>
                        <div class="cost-row">
                            <span class="cost-type">재진 진료</span>
                            <span class="cost-amount" id="followUpCost">-</span>
                        </div>
                    </div>
                    <div class="estimated-cost">
                        <div class="label">AI 예상 진료비</div>
                        <div class="amount" id="estimatedCost">-</div>
                    </div>
                </div>
            </div>

            <div class="health-history-notice">
                <div class="history-icon"><i class="fas fa-save"></i></div>
                <div class="history-text">
                    <h6>자동 저장 완료</h6>
                    <p>진단 결과가 건강 히스토리에 저장되었습니다.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-content">
        <div class="loading-spinner"></div>
        <div class="loading-text">AI가 증상과 이미지를 분석하고 있습니다...</div>
    </div>
</div>