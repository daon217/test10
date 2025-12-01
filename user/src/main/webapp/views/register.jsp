<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- 회원가입 컨테이너 -->
        <div class="auth-container"
            style="min-height: calc(100vh - 200px); display: flex; align-items: center; justify-content: center; padding: 2rem 1rem;">
            <div
                style="max-width: 700px; width: 100%; background: white; border-radius: 1.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.1); padding: 3rem 2.5rem;">
                <!-- 헤더 -->
                <div style="text-align: center; margin-bottom: 2rem;">
                    <div
                        style="width: 60px; height: 60px; background: linear-gradient(135deg, #FF6B6B, #FA5252); border-radius: 1rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; box-shadow: 0 4px 12px rgba(255,107,107,0.3);">
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
                        <div class="step-label">반려동물</div>
                    </div>
                    <div class="step-line"></div>
                    <div class="step" id="step-indicator-4">
                        <div class="step-number">4</div>
                        <div class="step-label">완료</div>
                    </div>
                </div>

                <form id="registerForm" action="<c:url value='/register'/>" method="post" enctype="multipart/form-data">

                    <!-- ========== STEP 1: 역할 선택 ========== -->
                    <div class="register-step-content active" id="step-1">
                        <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">어떤 역할로
                            가입하시나요?</h4>
                        <p style="color: #6c757d; margin-bottom: 2rem;">역할에 따라 다른 서비스를 제공해드립니다</p>

                        <div class="role-selection">
                            <label class="role-card" for="role-owner">
                                <input type="radio" name="userRole" id="role-owner" value="OWNER">
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
                        <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 2rem;">기본 정보를
                            입력해주세요</h4>

                        <!-- 아이디 -->
                        <div class="form-group">
                            <label style="font-weight: 600; color: #212529;">아이디 <span
                                    style="color: #dc3545;">*</span></label>
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
                            <label style="font-weight: 600; color: #212529;">비밀번호 <span
                                    style="color: #dc3545;">*</span></label>
                            <div style="position: relative;">
                                <i class="fas fa-lock"
                                    style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
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
                            <label style="font-weight: 600; color: #212529;">비밀번호 확인 <span
                                    style="color: #dc3545;">*</span></label>
                            <div style="position: relative;">
                                <i class="fas fa-lock"
                                    style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #6c757d; z-index: 1;"></i>
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
                            <label style="font-weight: 600; color: #212529;">이름 <span
                                    style="color: #dc3545;">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" placeholder="실명을 입력하세요"
                                style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                        </div>

                        <!-- 이메일 -->
                        <div class="form-group">
                            <label style="font-weight: 600; color: #212529;">이메일 <span
                                    style="color: #dc3545;">*</span></label>
                            <input type="email" class="form-control" id="email" name="email"
                                placeholder="example@email.com"
                                style="height: 3rem; border-radius: 0.75rem; border: 2px solid #e9ecef;">
                        </div>

                        <!-- 전화번호 -->
                        <div class="form-group">
                            <label style="font-weight: 600; color: #212529;">전화번호 <span
                                    style="color: #dc3545;">*</span></label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="010-1234-5678"
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

                    <!-- ========== STEP 3: 반려동물 정보 입력 (반려인만) ========== -->
                    <div class="register-step-content" id="step-3">
                        <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">반려동물
                            정보를 입력해주세요</h4>
                        <p style="color: #6c757d; margin-bottom: 2rem;">최소 1마리 이상 등록해주세요</p>

                        <!-- 반려동물 폼 컨테이너 -->
                        <div id="petFormsContainer">
                            <!-- 첫 번째 반려동물 폼 -->
                            <div class="pet-form-card" data-pet-index="0">
                                <div class="pet-card-header">
                                    <h5 class="pet-card-title">
                                        <span class="pet-number-badge">1</span>
                                        반려동물 정보
                                    </h5>
                                </div>

                                <div class="pet-card-body">
                                    <!-- 사진 업로드 -->
                                    <div class="pet-photo-section">
                                        <div class="pet-photo-wrapper">
                                            <div class="pet-photo-preview" id="pet-photo-preview-0">
                                                <i class="fas fa-camera"></i>
                                            </div>
                                            <label for="petPhoto_0" class="pet-photo-btn">
                                                <i class="fas fa-plus"></i>
                                            </label>
                                            <input type="file" id="petPhoto_0" name="petPhoto_0" accept="image/*"
                                                onchange="previewPetPhoto(0, this)" hidden>
                                        </div>
                                        <p class="pet-photo-guide">프로필 사진을 등록해주세요</p>
                                    </div>

                                    <!-- 2열 레이아웃 -->
                                    <div class="form-row-group">
                                        <!-- 이름 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-font mr-1"></i> 이름 <span
                                                    class="required">*</span></label>
                                            <input type="text" class="form-control-auth" name="petName_0"
                                                placeholder="반려동물 이름" required>
                                        </div>

                                        <!-- 종류 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-paw mr-1"></i> 종류 <span
                                                    class="required">*</span></label>
                                            <select class="form-control-auth" name="petType_0" id="petType_0"
                                                onchange="toggleCustomPetType(0)" required>
                                                <option value="">선택하세요</option>
                                                <option value="DOG">강아지</option>
                                                <option value="CAT">고양이</option>
                                                <option value="ETC">기타 (직접 입력)</option>
                                            </select>
                                            <!-- 기타 선택 시 직접 입력 필드 -->
                                            <input type="text" class="form-control-auth mt-2" name="customPetType_0"
                                                id="customPetType_0" placeholder="어떤 동물을 키우시나요?" style="display: none;"
                                                maxlength="20">
                                        </div>
                                    </div>

                                    <div class="form-row-group">
                                        <!-- 품종 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-dna mr-1"></i> 품종</label>
                                            <input type="text" class="form-control-auth" name="petBreed_0"
                                                placeholder="예: 골든 리트리버">
                                        </div>

                                        <!-- 성별 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-venus-mars mr-1"></i> 성별 <span
                                                    class="required">*</span></label>
                                            <select class="form-control-auth" name="petGender_0" required>
                                                <option value="">선택하세요</option>
                                                <option value="MALE">수컷</option>
                                                <option value="FEMALE">암컷</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row-group">
                                        <!-- 나이 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-birthday-cake mr-1"></i> 나이 <span
                                                    class="required">*</span></label>
                                            <input type="number" class="form-control-auth" name="petAge_0"
                                                placeholder="나이 (년)" min="0" max="30" required>
                                        </div>

                                        <!-- 몸무게 -->
                                        <div class="form-group">
                                            <label><i class="fas fa-weight mr-1"></i> 몸무게 <span
                                                    class="required">*</span></label>
                                            <input type="number" class="form-control-auth" name="petWeight_0"
                                                placeholder="몸무게 (kg)" step="0.1" min="0" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 반려동물 추가 버튼 -->
                        <button type="button" class="btn-add-pet" onclick="addPetForm()">
                            <i class="fas fa-plus-circle"></i> 반려동물 추가하기
                        </button>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                            <button type="button" class="btn btn-outline-secondary" onclick="prevStep(2)"
                                style="height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                                <i class="fas fa-arrow-left mr-2"></i> 이전
                            </button>
                            <button type="button" class="btn btn-primary" onclick="nextStep(4)"
                                style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 3rem; border-radius: 0.75rem; font-weight: 600;">
                                다음 <i class="fas fa-arrow-right ml-2"></i>
                            </button>
                        </div>
                    </div>

                    <!-- ========== STEP 4: 약관 동의 ========== -->
                    <div class="register-step-content" id="step-4">
                        <h4 style="font-size: 1.25rem; font-weight: 700; color: #212529; margin-bottom: 0.5rem;">약관 동의
                        </h4>
                        <p style="color: #6c757d; margin-bottom: 2rem;">아래 약관에 동의하고 가입을 완료하세요</p>

                        <div class="terms-section">
                            <div class="form-check">
                                <input type="checkbox" class="custom-control-input" id="agreeAll"
                                    onclick="toggleAllTerms()">
                                <label class="custom-control-label font-weight-bold" for="agreeAll">
                                    전체 약관에 동의합니다
                                </label>
                            </div>
                            <hr>
                            <div class="form-check">
                                <input type="checkbox" class="custom-control-input term-checkbox" id="agreeTerms"
                                    required>
                                <label class="custom-control-label" for="agreeTerms">
                                    <a href="#" onclick="alert('이용약관'); return false;">[필수] 이용약관</a>에 동의합니다
                                </label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" class="custom-control-input term-checkbox" id="agreePrivacy"
                                    required>
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
                            <button type="button" class="btn btn-outline-secondary" onclick="prevStep(3)"
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
                    <a href="<c:url value='/login'/>"
                        style="color: #FF6B6B; text-decoration: none; font-weight: 600; margin-left: 0.5rem;">로그인</a>
                </div>
            </div>
        </div>

        <!-- 외부 JavaScript 파일 로드 -->
        <script src="<c:url value='/js/register.js'/>"></script>