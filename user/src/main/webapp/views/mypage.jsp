<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                        <span class="profile-stat-value">
                            ${not empty formattedCreatedAt ? formattedCreatedAt : '정보 없음'}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 탭 네비게이션 -->
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

        <!-- 탭 콘텐츠 -->
        <div class="mypage-content">

            <!-- ========== 탭 1: 내 정보 ========== -->
            <div id="tab-info" class="tab-panel active">
                <h2 class="section-title">
                    <i class="fas fa-user-circle"></i>
                    개인정보 관리
                </h2>

                <div class="info-layout-grid">
                    <!-- 왼쪽: 기본 정보 -->
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
                </div>

                <!-- 회원 탈퇴 섹션 -->
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

            <!-- ========== 탭 2: 반려동물 ========== -->
            <div id="tab-pets" class="tab-panel">
                <h2 class="section-title">
                    <i class="fas fa-paw"></i>
                    반려동물 관리
                </h2>

                <!-- ✅ 디버깅: pets 변수 확인 -->
                <c:if test="${empty pets}">
                    <div style="padding: 20px; background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; margin-bottom: 20px;">
                        <strong>디버깅:</strong> pets 변수가 비어있습니다. petCount = ${petCount}
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${user.role == 'OWNER'}">
                        <!-- 반려인용: 반려동물 카드 그리드 -->
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

                                    <!-- ✅ type 필드 사용 + 한글 변환 -->
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
                                        <!-- ✅ pet.id → pet.petId -->
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
                            <div class="pet-card pet-card-add" onclick="openAddPetModal()">
                                <i class="fas fa-plus-circle"></i>
                                <span>반려동물 추가하기</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- 일반 사용자용: 안내 메시지 -->
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

<!-- 반려동물 추가 모달 -->
<div class="modal fade" id="addPetModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content" style="border-radius: 1rem; border: none;">
            <div class="modal-header" style="background: linear-gradient(135deg, #FF6B6B, #FA5252); color: white; border-radius: 1rem 1rem 0 0;">
                <h5 class="modal-title">
                    <i class="fas fa-paw mr-2"></i>
                    반려동물 추가하기
                </h5>
                <button type="button" class="close" data-dismiss="modal" style="color: white;">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body" style="padding: 2rem;">
                <form id="addPetForm" enctype="multipart/form-data">
                    <!-- 사진 업로드 -->
                    <div class="text-center mb-4">
                        <div style="width: 120px; height: 120px; margin: 0 auto; position: relative;">
                            <div id="petPhotoPreview" style="width: 100%; height: 100%; border-radius: 50%; background: #f8f9fa; display: flex; align-items: center; justify-content: center; border: 3px dashed #dee2e6; overflow: hidden;">
                                <i class="fas fa-camera" style="font-size: 2rem; color: #adb5bd;"></i>
                            </div>
                            <label for="petImage" style="position: absolute; bottom: 0; right: 0; width: 40px; height: 40px; background: #FF6B6B; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">
                                <i class="fas fa-plus"></i>
                            </label>
                            <input type="file" id="petImage" name="petImage" accept="image/*" hidden>
                        </div>
                        <p class="text-muted mt-2" style="font-size: 0.9rem;">프로필 사진 (선택)</p>
                    </div>

                    <div class="row">
                        <!-- 이름 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-font mr-1"></i> 이름 <span style="color: #dc3545;">*</span></label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                        </div>

                        <!-- 종류 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-paw mr-1"></i> 종류 <span style="color: #dc3545;">*</span></label>
                                <select class="form-control" name="type" id="petTypeSelect" required>
                                    <option value="">선택하세요</option>
                                    <option value="DOG">강아지</option>
                                    <option value="CAT">고양이</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>
                        </div>

                        <!-- 품종 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-list mr-1"></i> 품종</label>
                                <input type="text" class="form-control" name="breed" placeholder="예: 포메라니안">
                            </div>
                        </div>

                        <!-- 성별 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-venus-mars mr-1"></i> 성별 <span style="color: #dc3545;">*</span></label>
                                <select class="form-control" name="gender" required>
                                    <option value="">선택하세요</option>
                                    <option value="MALE">수컷</option>
                                    <option value="FEMALE">암컷</option>
                                </select>
                            </div>
                        </div>

                        <!-- 나이 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-birthday-cake mr-1"></i> 나이 <span style="color: #dc3545;">*</span></label>
                                <input type="number" class="form-control" name="age" min="0" max="30" required>
                            </div>
                        </div>

                        <!-- 몸무게 -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fas fa-weight mr-1"></i> 몸무게 (kg) <span style="color: #dc3545;">*</span></label>
                                <input type="number" class="form-control" name="weight" step="0.1" min="0" required>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="border: none; padding: 1rem 2rem 2rem;">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-pet-primary" onclick="submitAddPet()">
                    <i class="fas fa-check mr-2"></i>
                    추가하기
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ========== 반려동물 수정 모달 (회원가입 스타일) ========== -->
<div class="modal fade" id="editPetModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content" style="border-radius: 1.5rem; border: none;">
            <div class="modal-header" style="border-bottom: 2px solid #e9ecef; padding: 1.5rem 2rem;">
                <h5 class="modal-title" style="font-size: 1.25rem; font-weight: 700; color: #212529;">
                    <i class="fas fa-edit mr-2" style="color: #FF6B6B;"></i>
                    반려동물 정보 수정
                </h5>
                <button type="button" class="close" data-dismiss="modal" style="font-size: 1.5rem; opacity: 0.5;">
                    <span>&times;</span>
                </button>
            </div>

            <div class="modal-body" style="padding: 2rem;">
                <form id="editPetForm">
                    <input type="hidden" id="editPetId" name="id">

                    <div class="pet-form-card">
                        <!-- 사진 업로드 -->
                        <div class="pet-photo-section">
                            <div class="pet-photo-wrapper">
                                <div class="pet-photo-preview" id="edit-pet-photo-preview">
                                    <i class="fas fa-camera"></i>
                                </div>
                                <label for="editPetPhoto" class="pet-photo-btn">
                                    <i class="fas fa-edit"></i>
                                </label>
                                <input type="file" id="editPetPhoto" name="petPhoto" accept="image/*"
                                       onchange="previewEditPetPhoto(this)" hidden>
                            </div>
                            <p class="pet-photo-guide">새 사진을 선택하지 않으면 기존 사진이 유지됩니다</p>
                        </div>

                        <!-- 2열 레이아웃 -->
                        <div class="form-row-group">
                            <div class="form-group">
                                <label><i class="fas fa-font mr-1"></i> 이름 <span class="required">*</span></label>
                                <input type="text" class="form-control-auth" id="editPetName" name="petName" required>
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-paw mr-1"></i> 종류 <span class="required">*</span></label>
                                <select class="form-control-auth" id="editPetType" name="petType"
                                        onchange="toggleEditCustomPetType()" required>
                                    <option value="">선택하세요</option>
                                    <option value="DOG">강아지</option>
                                    <option value="CAT">고양이</option>
                                    <option value="ETC">기타 (직접 입력)</option>
                                </select>
                                <input type="text" class="form-control-auth mt-2" id="editCustomPetType" name="customPetType"
                                       placeholder="어떤 동물을 키우시나요?" style="display: none;" maxlength="20">
                            </div>
                        </div>

                        <div class="form-row-group">
                            <div class="form-group">
                                <label><i class="fas fa-dna mr-1"></i> 품종</label>
                                <input type="text" class="form-control-auth" id="editPetBreed" name="petBreed">
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-venus-mars mr-1"></i> 성별 <span class="required">*</span></label>
                                <select class="form-control-auth" id="editPetGender" name="petGender" required>
                                    <option value="">선택하세요</option>
                                    <option value="MALE">수컷</option>
                                    <option value="FEMALE">암컷</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row-group">
                            <div class="form-group">
                                <label><i class="fas fa-birthday-cake mr-1"></i> 나이 <span class="required">*</span></label>
                                <input type="number" class="form-control-auth" id="editPetAge" name="petAge" min="0" max="30" required>
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-weight mr-1"></i> 몸무게 <span class="required">*</span></label>
                                <input type="number" class="form-control-auth" id="editPetWeight" name="petWeight" step="0.1" min="0" required>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer" style="border-top: 2px solid #e9ecef; padding: 1rem 2rem;">
                <button type="button" class="btn btn-outline-secondary" data-dismiss="modal"
                        style="height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                    <i class="fas fa-times mr-2"></i> 취소
                </button>
                <button type="button" class="btn btn-primary" onclick="submitEditPet()"
                        style="background: linear-gradient(135deg, #FF6B6B, #FA5252); border: none; height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                    <i class="fas fa-save mr-2"></i> 저장하기
                </button>
            </div>
        </div>
    </div>
</div>

<script src="<c:url value='/js/mypage.js'/>"></script>
