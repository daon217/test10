/**
 * 마이페이지 JavaScript
 * PetCare AI - 반려동물 케어 시스템
 * 수정: 일반 사용자 → 반려인 역할 변경 로직 추가
 */

// ==================== 탭 전환 ====================

function showTab(tabName) {
    // 모든 탭 패널 숨기기
    document.querySelectorAll('.tab-panel').forEach(panel => {
        panel.classList.remove('active');
    });

    // 모든 탭 버튼 비활성화
    document.querySelectorAll('.mypage-tab').forEach(tab => {
        tab.classList.remove('active');
    });

    // 선택한 탭 활성화
    document.getElementById('tab-' + tabName).classList.add('active');
    event.currentTarget.classList.add('active');
}

// ==================== 개인정보 수정 ====================

// 프로필 폼 제출
document.getElementById('profileForm')?.addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value
    };

    // 이메일 검증
    if (!validateEmail(formData.email)) {
        alert('올바른 이메일 형식을 입력해주세요.');
        return;
    }

    // 전화번호 검증
    if (!validatePhone(formData.phone)) {
        alert('올바른 전화번호 형식을 입력해주세요. (010-1234-5678)');
        return;
    }

    // 서버로 전송
    fetch('/mypage/update-profile', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams(formData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('개인정보가 수정되었습니다.');
                location.reload(); // 페이지 새로고침으로 세션 반영
            } else {
                alert(data.message || '수정 실패');
            }
        })
        .catch(error => {
            console.error('수정 중 오류:', error);
            alert('수정 중 오류가 발생했습니다.');
        });
});

// 폼 초기화
function resetForm() {
    if (confirm('변경사항을 취소하시겠습니까?')) {
        location.reload();
    }
}

// ==================== 비밀번호 변경 ====================

document.getElementById('passwordForm')?.addEventListener('submit', function (e) {
    e.preventDefault();

    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // 비밀번호 검증
    if (!currentPassword) {
        alert('현재 비밀번호를 입력해주세요.');
        return;
    }

    if (newPassword.length < 8) {
        alert('새 비밀번호는 8자 이상이어야 합니다.');
        return;
    }

    if (!/(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])/.test(newPassword)) {
        alert('새 비밀번호는 영문, 숫자, 특수문자를 모두 포함해야 합니다.');
        return;
    }

    if (newPassword !== confirmPassword) {
        alert('새 비밀번호가 일치하지 않습니다.');
        return;
    }

    if (currentPassword === newPassword) {
        alert('현재 비밀번호와 새 비밀번호가 같습니다.');
        return;
    }

    // 서버로 전송
    fetch('/mypage/change-password', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('비밀번호가 변경되었습니다.');
                // 수동으로 필드 초기화 (reset() 사용하지 않음)
                document.getElementById('currentPassword').value = '';
                document.getElementById('newPassword').value = '';
                document.getElementById('confirmPassword').value = '';
                // 비밀번호 필드 테두리 색상 초기화
                document.getElementById('currentPassword').style.borderColor = '#e9ecef';
                document.getElementById('newPassword').style.borderColor = '#e9ecef';
                document.getElementById('confirmPassword').style.borderColor = '#e9ecef';
            } else {
                alert(data.message || '변경 실패');
            }
        })
        .catch(error => {
            console.error('비밀번호 변경 오류:', error);
            alert('비밀번호 변경 중 오류가 발생했습니다.');
        });
});

// 비밀번호 보기/숨기기 토글
function togglePasswordVisibility(inputId) {
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
/**
 * 마이페이지 JavaScript
 * PetCare AI - 반려동물 케어 시스템
 * 수정: 일반 사용자 → 반려인 역할 변경 로직 추가
 */

// ==================== 탭 전환 ====================

function showTab(tabName) {
    // 모든 탭 패널 숨기기
    document.querySelectorAll('.tab-panel').forEach(panel => {
        panel.classList.remove('active');
    });

    // 모든 탭 버튼 비활성화
    document.querySelectorAll('.mypage-tab').forEach(tab => {
        tab.classList.remove('active');
    });

    // 선택한 탭 활성화
    document.getElementById('tab-' + tabName).classList.add('active');
    event.currentTarget.classList.add('active');
}

// ==================== 개인정보 수정 ====================

// 프로필 폼 제출
document.getElementById('profileForm')?.addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value
    };

    // 이메일 검증
    if (!validateEmail(formData.email)) {
        alert('올바른 이메일 형식을 입력해주세요.');
        return;
    }

    // 전화번호 검증
    if (!validatePhone(formData.phone)) {
        alert('올바른 전화번호 형식을 입력해주세요. (010-1234-5678)');
        return;
    }

    // 서버로 전송
    fetch('/mypage/update-profile', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams(formData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('개인정보가 수정되었습니다.');
                location.reload(); // 페이지 새로고침으로 세션 반영
            } else {
                alert(data.message || '수정 실패');
            }
        })
        .catch(error => {
            console.error('수정 중 오류:', error);
            alert('수정 중 오류가 발생했습니다.');
        });
});

// 폼 초기화
function resetForm() {
    if (confirm('변경사항을 취소하시겠습니까?')) {
        location.reload();
    }
}

// ==================== 비밀번호 변경 ====================

document.getElementById('passwordForm')?.addEventListener('submit', function (e) {
    e.preventDefault();

    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // 비밀번호 검증
    if (!currentPassword) {
        alert('현재 비밀번호를 입력해주세요.');
        return;
    }

    if (newPassword.length < 8) {
        alert('새 비밀번호는 8자 이상이어야 합니다.');
        return;
    }

    if (!/(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])/.test(newPassword)) {
        alert('새 비밀번호는 영문, 숫자, 특수문자를 모두 포함해야 합니다.');
        return;
    }

    if (newPassword !== confirmPassword) {
        alert('새 비밀번호가 일치하지 않습니다.');
        return;
    }

    if (currentPassword === newPassword) {
        alert('현재 비밀번호와 새 비밀번호가 같습니다.');
        return;
    }

    // 서버로 전송
    fetch('/mypage/change-password', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('비밀번호가 변경되었습니다.');
                // 수동으로 필드 초기화 (reset() 사용하지 않음)
                document.getElementById('currentPassword').value = '';
                document.getElementById('newPassword').value = '';
                document.getElementById('confirmPassword').value = '';
                // 비밀번호 필드 테두리 색상 초기화
                document.getElementById('currentPassword').style.borderColor = '#e9ecef';
                document.getElementById('newPassword').style.borderColor = '#e9ecef';
                document.getElementById('confirmPassword').style.borderColor = '#e9ecef';
            } else {
                alert(data.message || '변경 실패');
            }
        })
        .catch(error => {
            console.error('비밀번호 변경 오류:', error);
            alert('비밀번호 변경 중 오류가 발생했습니다.');
        });
});

// 비밀번호 보기/숨기기 토글
function togglePasswordVisibility(inputId) {
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

// ==================== 프로필 사진 업로드 ====================

// ✅ 이벤트 리스너 중복 방지
let profileImageListenerAdded = false;

function initProfileImageUpload() {
    const input = document.getElementById('profileImageInput');

    if (!input || profileImageListenerAdded) return;

    profileImageListenerAdded = true;

    input.addEventListener('change', function (e) {
        const file = e.target.files[0];

        if (!file) return;

        // 파일 타입 검증
        if (!file.type.startsWith('image/')) {
            alert('이미지 파일만 업로드 가능합니다.');
            e.target.value = '';
            return;
        }

        // 파일 크기 검증 (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB 이하여야 합니다.');
            e.target.value = '';
            return;
        }

        // 서버 업로드 (미리보기는 성공 후에만 표시)
        const formData = new FormData();
        formData.append('profileImage', file);

        fetch('/mypage/upload-profile-image', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 성공 시에만 이미지 변경
                    const reader = new FileReader();
                    reader.onload = function (event) {
                        const avatar = document.querySelector('.profile-avatar');
                        const existingImg = avatar.querySelector('img');
                        const uploadLabel = avatar.querySelector('.profile-avatar-upload');

                        if (existingImg) {
                            existingImg.src = event.target.result;
                        } else {
                            const newImg = document.createElement('img');
                            newImg.src = event.target.result;
                            newImg.alt = 'Profile';
                            newImg.style.width = '100%';
                            newImg.style.height = '100%';
                            newImg.style.objectFit = 'cover';
                            newImg.style.borderRadius = '50%';

                            const existingIcon = avatar.querySelector('i');
                            if (existingIcon) {
                                existingIcon.remove();
                            }

                            avatar.insertBefore(newImg, uploadLabel);
                        }
                    };
                    reader.readAsDataURL(file);

                    alert('프로필 사진이 업로드되었습니다.');
                    e.target.value = '';
                } else {
                    alert(data.message || '업로드 실패');
                    e.target.value = '';
                }
            })
            .catch(error => {
                console.error('업로드 오류:', error);
                alert('업로드 중 오류가 발생했습니다.');
                e.target.value = '';
            });
    });
}

// DOMContentLoaded에서 초기화
document.addEventListener('DOMContentLoaded', initProfileImageUpload);

// ==================== 회원 탈퇴 ====================

function showDeleteModal() {
    document.getElementById('deleteModal').classList.add('active');
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.remove('active');
    document.getElementById('deleteConfirmPassword').value = '';
    document.getElementById('deleteConfirm').checked = false;
}

function confirmDelete() {
    const password = document.getElementById('deleteConfirmPassword').value;
    const confirm = document.getElementById('deleteConfirm').checked;

    if (!password) {
        alert('비밀번호를 입력해주세요.');
        return;
    }

    if (!confirm) {
        alert('탈퇴 동의에 체크해주세요.');
        return;
    }

    if (window.confirm('정말로 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
        fetch('/mypage/delete-account', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({ password: password })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('회원 탈퇴가 완료되었습니다.');
                    window.location.href = '/';
                } else {
                    alert(data.message || '탈퇴 실패');
                }
            })
            .catch(error => {
                console.error('탈퇴 오류:', error);
                alert('탈퇴 중 오류가 발생했습니다.');
            });
    }
}

// 모달 외부 클릭 시 닫기
document.querySelectorAll('.modal-overlay').forEach(modal => {
    modal.addEventListener('click', function (e) {
        if (e.target === this) {
            this.classList.remove('active');
        }
    });
});

// ==================== 반려동물 관리 ====================

function showAddPetModal() {
    document.getElementById('petModalTitle').innerHTML = '<i class="fas fa-paw"></i> 반려동물 추가';
    document.getElementById('petForm').reset();
    document.getElementById('petId').value = '';

    // 이미지 미리보기 초기화
    const preview = document.getElementById('petPhotoPreview');
    if (preview) {
        preview.src = '';
        preview.style.display = 'none';
    }

    document.getElementById('petModal').classList.add('active');
}

function closePetModal() {
    document.getElementById('petModal').classList.remove('active');
}

function previewPetPhoto(input) {
    const preview = document.getElementById('petPhotoPreview');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        }
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.src = '';
        preview.style.display = 'none';
    }
}

function editPet(petId) {
    console.log('반려동물 수정:', petId);

    document.getElementById('petModalTitle').innerHTML = '<i class="fas fa-paw"></i> 반려동물 수정';
    document.getElementById('petId').value = petId;

    // 서버에서 반려동물 정보 가져오기
    fetch(`/mypage/get-pet?petId=${petId}`, {
        method: 'GET'
    })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.pet) {
                const pet = data.pet;

                // 폼에 기존 데이터 채우기
                document.getElementById('petName').value = pet.name || '';
                document.getElementById('petType').value = pet.type || '';
                document.getElementById('petBreed').value = pet.breed || '';
                document.getElementById('petGender').value = pet.gender || '';
                document.getElementById('petAge').value = pet.age || '';
                document.getElementById('petWeight').value = pet.weight || '';

                // 이미지 미리보기 설정
                const preview = document.getElementById('petPhotoPreview');
                if (preview) {
                    if (pet.photo) {
                        preview.src = pet.photo;
                        preview.style.display = 'block';
                    } else {
                        preview.src = '';
                        preview.style.display = 'none';
                    }
                }

                // 모달 열기
                document.getElementById('petModal').classList.add('active');
            } else {
                alert(data.message || '반려동물 정보를 불러오는데 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('반려동물 정보 로드 오류:', error);
            alert('반려동물 정보를 불러오는 중 오류가 발생했습니다.');
        });
}

/**
 * ✅ 반려동물 저장 - 일반 사용자가 반려동물 추가 시 역할 변경 알림
 */
function savePet() {
    const petId = document.getElementById('petId').value;

    // FormData 객체 생성
    const formData = new FormData();

    // 기본 정보 추가
    const name = document.getElementById('petName').value;
    const type = document.getElementById('petType').value;
    const breed = document.getElementById('petBreed').value;
    const gender = document.getElementById('petGender').value;
    const age = document.getElementById('petAge').value;
    const weight = document.getElementById('petWeight').value;

    formData.append('name', name);
    formData.append('type', type);
    formData.append('breed', breed);
    formData.append('gender', gender);
    formData.append('age', age);
    formData.append('weight', weight);

    // 이미지 파일 추가
    const imageInput = document.getElementById('petImage');
    if (imageInput && imageInput.files && imageInput.files[0]) {
        formData.append('petImage', imageInput.files[0]);
    }

    // 필수 필드 검증
    if (!name || !type || !gender || !age || !weight) {
        alert('필수 항목을 모두 입력해주세요.');
        return;
    }

    // 나이 범위 검증
    if (age < 0 || age > 30) {
        alert('나이는 0-30세 사이로 입력해주세요.');
        return;
    }

    // 몸무게 범위 검증
    if (weight <= 0 || weight > 200) {
        alert('몸무게를 올바르게 입력해주세요. (0-200kg)');
        return;
    }

    const url = petId ? '/mypage/update-pet' : '/mypage/add-pet';
    if (petId) {
        formData.append('petId', petId);
    }

    fetch(url, {
        method: 'POST',
        // FormData 사용 시 Content-Type 헤더는 자동 설정되므로 생략
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // ✅ 역할 변경이 발생한 경우 특별한 안내
                if (data.roleChanged) {
                    alert('🎉 축하합니다!\n\n반려동물이 추가되었으며, 이제 반려인으로 전환되었습니다.\n반려인 전용 기능을 사용하실 수 있습니다.');
                    console.log('✅ 역할 변경 감지: GENERAL → OWNER');
                } else {
                    alert(data.message || (petId ? '반려동물 정보가 수정되었습니다.' : '반려동물이 추가되었습니다.'));
                }

                closePetModal();
                location.reload(); // 페이지 새로고침하여 변경사항 반영
            } else {
                alert(data.message || '저장 실패');
            }
        })
        .catch(error => {
            console.error('저장 오류:', error);
            alert('저장 중 오류가 발생했습니다.');
        });
}

function deletePet(petId) {
    if (confirm('정말 삭제하시겠습니까?')) {
        fetch('/mypage/delete-pet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({ petId: petId })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('반려동물이 삭제되었습니다.');
                    location.reload();
                } else {
                    alert(data.message || '삭제 실패');
                }
            })
            .catch(error => {
                console.error('삭제 오류:', error);
                alert('삭제 중 오류가 발생했습니다.');
            });
    }
}

// ==================== 유틸리티 함수 ====================

function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validatePhone(phone) {
    return /^010-\d{4}-\d{4}$/.test(phone);
}

// ==================== 전화번호 자동 하이픈 ====================

document.getElementById('phone')?.addEventListener('input', function (e) {
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

// ==================== 이메일 실시간 검증 ====================

document.getElementById('email')?.addEventListener('blur', function () {
    if (this.value && !validateEmail(this.value)) {
        this.style.borderColor = '#dc3545';
        alert('올바른 이메일 형식을 입력해주세요.');
    } else {
        this.style.borderColor = '#e9ecef';
    }
});

// ==================== 비밀번호 실시간 검증 ====================

document.getElementById('newPassword')?.addEventListener('input', function () {
    const password = this.value;

    if (password.length >= 8 && /(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])/.test(password)) {
        this.style.borderColor = '#28a745';
    } else if (password.length > 0) {
        this.style.borderColor = '#dc3545';
    } else {
        this.style.borderColor = '#e9ecef';
    }
});

document.getElementById('confirmPassword')?.addEventListener('input', function () {
    const newPassword = document.getElementById('newPassword').value;

    if (this.value && newPassword !== this.value) {
        this.style.borderColor = '#dc3545';
    } else if (this.value) {
        this.style.borderColor = '#28a745';
    } else {
        this.style.borderColor = '#e9ecef';
    }
});

// ==================== 페이지 로드 완료 ====================

console.log('🐾 마이페이지 로드 완료');