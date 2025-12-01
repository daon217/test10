<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- 마이페이지 추가 스타일 -->
        <style>
            /* 2단 그리드 레이아웃 */
            .info-layout-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .info-card {
                background: white;
                border: 2px solid #e9ecef;
                border-radius: 1.25rem;
                padding: 2rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }

            .info-card:hover {
                border-color: #FF6B6B;
                box-shadow: 0 8px 24px rgba(255, 107, 107, 0.15);
            }

            .info-card-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: #212529;
                margin-bottom: 1.5rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid #e9ecef;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .info-card-title i {
                color: #FF6B6B;
            }

            /* ✅ 일반 사용자용 안내 메시지 */
            .empty-pet-notice {
                text-align: center;
                padding: 3rem 2rem;
                background: linear-gradient(135deg, #FFE3E3 0%, #E3FFF9 100%);
                border-radius: 1.25rem;
                margin-bottom: 2rem;
            }

            .empty-pet-notice i {
                font-size: 4rem;
                color: #FF6B6B;
                margin-bottom: 1.5rem;
                opacity: 0.8;
            }

            .empty-pet-notice h3 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #212529;
                margin-bottom: 1rem;
            }

            .empty-pet-notice p {
                color: #6c757d;
                font-size: 1.05rem;
                line-height: 1.6;
                margin-bottom: 2rem;
            }

            .empty-pet-notice .highlight {
                color: #FF6B6B;
                font-weight: 600;
            }

            /* 반응형 */
            @media (max-width: 768px) {
                .info-layout-grid {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }
            }
        </style>

        <!-- 마이페이지 컨테이너 -->
        <div class="mypage-container">
            <div class="mypage-wrapper">

                <!-- 프로필 헤더 -->
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
                                <span class="profile-stat-value">${user.formattedJoinDateKorean}</span>
                            </div>
                            <c:if test="${user.role == 'OWNER'}">
                                <div class="profile-stat-item">
                                    <span class="profile-stat-label">반려동물</span>
                                    <span class="profile-stat-value">${petCount}마리</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- 탭 네비게이션 (✅ 일반 사용자도 반려동물 탭 표시) -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" onclick="showTab('info')">
                        <i class="fas fa-user-circle"></i>
                        <span>내 정보</span>
                    </button>
                    <!-- ✅ 모든 사용자에게 반려동물 탭 표시 -->
                    <button class="mypage-tab" onclick="showTab('pets')">
                        <i class="fas fa-paw"></i>
                        <span>반려동물</span>
                    </button>
                </div>

                <!-- 탭 콘텐츠 -->
                <div class="mypage-content">

                    <!-- ========== 탭 1: 내 정보 ========== -->
                    <div id="tab-info" class="tab-panel active">
                        <h2 class="section-title">
                            <i class="fas fa-user-circle"></i>
                            개인정보 관리
                        </h2>

                        <!-- 2단 레이아웃 -->
                        <div class="info-layout-grid">
                            <!-- 왼쪽: 개인정보 수정 -->
                            <div class="info-card">
                                <h3 class="info-card-title">
                                    <i class="fas fa-edit"></i>
                                    기본 정보
                                </h3>

                                <form id="profileForm">
                                    <!-- 아이디 (수정 불가) -->
                                    <div class="form-group-mypage">
                                        <label>
                                            아이디
                                            <span class="badge badge-secondary">수정불가</span>
                                        </label>
                                        <input type="text" class="form-control-mypage readonly" value="${user.username}"
                                            readonly>
                                    </div>

                                    <!-- 이름 -->
                                    <div class="form-group-mypage">
                                        <label>이름</label>
                                        <input type="text" class="form-control-mypage" id="name" value="${user.name}"
                                            placeholder="이름">
                                    </div>

                                    <!-- 이메일 -->
                                    <div class="form-group-mypage">
                                        <label>이메일</label>
                                        <input type="email" class="form-control-mypage" id="email" value="${user.email}"
                                            placeholder="example@email.com">
                                    </div>

                                    <!-- 전화번호 -->
                                    <div class="form-group-mypage">
                                        <label>전화번호</label>
                                        <input type="tel" class="form-control-mypage" id="phone" value="${user.phone}"
                                            placeholder="010-1234-5678">
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

                            <!-- 오른쪽: 비밀번호 변경 -->
                            <div class="info-card">
                                <h3 class="info-card-title">
                                    <i class="fas fa-lock"></i>
                                    비밀번호 변경
                                </h3>

                                <form id="passwordForm">
                                    <div class="form-group-mypage">
                                        <label>현재 비밀번호</label>
                                        <div class="password-toggle-wrapper">
                                            <input type="password" class="form-control-mypage" id="currentPassword"
                                                placeholder="현재 비밀번호">
                                            <button type="button" class="password-toggle-btn"
                                                onclick="togglePasswordVisibility('currentPassword')">
                                                <i class="fas fa-eye" id="currentPassword-icon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-group-mypage">
                                        <label>새 비밀번호</label>
                                        <div class="password-toggle-wrapper">
                                            <input type="password" class="form-control-mypage" id="newPassword"
                                                placeholder="8자 이상, 영문+숫자+특수문자">
                                            <button type="button" class="password-toggle-btn"
                                                onclick="togglePasswordVisibility('newPassword')">
                                                <i class="fas fa-eye" id="newPassword-icon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-group-mypage">
                                        <label>새 비밀번호 확인</label>
                                        <div class="password-toggle-wrapper">
                                            <input type="password" class="form-control-mypage" id="confirmPassword"
                                                placeholder="새 비밀번호 다시 입력">
                                            <button type="button" class="password-toggle-btn"
                                                onclick="togglePasswordVisibility('confirmPassword')">
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
                        </div>

                        <!-- 회원 탈퇴 -->
                        <div class="danger-zone">
                            <h3 class="danger-zone-title">
                                <i class="fas fa-exclamation-triangle"></i>
                                회원 탈퇴
                            </h3>
                            <p class="danger-zone-desc">
                                회원 탈퇴 시 모든 데이터가 영구 삭제되며 복구할 수 없습니다.<br>
                                반려동물 정보, 산책 기록, 다이어리 등 모든 정보가 삭제됩니다.
                            </p>
                            <button type="button" class="btn-danger-zone" onclick="showDeleteModal()">
                                <i class="fas fa-user-times"></i> 회원 탈퇴하기
                            </button>
                        </div>
                    </div>

                    <!-- ========== 탭 2: 반려동물 (✅ 모든 사용자에게 표시) ========== -->
                    <div id="tab-pets" class="tab-panel">
                        <h2 class="section-title">
                            <i class="fas fa-paw"></i>
                            내 반려동물 관리
                        </h2>

                        <!-- ✅ 일반 사용자용 안내 메시지 -->
                        <c:if test="${user.role == 'GENERAL' && (empty pets || petCount == 0)}">
                            <div class="empty-pet-notice">
                                <i class="fas fa-paw"></i>
                                <h3>반려동물을 등록하고 반려인이 되어보세요!</h3>
                                <p>
                                    반려동물 정보를 등록하시면 <span class="highlight">자동으로 반려인 계정으로 전환</span>되며,<br>
                                    다양한 반려인 전용 서비스를 이용하실 수 있습니다.
                                </p>
                                <ul
                                    style="text-align: left; display: inline-block; margin: 0 auto 2rem; color: #495057;">
                                    <li style="margin-bottom: 0.5rem;">✅ AI 기반 산책 추천 및 기록</li>
                                    <li style="margin-bottom: 0.5rem;">✅ 반려동물 건강 관리 및 다이어리</li>
                                    <li style="margin-bottom: 0.5rem;">✅ 홈캠 분석 및 행동 리포트</li>
                                    <li style="margin-bottom: 0.5rem;">✅ 산책 알바 매칭 서비스</li>
                                </ul>
                                <button class="btn-mypage-primary" onclick="showAddPetModal()"
                                    style="font-size: 1.1rem; padding: 1rem 2rem;">
                                    <i class="fas fa-plus-circle mr-2"></i>
                                    첫 번째 반려동물 등록하기
                                </button>
                            </div>
                        </c:if>

                        <!-- ✅ 반려인이거나 반려동물이 있는 경우 -->
                        <c:if test="${user.role == 'OWNER' || (not empty pets && petCount > 0)}">
                            <div class="pet-grid">
                                <!-- 등록된 반려동물 카드 -->
                                <c:forEach items="${pets}" var="pet">
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
                                        <h3 class="pet-card-name">${pet.name}</h3>
                                        <p class="pet-card-info">
                                            <i class="fas fa-dog"></i>
                                            <c:choose>
                                                <c:when test="${pet.type == 'ETC' && not empty pet.customType}">
                                                    ${pet.customType}
                                                </c:when>
                                                <c:when test="${pet.type == 'DOG'}">강아지</c:when>
                                                <c:when test="${pet.type == 'CAT'}">고양이</c:when>
                                                <c:otherwise>${pet.type}</c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty pet.breed}">/ ${pet.breed}</c:if>
                                        </p>
                                        <p class="pet-card-info">
                                            <i class="fas fa-birthday-cake"></i> ${pet.age}살 /
                                            <i class="fas fa-weight"></i> ${pet.weight}kg
                                        </p>
                                        <p class="pet-card-info">
                                            <i class="fas fa-${pet.gender == 'MALE' ? 'mars' : 'venus'}"></i>
                                            ${pet.gender == 'MALE' ? '수컷' : '암컷'}
                                        </p>
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

                                <!-- 반려동물 추가 카드 -->
                                <div class="pet-card pet-card-add" onclick="showAddPetModal()">
                                    <i class="fas fa-plus-circle"></i>
                                    <span>반려동물 추가</span>
                                </div>
                            </div>
                        </c:if>
                    </div>

                </div>
            </div>
        </div>

        <!-- 회원 탈퇴 확인 모달 -->
        <div id="deleteModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
                        정말 탈퇴하시겠습니까?
                    </h3>
                    <button class="modal-close" onclick="closeDeleteModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <p style="color: #6c757d; margin-bottom: 1.5rem;">
                        회원 탈퇴 시 모든 데이터가 <strong style="color: #dc3545;">영구 삭제</strong>되며 복구할 수 없습니다.
                    </p>
                    <div class="form-group-mypage">
                        <label>비밀번호를 입력하여 본인 확인</label>
                        <input type="password" class="form-control-mypage" id="deleteConfirmPassword"
                            placeholder="비밀번호 입력">
                    </div>
                    <div class="form-group-mypage">
                        <label>
                            <input type="checkbox" id="deleteConfirm" style="margin-right: 0.5rem;">
                            위 내용을 확인했으며 탈퇴에 동의합니다
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-mypage-secondary" onclick="closeDeleteModal()">
                        취소
                    </button>
                    <button class="btn-danger-zone" onclick="confirmDelete()">
                        탈퇴하기
                    </button>
                </div>
            </div>
        </div>

        <!-- 반려동물 추가/수정 모달 -->
        <div id="petModal" class="modal-overlay">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header">
                    <h3 class="modal-title" id="petModalTitle">
                        <i class="fas fa-paw"></i>
                        반려동물 추가
                    </h3>
                    <button class="modal-close" onclick="closePetModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="petForm">
                        <input type="hidden" id="petId">

                        <div class="form-group-mypage">
                            <label>프로필 사진</label>
                            <div class="pet-photo-upload-wrapper" style="text-align: center; margin-bottom: 1rem;">
                                <img id="petPhotoPreview" src="" alt="Preview"
                                    style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; display: none; margin: 0 auto 10px; border: 2px solid #e9ecef;">
                                <input type="file" class="form-control-mypage" id="petImage" accept="image/*"
                                    onchange="previewPetPhoto(this)">
                            </div>
                        </div>

                        <div class="form-group-mypage">
                            <label>이름 <span style="color: #dc3545;">*</span></label>
                            <input type="text" class="form-control-mypage" id="petName" placeholder="반려동물 이름" required>
                        </div>

                        <div class="form-row-2">
                            <div class="form-group-mypage">
                                <label>종류 <span style="color: #dc3545;">*</span></label>
                                <select class="form-control-mypage" id="petType" required>
                                    <option value="">선택하세요</option>
                                    <option value="DOG">강아지</option>
                                    <option value="CAT">고양이</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>

                            <div class="form-group-mypage">
                                <label>품종</label>
                                <input type="text" class="form-control-mypage" id="petBreed" placeholder="예: 골든 리트리버">
                            </div>
                        </div>

                        <div class="form-row-2">
                            <div class="form-group-mypage">
                                <label>성별 <span style="color: #dc3545;">*</span></label>
                                <select class="form-control-mypage" id="petGender" required>
                                    <option value="">선택하세요</option>
                                    <option value="MALE">수컷</option>
                                    <option value="FEMALE">암컷</option>
                                </select>
                            </div>

                            <div class="form-group-mypage">
                                <label>나이 <span style="color: #dc3545;">*</span></label>
                                <input type="number" class="form-control-mypage" id="petAge" placeholder="나이 (년)"
                                    min="0" max="30" required>
                            </div>
                        </div>

                        <div class="form-group-mypage">
                            <label>몸무게 (kg) <span style="color: #dc3545;">*</span></label>
                            <input type="number" class="form-control-mypage" id="petWeight" placeholder="몸무게" step="0.1"
                                min="0" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="btn-mypage-secondary" onclick="closePetModal()">
                        취소
                    </button>
                    <button class="btn-mypage-primary" onclick="savePet()">
                        <i class="fas fa-save"></i> 저장
                    </button>
                </div>
            </div>
        </div>

        <!-- 외부 JavaScript 파일 로드 -->
        <script src="<c:url value='/js/mypage.js'/>"></script>