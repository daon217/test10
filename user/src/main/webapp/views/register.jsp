<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 다단계 회원가입 전용 스타일 */
    .register-steps {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 2rem;
        padding: 0 1rem;
    }

    .register-steps .step {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .register-steps .step-number {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #e9ecef;
        color: #6c757d;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 0.5rem;
        transition: all 0.3s ease;
    }

    .register-steps .step.active .step-number {
        background: linear-gradient(135deg, #FF6B6B, #FA5252);
        color: white;
        box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
    }

    .register-steps .step.completed .step-number {
        background: #51CF66;
        color: white;
    }

    .register-steps .step-label {
        font-size: 0.875rem;
        color: #6c757d;
        font-weight: 500;
    }

    .register-steps .step.active .step-label {
        color: #FF6B6B;
        font-weight: 700;
    }

    .register-steps .step-line {
        width: 80px;
        height: 2px;
        background: #e9ecef;
        margin: 0 1rem;
        margin-bottom: 2rem;
    }

    .register-step-content {
        display: none;
    }

    .register-step-content.active {
        display: block;
        animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .role-selection {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
        margin-bottom: 1.5rem;
    }

    .role-card {
        border: 2px solid #e9ecef;
        border-radius: 1rem;
        padding: 1.5rem;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .role-card:hover {
        border-color: #FFB3B3;
        background: #FFF5F5;
    }

    .role-card.selected {
        border-color: #FF6B6B;
        background: #FFE3E3;
    }

    .role-card input[type="radio"] {
        display: none;
    }

    .role-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: #FF6B6B;
    }

    .role-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #212529;
        margin-bottom: 0.5rem;
    }

    .role-desc {
        font-size: 0.875rem;
        color: #6c757d;
    }

    .terms-section {
        background: #f8f9fa;
        padding: 1.5rem;
        border-radius: 1rem;
        margin-bottom: 1.5rem;
    }

    .terms-section .form-check {
        margin-bottom: 1rem;
    }

    .terms-section .form-check:last-child {
        margin-bottom: 0;
    }

    .terms-section a {
        color: #FF6B6B;
        text-decoration: none;
        font-weight: 600;
    }

    .terms-section a:hover {
        text-decoration: underline;
    }
</style>

<!-- 회원가입 컨테이너 -->
<div class="auth-container" style="min-height: calc(100vh - 200px); display: flex; align-items: center; justify-content: center; padding: 2rem 1rem;">
    <div style="max-width: 600px; width: 100%; background: white; border-radius: 1.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.1); padding: 3rem 2.5rem;">
        <!-- 헤더 -->
        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 60px; height: 60px; background: linear-gradient(135deg, #FF6B6B, #FA5252); border-radius: 1rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; box-shadow: 0 4px 12px rgba(255,107,107,0.3);">
                <i class="fas fa-paw" style="color: white; font-size: 1.75rem;"></i>
            </div>
            <h2 style="font-size: 1.5rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">회원가입</h2>
            <p style="color: #6c757d; margin-bottom: 0;">빠르고 간편한 가입으로 시작하세요</p>
        </div>

        <!-- 진행 단계 표시 -->
        <div class="register-steps">
            <div class="step active" id="step-indicator-1">
                <div class="step-number">1</div>
                <div class="step-label">역할</div>
            </div>
            <div class="step-line"></div>
            <div class="step" id="step-indicator-2">
                <div class="step-number">2</div>
                <div class="step-label">정보</div>
            </div>
            <div class="step-line"></div>
            <div class="step" id="step-indicator-3">
                <div class="step-number">3</div>
                <div class="step-label">완료</div>
            </div>
        </div>

        <form id="registerForm" action="<c:url value='/register'/>" method="post">

            <!-- ========== STEP 1: 역할 선택 ========== -->
            <div class="register-step-content active" id="step-1">
                <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">어떤 역할로 가입하시나요?</h4>
                <p style="color: #6c757d; margin-bottom: 2rem;">역할에 따라 다른 서비스를 제공해드립니다</p>

                <div class="role-selection">
                    <label class="role-card" for="role-owner">
                        <input type="radio" name="userRole" id="role-owner" value="OWNER" checked>
                        <div class="role-icon"><i class="fas fa-dog"></i></div>
                        <div class="role-title">반려인</div>
                        <div class="role-desc">반려동물과 함께하는 보호자</div>
                    </label>

                    <label class="role-card" for="role-general">
                        <input type="radio" name="userRole" id="role-general" value="GENERAL">
                        <div class="role-icon"><i class="fas fa-user"></i></div>
                        <div class="role-title">일반 사용자</div>
                        <div class="role-desc">산책 알바 등 서비스 이용</div>
                    </label>
                </div>

                <button type="button" class="btn btn-primary btn-block" onclick="nextStep(2)"
                        style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                    다음 <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>

            <!-- ========== STEP 2: 기본 정보 입력 ========== -->
            <div class="register-step-content" id="step-2">
                <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 2rem;">기본 정보를 입력해주세요</h4>

                <!-- 아이디 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">아이디 <span style="color: #dc3545;">*</span></label>
                    <div style="display: flex; gap: 0.5rem;">
                        <input type="text" class="form-control" id="username" name="username"
                               placeholder="4-20자 영문, 숫자"
                               style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                        <button type="button" class="btn btn-outline-primary" onclick="checkUsername()"
                                style="white-space: nowrap; height: 3rem; border-radius: 0.75rem; border: 2px solid #FF6B6B; color: #FF6B6B; background: white; font-weight: 600;">
                            중복확인
                        </button>
                    </div>
                </div>

                <!-- 비밀번호 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">비밀번호 <span style="color: #dc3545;">*</span></label>
                    <div style="position: relative;">
                        <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="8자 이상, 영문+숫자+특수문자"
                               style="padding-left: 2.75rem; padding-right: 3rem; height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                        <button type="button" onclick="togglePassword('password')"
                                style="position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); background: none; border: none; color: #6c757d; cursor: pointer; padding: 0.5rem; z-index: 2;">
                            <i class="fas fa-eye" id="password-icon"></i>
                        </button>
                    </div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">비밀번호 확인 <span style="color: #dc3545;">*</span></label>
                    <div style="position: relative;">
                        <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
                        <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm"
                               placeholder="비밀번호를 다시 입력하세요"
                               style="padding-left: 2.75rem; padding-right: 3rem; height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                        <button type="button" onclick="togglePassword('passwordConfirm')"
                                style="position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); background: none; border: none; color: #6c757d; cursor: pointer; padding: 0.5rem; z-index: 2;">
                            <i class="fas fa-eye" id="passwordConfirm-icon"></i>
                        </button>
                    </div>
                </div>

                <!-- 이름 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">이름 <span style="color: #dc3545;">*</span></label>
                    <input type="text" class="form-control" id="name" name="name"
                           placeholder="실명을 입력하세요"
                           style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                </div>

                <!-- 이메일 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">이메일 <span style="color: #dc3545;">*</span></label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="example@email.com"
                           style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                </div>

                <!-- 전화번호 -->
                <div class="form-group">
                    <label style="font-weight: 600; color: #212529;">전화번호 <span style="color: #dc3545;">*</span></label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           placeholder="010-1234-5678"
                           style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; margin-top: 2rem;">
                    <button type="button" class="btn btn-outline-secondary" onclick="prevStep(1)"
                            style="height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                        <i class="fas fa-arrow-left mr-2"></i> 이전
                    </button>
                    <button type="button" class="btn btn-primary" onclick="nextStep(3)"
                            style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                        다음 <i class="fas fa-arrow-right ml-2"></i>
                    </button>
                </div>
            </div>

            <!-- ========== STEP 3: 약관 동의 ========== -->
            <div class="register-step-content" id="step-3">
                <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">약관 동의</h4>
                <p style="color: #6c757d; margin-bottom: 2rem;">아래 약관에 동의하고 가입을 완료하세요</p>

                <div class="terms-section">
                    <div class="form-check">
                        <input type="checkbox" class="custom-control-input" id="agreeAll" onclick="toggleAllTerms()">
                        <label class="custom-control-label font-weight-bold" for="agreeAll">
                            전체 약관에 동의합니다
                        </label>
                    </div>
                    <hr>
                    <div class="form-check">
                        <input type="checkbox" class="custom-control-input term-checkbox" id="agreeTerms" required>
                        <label class="custom-control-label" for="agreeTerms">
                            <a href="#" onclick="alert('이용약관'); return false;">[필수] 이용약관</a>에 동의합니다
                        </label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="custom-control-input term-checkbox" id="agreePrivacy" required>
                        <label class="custom-control-label" for="agreePrivacy">
                            <a href="#" onclick="alert('개인정보처리방침'); return false;">[필수] 개인정보처리방침</a>에 동의합니다
                        </label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="custom-control-input term-checkbox" id="agreeMarketing">
                        <label class="custom-control-label" for="agreeMarketing">
                            [선택] 마케팅 정보 수신에 동의합니다
                        </label>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                    <button type="button" class="btn btn-outline-secondary" onclick="prevStep(2)"
                            style="height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                        <i class="fas fa-arrow-left mr-2"></i> 이전
                    </button>
                    <button type="submit" class="btn btn-primary"
                            style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                        <i class="fas fa-user-plus mr-2"></i> 가입 완료
                    </button>
                </div>
            </div>

        </form>

        <!-- 로그인 링크 -->
        <div style="text-align: center; margin-top: 1.5rem; color: #6c757d;">
            이미 계정이 있으신가요?
            <a href="<c:url value='/login'/>" style="color: #FF6B6B; text-decoration: none; font-weight: 600; margin-left: 0.5rem;">로그인</a>
        </div>
    </div>
</div>

<script>
    let currentStep = 1;

    // 다음 단계
    function nextStep(step) {
        if (!validateStep(currentStep)) return;

        document.getElementById('step-' + currentStep).classList.remove('active');
        document.getElementById('step-indicator-' + currentStep).classList.remove('active');
        document.getElementById('step-indicator-' + currentStep).classList.add('completed');

        currentStep = step;
        document.getElementById('step-' + currentStep).classList.add('active');
        document.getElementById('step-indicator-' + currentStep).classList.add('active');
        window.scrollTo(0, 0);
    }

    // 이전 단계
    function prevStep(step) {
        document.getElementById('step-' + currentStep).classList.remove('active');
        document.getElementById('step-indicator-' + currentStep).classList.remove('active');

        currentStep = step;
        document.getElementById('step-' + currentStep).classList.add('active');
        document.getElementById('step-indicator-' + currentStep).classList.add('active');
        document.getElementById('step-indicator-' + currentStep).classList.remove('completed');
        window.scrollTo(0, 0);
    }

    // 단계 검증
    function validateStep(step) {
        if (step === 2) {
            const fields = ['username', 'password', 'passwordConfirm', 'name', 'email', 'phone'];
            for (let field of fields) {
                if (!document.getElementById(field).value) {
                    alert('모든 필수 항목을 입력해주세요.');
                    return false;
                }
            }
            if (document.getElementById('password').value !== document.getElementById('passwordConfirm').value) {
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
        }
        return true;
    }

    // 역할 카드 선택
    document.querySelectorAll('.role-card').forEach(card => {
        card.addEventListener('click', function() {
            document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
            this.classList.add('selected');
        });
    });

    // 비밀번호 토글
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

    // 아이디 중복 확인
    function checkUsername() {
        const username = document.getElementById('username').value;
        if (!username) {
            alert('아이디를 입력해주세요.');
            return;
        }
        alert('사용 가능한 아이디입니다.');
    }

    // 전체 약관 동의
    function toggleAllTerms() {
        const agreeAll = document.getElementById('agreeAll').checked;
        document.querySelectorAll('.term-checkbox').forEach(cb => cb.checked = agreeAll);
    }

    // 전화번호 자동 하이픈
    document.getElementById('phone').addEventListener('input', function(e) {
        let value = e.target.value.replace(/[^0-9]/g, '');
        if (value.length > 0) {
            if (value.length <= 3) {
                e.target.value = value;
            } else if (value.length <= 7) {
                e.target.value = value.slice(0, 3) + '-' + value.slice(3);
            } else {
                e.target.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
            }
        }
    });

    // 비밀번호 확인 검증
    document.getElementById('passwordConfirm').addEventListener('input', function() {
        const password = document.getElementById('password').value;
        if (this.value && password !== this.value) {
            this.style.borderColor = '#dc3545';
        } else {
            this.style.borderColor = '#e9ecef';
        }
    });

    // 폼 제출
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        if (!document.getElementById('agreeTerms').checked || !document.getElementById('agreePrivacy').checked) {
            e.preventDefault();
            alert('필수 약관에 동의해주세요.');
        }
    });
</script>
