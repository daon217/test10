<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

<div class="walkpt-container">
    <div class="container">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="pet-card">
                    <div class="pet-card-header">
                        <h3><i class="fas fa-edit"></i> 함께 산책하기 글 작성</h3>
                        <p class="text-muted mb-0">같은 시간, 같은 장소에서 함께 산책할 반려인을 찾아보세요</p>
                    </div>

                    <div class="pet-card-body">
                        <form id="togetherWalkForm" action="<c:url value='/walkpt/togetherwalk/write'/>"
                              method="post" enctype="multipart/form-data">
                            <!-- 제목 -->
                            <div class="form-group">
                                <label for="title" class="font-weight-bold">
                                    <i class="fas fa-heading"></i> 제목 <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="title" name="title"
                                       placeholder="예: 한강공원에서 함께 산책해요!" required>
                            </div>

                            <!-- 반려동물 정보 -->
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-paw"></i> 반려동물 정보</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="petName">이름 <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="petName"
                                                       name="petName" placeholder="예: 몽이" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="petType">종류 <span
                                                        class="text-danger">*</span></label>
                                                <select class="form-control" id="petType" name="petType"
                                                        required>
                                                    <option value="">선택하세요</option>
                                                    <option value="dog">강아지</option>
                                                    <option value="cat">고양이</option>
                                                    <option value="other">기타</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="petSize">크기 <span
                                                        class="text-danger">*</span></label>
                                                <select class="form-control" id="petSize" name="petSize"
                                                        required>
                                                    <option value="">선택하세요</option>
                                                    <option value="small">소형 (5kg 이하)</option>
                                                    <option value="medium">중형 (5-15kg)</option>
                                                    <option value="large">대형 (15kg 이상)</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="petAge">나이</label>
                                                <input type="number" class="form-control" id="petAge"
                                                       name="petAge" placeholder="예: 3" min="0" max="30">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="petImage">반려동물 사진 업로드</label>
                                        <div class="custom-file">
                                            <input type="file" class="custom-file-input" id="petImage"
                                                   name="petImage" accept="image/*">
                                            <label class="custom-file-label" for="petImage">파일 선택...</label>
                                        </div>
                                        <small class="form-text text-muted">반려동물 사진을 업로드하면 더 많은 관심을 받을 수
                                            있어요</small>
                                        <div id="imagePreview" class="mt-2" style="display: none;">
                                            <img id="previewImg" src="" alt="미리보기"
                                                 style="max-width: 200px; border-radius: 8px;">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 산책 일정 -->
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-calendar-check"></i> 산책 일정</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="walkDate">날짜 <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="walkDate"
                                                       name="walkDate" required>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="walkStartTime">시작 시간 <span
                                                        class="text-danger">*</span></label>
                                                <input type="time" class="form-control" id="walkStartTime"
                                                       name="walkStartTime" required>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="walkEndTime">종료 시간 <span
                                                        class="text-danger">*</span></label>
                                                <input type="time" class="form-control" id="walkEndTime"
                                                       name="walkEndTime" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="location">산책 장소 <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="location" name="location"
                                               placeholder="예: 서울특별시 강남구 삼성동 한강공원" required>
                                        <small class="form-text text-muted">상세한 주소나 장소를 입력하면 더 정확한 매칭이
                                            가능합니다</small>
                                    </div>
                                </div>
                            </div>

                            <!-- 상세 내용 -->
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-align-left"></i> 상세 내용</h5>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="content">내용 <span class="text-danger">*</span></label>
                                        <textarea class="form-control" id="content" name="content" rows="8"
                                                  placeholder="함께 산책하고 싶은 이유나 반려동물의 성격 등을 자유롭게 작성해주세요.&#10;&#10;예시:&#10;- 비슷한 나이대의 소형견 친구들을 찾고 있어요!&#10;- 우리 몽이는 활발하고 다른 강아지들과 잘 어울려요.&#10;- 한강공원을 자주 가는데 함께 산책하면 좋을 것 같아요."
                                                  required></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- 버튼 -->
                            <div class="d-flex justify-content-between">
                                <a href="<c:url value='/walkpt/togetherwalk/list'/>" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> 취소
                                </a>
                                <button type="submit" class="btn btn-pet-primary">
                                    <i class="fas fa-check"></i> 등록하기
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 파일 선택 시 라벨 업데이트 및 미리보기
    document.getElementById('petImage').addEventListener('change', function (e) {
        const fileName = e.target.files[0] ? e.target.files[0].name : '파일 선택...';
        const label = e.target.nextElementSibling;
        label.textContent = fileName;

        // 이미지 미리보기
        if (e.target.files && e.target.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('previewImg').src = e.target.result;
                document.getElementById('imagePreview').style.display = 'block';
            };
            reader.readAsDataURL(e.target.files[0]);
        }
    });

    // 폼 제출 시
    document.getElementById('togetherWalkForm').addEventListener('submit', function (e) {
        e.preventDefault();

        // 실제로는 서버에 전송
        if (confirm('함께 산책하기 글을 등록하시겠습니까?')) {
            showToast('글이 등록되었습니다!', 'success');
            setTimeout(function () {
                window.location.href = '<c:url value="/walkpt/togetherwalk/list"/>';
            }, 1500);
        }
    });

    // 날짜 최소값 설정 (오늘 이후만 선택 가능)
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('walkDate').setAttribute('min', today);
</script>