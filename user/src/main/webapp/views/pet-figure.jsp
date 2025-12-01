<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Link to external CSS -->
        <link rel="stylesheet" href="<c:url value='/css/pet-figure.css'/>">

        <div class="main-container">
            <div class="figure-container">
                <div class="figure-header">
                    <h2 class="section-title-custom">✨ 나만의 펫 피규어 스튜디오</h2>
                    <p>사랑스러운 반려동물의 사진을 올려보세요.<br>AI가 마법처럼 특별한 2D 피규어로 만들어드립니다.</p>
                </div>

                <div class="feature-card">
                    <label class="upload-area" for="petImage">
                        <input type="file" id="petImage" class="file-input" accept="image/*">
                        <i class="fas fa-magic upload-icon"></i>
                        <p class="mb-1" id="upload-text" style="font-size: 1.15rem; color: #444;">
                            <strong>여기를 클릭하여 사진을 업로드하세요</strong>
                        </p>
                        <small class="text-muted">JPG, PNG 파일 지원 | 최대 10MB</small>
                        <div id="image-preview"
                            style="max-width: 100%; max-height: 400px; overflow: hidden; margin-top: 2rem; display: none; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                            <img id="preview-img" alt="업로드 이미지 미리보기"
                                style="width: 100%; height: 100%; object-fit: contain;">
                        </div>
                    </label>

                    <!-- Custom Prompt Input -->
                    <div class="form-group mt-4" style="text-align: left; max-width: 80%; margin: 0 auto;">
                        <label for="customPrompt" style="font-weight: 600; color: #555;">추가 요청사항 (선택사항)</label>
                        <input type="text" id="customPrompt" class="form-control"
                            placeholder="예: 고양이가 박스 안에 있는 모습을 그대로 살려주세요."
                            style="border-radius: 12px; padding: 1rem; border: 1px solid #ddd; width: 100%;">
                    </div>

                    <button type="button" id="generate-btn" class="btn btn-figure-primary" disabled
                        onclick="generateFigure()">
                        <span id="btn-text"><i class="fas fa-wand-magic-sparkles mr-2"></i> 피규어 생성 시작하기</span>
                        <div class="spinner-border text-light" role="status" id="loading-spinner">
                            <span class="sr-only">Loading...</span>
                        </div>
                    </button>
                </div>

                <div class="result-section" id="result-section" style="display: none;">
                    <div class="showcase-stage">
                        <div class="figure-image-card">
                            <h5 class="mb-4" style="color: var(--figure-primary); font-weight: 700;"><i
                                    class="fas fa-crown mr-2"></i> 완성된 피규어</h5>
                            <img id="figure-result-img" src="" alt="생성된 피규어">
                            <br>
                            <a id="download-link" href="#" download="pet-figure.png" class="btn btn-download">
                                <i class="fas fa-download mr-2"></i> 이미지 저장하기
                            </a>
                        </div>
                    </div>

                    <!-- Gallery Section -->
                    <div class="gallery-section" id="gallery-section" style="display: none;">
                        <h6 class="gallery-title"><i class="fas fa-history mr-2"></i>최근 생성된 피규어</h6>
                        <div class="gallery-grid" id="gallery-grid">
                            <!-- Gallery items will be added here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const fileInput = document.getElementById('petImage');
                const previewImg = document.getElementById('preview-img');
                const imagePreview = document.getElementById('image-preview');
                const uploadText = document.getElementById('upload-text');
                const generateBtn = document.getElementById('generate-btn');
                const resultSection = document.getElementById('result-section');
                const gallerySection = document.getElementById('gallery-section');
                const galleryGrid = document.getElementById('gallery-grid');
                const customPromptInput = document.getElementById('customPrompt');

                // Session storage for generated figures
                let generatedFigures = [];

                fileInput.addEventListener('change', function (e) {
                    const file = e.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImg.src = e.target.result;
                            imagePreview.style.display = 'block';
                            uploadText.innerHTML = '<strong>' + file.name + '</strong>';
                            generateBtn.disabled = false;
                        }
                        reader.readAsDataURL(file);
                    } else {
                        previewImg.src = '';
                        imagePreview.style.display = 'none';
                        uploadText.innerHTML = '<strong>반려동물 사진을 업로드해주세요.</strong>';
                        generateBtn.disabled = true;
                    }
                });

                // Retry logic helper
                async function fetchWithRetry(url, options, retries = 1) {
                    try {
                        const response = await fetch(url, options);
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        const data = await response.json();
                        if (data.error) {
                            throw new Error(data.error);
                        }
                        return data;
                    } catch (error) {
                        if (retries > 0) {
                            console.log(`Request failed, retrying... (${retries} attempts left)`);
                            return fetchWithRetry(url, options, retries - 1);
                        } else {
                            throw error;
                        }
                    }
                }

                window.generateFigure = function () {
                    const file = fileInput.files[0];
                    if (!file) return;

                    const btnText = document.getElementById('btn-text');
                    const loadingSpinner = document.getElementById('loading-spinner');
                    const customPrompt = customPromptInput.value;

                    generateBtn.disabled = true;
                    btnText.style.display = 'none';
                    loadingSpinner.style.display = 'block';

                    const formData = new FormData();
                    formData.append('image', file);
                    if (customPrompt) {
                        formData.append('customPrompt', customPrompt);
                    }

                    fetchWithRetry('<c:url value="/api/pet-figure/generate"/>', {
                        method: 'POST',
                        body: formData
                    }, 1) // 1 retry attempt
                        .then(data => {
                            const imageUrl = data.imageUrl;

                            // Add to history
                            const newFigure = {
                                id: Date.now(),
                                url: imageUrl,
                                timestamp: new Date()
                            };
                            generatedFigures.unshift(newFigure); // Add to beginning

                            // Update View
                            updateMainView(newFigure);
                            renderGallery();

                            resultSection.style.display = 'block';
                            resultSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('피규어 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.\n' + error.message);
                        })
                        .finally(() => {
                            generateBtn.disabled = false;
                            btnText.style.display = 'inline';
                            loadingSpinner.style.display = 'none';
                        });
                }

                function updateMainView(figure) {
                    const resultImg = document.getElementById('figure-result-img');
                    const downloadLink = document.getElementById('download-link');

                    resultImg.src = figure.url;
                    downloadLink.href = figure.url;

                    // Highlight active in gallery
                    const items = document.querySelectorAll('.gallery-item');
                    items.forEach(item => {
                        if (item.dataset.id == figure.id) {
                            item.classList.add('active');
                        } else {
                            item.classList.remove('active');
                        }
                    });
                }

                function renderGallery() {
                    if (generatedFigures.length === 0) {
                        gallerySection.style.display = 'none';
                        return;
                    }

                    gallerySection.style.display = 'block';
                    galleryGrid.innerHTML = '';

                    generatedFigures.forEach(figure => {
                        const item = document.createElement('div');
                        item.className = 'gallery-item';
                        item.dataset.id = figure.id;

                        // Check if this is the currently displayed one
                        const currentSrc = document.getElementById('figure-result-img').src;
                        if (currentSrc === figure.url) {
                            item.classList.add('active');
                        }

                        const img = document.createElement('img');
                        img.src = figure.url;
                        img.alt = 'Generated Figure';

                        item.appendChild(img);

                        item.addEventListener('click', () => {
                            updateMainView(figure);
                            document.querySelector('.showcase-stage').scrollIntoView({ behavior: 'smooth', block: 'center' });
                        });

                        galleryGrid.appendChild(item);
                    });
                }
            });
        </script>