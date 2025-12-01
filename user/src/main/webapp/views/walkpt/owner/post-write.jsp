<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="pet-card">
                            <div class="pet-card-header">
                                <h3><i class="fas fa-edit"></i> 산책 구인 글 작성</h3>
                                <p class="text-muted mb-0">반려동물 산책을 도와줄 알바생을 찾아보세요</p>
                            </div>

                            <div class="pet-card-body">
                                <form id="postWriteForm" action="<c:url value='/walkpt/owner/post-write'/>"
                                    method="post" enctype="multipart/form-data">
                                    <!-- 제목 -->
                                    <div class="form-group">
                                        <label for="title" class="font-weight-bold">
                                            <i class="fas fa-heading"></i> 제목 <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="title" name="title"
                                            placeholder="예: 소형견 산책 도와주실 분 구합니다" required>
                                    </div>

                                    <!-- 반려동물 선택 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-paw"></i> 함께할 반려동물 선택</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="petId">반려동물 <span class="text-danger">*</span></label>
                                                <select class="form-control" id="petId" name="petId" required>
                                                    <option value="">선택하세요</option>
                                                    <c:forEach items="${pets}" var="pet">
                                                        <option value="${pet.petId}">${pet.name} (${pet.breed},
                                                            ${pet.age}살)</option>
                                                    </c:forEach>
                                                </select>
                                                <c:if test="${empty pets}">
                                                    <small class="form-text text-danger">
                                                        등록된 반려동물이 없습니다. <a
                                                            href="<c:url value='/mypage/pet/register'/>">반려동물 등록하러
                                                            가기</a>
                                                    </small>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 산책 조건 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-calendar-check"></i> 산책 조건</h5>
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
                                                <label for="location">산책 지역 <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="location" name="location"
                                                    placeholder="예: 서울특별시 강남구 역삼동" required>
                                                <small class="form-text text-muted">상세한 주소를 입력하면 더 정확한 매칭이 가능합니다</small>
                                            </div>
                                            <div class="form-group">
                                                <label for="payment">희망 보수 (원) <span
                                                        class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="payment" name="payAmount"
                                                    placeholder="예: 15000" min="0" step="1000" required>
                                                <small class="form-text text-muted">시급 기준으로 입력해주세요</small>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 유의사항 -->
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0"><i class="fas fa-exclamation-circle"></i> 유의사항</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="notes">반려동물 성격 및 주의사항</label>
                                                <textarea class="form-control" id="notes" name="content" rows="5"
                                                    placeholder="예: 낯을 많이 가려서 처음엔 조금 경계할 수 있어요. 다른 강아지를 보면 짖을 수 있으니 주의해주세요."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 버튼 -->
                                    <div class="d-flex justify-content-between">
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

        <script>
            // 폼 제출 시
            document.getElementById('postWriteForm').addEventListener('submit', function (e) {
                if (!confirm('구인 글을 등록하시겠습니까?')) {
                    e.preventDefault();
                }
            });

            // 날짜 최소값 설정 (오늘 이후만 선택 가능)
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('walkDate').setAttribute('min', today);
        </script>