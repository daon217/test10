<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="pet-card">
                            <div class="pet-card-header">
                                <h3><i class="fas fa-id-card"></i> 이력서 / 프로필 관리</h3>
                                <p class="text-muted mb-0">나의 정보를 입력하여 더 많은 구인 기회를 얻으세요</p>
                            </div>

                            <div class="pet-card-body">
                                <form id="resumeForm">
                                    <!-- 기본 정보 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-user"></i> 기본 정보</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group text-center mb-4">
                                                <div class="mb-3">
                                                    <img id="profilePreview"
                                                        src="https://via.placeholder.com/150x150?text=Profile"
                                                        alt="프로필 사진" class="rounded-circle" width="150" height="150">
                                                </div>
                                                <div class="custom-file" style="max-width: 300px; margin: 0 auto;">
                                                    <input type="file" class="custom-file-input" id="profileImage"
                                                        accept="image/*">
                                                    <label class="custom-file-label" for="profileImage">프로필 사진
                                                        선택...</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="nickname">닉네임 <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="nickname"
                                                            name="nickname" placeholder="예: 김산책" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="name">이름 <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="name" name="name"
                                                            placeholder="예: 김철수" required>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="intro">한 줄 소개 <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="intro" name="intro"
                                                    placeholder="예: 책임감 있게 반려동물을 돌봐드립니다" maxlength="100" required>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 활동 조건 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-map-marked-alt"></i> 활동 조건</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label>활동 가능 지역 <span class="text-danger">*</span></label>
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="region1" name="regions" value="gangnam">
                                                            <label class="custom-control-label"
                                                                for="region1">강남구</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="region2" name="regions" value="songpa">
                                                            <label class="custom-control-label"
                                                                for="region2">송파구</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="region3" name="regions" value="gangdong">
                                                            <label class="custom-control-label"
                                                                for="region3">강동구</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="region4" name="regions" value="seocho">
                                                            <label class="custom-control-label"
                                                                for="region4">서초구</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="region5" name="regions" value="gwangjin">
                                                            <label class="custom-control-label"
                                                                for="region5">광진구</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>가능 요일</label>
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="day1" name="days" value="weekday">
                                                            <label class="custom-control-label" for="day1">평일</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="day2" name="days" value="weekend">
                                                            <label class="custom-control-label" for="day2">주말</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>가능 시간대</label>
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="time1" name="times" value="morning">
                                                            <label class="custom-control-label" for="time1">오전</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="time2" name="times" value="afternoon">
                                                            <label class="custom-control-label" for="time2">오후</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="time3" name="times" value="evening">
                                                            <label class="custom-control-label" for="time3">저녁</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 반려동물 관련 정보 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-paw"></i> 반려동물 관련 정보</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label>다룰 수 있는 반려동물</label>
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="pet1" name="petTypes" value="small_dog">
                                                            <label class="custom-control-label" for="pet1">소형견</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="pet2" name="petTypes" value="medium_dog">
                                                            <label class="custom-control-label" for="pet2">중형견</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="pet3" name="petTypes" value="large_dog">
                                                            <label class="custom-control-label" for="pet3">대형견</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" class="custom-control-input"
                                                                id="pet4" name="petTypes" value="cat">
                                                            <label class="custom-control-label" for="pet4">고양이</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="experience">키워본 경험 및 알바 경험</label>
                                                <textarea class="form-control" id="experience" name="experience"
                                                    rows="4"
                                                    placeholder="예: 5년간 소형견을 키워왔으며, 1년간 반려동물 산책 알바 경험이 있습니다."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 자격/강점 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-certificate"></i> 자격 및 강점</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="certifications">자격증 / 교육 이수</label>
                                                <input type="text" class="form-control" id="certifications"
                                                    name="certifications" placeholder="예: 반려동물관리사 2급, 반려동물행동교정사">
                                            </div>
                                            <div class="form-group">
                                                <label for="specialties">특이사항 및 강점</label>
                                                <textarea class="form-control" id="specialties" name="specialties"
                                                    rows="3"
                                                    placeholder="예: 체력이 좋아 대형견 산책에 자신 있습니다. 응급처치 교육 이수."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 버튼 -->
                                    <div class="d-flex justify-content-between">
                                        <button type="button" class="btn btn-secondary" onclick="history.back()">
                                            <i class="fas fa-times"></i> 취소
                                        </button>
                                        <div>
                                            <button type="button" class="btn btn-pet-outline mr-2"
                                                onclick="previewResume()">
                                                <i class="fas fa-eye"></i> 미리보기
                                            </button>
                                            <button type="submit" class="btn btn-pet-primary">
                                                <i class="fas fa-save"></i> 저장
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />

        <script>
            // 프로필 사진 미리보기
            document.getElementById('profileImage').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('profilePreview').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                    e.target.nextElementSibling.textContent = file.name;
                }
            });

            // 이력서 미리보기
            function previewResume() {
                alert('미리보기 기능은 준비 중입니다.');
            }

            // 폼 제출
            document.getElementById('resumeForm').addEventListener('submit', function (e) {
                e.preventDefault();

                showConfirmModal('이력서 저장', '이력서를 저장하시겠습니까?', function () {
                    // 실제로는 서버에 전송
                    showToast('이력서가 저장되었습니다!', 'success');
                    setTimeout(function () {
                        window.location.href = '<c:url value="/walkpt"/>';
                    }, 1500);
                });
            });
        </script>