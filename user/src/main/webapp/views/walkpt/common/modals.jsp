<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- 로그인 필요 모달 -->
        <div class="modal fade" id="loginRequiredModal" tabindex="-1" role="dialog" aria-labelledby="loginRequiredLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="loginRequiredLabel">
                            <i class="fas fa-lock"></i> 로그인 필요
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <i class="fas fa-sign-in-alt"
                            style="font-size: 3rem; color: var(--primary-color); margin-bottom: 1rem;"></i>
                        <p class="mb-0">로그인이 필요한 기능입니다.</p>
                        <p class="text-muted">로그인 후 이용해주세요.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                        <a href="<c:url value='/login'/>" class="btn btn-pet-primary">
                            <i class="fas fa-sign-in-alt"></i> 로그인
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 확인 모달 (범용) -->
        <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalTitle">
                            <i class="fas fa-question-circle"></i> 확인
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="confirmModalBody">
                        정말 진행하시겠습니까?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-pet-primary" id="confirmModalConfirmBtn">확인</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 토스트 알림 -->
        <div aria-live="polite" aria-atomic="true" style="position: fixed; top: 80px; right: 20px; z-index: 9999;">
            <div id="toastContainer"></div>
        </div>

        <script>
            // 로그인 필요 모달 표시 함수
            function showLoginRequired() {
                $('#loginRequiredModal').modal('show');
            }

            // 확인 모달 표시 함수
            function showConfirmModal(title, message, confirmCallback) {
                document.getElementById('confirmModalTitle').innerHTML = '<i class="fas fa-question-circle"></i> ' + title;
                document.getElementById('confirmModalBody').textContent = message;

                const confirmBtn = document.getElementById('confirmModalConfirmBtn');
                // 기존 리스너 제거
                const newConfirmBtn = confirmBtn.cloneNode(true);
                confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);

                // 새 리스너 추가
                newConfirmBtn.addEventListener('click', function () {
                    $('#confirmModal').modal('hide');
                    if (confirmCallback) confirmCallback();
                });

                $('#confirmModal').modal('show');
            }

            // 토스트 알림 표시 함수
            function showToast(message, type = 'success') {
                const toastId = 'toast-' + Date.now();
                const iconMap = {
                    'success': 'fa-check-circle',
                    'error': 'fa-exclamation-circle',
                    'warning': 'fa-exclamation-triangle',
                    'info': 'fa-info-circle'
                };
                const bgMap = {
                    'success': 'bg-success',
                    'error': 'bg-danger',
                    'warning': 'bg-warning',
                    'info': 'bg-info'
                };

                const toastHTML = `
        <div class="toast ${bgMap[type]} text-white" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true" data-delay="3000">
            <div class="toast-body d-flex align-items-center">
                <i class="fas ${iconMap[type]} mr-2"></i>
                <span>${message}</span>
                <button type="button" class="ml-auto mb-1 close text-white" data-dismiss="toast" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </div>
    `;

                const container = document.getElementById('toastContainer');
                container.insertAdjacentHTML('beforeend', toastHTML);

                const toastElement = document.getElementById(toastId);
                $(toastElement).toast('show');

                // 토스트가 숨겨진 후 제거
                $(toastElement).on('hidden.bs.toast', function () {
                    toastElement.remove();
                });
            }

            // 지원하기 함수 예시
            function applyToJob(jobId) {
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        showLoginRequired();
                    </c:when>
                    <c:otherwise>
                        showConfirmModal('지원 확인', '이 구인 글에 지원하시겠습니까?', function() {
                            // 실제로는 서버에 요청
                            showToast('지원이 완료되었습니다.', 'success');
            });
                    </c:otherwise>
                </c:choose>
            }

            // 수락/거절 함수 예시
            function acceptApplicant(applicantId) {
                showConfirmModal('지원 수락', '이 지원자를 수락하시겠습니까?', function () {
                    // 실제로는 서버에 요청
                    showToast('지원자를 수락했습니다.', 'success');
                });
            }

            function rejectApplicant(applicantId) {
                showConfirmModal('지원 거절', '이 지원자를 거절하시겠습니까?', function () {
                    // 실제로는 서버에 요청
                    showToast('지원자를 거절했습니다.', 'info');
                });
            }

            // 산책 시작/종료 함수 예시
            function startWalk(sessionId) {
                showConfirmModal('산책 시작', '산책을 시작하시겠습니까?', function () {
                    // 실제로는 서버에 요청 및 페이지 이동
                    showToast('산책이 시작되었습니다.', 'success');
                });
            }

            function endWalk(sessionId) {
                showConfirmModal('산책 종료', '산책을 종료하시겠습니까?', function () {
                    // 실제로는 서버에 요청
                    showToast('산책이 종료되었습니다.', 'success');
                });
            }
        </script>

        <style>
            .toast {
                min-width: 250px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                border-radius: 8px;
            }

            .toast-body {
                padding: 1rem;
            }
        </style>