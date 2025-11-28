<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="pet-card">
                            <div class="pet-card-header">
                                <h3><i class="fas fa-star"></i> 산책 후기 작성</h3>
                                <p class="text-muted mb-0">산책 알바생에 대한 후기를 남겨주세요</p>
                            </div>

                            <div class="pet-card-body">
                                <!-- 세션 요약 -->
                                <div class="card bg-light mb-4">
                                    <div class="card-body">
                                        <h5><i class="fas fa-info-circle"></i> 산책 정보</h5>
                                        <div class="row mt-3">
                                            <div class="col-md-6">
                                                <p><strong>알바생:</strong> 김산책</p>
                                                <p><strong>반려동물:</strong> 몽이 (포메라니안)</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>날짜:</strong> 2025-11-27</p>
                                                <p><strong>시간:</strong> 2시간 15분</p>
                                                <p><strong>거리:</strong> 3.2km</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 평가 폼 -->
                                <form id="reviewForm">
                                    <!-- 별점 -->
                                    <div class="form-group">
                                        <label class="font-weight-bold">
                                            <i class="fas fa-star" style="color: #FFD43B;"></i> 별점 <span
                                                class="text-danger">*</span>
                                        </label>
                                        <div class="star-rating mt-2">
                                            <input type="radio" id="star5" name="rating" value="5" required>
                                            <label for="star5" title="5점"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star4" name="rating" value="4">
                                            <label for="star4" title="4점"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star3" name="rating" value="3">
                                            <label for="star3" title="3점"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star2" name="rating" value="2">
                                            <label for="star2" title="2점"><i class="fas fa-star"></i></label>
                                            <input type="radio" id="star1" name="rating" value="1">
                                            <label for="star1" title="1점"><i class="fas fa-star"></i></label>
                                        </div>
                                        <div id="ratingDisplay" class="mt-2 text-muted">별점을 선택해주세요</div>
                                    </div>

                                    <!-- 한 줄 코멘트 -->
                                    <div class="form-group">
                                        <label for="comment" class="font-weight-bold">
                                            <i class="fas fa-comment"></i> 한 줄 코멘트 <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="comment" name="comment"
                                            placeholder="예: 정말 책임감 있게 산책시켜 주셨어요!" maxlength="100" required>
                                        <small class="form-text text-muted">최대 100자</small>
                                    </div>

                                    <!-- 상세 후기 -->
                                    <div class="form-group">
                                        <label for="detailedReview" class="font-weight-bold">
                                            <i class="fas fa-edit"></i> 상세 후기
                                        </label>
                                        <textarea class="form-control" id="detailedReview" name="detailedReview"
                                            rows="6" placeholder="산책 과정에서 좋았던 점이나 아쉬운 점을 자유롭게 작성해주세요."></textarea>
                                        <small class="form-text text-muted">상세한 후기는 다른 이용자들에게 큰 도움이 됩니다</small>
                                    </div>

                                    <!-- 버튼 -->
                                    <div class="d-flex justify-content-between mt-4">
                                        <a href="<c:url value='/walkpt/owner/history'/>" class="btn btn-secondary">
                                            <i class="fas fa-times"></i> 취소
                                        </a>
                                        <button type="submit" class="btn btn-pet-primary">
                                            <i class="fas fa-check"></i> 후기 등록
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />

        <style>
            .star-rating {
                direction: rtl;
                display: inline-flex;
                font-size: 2rem;
            }

            .star-rating input {
                display: none;
            }

            .star-rating label {
                color: #ddd;
                cursor: pointer;
                margin: 0 0.2rem;
                transition: color 0.2s;
            }

            .star-rating label:hover,
            .star-rating label:hover~label,
            .star-rating input:checked~label {
                color: #FFD43B;
            }
        </style>

        <script>
            // 별점 선택 시 표시
            document.querySelectorAll('input[name="rating"]').forEach(function (radio) {
                radio.addEventListener('change', function () {
                    const value = this.value;
                    document.getElementById('ratingDisplay').textContent = value + '점 선택됨';
                });
            });

            // 폼 제출
            document.getElementById('reviewForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const rating = document.querySelector('input[name="rating"]:checked');
                if (!rating) {
                    alert('별점을 선택해주세요.');
                    return;
                }

                const comment = document.getElementById('comment').value.trim();
                if (!comment) {
                    alert('한 줄 코멘트를 입력해주세요.');
                    return;
                }

                showConfirmModal('후기 등록', '후기를 등록하시겠습니까?', function () {
                    // 실제로는 서버에 전송
                    showToast('후기가 등록되었습니다!', 'success');
                    setTimeout(function () {
                        window.location.href = '<c:url value="/walkpt/owner/history"/>';
                    }, 1500);
                });
            });
        </script>