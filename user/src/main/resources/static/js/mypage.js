// ============================================
// 마이페이지 전용 JavaScript
// ============================================

// ========== 탭 전환 ==========
function showTab(tabName) {
    document.querySelectorAll('.tab-panel').forEach(panel => {
        panel.classList.remove('active');
    });
    document.querySelectorAll('.mypage-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    document.getElementById('tab-' + tabName).classList.add('active');
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

            fetch('/mypage/profile', {
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

            fetch('/mypage/password', {
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

        fetch('/mypage/profile-image', {
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

        fetch('/mypage/withdraw', {
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

// ========== 반려동물 추가 모달 ==========
function openAddPetModal() {
    $('#addPetModal').modal('show');

    // 폼 초기화
    document.getElementById('addPetForm').reset();
    document.getElementById('petPhotoPreview').innerHTML = '<i class="fas fa-camera" style="font-size: 2rem; color: #adb5bd;"></i>';
}

// 사진 미리보기
document.addEventListener('DOMContentLoaded', function() {
    const petImageInput = document.getElementById('petImage');
    if (petImageInput) {
        petImageInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('petPhotoPreview').innerHTML =
                            `<img src="${e.target.result}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">`;
                };
                reader.readAsDataURL(file);
            }
        });
    }
});

// ========== 반려동물 추가 제출 ==========
function submitAddPet() {
    const form = document.getElementById('addPetForm');

    if (!form.checkValidity()) {
        alert('필수 항목을 모두 입력해주세요.');
        return;
    }

    const formData = new FormData(form);

    fetch('/mypage/add-pet', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('반려동물이 추가되었습니다.');
                    $('#addPetModal').modal('hide');
                    location.reload();
                } else {
                    alert('추가에 실패했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
}

// ========== 모달용 사진 미리보기 ==========
function previewModalPetPhoto(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('modal-pet-photo-preview').innerHTML =
                    '<img src="' + e.target.result + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ========== 모달용 기타 동물 입력 토글 ==========
function toggleModalCustomPetType() {
    const petType = document.getElementById('modalPetType').value;
    const customInput = document.getElementById('modalCustomPetType');

    if (petType === 'ETC') {
        customInput.style.display = 'block';
        customInput.required = true;
    } else {
        customInput.style.display = 'none';
        customInput.required = false;
        customInput.value = '';
    }
}

// ========== 반려동물 수정 모달 열기 ==========
function editPet(petId) {
    fetch('/mypage/pet/' + petId, {
        method: 'GET'
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const pet = data.pet;

                    // 폼에 데이터 채우기
                    document.getElementById('editPetId').value = pet.petId;
                    document.getElementById('editPetName').value = pet.name;
                    document.getElementById('editPetType').value = pet.type;
                    document.getElementById('editPetBreed').value = pet.breed || '';
                    document.getElementById('editPetGender').value = pet.gender;
                    document.getElementById('editPetAge').value = pet.age;
                    document.getElementById('editPetWeight').value = pet.weight;

                    // 기타 동물이면 커스텀 입력 표시
                    if (pet.type === 'ETC') {
                        document.getElementById('editCustomPetType').value = pet.customType || '';
                        document.getElementById('editCustomPetType').style.display = 'block';
                    }

                    // 사진 미리보기
                    if (pet.photo) {
                        document.getElementById('edit-pet-photo-preview').innerHTML =
                                '<img src="' + pet.photo + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
                    } else {
                        document.getElementById('edit-pet-photo-preview').innerHTML = '<i class="fas fa-camera"></i>';
                    }

                    $('#editPetModal').modal('show');
                } else {
                    alert('반려동물 정보를 불러오는데 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
}

// ========== 수정 모달용 사진 미리보기 ==========
function previewEditPetPhoto(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('edit-pet-photo-preview').innerHTML =
                    '<img src="' + e.target.result + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ========== 수정 모달용 기타 동물 입력 토글 ==========
function toggleEditCustomPetType() {
    const petType = document.getElementById('editPetType').value;
    const customInput = document.getElementById('editCustomPetType');

    if (petType === 'ETC') {
        customInput.style.display = 'block';
        customInput.required = true;
    } else {
        customInput.style.display = 'none';
        customInput.required = false;
        customInput.value = '';
    }
}

// ========== 반려동물 수정 제출 ==========
function submitEditPet() {
    const form = document.getElementById('editPetForm');

    if (!form.checkValidity()) {
        alert('필수 항목을 모두 입력해주세요.');
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);

    fetch('/mypage/update-pet', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('수정되었습니다.');
                    $('#editPetModal').modal('hide');
                    location.reload();
                } else {
                    alert('수정에 실패했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
}

// ========== 반려동물 삭제 ==========
function deletePet(petId) {
    if (confirm('이 반려동물 정보를 삭제하시겠습니까?')) {
        fetch('/mypage/delete-pet/' + petId, {
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

// ========== 다이어리 필터링 ==========
document.addEventListener('DOMContentLoaded', function() {
    const filterTags = document.querySelectorAll('.filter-tag');
    filterTags.forEach(tag => {
        tag.addEventListener('click', function() {
            filterTags.forEach(t => t.classList.remove('active'));
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

function changeView(viewType) {
    const buttons = document.querySelectorAll('.view-options .btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');
    console.log('뷰 전환:', viewType);
}

function openAddMemoModal(dateStr) {
    const memo = prompt('메모를 입력하세요:' + (dateStr ? '\n날짜: ' + dateStr : ''));
    if (memo) {
        alert('메모가 저장되었습니다: ' + memo);
    }
}

function loadMoreDiary() {
    alert('더 많은 다이어리를 불러옵니다.');
}

// ========== FullCalendar 초기화 ==========
document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('diary-calendar-container');

    if (calendarEl && typeof FullCalendar !== 'undefined') {
        calendarEl.innerHTML = '';

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: 'auto',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,listWeek'
            },
            buttonText: {
                today: '오늘',
                month: '월',
                week: '주',
                list: '목록'
            },

            events: [
                {
                    title: '한강공원 산책',
                    start: '2024-12-02',
                    backgroundColor: '#FF6B6B'
                },
                {
                    title: '홈캠 이벤트',
                    start: '2024-12-02',
                    backgroundColor: '#FFD43B'
                },
                {
                    title: '동물병원 방문',
                    start: '2024-11-30',
                    backgroundColor: '#4ECDC4'
                },
                {
                    title: '🎂 생일 축하!',
                    start: '2024-11-25',
                    backgroundColor: '#FF6B6B'
                }
            ],

            eventClick: function(info) {
                alert('이벤트: ' + info.event.title + '\n날짜: ' + info.event.startStr);
            },

            dateClick: function(info) {
                openAddMemoModal(info.dateStr);
            }
        });

        calendar.render();
    }
});

// ========== 행동 리포트 ==========
function changeReportPeriod(period) {
    const buttons = document.querySelectorAll('.report-controls .btn-group .btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');
    console.log('리포트 기간:', period);
}

function generateReport() {
    if (confirm('최신 데이터로 리포트를 생성하시겠습니까?')) {
        alert('리포트를 생성하고 있습니다...');
    }
}

// ========== Chart.js 초기화 ==========
document.addEventListener('DOMContentLoaded', function() {
    const activityCtx = document.getElementById('activityCanvas');
    if (activityCtx && typeof Chart !== 'undefined') {
        new Chart(activityCtx, {
            type: 'line',
            data: {
                labels: ['월', '화', '수', '목', '금', '토', '일'],
                datasets: [{
                    label: '활동량 (분)',
                    data: [30, 45, 40, 50, 35, 60, 55],
                    borderColor: '#FF6B6B',
                    backgroundColor: 'rgba(255, 107, 107, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
});