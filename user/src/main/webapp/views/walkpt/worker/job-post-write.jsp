<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="pet-card">
                            <div class="pet-card-header">
                                <h3><i class="fas fa-pen"></i> 구직 글 작성</h3>
                                <p class="text-muted mb-0">나의 강점과 가능 조건을 어필하세요</p>
                            </div>

                            <div class="pet-card-body">
                                <!-- 작성 안내 -->
                                <div class="alert alert-info">
                                    <h6><i class="fas fa-info-circle"></i> 작성 팁</h6>
                                    <ul class="mb-0">
                                        <li>제목에 주요 강점을 포함하세요 (예: "소형견 전문", "대형견 경험 풍부")</li>
                                        <li>활동 가능한 지역과 시간대를 명확히 기재하세요</li>
                                        <li>반려동물 관련 경험과 자격증을 적극적으로 어필하세요</li>
                                    </ul>
                                </div>

                                <form id="jobPostForm">
                                    <!-- 제목 -->
                                    <div class="form-group">
                                        <label for="title" class="font-weight-bold">
                                            <i class="fas fa-heading"></i> 제목 <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="title" name="title"
                                            placeholder="예: 책임감 있는 소형중형견 산책 알바입니다" required>
                                    </div>

                                    <!-- 내용 -->
                                    <div class="form-group">
                                        <label for="content" class="font-weight-bold">
                                            <i class="fas fa-align-left"></i> 내용 <span class="text-danger">*</span>
                                        </label>
                                        <textarea class="form-control" id="content" name="content" rows="12" required
                                            placeholder="아래 형식을 참고하여 작성해주세요:

📍 활동 가능 지역: 서울 강남구, 송파구
⏰ 활동 가능 시간: 평일 오후, 주말 전일
🐕 가능한 반려동물: 소형견, 중형견

[경험 및 자격]
- 5년간 소형견 키움
- 반려동물관리사 2급 자격증 보유
- 1년간 산책 알바 경험 (총 50회 이상)

[자기소개]
책임감 있게 반려동물을 돌봐드립니다. 반려견을 직접 키워본 경험이 있어 다양한 상황에 유연하게 대응할 수 있습니다."></textarea>
                                    </div>

                                    <!-- 이력서 불러오기 버튼 -->
                                    <div class="form-group">
                                        <button type="button" class="btn btn-pet-outline" onclick="loadResume()">
                                            <i class="fas fa-file-import"></i> 이력서 내용 불러오기
                                        </button>
                                        <small class="form-text text-muted">
                                            저장된 이력서 정보를 불러와서 빠르게 작성할 수 있습니다
                                        </small>
                                    </div>

                                    <!-- 버튼 -->
                                    <div class="d-flex justify-content-between mt-4">
                                        <a href="<c:url value='/walkpt'/>" class="btn btn-secondary">
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

        <jsp:include page="../common/modals.jsp" />

        <script>
            function loadResume() {
                // 실제로는 서버에서 이력서 데이터를 가져와서 폼에 채움
                const dummyContent = `📍 활동 가능 지역: 서울 강남구, 송파구
⏰ 활동 가능 시간: 평일 오전·오후, 주말 가능
🐕 가능한 반려동물: 소형견, 중형견

[경험 및 자격]
- 5년간 소형견 키움
- 반려동물관리사 2급 자격증 보유
- 소형·중형견 산책 경험 풍부

[자기소개]
책임감 있게 반려동물을 돌봐드립니다. 반려견을 직접 키워본 경험이 있어 어떤 상황에서도 침착하게 대응할 수 있습니다.`;

                document.getElementById('content').value = dummyContent;
                showToast('이력서 내용을 불러왔습니다', 'success');
            }

            document.getElementById('jobPostForm').addEventListener('submit', function (e) {
                e.preventDefault();

                showConfirmModal('구직 글 등록', '구직 글을 등록하시겠습니까?', function () {
                    // 실제로는 서버에 전송
                    showToast('구직 글이 등록되었습니다!', 'success');
                    setTimeout(function () {
                        window.location.href = '<c:url value="/walkpt"/>';
                    }, 1500);
                });
            });
        </script>