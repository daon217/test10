<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 로그인 컨테이너 (index.jsp 내부에 포함되는 버전) -->
<div class="auth-container" style="min-height: calc(100vh - 200px); display: flex; align-items: center; justify-content: center; padding: 2rem 1rem;">
    <div class="auth-card-simple" style="max-width: 450px; width: 100%; background: white; border-radius: 1.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.1); padding: 3rem 2.5rem;">
        <!-- 로고 및 헤더 -->
        <div class="text-center mb-4">
            <div style="width: 70px; height: 70px; background: linear-gradient(135deg, #FF6B6B, #FA5252); border-radius: 1rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; box-shadow: 0 4px 12px rgba(255,107,107,0.3);">
                <i class="fas fa-paw" style="color: white; font-size: 2rem;"></i>
            </div>
            <h2 style="font-size: 1.75rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">로그인</h2>
            <p style="color: #6c757d; font-size: 0.95rem;">반려동물과 함께하는 스마트 라이프</p>
        </div>

        <!-- 로그인 폼 -->
        <form id="loginForm" action="<c:url value='/login'/>" method="post">
            <!-- 아이디 -->
            <div class="form-group">
                <label for="username" style="font-weight: 600; color: #212529; margin-bottom: 0.5rem;">아이디</label>
                <div style="position: relative;">
                    <i class="fas fa-user" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
                    <input type="text"
                           class="form-control"
                           id="username"
                           name="username"
                           placeholder="아이디를 입력하세요"
                           style="padding-left: 2.75rem; height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;"
                           required>
                </div>
            </div>

            <!-- 비밀번호 -->
            <div class="form-group">
                <label for="password" style="font-weight: 600; color: #212529; margin-bottom: 0.5rem;">비밀번호</label>
                <div style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
                    <input type="password"
                           class="form-control"
                           id="password"
                           name="password"
                           placeholder="비밀번호를 입력하세요"
                           style="padding-left: 2.75rem; padding-right: 3rem; height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;"
                           required>
                    <button type="button"
                            onclick="togglePassword('password')"
                            style="position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); background: none; border: none; color: #6c757d; cursor: pointer; padding: 0.5rem; z-index: 2;">
                        <i class="fas fa-eye" id="password-icon"></i>
                    </button>
                </div>
            </div>

            <!-- 옵션 -->
            <div class="form-options" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class="custom-control-input" id="rememberMe" name="rememberMe">
                    <label class="custom-control-label" for="rememberMe" style="font-size: 0.9rem; color: #6c757d;">로그인 유지</label>
                </div>
                <a href="<c:url value='/forgot-password'/>" style="color: #6c757d; text-decoration: none; font-size: 0.9rem;">비밀번호 찾기</a>
            </div>

            <!-- 로그인 버튼 -->
            <button type="submit"
                    class="btn btn-primary btn-block"
                    style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 3rem; border-radius: 0.75rem; font-weight: 600; font-size: 1rem; box-shadow: 0 4px 12px rgba(255,107,107,0.3);">
                <i class="fas fa-sign-in-alt mr-2"></i>
                로그인
            </button>

            <!-- 에러 메시지 -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3" role="alert" style="border-radius: 0.75rem;">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                        ${error}
                </div>
            </c:if>
        </form>

        <!-- 회원가입 링크 -->
        <div style="text-align: center; margin-top: 1.5rem; color: #6c757d;">
            아직 회원이 아니신가요?
            <a href="<c:url value='/register'/>" style="color: #FF6B6B; text-decoration: none; font-weight: 600; margin-left: 0.5rem;">회원가입</a>
        </div>
    </div>
</div>

<script>
    // 비밀번호 표시/숨김 토글
    function togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(inputId + '-icon');

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    // 소셜 로그인
    function socialLogin(provider) {
        alert(provider + ' 소셜 로그인 기능은 준비중입니다.');
    }

    // 폼 유효성 검사
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username');
        const password = document.getElementById('password');
        let isValid = true;

        if (!username.value.trim()) {
            username.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            username.style.borderColor = '#e9ecef';
        }

        if (!password.value.trim()) {
            password.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            password.style.borderColor = '#e9ecef';
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    // 입력 시 에러 상태 제거
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', function() {
            this.style.borderColor = '#e9ecef';
        });
    });
</script>
