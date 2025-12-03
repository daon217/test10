<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5 mb-5">
    <div class="text-center mb-5">
        <h2 class="font-weight-bold"><i class="fas fa-headset text-primary"></i> 고객센터</h2>
        <p class="text-muted">궁금한 점이나 불편한 사항을 남겨주세요.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <ul class="nav nav-tabs card-header-tabs" id="customerTab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="faq-tab" data-toggle="tab" href="#faq" role="tab" aria-controls="faq" aria-selected="true">자주 묻는 질문 (FAQ)</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="qna-tab" data-toggle="tab" href="#qna" role="tab" aria-controls="qna" aria-selected="false">1:1 문의하기</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="customerTabContent">
                        <div class="tab-pane fade show active" id="faq" role="tabpanel" aria-labelledby="faq-tab">
                            <div class="accordion" id="accordionExample">
                                <div class="card border-0 mb-2">
                                    <div class="card-header bg-light" id="headingOne">
                                        <h2 class="mb-0">
                                            <button class="btn btn-link btn-block text-left text-dark font-weight-bold" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                                Q. AI 산책 추천은 어떻게 이용하나요?
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
                                        <div class="card-body">
                                            A. 상단 메뉴의 '산책 > AI 산책 제시' 메뉴에서 이용하실 수 있습니다. 반려동물의 특성에 맞는 최적의 산책 코스를 추천해 드립니다.
                                        </div>
                                    </div>
                                </div>
                                <div class="card border-0 mb-2">
                                    <div class="card-header bg-light" id="headingTwo">
                                        <h2 class="mb-0">
                                            <button class="btn btn-link btn-block text-left text-dark font-weight-bold collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                Q. 홈캠 영상은 저장되나요?
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
                                        <div class="card-body">
                                            A. 실시간 모니터링 기능은 저장되지 않으며, 이상 행동 감지 시에만 짧은 클립으로 저장되어 '마이페이지'에서 확인하실 수 있습니다.
                                        </div>
                                    </div>
                                </div>
                                <div class="card border-0 mb-2">
                                    <div class="card-header bg-light" id="headingThree">
                                        <h2 class="mb-0">
                                            <button class="btn btn-link btn-block text-left text-dark font-weight-bold collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                Q. 산책 매칭은 무료인가요?
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
                                        <div class="card-body">
                                            A. 네, 일반 산책 매칭 서비스는 무료로 제공됩니다. 다만 전문 펫시터 매칭(산책 알바)의 경우 별도의 비용이 발생할 수 있습니다.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="qna" role="tabpanel" aria-labelledby="qna-tab">
                            <form action="<c:url value='/customer/inquiry'/>" method="post">
                                <div class="form-group">
                                    <label for="category">문의 유형</label>
                                    <select class="form-control" id="category" name="category">
                                        <option>서비스 이용 문의</option>
                                        <option>계정/로그인</option>
                                        <option>결제/환불</option>
                                        <option>기타</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="title">제목</label>
                                    <input type="text" class="form-control" id="title" name="title" placeholder="문의 제목을 입력하세요" required>
                                </div>
                                <div class="form-group">
                                    <label for="content">내용</label>
                                    <textarea class="form-control" id="content" name="content" rows="5" placeholder="문의 내용을 상세히 입력해주세요" required></textarea>
                                </div>
                                <div class="text-right">
                                    <button type="submit" class="btn btn-pet-primary">문의 등록</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>