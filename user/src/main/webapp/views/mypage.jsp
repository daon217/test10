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
                        <span class="profile-stat-value">${user.createdAt}</span>
                    </div>
                    <div class="profile-stat-item">
                        <span class="profile-stat-label">활동</span>
                        <span class="profile-stat-value">247일</span> <%-- 실제 활동 데이터 출력 필요 --%>
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
            <button class="mypage-tab" onclick="showTab('diary')">
                <i class="fas fa-book"></i>
                <span>펫 다이어리</span>
            </button>
            <button class="mypage-tab" onclick="showTab('report')">
                <i class="fas fa-chart-line"></i>
                <span>행동 리포트</span>
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
                                    <p class="pet-card-info">${pet.species} · ${pet.breed}</p>
                                    <p class="pet-card-info">${pet.age}살 · ${pet.weight}kg</p>
                                    <div class="pet-card-actions">
                                        <button class="btn-pet-edit" onclick="editPet(${pet.id})">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button class="btn-pet-delete" onclick="deletePet(${pet.id})">
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

            <!-- ========== 탭 3: 펫 다이어리 ========== -->
            <!-- ========== 탭 3: 펫 다이어리 (자동 통합) ========== -->
            <div id="tab-diary" class="tab-panel">
                <h2 class="section-title">
                    <i class="fas fa-book"></i>
                    펫 다이어리
                </h2>

                <!-- 안내 메시지 -->
                <div class="alert alert-info mb-4">
                    <i class="fas fa-info-circle mr-2"></i>
                    <strong>자동 기록 시스템:</strong> 산책, 홈캠 이벤트, 건강 체크 등 모든 활동이 자동으로 다이어리에 저장됩니다.
                </div>

                <!-- 다이어리 요약 통계 -->
                <div class="diary-summary-section mb-4">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #9775FA, #7950F2);">
                                    <i class="fas fa-book-open"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>총 기록</h4>
                                    <p class="stat-number">156개</p>
                                    <span class="stat-detail">전체 활동</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #FF6B6B, #FA5252);">
                                    <i class="fas fa-walking"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>산책 기록</h4>
                                    <p class="stat-number">89회</p>
                                    <span class="stat-detail">자동 저장</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #4ECDC4, #38D9A9);">
                                    <i class="fas fa-video"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>홈캠 이벤트</h4>
                                    <p class="stat-number">43건</p>
                                    <span class="stat-detail">자동 감지</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #FFD43B, #FF922B);">
                                    <i class="fas fa-camera"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>사진/영상</h4>
                                    <p class="stat-number">342장</p>
                                    <span class="stat-detail">수동 + 자동</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 필터 및 검색 -->
                <div class="diary-filters mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="filter-tags">
                            <button class="filter-tag active" data-tag="all">
                                <i class="fas fa-list"></i> 전체
                            </button>
                            <button class="filter-tag" data-tag="walk">
                                <i class="fas fa-walking"></i> 산책
                            </button>
                            <button class="filter-tag" data-tag="health">
                                <i class="fas fa-heartbeat"></i> 건강
                            </button>
                            <button class="filter-tag" data-tag="homecam">
                                <i class="fas fa-video"></i> 홈캠
                            </button>
                            <button class="filter-tag" data-tag="memo">
                                <i class="fas fa-pen"></i> 메모
                            </button>
                            <button class="filter-tag" data-tag="special">
                                <i class="fas fa-star"></i> 기념일
                            </button>
                        </div>
                        <button class="btn btn-pet-primary" onclick="openAddMemoModal()">
                            <i class="fas fa-plus-circle mr-2"></i>
                            메모 추가하기
                        </button>
                    </div>
                </div>

                <!-- 다이어리 캘린더 (FullCalendar) -->
                <div class="info-card mb-4">
                    <h3 class="info-card-title">
                        <i class="fas fa-calendar-alt"></i>
                        통합 타임라인 캘린더
                    </h3>
                    <div id="diary-calendar-container" style="min-height: 600px;">
                        <!-- FullCalendar가 여기에 렌더링됨 -->
                        <div class="text-center py-5">
                            <i class="fas fa-spinner fa-spin fa-3x text-primary mb-3"></i>
                            <p class="text-muted">캘린더를 불러오는 중...</p>
                        </div>
                    </div>
                </div>

                <!-- 최근 활동 타임라인 -->
                <div class="info-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3 class="info-card-title mb-0">
                            <i class="fas fa-clock"></i>
                            최근 활동 내역
                        </h3>
                        <div class="view-options">
                            <button class="btn btn-sm btn-pet-outline" onclick="changeView('timeline')">
                                <i class="fas fa-stream"></i> 타임라인
                            </button>
                            <button class="btn btn-sm btn-pet-outline active" onclick="changeView('list')">
                                <i class="fas fa-list"></i> 리스트
                            </button>
                        </div>
                    </div>

                    <div class="diary-timeline" id="diaryTimeline">
                        <!-- 자동 기록: 산책 -->
                        <div class="diary-item" data-type="walk">
                            <div class="diary-item-icon">
                                <i class="fas fa-walking"></i>
                            </div>
                            <div class="diary-item-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="diary-item-title">
                                            한강공원 산책
                                            <span class="badge badge-primary ml-2">자동</span>
                                        </h5>
                                        <p class="diary-item-date">
                                            <i class="fas fa-calendar"></i> 2024년 12월 2일 오후 3:20
                                        </p>
                                    </div>
                                    <span class="badge badge-success">산책</span>
                                </div>
                                <p class="diary-item-preview">
                                    오늘 산책을 완료했습니다. 날씨가 좋았어요! 🐕
                                </p>
                                <div class="diary-item-meta">
                                    <span><i class="fas fa-route"></i> 2.3km</span>
                                    <span><i class="fas fa-clock"></i> 45분</span>
                                    <span><i class="fas fa-image"></i> 사진 5장</span>
                                </div>
                            </div>
                        </div>

                        <!-- 자동 기록: 홈캠 이벤트 -->
                        <div class="diary-item" data-type="homecam">
                            <div class="diary-item-icon" style="background: linear-gradient(135deg, #FFD43B, #FF922B);">
                                <i class="fas fa-video"></i>
                            </div>
                            <div class="diary-item-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="diary-item-title">
                                            귀여운 행동 감지
                                            <span class="badge badge-primary ml-2">자동</span>
                                        </h5>
                                        <p class="diary-item-date">
                                            <i class="fas fa-calendar"></i> 2024년 12월 2일 오전 10:15
                                        </p>
                                    </div>
                                    <span class="badge badge-warning">홈캠</span>
                                </div>
                                <p class="diary-item-preview">
                                    AI가 감지한 특별한 순간: 뭉치가 장난감과 놀고 있어요 🎾
                                </p>
                                <div class="diary-item-meta">
                                    <span><i class="fas fa-robot"></i> AI 감지</span>
                                    <span><i class="fas fa-video"></i> 영상 1개</span>
                                </div>
                            </div>
                        </div>

                        <!-- 자동 기록: 건강 체크 -->
                        <div class="diary-item" data-type="health">
                            <div class="diary-item-icon" style="background: linear-gradient(135deg, #4ECDC4, #38D9A9);">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <div class="diary-item-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="diary-item-title">
                                            동물병원 방문
                                            <span class="badge badge-primary ml-2">자동</span>
                                        </h5>
                                        <p class="diary-item-date">
                                            <i class="fas fa-calendar"></i> 2024년 11월 30일 오후 2:00
                                        </p>
                                    </div>
                                    <span class="badge badge-info">건강</span>
                                </div>
                                <p class="diary-item-preview">
                                    정기 검진차 병원 다녀왔어요. 건강 상태 양호! 💪
                                </p>
                                <div class="diary-item-meta">
                                    <span><i class="fas fa-user-md"></i> 김수의 수의사</span>
                                    <span><i class="fas fa-won-sign"></i> 50,000원</span>
                                    <span><i class="fas fa-check-circle"></i> 양호</span>
                                </div>
                            </div>
                        </div>

                        <!-- 수동 기록: 사용자 메모 -->
                        <div class="diary-item" data-type="memo">
                            <div class="diary-item-icon" style="background: linear-gradient(135deg, #9775FA, #7950F2);">
                                <i class="fas fa-pen"></i>
                            </div>
                            <div class="diary-item-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="diary-item-title">
                                            새로운 간식 도전
                                            <span class="badge badge-secondary ml-2">수동</span>
                                        </h5>
                                        <p class="diary-item-date">
                                            <i class="fas fa-calendar"></i> 2024년 11월 28일 오후 5:30
                                        </p>
                                    </div>
                                    <span class="badge badge-dark">메모</span>
                                </div>
                                <p class="diary-item-preview">
                                    오늘 새로운 간식을 줘봤는데 정말 좋아하네요! 앞으로 자주 사줘야겠어요 😋
                                </p>
                                <div class="diary-item-meta">
                                    <span><i class="fas fa-tag"></i> 음식</span>
                                    <span><i class="fas fa-image"></i> 사진 3장</span>
                                </div>
                            </div>
                        </div>

                        <!-- 특별한 날: 기념일 -->
                        <div class="diary-item" data-type="special">
                            <div class="diary-item-icon" style="background: linear-gradient(135deg, #FF6B6B, #FA5252);">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="diary-item-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="diary-item-title">
                                            생일 축하해요!
                                            <span class="badge badge-secondary ml-2">수동</span>
                                        </h5>
                                        <p class="diary-item-date">
                                            <i class="fas fa-calendar"></i> 2024년 11월 25일
                                        </p>
                                    </div>
                                    <span class="badge badge-danger">기념일</span>
                                </div>
                                <p class="diary-item-preview">
                                    우리 뭉치 3살 생일 🎉 케이크 만들어줬어요!
                                </p>
                                <div class="diary-item-meta">
                                    <span><i class="fas fa-star"></i> 특별한 날</span>
                                    <span><i class="fas fa-image"></i> 사진 12장</span>
                                    <span><i class="fas fa-video"></i> 영상 1개</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 더보기 버튼 -->
                    <div class="text-center mt-4">
                        <button class="btn btn-pet-outline" onclick="loadMoreDiary()">
                            <i class="fas fa-chevron-down mr-2"></i>
                            더보기
                        </button>
                    </div>
                </div>
            </div>

            <!-- ========== 탭 4: 행동 리포트 ========== -->
            <div id="tab-report" class="tab-panel">
                <h2 class="section-title">
                    <i class="fas fa-chart-line"></i>
                    행동 리포트
                </h2>

                <!-- 리포트 기간 선택 -->
                <div class="report-controls mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-pet-outline active" onclick="changeReportPeriod('week')">
                                <i class="fas fa-calendar-week"></i> 주간
                            </button>
                            <button type="button" class="btn btn-pet-outline" onclick="changeReportPeriod('month')">
                                <i class="fas fa-calendar-alt"></i> 월간
                            </button>
                            <button type="button" class="btn btn-pet-outline" onclick="changeReportPeriod('year')">
                                <i class="fas fa-calendar"></i> 연간
                            </button>
                        </div>
                        <button class="btn btn-pet-primary" onclick="generateReport()">
                            <i class="fas fa-sync-alt mr-2"></i>
                            리포트 생성하기
                        </button>
                    </div>
                </div>

                <!-- 행동 요약 카드 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="report-stat-card">
                            <div class="report-stat-icon" style="background: linear-gradient(135deg, #FF6B6B, #FA5252);">
                                <i class="fas fa-walking"></i>
                            </div>
                            <div class="report-stat-content">
                                <h5>평균 산책 시간</h5>
                                <p class="report-stat-value">45분</p>
                                <span class="report-stat-change positive">
                                    <i class="fas fa-arrow-up"></i> 12% 증가
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="report-stat-card">
                            <div class="report-stat-icon" style="background: linear-gradient(135deg, #4ECDC4, #38D9A9);">
                                <i class="fas fa-route"></i>
                            </div>
                            <div class="report-stat-content">
                                <h5>평균 거리</h5>
                                <p class="report-stat-value">2.3km</p>
                                <span class="report-stat-change positive">
                                    <i class="fas fa-arrow-up"></i> 8% 증가
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="report-stat-card">
                            <div class="report-stat-icon" style="background: linear-gradient(135deg, #9775FA, #7950F2);">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="report-stat-content">
                                <h5>평균 수면 시간</h5>
                                <p class="report-stat-value">12시간</p>
                                <span class="report-stat-change neutral">
                                    <i class="fas fa-minus"></i> 변화 없음
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="report-stat-card">
                            <div class="report-stat-icon" style="background: linear-gradient(135deg, #FFD43B, #FF922B);">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <div class="report-stat-content">
                                <h5>활동량 지수</h5>
                                <p class="report-stat-value">85점</p>
                                <span class="report-stat-change positive">
                                    <i class="fas fa-arrow-up"></i> 5점 상승
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 활동량 차트 -->
                <div class="info-card mb-4">
                    <h3 class="info-card-title">
                        <i class="fas fa-chart-area"></i>
                        주간 활동량 추이
                    </h3>
                    <div id="activity-chart" style="height: 300px;">
                        <canvas id="activityCanvas"></canvas>
                    </div>
                </div>

                <!-- AI 추천 사항 -->
                <div class="info-card">
                    <h3 class="info-card-title">
                        <i class="fas fa-lightbulb"></i>
                        AI 추천 및 권장 사항
                    </h3>
                    <div class="recommendations-list">
                        <div class="recommendation-item">
                            <div class="recommendation-icon success">
                                <i class="fas fa-thumbs-up"></i>
                            </div>
                            <div class="recommendation-content">
                                <h5>산책 루틴 유지</h5>
                                <p>현재 산책 패턴이 매우 양호합니다. 이 패턴을 꾸준히 유지해주세요.</p>
                            </div>
                        </div>
                        <div class="recommendation-item">
                            <div class="recommendation-icon info">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div class="recommendation-content">
                                <h5>주말 활동량 증가 권장</h5>
                                <p>주말 산책 시간을 평일 수준으로 늘리면 더 건강한 생활 패턴을 유지할 수 있습니다.</p>
                            </div>
                        </div>
                        <div class="recommendation-item">
                            <div class="recommendation-icon success">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="recommendation-content">
                                <h5>건강 상태 양호</h5>
                                <p>전반적인 활동량과 수면 패턴이 건강한 상태를 유지하고 있습니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="<c:url value='/js/mypage.js'/>"></script>