/**
 * 회원가입 페이지 JavaScript
 * PetCare AI - 반려동물 케어 시스템
 * 수정: 일반 사용자 회원가입 허용 로직 추가
 */

let currentStep = 1;
let petFormCount = 1;

// 아이디 중복 확인 상태
let isUsernameChecked = false;
let checkedUsername = '';

// 현재 선택된 역할 확인
const isOwner = () => {
    const ownerRadio = document.getElementById('role-owner');
    return ownerRadio && ownerRadio.checked;
};

/**
 * 다음 단계로 이동
 */
function nextStep(step) {
    // 현재 단계 유효성 검사
    if (!validateStep(currentStep)) return;

    // 일반 사용자일 때 3단계(반려동물) 진입 시 처리
    if (step === 3 && !isOwner()) {
        // ✅ 반려동물 입력 필드 완전 비활성화 (required 제거)
        disablePetFields();
        // 바로 4단계로 건너뜀
        step = 4;
    } else if (step === 3 && isOwner()) {
        // 반려인일 경우 필드 활성화
        enablePetFields();
    }

    // UI 업데이트
    updateStepUI(step);
}

/**
 * 이전 단계로 이동
 */
function prevStep(step) {
    // 일반 사용자가 4단계에서 뒤로 갈 때 3단계 건너뛰고 2단계로
    if (currentStep === 4 && !isOwner()) {
        step = 2;
    }

    // UI 업데이트
    updateStepUI(step);
}

/**
 * 단계 변경에 따른 UI 업데이트 함수
 */
function updateStepUI(step) {
    // 기존 단계 비활성화
    document.getElementById('step-' + currentStep).classList.remove('active');
    document.getElementById('step-indicator-' + currentStep).classList.remove('active');

    // 진행된 단계 표시 (완료 표시)
    if (step > currentStep) {
        document.getElementById('step-indicator-' + currentStep).classList.add('completed');
    } else {
        // 뒤로 갈 때는 현재 단계 완료 표시 제거
        document.getElementById('step-indicator-' + currentStep).classList.remove('completed');
    }

    currentStep = step;

    // 새 단계 활성화
    document.getElementById('step-' + currentStep).classList.add('active');
    document.getElementById('step-indicator-' + currentStep).classList.add('active');

    // 뒤로 왔을 때 해당 단계 완료 표시 제거
    document.getElementById('step-indicator-' + currentStep).classList.remove('completed');

    // 3단계 인디케이터 스타일 처리 (일반 사용자는 흐리게)
    const step3Indicator = document.getElementById('step-indicator-3');
    if (!isOwner()) {
        step3Indicator.style.opacity = '0.3';
    } else {
        step3Indicator.style.opacity = '1';
    }

    window.scrollTo(0, 0);
}

/**
 * ✅ 반려동물 입력 필드 완전 비활성화 (일반 사용자용)
 * CRITICAL: required 속성을 완전히 제거하고 name도 제거해야 서버 전송 안됨
 */
function disablePetFields() {
    const petSection = document.getElementById('step-3');
    if (!petSection) return;

    // 모든 입력 필드 선택
    const inputs = petSection.querySelectorAll('input, select, textarea');

    inputs.forEach(input => {
        // 1. disabled 설정
        input.disabled = true;

        // 2. ✅ required 속성 완전 제거 (이게 핵심!)
        input.removeAttribute('required');

        // 3. ✅ name 속성 백업 후 제거 (서버로 전송 안되도록)
        if (input.name) {
            input.setAttribute('data-original-name', input.name);
            input.removeAttribute('name');
        }

        // 4. 값 초기화 (혹시 모를 검증 방지)
        if (input.tagName === 'SELECT') {
            input.selectedIndex = 0;
        } else if (input.type !== 'file') {
            input.value = '';
        }
    });

    console.log('✅ 일반 사용자: 반려동물 필드 완전 비활성화 완료');
}

/**
 * 반려동물 입력 필드 활성화 (반려인용)
 */
function enablePetFields() {
    const petSection = document.getElementById('step-3');
    if (!petSection) return;

    const inputs = petSection.querySelectorAll('input, select, textarea');

    inputs.forEach(input => {
        // 1. disabled 해제
        input.disabled = false;

        // 2. name 속성 복구
        const originalName = input.getAttribute('data-original-name');
        if (originalName) {
            input.setAttribute('name', originalName);
        }

        // 3. 필수 필드 복구 (첫 번째 반려동물의 필수 항목만)
        const petIndex = input.name ? input.name.match(/_(\d+)$/)?.[1] : null;
        if (petIndex === '0') {
            // 첫 번째 반려동물의 필수 필드만 required 복구
            const fieldName = input.name.replace(/_0$/, '');
            if (['petName', 'petType', 'petGender', 'petAge', 'petWeight'].includes(fieldName)) {
                input.setAttribute('required', 'required');
            }
        }
    });

    console.log('✅ 반려인: 반려동물 필드 활성화 완료');
}

// ==================== 입력 검증 ====================

function validateStep(step) {
    if (step === 1) return validateRole();
    if (step === 2) return validateUserInfo();
    if (step === 3 && isOwner()) return validatePetInfo();
    return true;
}

function validateRole() {
    const roleSelected = document.querySelector('input[name="userRole"]:checked');
    if (!roleSelected) {
        alert('역할을 선택해주세요.');
        return false;
    }
    return true;
}

function validateUserInfo() {
    const username = document.getElementById('username').value;

    // 아이디 중복 확인 여부 체크
    if (!isUsernameChecked || username !== checkedUsername) {
        alert('아이디 중복 확인을 해주세요.');
        document.getElementById('username').focus();
        return false;
    }

    if (!username || username.length < 4) {
        alert('아이디를 올바르게 입력해주세요 (4자 이상).');
        return false;
    }

    const password = document.getElementById('password').value;
    const passwordConfirm = document.getElementById('passwordConfirm').value;

    if (!password || password.length < 4) {
        alert('비밀번호를 입력해주세요 (4자 이상).');
        return false;
    }

    if (password !== passwordConfirm) {
        alert('비밀번호가 일치하지 않습니다.');
        return false;
    }

    const name = document.getElementById('name').value;
    if (!name) {
        alert('이름을 입력해주세요.');
        return false;
    }

    const email = document.getElementById('email').value;
    if (!email) {
        alert('이메일을 입력해주세요.');
        return false;
    }

    const phone = document.getElementById('phone').value;
    if (!phone) {
        alert('전화번호를 입력해주세요.');
        return false;
    }

    return true;
}

/**
 * ✅ 반려동물 정보 검증 (반려인만)
 */
function validatePetInfo() {
    // ✅ 일반 사용자는 무조건 통과
    if (!isOwner()) {
        console.log('✅ 일반 사용자: 반려동물 검증 생략');
        return true;
    }

    // 반려인: 첫 번째 반려동물 폼의 필수값 체크
    const container = document.querySelector('.pet-form-container[data-pet-index="0"]');
    if (!container) {
        alert('반려동물 정보를 입력해주세요.');
        return false;
    }

    // 필수 필드 검증
    const requiredFields = {
        'petName_0': '이름',
        'petType_0': '종류',
        'petGender_0': '성별',
        'petAge_0': '나이',
        'petWeight_0': '몸무게'
    };

    for (const [name, label] of Object.entries(requiredFields)) {
        const input = document.querySelector(`[name="${name}"]`);
        if (!input || !input.value || input.value.trim() === '') {
            alert(`반려동물의 ${label}을(를) 입력해주세요.`);
            if (input) input.focus();
            return false;
        }
    }

    // 기타 선택 시 customPetType 검증
    const petType = document.querySelector('[name="petType_0"]');
    if (petType && petType.value === 'ETC') {
        const customType = document.querySelector('[name="customPetType_0"]');
        if (!customType || !customType.value || customType.value.trim() === '') {
            alert('기타 동물의 종류를 입력해주세요.');
            if (customType) customType.focus();
            return false;
        }
    }

    console.log('✅ 반려인: 반려동물 정보 검증 통과');
    return true;
}

// ==================== 아이디 중복 확인 ====================

function checkUsername() {
    const username = document.getElementById('username').value;
    const usernameInput = document.getElementById('username');

    // 유효성 검사
    if (!username || username.trim().length === 0) {
        alert('아이디를 입력해주세요.');
        usernameInput.focus();
        return;
    }

    if (username.length < 4 || username.length > 20) {
        alert('아이디는 4-20자로 입력해주세요.');
        usernameInput.focus();
        return;
    }

    if (!/^[a-zA-Z0-9]+$/.test(username)) {
        alert('아이디는 영문과 숫자만 사용 가능합니다.');
        usernameInput.focus();
        return;
    }

    // 서버에 중복 확인 요청
    fetch(`/register/check-username?username=${encodeURIComponent(username)}`, {
        method: 'GET'
    })
        .then(response => response.json())
        .then(data => {
            if (data.available) {
                alert(data.message || '사용 가능한 아이디입니다.');
                usernameInput.style.borderColor = '#28a745';
                isUsernameChecked = true;
                checkedUsername = username;
            } else {
                alert(data.message || '이미 사용 중인 아이디입니다.');
                usernameInput.style.borderColor = '#dc3545';
                isUsernameChecked = false;
                checkedUsername = '';
            }
        })
        .catch(error => {
            console.error('아이디 중복 확인 오류:', error);
            alert('중복 확인 중 오류가 발생했습니다.');
        });
}

// 아이디 입력 시 중복 확인 상태 초기화
document.addEventListener('DOMContentLoaded', function () {
    const usernameInput = document.getElementById('username');
    if (usernameInput) {
        usernameInput.addEventListener('input', function () {
            const currentUsername = this.value;
            // 확인된 아이디와 다르면 중복 확인 상태 초기화
            if (currentUsername !== checkedUsername) {
                isUsernameChecked = false;
                this.style.borderColor = '#e9ecef';
            }
        });
    }
});

// ==================== 반려동물 관리 ====================

function addPetForm() {
    const container = document.getElementById('petFormsContainer');
    const newIndex = petFormCount;
    const displayNumber = newIndex + 1;

    const newForm = `
        <div class="pet-form-card" data-pet-index="${newIndex}">
            <div class="pet-card-header">
                <h5 class="pet-card-title">
                    <span class="pet-number-badge">${displayNumber}</span>
                    반려동물 정보
                </h5>
                <button type="button" class="btn-remove-pet" onclick="removePetForm(${newIndex})">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </div>

            <div class="pet-card-body">
                <!-- 사진 업로드 -->
                <div class="pet-photo-section">
                    <div class="pet-photo-wrapper">
                        <div class="pet-photo-preview" id="pet-photo-preview-${newIndex}">
                            <i class="fas fa-camera"></i>
                        </div>
                        <label for="petPhoto_${newIndex}" class="pet-photo-btn">
                            <i class="fas fa-plus"></i>
                        </label>
                        <input type="file" id="petPhoto_${newIndex}" name="petPhoto_${newIndex}" accept="image/*" onchange="previewPetPhoto(${newIndex}, this)" hidden>
                    </div>
                    <p class="pet-photo-guide">프로필 사진을 등록해주세요</p>
                </div>

                <!-- 2열 레이아웃 -->
                <div class="form-row-group">
                    <!-- 이름 -->
                    <div class="form-group">
                        <label><i class="fas fa-font mr-1"></i> 이름 <span class="required">*</span></label>
                        <input type="text" class="form-control-auth" name="petName_${newIndex}" placeholder="반려동물 이름" required>
                    </div>

                    <!-- 종류 -->
                    <div class="form-group">
                        <label><i class="fas fa-paw mr-1"></i> 종류 <span class="required">*</span></label>
                        <select class="form-control-auth" name="petType_${newIndex}" id="petType_${newIndex}" onchange="toggleCustomPetType(${newIndex})" required>
                            <option value="">선택하세요</option>
                            <option value="DOG">강아지</option>
                            <option value="CAT">고양이</option>
                            <option value="ETC">기타 (직접 입력)</option>
                        </select>
                        <!-- 기타 선택 시 직접 입력 필드 -->
                        <input type="text" class="form-control-auth mt-2" name="customPetType_${newIndex}" id="customPetType_${newIndex}"
                               placeholder="어떤 동물을 키우시나요?"
                               style="display: none;"
                               maxlength="20">
                    </div>
                </div>

                <div class="form-row-group">
                    <!-- 품종 -->
                    <div class="form-group">
                        <label><i class="fas fa-dna mr-1"></i> 품종</label>
                        <input type="text" class="form-control-auth" name="petBreed_${newIndex}" placeholder="예: 골든 리트리버">
                    </div>

                    <!-- 성별 -->
                    <div class="form-group">
                        <label><i class="fas fa-venus-mars mr-1"></i> 성별 <span class="required">*</span></label>
                        <select class="form-control-auth" name="petGender_${newIndex}" required>
                            <option value="">선택하세요</option>
                            <option value="MALE">수컷</option>
                            <option value="FEMALE">암컷</option>
                        </select>
                    </div>
                </div>

                <div class="form-row-group">
                    <!-- 나이 -->
                    <div class="form-group">
                        <label><i class="fas fa-birthday-cake mr-1"></i> 나이 <span class="required">*</span></label>
                        <input type="number" class="form-control-auth" name="petAge_${newIndex}" placeholder="나이 (년)" min="0" max="30" required>
                    </div>

                    <!-- 몸무게 -->
                    <div class="form-group">
                        <label><i class="fas fa-weight mr-1"></i> 몸무게 <span class="required">*</span></label>
                        <input type="number" class="form-control-auth" name="petWeight_${newIndex}" placeholder="몸무게 (kg)" step="0.1" min="0" required>
                    </div>
                </div>
            </div>
        </div>
    `;

    container.insertAdjacentHTML('beforeend', newForm);
    petFormCount++;
}

function removePetForm(index) {
    const form = document.querySelector(`[data-pet-index="${index}"]`);
    if (form) form.remove();
}

function previewPetPhoto(index, input) {
    const preview = document.getElementById(`pet-photo-preview-${index}`);
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.innerHTML = `<img src="${e.target.result}" style="width:100%; height:100%; object-fit:cover;">`;
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ==================== 초기화 ====================

document.addEventListener('DOMContentLoaded', function () {
    console.log('🐾 회원가입 페이지 로드 완료');

    // 역할 카드 클릭 시 라디오 버튼 체크
    document.querySelectorAll('.role-card').forEach(card => {
        card.addEventListener('click', function () {
            document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
            this.classList.add('selected');
            const radio = this.querySelector('input[type="radio"]');
            if (radio) {
                radio.checked = true;

                // ✅ 역할 선택 즉시 반려동물 필드 처리
                if (radio.value === 'GENERAL') {
                    console.log('✅ 일반 사용자 선택 → 반려동물 필드 비활성화');
                    disablePetFields();
                } else if (radio.value === 'OWNER') {
                    console.log('✅ 반려인 선택 → 반려동물 필드 활성화');
                    enablePetFields();
                }
            }
        });
    });

    // 약관 동의 개별 체크박스 이벤트
    document.querySelectorAll('.term-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            const allChecked = Array.from(document.querySelectorAll('.term-checkbox'))
                .every(cb => cb.checked);
            document.getElementById('agreeAll').checked = allChecked;
        });
    });

    // ✅ 페이지 로드 시에도 일반 사용자면 비활성화 (새로고침 대비)
    const generalRadio = document.getElementById('role-general');
    if (generalRadio && generalRadio.checked) {
        console.log('✅ 페이지 로드: 일반 사용자 선택됨 → 반려동물 필드 비활성화');
        disablePetFields();
    }
});

function togglePassword(id) {
    const input = document.getElementById(id);
    const icon = document.getElementById(id + '-icon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.add('fa-eye');
        icon.classList.remove('fa-eye-slash');
    }
}

function toggleAllTerms() {
    const all = document.getElementById('agreeAll').checked;
    document.querySelectorAll('.term-checkbox').forEach(cb => cb.checked = all);
}

function toggleCustomPetType(index) {
    const typeSelect = document.getElementById('petType_' + index);
    const customInput = document.getElementById('customPetType_' + index);

    if (typeSelect && customInput) {
        if (typeSelect.value === 'ETC') {
            customInput.style.display = 'block';
            // 반려인이고 첫 번째 반려동물일 때만 required
            if (isOwner() && index === 0) {
                customInput.required = true;
            }
        } else {
            customInput.style.display = 'none';
            customInput.required = false;
            customInput.value = '';
        }
    }
}