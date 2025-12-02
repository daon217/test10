// ============================================
// 마이페이지 전용 JavaScript
// ============================================

// ========== 탭 전환 ==========
function showTab(tabName) {
    // 모든 탭 패널 숨기기
    document.querySelectorAll('.tab-panel').forEach(panel => {
        panel.classList.remove('active');
    });

    // 모든 탭 버튼 비활성화
    document.querySelectorAll('.mypage-tab').forEach(tab => {
        tab.classList.remove('active');
    });

    // 선택한 탭 패널 표시
    document.getElementById('tab-' + tabName).classList.add('active');

    // 선택한 탭 버튼 활성화
    event.currentTarget.classList.add('active');
}

// ========== 폼 리셋 ==========
function resetForm() {
    if (confirm('변경사항을 취소하시겠습니까?')) {
        location.reload();
    }
}

// ========== 비밀번호 보기/숨기기 ==========
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

// ========== 프로필 정보 수정 ==========
document.addEventListener('DOMContentLoaded', function () {
    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value
            };

            fetch('/api/mypage/profile', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('프로필이 수정되었습니다.');
                            location.reload();
                        } else {
                            alert('프로필 수정에 실패했습니다: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('서버 오류가 발생했습니다.');
                    });
        });
    }
});

// ========== 비밀번호 변경 ==========
document.addEventListener('DOMContentLoaded', function () {
    const passwordForm = document.getElementById('passwordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // 유효성 검사
            if (newPassword !== confirmPassword) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }

            if (newPassword.length < 8) {
                alert('비밀번호는 8자 이상이어야 합니다.');
                return;
            }

            const formData = {
                currentPassword: currentPassword,
                newPassword: newPassword
            };

            fetch('/api/mypage/password', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('비밀번호가 변경되었습니다.');
                            passwordForm.reset();
                        } else {
                            alert('비밀번호 변경에 실패했습니다: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('서버 오류가 발생했습니다.');
                    });
        });
    }
});

// ========== 프로필 이미지 업로드 ==========
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

        const formData = new FormData();
        formData.append('file', file);

        fetch('/api/mypage/profile-image', {
            method: 'POST',
            body: formData
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('프로필 사진이 업로드되었습니다.');
                        location.reload();
                    } else {
                        alert('업로드에 실패했습니다: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                });
    });
}

// 프로필 이미지 업로드 초기화
document.addEventListener('DOMContentLoaded', initProfileImageUpload);

// ========== 회원 탈퇴 ==========
function withdrawAccount() {
    if (confirm('정말 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.')) {
        const password = prompt('비밀번호를 입력하세요:');

        if (!password) {
            alert('비밀번호를 입력해야 합니다.');
            return;
        }

        fetch('/api/mypage/withdraw', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({password: password})
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('회원 탈퇴가 완료되었습니다.');
                        location.href = '/';
                    } else {
                        alert('탈퇴에 실패했습니다: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                });
    }
}

// ========== 반려동물 관련 함수 ==========
function openAddPetModal() {
    alert('반려동물 추가 모달 (개발 예정)');
    // TODO: 모달 구현
}

function editPet(petId) {
    alert('반려동물 수정 (ID: ' + petId + ')');
    // TODO: 구현
}

function deletePet(petId) {
    if (confirm('이 반려동물 정보를 삭제하시겠습니까?')) {
        fetch('/api/pets/' + petId, {
            method: 'DELETE'
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('삭제에 실패했습니다: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                });
    }
}

// ========== 다이어리 관련 함수 ==========
document.addEventListener('DOMContentLoaded', function() {
    const filterTags = document.querySelectorAll('.filter-tag');

    filterTags.forEach(tag => {
        tag.addEventListener('click', function() {
            // 모든 태그 비활성화
            filterTags.forEach(t => t.classList.remove('active'));
            // 클릭한 태그 활성화
            this.classList.add('active');

            const filterType = this.dataset.tag;
            filterDiaryItems(filterType);
        });
    });
});

function filterDiaryItems(type) {
    const items = document.querySelectorAll('.diary-item');

    items.forEach(item => {
        if (type === 'all' || item.dataset.type === type) {
            item.style.display = 'flex';
        } else {
            item.style.display = 'none';
        }
    });
}

// ========== 뷰 전환 ==========
function changeView(viewType) {
    const buttons = document.querySelectorAll('.view-options .btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');

    if (viewType === 'timeline') {
        // TODO: 타임라인 뷰로 전환
        console.log('타임라인 뷰');
    } else {
        // TODO: 리스트 뷰로 전환
        console.log('리스트 뷰');
    }
}

// ========== 메모 추가 모달 ==========
function openAddMemoModal() {
    alert('메모 추가 모달 (개발 예정)');
    // TODO: 모달 구현
}

// ========== 더보기 ==========
function loadMoreDiary() {
    alert('더 많은 다이어리 불러오기 (개발 예정)');
    // TODO: 페이지네이션 구현
}

// ========== FullCalendar 초기화 (실제 구현) ==========
document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('diary-calendar-container');

    if (calendarEl) {
        // TODO: FullCalendar 라이브러리 로드 후 초기화
        /*
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            events: '/api/diary/events', // 서버에서 이벤트 로드
            eventClick: function(info) {
                // 이벤트 클릭 시 상세 정보 표시
                showDiaryDetail(info.event.id);
            }
        });
        calendar.render();
        */
    }
});

// ========== 행동 리포트 관련 함수 ==========
function changeReportPeriod(period) {
    // 모든 버튼 비활성화
    document.querySelectorAll('.report-controls .btn-group .btn').forEach(btn => {
        btn.classList.remove('active');
    });

    // 선택한 버튼 활성화
    event.currentTarget.classList.add('active');

    console.log('리포트 기간 변경:', period);
    // TODO: 실제 구현 시 서버에서 데이터 가져와서 차트 업데이트
}

function generateReport() {
    if (confirm('최신 데이터로 리포트를 생성하시겠습니까?')) {
        alert('리포트를 생성하고 있습니다...');
        // TODO: 실제 구현 시 서버 API 호출
    }
}

// Chart.js 초기화
document.addEventListener('DOMContentLoaded', function () {
    const activityCtx = document.getElementById('activityCanvas');
    if (activityCtx) {
        // TODO: Chart.js 초기화
        // new Chart(activityCtx, {
        //     type: 'line',
        //     data: { ... },
        //     options: { ... }
        // });
    }
});