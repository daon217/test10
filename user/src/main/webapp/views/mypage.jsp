<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mypage-container">
    <div class="mypage-wrapper">

        <div class="profile-header">
            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${not empty user.profileImage}">
                        <img src="<c:url value='${user.profileImage}'/>" alt="Profile">
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-user"></i>
                    </c:otherwise>
                </c:choose>
                <label class="profile-avatar-upload">
                    <i class="fas fa-camera"></i>
                    <input type="file" id="profileImageInput" accept="image/*" style="display: none;">
                </label>
            </div>

            <div class="profile-info">
                <h1 class="profile-name">${user.name}님</h1>
                <span class="profile-role">
                    <c:choose>
                        <c:when test="${user.role == 'OWNER'}">
                            <i class="fas fa-paw"></i> 반려인
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user"></i> 일반 사용자
                        </c:otherwise>
                    </c:choose>
                </span>

                <div class="profile-stats">
                    <div class="profile-stat-item">
                        <span class="profile-stat-label">가입일</span>
                        <span class="profile-stat-value">
                            ${not empty formattedCreatedAt ? formattedCreatedAt : '정보 없음'}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="mypage-tabs">
            <button class="mypage-tab active" onclick="showTab('info')">
                <i class="fas fa-user-circle"></i>
                <span>내 정보</span>
            </button>
            <button class="mypage-tab" onclick="showTab('pets')">
                <i class="fas fa-paw"></i>
                <span>반려동물</span>
            </button>
        </div>

        <div class="mypage-content">

            <div id="tab-info" class="tab-panel active">
                <h2 class="section-title">
                    <i class="fas fa-user-circle"></i>
                    개인정보 관리
                </h2>

                <div class="info-layout-grid">
                    <div class="info-card">
                        <h3 class="info-card-title">
                            <i class="fas fa-edit"></i>
                            기본 정보
                        </h3>
                        <form id="profileForm">
                            <div class="form-group-mypage">
                                <label>
                                    아이디
                                    <span class="badge badge-secondary">수정불가</span>
                                </label>
                                <input type="text" class="form-control-mypage readonly" value="${user.username}" readonly>
                            </div>
                            <div class="form-group-mypage">
                                <label>이름</label>
                                <input type="text" class="form-control-mypage" id="name" value="${user.name}" placeholder="이름">
                            </div>
                            <div class="form-group-mypage">
                                <label>이메일</label>
                                <input type="email" class="form-control-mypage" id="email" value="${user.email}" placeholder="example@email.com">
                            </div>
                            <div class="form-group-mypage">
                                <label>전화번호</label>
                                <input type="tel" class="form-control-mypage" id="phone" value="${user.phone}" placeholder="010-1234-5678">
                            </div>
                            <div class="button-group">
                                <button type="button" class="btn-mypage-secondary" onclick="resetForm()">
                                    <i class="fas fa-undo"></i> 취소
                                </button>
                                <button type="submit" class="btn-mypage-primary">
                                    <i class="fas fa-save"></i> 저장하기
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="info-card">
                        <h3 class="info-card-title">
                            <i class="fas fa-lock"></i>
                            비밀번호 변경
                        </h3>
                        <form id="passwordForm">
                            <div class="form-group-mypage">
                                <label>현재 비밀번호</label>
                                <div class="password-toggle-wrapper">
                                    <input type="password" class="form-control-mypage" id="currentPassword" placeholder="현재 비밀번호">
                                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('currentPassword')">
                                        <i class="fas fa-eye" id="currentPassword-icon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group-mypage">
                                <label>새 비밀번호</label>
                                <div class="password-toggle-wrapper">
                                    <input type="password" class="form-control-mypage" id="newPassword" placeholder="8자 이상, 영문+숫자+특수문자">
                                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('newPassword')">
                                        <i class="fas fa-eye" id="newPassword-icon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group-mypage">
                                <label>새 비밀번호 확인</label>
                                <div class="password-toggle-wrapper">
                                    <input type="password" class="form-control-mypage" id="confirmPassword" placeholder="새 비밀번호 다시 입력">
                                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('confirmPassword')">
                                        <i class="fas fa-eye" id="confirmPassword-icon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="button-group">
                                <button type="submit" class="btn-mypage-primary">
                                    <i class="fas fa-key"></i> 비밀번호 변경
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="info-card" style="grid-column: span 2;">
                        <h3 class="info-card-title">
                            <i class="fas fa-id-card-alt"></i>
                            이력서 관리
                        </h3>
                        <p style="color: #666; font-size: 0.9rem; margin-bottom: 15px;">
                            산책 메이트 및 돌봄 서비스 매칭 시 상대방에게 보여질 이력서를 관리합니다.<br>
                            나의 경력과 자격증, 소개글을 상세하게 작성해보세요.
                        </p>
                        <div style="background-color: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 15px; border: 1px solid #eee;">
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                                <i class="fas fa-check-circle" style="color: var(--point-color);"></i>
                                <span style="font-weight: bold; color: #333;">등록된 이력서가 있습니다.</span>
                            </div>
                            <div style="font-size: 0.85rem; color: #888; margin-left: 26px;">
                                최종 수정일: 2024.12.08
                            </div>
                        </div>
                        <div class="button-group" style="justify-content: flex-end;">
                            <button type="button" class="btn-mypage-primary" onclick="openResumeEditModal()">
                                <i class="fas fa-pen"></i> 이력서 수정하기
                            </button>
                        </div>
                    </div>

                </div>

                <div class="danger-zone">
                    <h3 class="danger-zone-title">
                        <i class="fas fa-exclamation-triangle"></i>
                        회원 탈퇴
                    </h3>
                    <p class="danger-zone-desc">
                        회원 탈퇴 시 모든 데이터가 삭제되며, 복구할 수 없습니다.<br>
                        신중하게 결정해주세요.
                    </p>
                    <button class="btn-danger-zone" onclick="withdrawAccount()">
                        <i class="fas fa-user-times"></i> 회원 탈퇴
                    </button>
                </div>
            </div>

            <div id="tab-pets" class="tab-panel">
                <h2 class="section-title">
                    <i class="fas fa-paw"></i>
                    반려동물 관리
                </h2>
                <c:if test="${empty pets}">
                    <div style="padding: 20px; background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; margin-bottom: 20px;">
                        <strong>디버깅:</strong> pets 변수가 비어있습니다. petCount = ${petCount}
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${user.role == 'OWNER'}">
                        <div class="pet-grid">
                            <c:forEach var="pet" items="${pets}">
                                <div class="pet-card">
                                    <div class="pet-card-photo">
                                        <c:choose>
                                            <c:when test="${not empty pet.photo}">
                                                <img src="<c:url value='${pet.photo}'/>" alt="${pet.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-paw"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h4 class="pet-card-name">${pet.name}</h4>
                                    <p class="pet-card-info">
                                        <c:choose>
                                            <c:when test="${pet.type == 'DOG'}">강아지</c:when>
                                            <c:when test="${pet.type == 'CAT'}">고양이</c:when>
                                            <c:otherwise>
                                                <c:if test="${not empty pet.customType}">${pet.customType}</c:if>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty pet.breed}"> · ${pet.breed}</c:if>
                                    </p>
                                    <p class="pet-card-info">${pet.age}살 · ${pet.weight}kg</p>
                                    <div class="pet-card-actions">
                                        <button class="btn-pet-edit" onclick="editPet(${pet.petId})">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button class="btn-pet-delete" onclick="deletePet(${pet.petId})">
                                            <i class="fas fa-trash"></i> 삭제
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                            <div class="pet-card pet-card-add" onclick="openAddPetModal()">
                                <i class="fas fa-plus-circle"></i>
                                <span>반려동물 추가하기</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-pet-notice">
                            <i class="fas fa-info-circle"></i>
                            <h3>반려동물 정보가 없습니다</h3>
                            <p>
                                현재 <span class="highlight">일반 사용자</span>로 가입되어 있습니다.<br>
                                반려동물을 키우고 계신다면, 반려동물 정보를 추가하여<br>
                                더 많은 서비스를 이용해보세요!
                            </p>
                            <button class="btn-mypage-primary" onclick="openAddPetModal()">
                                <i class="fas fa-paw mr-2"></i>
                                반려동물 추가하기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<div id="resumeEditModal" class="modal" onclick="closeResumeEditModal(event)" style="display:none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.5);">
    <div class="modal-content" style="background-color: #fff; margin: 5% auto; padding: 30px; border-radius: 20px; width: 90%; max-width: 600px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); position: relative;">
        <span class="close-modal" onclick="closeResumeEditModal(event)" style="position: absolute; top: 20px; right: 25px; font-size: 28px; cursor: pointer; color: #aaa;">&times;</span>

        <div style="text-align: center; border-bottom: 2px dashed #eee; padding-bottom: 20px; margin-bottom: 20px;">
            <div style="width: 80px; height: 80px; background-color: #FFF0F0; border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #FF6B6B;">
                <i class="fas fa-user-edit"></i>
            </div>
            <h3 style="font-weight: bold; color: #333;">이력서 수정</h3>
            <p style="color: #888; font-size: 0.9rem;">작성된 내용은 매칭 시 상대방에게 공개됩니다.</p>
        </div>

        <form id="resumeEditForm" onsubmit="saveResume(event)">
            <div style="margin-bottom: 20px;">
                <h4 style="font-size: 1.1rem; font-weight: bold; color: #333; border-left: 4px solid #4ECDC4; padding-left: 10px; margin-bottom: 15px;">
                    <i class="fas fa-info-circle"></i> 기본 정보
                </h4>
                <div class="form-group-mypage">
                    <label>나이 / 거주지</label>
                    <input type="text" class="form-control-mypage" value="24세 / 서울시 강남구" required>
                </div>
            </div>

            <div style="margin-bottom: 20px;">
                <h4 style="font-size: 1.1rem; font-weight: bold; color: #333; border-left: 4px solid #4ECDC4; padding-left: 10px; margin-bottom: 15px;">
                    <i class="fas fa-history"></i> 경력사항
                </h4>
                <div class="row" style="display: flex; gap: 10px; margin-bottom: 10px;">
                    <div style="flex: 1;">
                        <input type="text" class="form-control-mypage" value="반려견 산책" placeholder="활동명">
                    </div>
                    <div style="flex: 1;">
                        <input type="text" class="form-control-mypage" value="3회" placeholder="횟수/기간">
                    </div>
                </div>
                <div class="row" style="display: flex; gap: 10px;">
                    <div style="flex: 1;">
                        <input type="text" class="form-control-mypage" value="반려묘 미용" placeholder="활동명">
                    </div>
                    <div style="flex: 1;">
                        <input type="text" class="form-control-mypage" value="1회" placeholder="횟수/기간">
                    </div>
                </div>
            </div>

            <div style="margin-bottom: 20px;">
                <h4 style="font-size: 1.1rem; font-weight: bold; color: #333; border-left: 4px solid #4ECDC4; padding-left: 10px; margin-bottom: 15px;">
                    <i class="fas fa-certificate"></i> 자격증
                </h4>
                <input type="text" class="form-control-mypage" value="반려동물관리사 2급, 반려견스타일리스트 3급" placeholder=", 로 구분하여 입력">
                <p style="font-size: 0.8rem; color: #999; margin-top: 5px;">* 쉼표(,)로 구분하여 입력해주세요.</p>
            </div>

            <div style="margin-bottom: 20px;">
                <h4 style="font-size: 1.1rem; font-weight: bold; color: #333; border-left: 4px solid #4ECDC4; padding-left: 10px; margin-bottom: 15px;">
                    <i class="fas fa-comment-dots"></i> 한마디
                </h4>
                <textarea class="form-control-mypage" rows="4" style="resize: none;">강아지를 너무 좋아해서 시작하게 되었습니다.
내 가족처럼 책임감 있게, 사랑으로 돌봐드리겠습니다! 믿고 맡겨주세요 :)</textarea>
            </div>

            <button type="submit" class="modal-footer-btn" style="width: 100%; padding: 15px; background-color: #4ECDC4; color: white; border: none; border-radius: 12px; font-weight: bold; cursor: pointer; font-size: 1.1rem;">
                수정 완료
            </button>
        </form>
    </div>
</div>

<script src="<c:url value='/js/mypage.js'/>"></script>
<script>
    // [추가] 이력서 수정 모달 스크립트
    function openResumeEditModal() {
        document.getElementById("resumeEditModal").style.display = "block";
    }

    function closeResumeEditModal(event) {
        if (event.target.id === "resumeEditModal" || event.target.classList.contains("close-modal")) {
            document.getElementById("resumeEditModal").style.display = "none";
        }
    }

    function saveResume(event) {
        event.preventDefault(); // 폼 제출 방지

        // 여기에 실제 저장 로직(AJAX 등)이 들어가야 하지만,
        // 요구사항대로 수정되는 척만 하기 위해 알림창만 띄우고 모달을 닫습니다.

        // SweetAlert2가 있다면 더 예쁘게 띄울 수 있음
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                icon: 'success',
                title: '이력서 수정 완료',
                text: '이력서 정보가 성공적으로 수정되었습니다.',
                confirmButtonColor: '#4ECDC4'
            }).then(() => {
                document.getElementById("resumeEditModal").style.display = "none";
            });
        } else {
            alert("이력서가 성공적으로 수정되었습니다.");
            document.getElementById("resumeEditModal").style.display = "none";
        }
    }
</script>