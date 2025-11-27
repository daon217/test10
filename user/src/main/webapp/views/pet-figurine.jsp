<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  /* 페이지 전용 스타일 */
  .figurine-container {
    max-width: 900px;
    margin: 3rem auto;
    padding: 0 1rem;
  }
  .figurine-header {
    text-align: center;
    margin-bottom: 2.5rem;
  }
  .figurine-header h2 {
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
    display: none; /* 초기에는 숨김 */
    margin-top: 2rem;
    text-align: center;
  }
  .figurine-image-card {
    padding: 0;
    overflow: hidden;
    border: none;
    text-align: center;
    min-height: 300px;
    background: #f1f3f5;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    color: var(--text-muted);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-sm);
  }
  .figurine-image-card img {
    width: auto;
    max-width: 100%;
    max-height: 500px;
    height: auto;
    border-radius: var(--radius-xl);
    object-fit: contain;
    display: none;
  }
  .image-preview {
    max-width: 100%;
    max-height: 300px;
    overflow: hidden;
    margin-top: 1rem;
    display: none;
  }
  .image-preview img {
    width: auto;
    height: 300px;
    border-radius: var(--radius-md);
    object-fit: contain;
  }
  /* 로딩 스피너 */
  .spinner-border {
    display: none;
  }
  .figurine-desc {
    color: var(--text-secondary);
    font-size: 1rem;
    margin-top: 1rem;
  }
</style>

<div class="main-container">
  <div class="figurine-container">
    <div class="figurine-header">
      <h2 class="section-title-custom">나의 강아지 피규어</h2>
      <p class="text-secondary">반려동물 사진 한 장으로 AI가 귀여운 3D 피규어 이미지를 제작해 드립니다.</p>
    </div>

    <div class="pet-card">
      <label class="upload-area" for="petImage">
        <input type="file" id="petImage" class="file-input" accept="image/*" multiple>
        <i class="fas fa-magic upload-icon"></i>
        <p class="mb-1 text-primary" id="upload-text">
          <strong>반려동물 전신 사진을 업로드해주세요. (정면 사진 권장)</strong>
        </p>
        <small class="text-muted">파일 형식: JPG, PNG | 최대 크기: 10MB</small>
        <div id="image-preview" class="image-preview">
          <img id="preview-img" alt="업로드 이미지 미리보기">
        </div>
      </label>

      <button type="button" id="generate-btn" class="btn btn-pet-primary btn-block mt-4" disabled
              onclick="runFigurineGeneration()" style="height: 3rem; font-size: 1.1rem;">
        <span id="btn-text"><i class="fas fa-cube mr-2"></i> AI 피규어 이미지 생성 시작</span>
        <div class="spinner-border text-light" role="status" id="loading-spinner">
          <span class="sr-only">Loading...</span>
        </div>
      </button>
    </div>

    <div class="result-section" id="result-section">
      <h3 class="text-primary" style="margin-bottom: 1.5rem;"><i class="fas fa-star mr-2"></i> AI 피규어 생성 결과</h3>
      <div class="figurine-image-card pet-card">
        <p id="figurine-status" class="mt-2" style="font-weight: 500;">AI 이미지 생성 결과가 여기에 표시됩니다.</p>
        <img id="figurine-result-img" src="<c:url value='/images/virtual-fitting-placeholder.png'/>" alt="AI 피규어 결과">
        <p id="figurine-description" class="figurine-desc">이미지를 업로드하고 AI 피규어 생성을 시작하세요.</p>
      </div>
    </div>

  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('petImage');
    const previewImg = document.getElementById('preview-img');
    const imagePreview = document.getElementById('image-preview');
    const uploadText = document.getElementById('upload-text');
    const generateBtn = document.getElementById('generate-btn');
    const loadingSpinner = document.getElementById('loading-spinner');
    const btnText = document.getElementById('btn-text');
    const resultSection = document.getElementById('result-section');
    const figurineResultImg = document.getElementById('figurine-result-img');
    const figurineStatus = document.getElementById('figurine-status');
    const figurineDescription = document.getElementById('figurine-description');
    const placeholderUrl = '<c:url value="/images/virtual-fitting-placeholder.png"/>';

    // 초기 상태 설정
    figurineResultImg.style.display = 'block';
    figurineResultImg.src = placeholderUrl;

    // 파일 선택 시 미리보기 표시 및 버튼 활성화
    fileInput.addEventListener('change', function(e) {
      const files = e.target.files;
      if (files && files.length > 0) {
        // **다중 파일 처리**: AI 분석은 첫 번째 파일만 사용합니다.
        const selectedFile = files[0];

        const reader = new FileReader();

        reader.onload = function(e) {
          previewImg.src = e.target.result;
          imagePreview.style.display = 'block';
          // 파일 이름 표시 로직
          let fileNameDisplay = selectedFile.name;
          if (files.length > 1) {
            fileNameDisplay = `${selectedFile.name} 외 ${files.length - 1}개 파일 선택됨. (AI 분석은 첫 번째 파일만 사용합니다.)`;
          }
          uploadText.innerHTML = `<strong>${fileNameDisplay}</strong>`;
          generateBtn.disabled = false;
        }
        reader.readAsDataURL(selectedFile);
        resultSection.style.display = 'none'; // 새 파일 선택 시 결과 숨김
      } else {
        previewImg.src = '';
        imagePreview.style.display = 'none';
        uploadText.innerHTML = '<strong>반려동물 전신 사진을 업로드해주세요. (정면 사진 권장)</strong>';
        generateBtn.disabled = true;
        resultSection.style.display = 'none';
      }
    });

    // AI 피규어 생성 함수
    window.runFigurineGeneration = function() {
      const fileInput = document.getElementById('petImage');
      const selectedFile = fileInput.files[0];

      if (generateBtn.disabled || !selectedFile) return;

      // 로딩 시작
      generateBtn.disabled = true;
      btnText.style.display = 'none';
      loadingSpinner.style.display = 'block';
      resultSection.style.display = 'none'; // 로딩 중 결과 숨김

      figurineStatus.textContent = 'AI가 피규어 이미지를 생성하고 있습니다...';
      figurineDescription.textContent = '잠시만 기다려주세요.';
      figurineResultImg.style.display = 'block';
      figurineResultImg.src = placeholderUrl;

      const formData = new FormData();
      formData.append('image', selectedFile);

      // API 호출
      fetch('<c:url value="/api/figurine/generate"/>', {
        method: 'POST',
        body: formData
      })
              .then(res => {
                if (!res.ok) {
                  // ClothesRecommendController의 오류 응답 구조를 예상하여 처리
                  return res.json().then(body => { throw new Error(body?.description || '이미지 생성 실패'); });
                }
                return res.json();
              })
              .then(data => {
                // 결과 업데이트
                figurineStatus.textContent = '✅ 이미지 생성 완료';
                figurineDescription.textContent = data.description || 'AI가 생성한 이미지입니다.';

                const imageUrl = data.figurineImageUrl || placeholderUrl;
                figurineResultImg.src = imageUrl;
                figurineResultImg.style.display = 'block';
              })
              .catch(error => {
                console.error('AI 이미지 생성 중 오류 발생:', error);
                alert(error.message || 'AI 이미지 생성에 실패했습니다. (서버 로그 확인)');

                // 오류 발생 시 기본값 설정
                figurineStatus.textContent = '❌ 이미지 생성 실패';
                figurineDescription.textContent = error.message || '오류: 다시 시도해주세요.';
                figurineResultImg.src = placeholderUrl;
                figurineResultImg.style.display = 'block';
              })
              .finally(() => {
                // 로딩 종료 및 결과 표시
                generateBtn.disabled = false;
                btnText.style.display = 'inline';
                loadingSpinner.style.display = 'none';
                resultSection.style.display = 'block';

                resultSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
              });
    }
  });
</script>