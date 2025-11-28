<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container">
                <h3 class="mb-4"><i class="fas fa-history"></i> 산책 이용 내역</h3>

                <!-- 테이블 -->
                <div class="pet-card">
                    <div class="pet-card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th>날짜</th>
                                        <th>알바생</th>
                                        <th>반려동물</th>
                                        <th>시간/거리</th>
                                        <th>상태</th>
                                        <th>후기</th>
                                        <th>액션</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>2025-11-27</td>
                                        <td>
                                            <i class="fas fa-user-circle"></i> 김산책
                                        </td>
                                        <td>몽이 (포메라니안)</td>
                                        <td>2시간 15분 / 3.2km</td>
                                        <td><span class="walkpt-badge badge-completed">완료</span></td>
                                        <td><span class="text-success"><i class="fas fa-check"></i> 작성 완료</span></td>
                                        <td>
                                            <button class="btn btn-pet-outline btn-sm" onclick="viewReview(1)">
                                                <i class="fas fa-eye"></i> 보기
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2025-11-25</td>
                                        <td>
                                            <i class="fas fa-user-circle"></i> 박돌봄
                                        </td>
                                        <td>몽이 (포메라니안)</td>
                                        <td>1시간 45분 / 2.5km</td>
                                        <td><span class="walkpt-badge badge-completed">완료</span></td>
                                        <td><span class="text-danger"><i class="fas fa-times"></i> 미작성</span></td>
                                        <td>
                                            <a href="<c:url value='/walkpt/owner/review-write?sessionId=2'/>"
                                                class="btn btn-pet-primary btn-sm">
                                                <i class="fas fa-star"></i> 작성
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2025-11-20</td>
                                        <td>
                                            <i class="fas fa-user-circle"></i> 이친절
                                        </td>
                                        <td>몽이 (포메라니안)</td>
                                        <td>2시간 / 3.0km</td>
                                        <td><span class="walkpt-badge badge-completed">완료</span></td>
                                        <td><span class="text-success"><i class="fas fa-check"></i> 작성 완료</span></td>
                                        <td>
                                            <button class="btn btn-pet-outline btn-sm" onclick="viewReview(3)">
                                                <i class="fas fa-eye"></i> 보기
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- 빈 상태 (데이터 없을 때) -->
                <div class="text-center py-5" style="display: none;" id="emptyState">
                    <i class="fas fa-inbox" style="font-size: 4rem; color: var(--text-tertiary);"></i>
                    <p class="text-muted mt-3">아직 이용 내역이 없습니다</p>
                    <a href="<c:url value='/walkpt'/>" class="btn btn-pet-primary mt-2">
                        <i class="fas fa-search"></i> 산책 알바 찾기
                    </a>
                </div>
            </div>
        </div>

        <!-- 후기 보기 모달 -->
        <div class="modal fade" id="reviewModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-star"></i> 내가 작성한 후기</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="reviewContent">
                        <!-- 후기 내용 -->
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/modals.jsp" />

        <script>
            function viewReview(sessionId) {
                // 실제로는 서버에서 후기 데이터 가져오기
                const dummyReview = `
        <div class="text-center mb-3">
            <div style="font-size: 2rem; color: #FFD43B;">
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
            </div>
            <p class="mt-2"><strong>5점</strong></p>
        </div>
        <hr>
        <p><strong>한 줄 코멘트:</strong></p>
        <p>정말 책임감 있게 산책시켜 주셨어요!</p>
        <hr>
        <p><강>상세 후기:</strong></p>
        <p>처음부터 끝까지 세심하게 신경써주셨습니다. 사진도 많이 찍어주시고, 중간중간 상황도 알려주셔서 안심하고 맡길 수 있었어요. 다음에도 꼭 부탁드리고 싶습니다!</p>
    `;
                document.getElementById('reviewContent').innerHTML = dummyReview;
                $('#reviewModal').modal('show');
            }
        </script>