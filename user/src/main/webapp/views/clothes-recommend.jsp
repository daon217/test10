<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 페이지 전용 스타일 */
    .recommend-container {
        max-width: 900px;
        margin: 3rem auto;
        padding: 0 1rem;
    }
    .recommend-header {
        text-align: center;
        margin-bottom: 2.5rem;
    }
    .recommend-header h2 {
        color: var(--primary-color);
        font-weight: var(--font-bold);
        margin-bottom: 0.5rem;
    }
    .upload-area {
        background: var(--bg-card);
        border: 2px dashed var(--border-light);
        border-radius: var(--radius-xl);
        padding: 2rem;
        text-align: center;
        cursor: pointer;
        transition: all var(--transition-base);
    }
    .upload-area:hover {
        border-color: var(--primary-light);
        background: var(--primary-bg);
    }
    .file-input {
        display: none;
    }
    .upload-icon {
        font-size: 3rem;
        color: var(--text-tertiary);
        margin-bottom: 1rem;
    }
    .result-section {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 1.5rem;
        margin-top: 2rem;
    }
    .result-card {
        background: var(--bg-card);
        border-radius: var(--radius-xl);
        box-shadow: var(--shadow-sm);
        padding: 1.5rem;
        border-left: 5px solid var(--primary-color);
    }
    .result-card h5 {
        font-weight: var(--font-semibold);
        color: var(--text-primary);
        margin-bottom: 1rem;
    }
    .fitting-image-card {
        grid-column: 1 / -1;
        padding: 0;
        overflow: hidden;
        border-left: none;
        text-align: center;
        min-height: 300px;
        background: #f1f3f5;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
        color: var(--text-muted);
    }
    .fitting-image-card img {
        width: 100%;
        height: auto;
        border-radius: var(--radius-xl);
    }
    .measurement-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .measurement-list li {
        display: flex;
        justify-content: space-between;
        padding: 0.5rem 0;
        border-bottom: 1px dashed var(--border-light);
        font-size: 0.95rem;
    }
    .measurement-list li:last-child {
        border-bottom: none;
    }
    .measurement-list .label {
        font-weight: var(--font-medium);
        color: var(--text-secondary);
    }
    .measurement-list .value {
        font-weight: var(--font-bold);
        color: var(--primary-color);
    }
    .color-chip-container {
        display: flex;
        gap: 10px;
        margin-top: 10px;
    }
    .color-chip {
        width: 40px;
        height: 40px;
        border-radius: var(--radius-md);
        border: 2px solid var(--border-light);
    }

    /* 로딩 스피너 */
    .spinner-border {
        display: none;
    }
</style>

<div class="main-container">
    <div class="recommend-container">
        <div class="recommend-header">
            <h2 class="section-title-custom">AI 옷 사이즈 추천</h2>
            <p class="text-secondary">전신 사진 한 장으로 AI가 신체 치수를 추정하고 맞춤 사이즈를 추천합니다.</p>
        </div>

        <div class="pet-card">
            <label class="upload-area" for="fullBodyImage">
                <input type="file" id="fullBodyImage" class="file-input" accept="image/*">
                <i class="fas fa-camera upload-icon"></i>
                <p class="mb-1 text-primary" id="upload-text">
                    <strong>전신 사진을 업로드해주세요. (정면 사진 권장)</strong>
                </p>
                <small class="text-muted">파일 형식: JPG, PNG | 최대 크기: 10MB</small>
                <div id="image-preview" style="max-width: 100%; max-height: 300px; overflow: hidden; margin-top: 1rem; display: none;">
                    <img id="preview-img" alt="업로드 이미지 미리보기" style="width: auto; height: 300px; border-radius: var(--radius-md); object-fit: contain;">
                </div>
            </label>

            <button type="button" id="analyze-btn" class="btn btn-pet-primary btn-block mt-4" disabled
                    onclick="runAIAnalysis()" style="height: 3rem; font-size: 1.1rem;">
                <span id="btn-text"><i class="fas fa-magic mr-2"></i> AI 사이즈 추천 시작</span>
                <div class="spinner-border text-light" role="status" id="loading-spinner">
                    <span class="sr-only">Loading...</span>
                </div>
            </button>
        </div>

        <div class="result-section" id="result-section" style="display: none;">
            <div class="result-card">
                <h5 class="text-primary"><i class="fas fa-ruler-combined mr-2"></i> 신체 치수 및 권장 사이즈</h5>
                <ul class="measurement-list">
                    <li><span class="label">추정 키</span><span class="value" id="height-result">175.2 cm</span></li>
                    <li><span class="label">추정 가슴 둘레</span><span class="value" id="chest-result">95 cm</span></li>
                    <li><span class="label">추정 허리 둘레</span><span class="value" id="waist-result">78 cm</span></li>
                    <li><span class="label">권장 상의 사이즈</span><span class="value" id="top-size">L (100)</span></li>
                    <li><span class="label">권장 하의 사이즈</span><span class="value" id="bottom-size">30 (76 cm)</span></li>
                </ul>
            </div>

            <div class="result-card">
                <h5 style="color: var(--secondary-color);"><i class="fas fa-palette mr-2"></i> 어울리는 컬러 추천</h5>
                <p class="text-secondary" id="color-recommend-text">
                    (피부톤 분석 기반) 웜톤에 적합한 소프트한 컬러 계열을 추천합니다.
                </p>
                <div class="color-chip-container" id="color-chips">
                    <div class="color-chip" style="background-color: #FFC0CB;" title="파스텔 핑크"></div>
                    <div class="color-chip" style="background-color: #ADD8E6;" title="스카이 블루"></div>
                    <div class="color-chip" style="background-color: #90EE90;" title="민트 그린"></div>
                    <div class="color-chip" style="background-color: #FFE4B5;" title="밝은 베이지"></div>
                </div>
            </div>

            <div class="fitting-image-card pet-card">
                <h5 class="text-primary" style="margin-bottom: 0;"><i class="fas fa-user-check mr-2"></i> AI 가상 피팅 이미지</h5>
                <p id="fitting-status" class="mt-2">AI가 추천 의상으로 피팅 이미지를 생성했습니다.</p>
                <img id="fitting-result-img" style="display: none;" src="<c:url value='/images/virtual-fitting-placeholder.png'/>" alt="AI 가상 피팅 결과">
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const fileInput = document.getElementById('fullBodyImage');
        const previewImg = document.getElementById('preview-img');
        const imagePreview = document.getElementById('image-preview');
        const uploadText = document.getElementById('upload-text');
        const analyzeBtn = document.getElementById('analyze-btn');
        const loadingSpinner = document.getElementById('loading-spinner');
        const btnText = document.getElementById('btn-text');
        const resultSection = document.getElementById('result-section');

        // 파일 선택 시 미리보기 표시 및 버튼 활성화
        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    imagePreview.style.display = 'block';
                    uploadText.innerHTML = '<strong>' + file.name + '</strong>';
                    analyzeBtn.disabled = false;
                }
                reader.readAsDataURL(file);
                resultSection.style.display = 'none'; // 새 파일 업로드 시 결과 숨김
            } else {
                previewImg.src = '';
                imagePreview.style.display = 'none';
                uploadText.innerHTML = '<strong>전신 사진을 업로드해주세요. (정면 사진 권장)</strong>';
                analyzeBtn.disabled = true;
                resultSection.style.display = 'none';
            }
        });

        // AI 분석 시뮬레이션 함수
        window.runAIAnalysis = function() {
            if (analyzeBtn.disabled) return;

            // 로딩 시작
            analyzeBtn.disabled = true;
            btnText.style.display = 'none';
            loadingSpinner.style.display = 'block';
            resultSection.style.display = 'none';

            // AI 분석 시뮬레이션 (3초 후 완료)
            setTimeout(() => {
                // 결과 업데이트 (Placeholder 데이터)
                document.getElementById('height-result').textContent = '175.2 cm';
                document.getElementById('chest-result').textContent = '95 cm';
                document.getElementById('waist-result').textContent = '78 cm';
                document.getElementById('top-size').textContent = 'L (100)';
                document.getElementById('bottom-size').textContent = '30 (76 cm)';

                document.getElementById('color-recommend-text').innerHTML = '(피부톤 분석 기반) <strong>웜톤</strong>에 적합한 소프트한 컬러 계열을 추천합니다.';
                document.getElementById('fitting-status').textContent = 'AI가 추천 의상으로 피팅 이미지를 생성했습니다.';
                document.getElementById('fitting-result-img').style.display = 'block';
                document.getElementById('fitting-result-img').src = '<c:url value="/images/virtual-fitting-result.jpg"/>'; // 실제 이미지 경로로 대체 필요

                // 로딩 종료 및 결과 표시
                analyzeBtn.disabled = false;
                btnText.style.display = 'inline';
                loadingSpinner.style.display = 'none';
                resultSection.style.display = 'grid'; // 결과 섹션 표시

                // 스크롤 이동
                resultSection.scrollIntoView({ behavior: 'smooth', block: 'start' });

            }, 3000);
        }
    });
</script>