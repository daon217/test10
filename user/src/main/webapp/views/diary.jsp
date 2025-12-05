<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/diary.css'/>">
        <!-- FullCalendar CSS -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />

        <div class="diary-container">
            <div class="container">
                <!-- Page Header -->
                <div class="diary-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1>
                                <i class="fas fa-book" style="color: var(--primary-color);"></i>
                                펫 다이어리
                            </h1>
                            <p class="subtitle">
                                우리 아이의 특별한 순간을 기록하고, 자동으로 저장되는 활동들을 확인하세요
                            </p>
                        </div>
                        <button class="btn btn-pet-primary btn-lg" onclick="openAddDiaryModal()">
                            <i class="fas fa-plus-circle mr-2"></i>
                            메모 추가하기
                        </button>
                    </div>
                </div>

                <!-- Summary Statistics -->
                <div class="diary-summary-section mb-4">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #9775FA, #7950F2);">
                                    <i class="fas fa-book-open"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>총 기록</h4>
                                    <p class="stat-number" id="totalRecords">0</p>
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
                                    <p class="stat-number" id="walkRecords">0</p>
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
                                    <p class="stat-number" id="homecamRecords">0</p>
                                    <span class="stat-detail">AI 감지</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #FFD43B, #FF922B);">
                                    <i class="fas fa-star"></i>
                                </div>
                                <div class="stat-content">
                                    <h4>특별한 날</h4>
                                    <p class="stat-number" id="specialRecords">0</p>
                                    <span class="stat-detail">기념일</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter Buttons -->
                <div class="diary-filters mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="filter-tags d-flex align-items-center">
                            <select class="form-control form-control-sm mr-2" id="petFilter" style="width: auto;"
                                onchange="filterByPet()">
                                <option value="">모든 반려동물</option>
                                <!-- Dynamically populated -->
                            </select>
                            <button class="filter-tag active" data-type="all" onclick="filterDiaryType('all')">
                                <i class="fas fa-list"></i> 전체
                            </button>
                            <button class="filter-tag" data-type="walk" onclick="filterDiaryType('walk')">
                                <i class="fas fa-walking"></i> 산책
                            </button>
                            <button class="filter-tag" data-type="health" onclick="filterDiaryType('health')">
                                <i class="fas fa-heartbeat"></i> 건강
                            </button>
                            <button class="filter-tag" data-type="homecam" onclick="filterDiaryType('homecam')">
                                <i class="fas fa-video"></i> 홈캠
                            </button>
                            <button class="filter-tag" data-type="memo" onclick="filterDiaryType('memo')">
                                <i class="fas fa-pen"></i> 메모
                            </button>
                            <button class="filter-tag" data-type="special" onclick="filterDiaryType('special')">
                                <i class="fas fa-star"></i> 기념일
                            </button>
                        </div>
                        <div class="view-toggle">
                            <button class="btn btn-sm btn-pet-outline active" id="calendarViewBtn"
                                onclick="switchView('calendar')">
                                <i class="fas fa-calendar-alt"></i> 캘린더
                            </button>
                            <button class="btn btn-sm btn-pet-outline" id="listViewBtn" onclick="switchView('list')">
                                <i class="fas fa-list"></i> 리스트
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Calendar View -->
                <div id="calendarView" class="diary-calendar-section">
                    <div class="info-card">
                        <div class="calendar-header">
                            <h3 class="info-card-title">
                                <i class="fas fa-calendar-alt"></i>
                                통합 타임라인 캘린더
                            </h3>
                            <p class="text-muted">
                                <i class="fas fa-info-circle mr-1"></i>
                                산책, 홈캠 이벤트, 건강 체크 등이 자동으로 기록됩니다
                            </p>
                        </div>
                        <div id="calendar"></div>
                    </div>
                </div>

                <!-- List View -->
                <div id="listView" class="diary-list-section" style="display: none;">
                    <div class="info-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3 class="info-card-title mb-0">
                                <i class="fas fa-clock"></i>
                                최근 활동 내역
                            </h3>
                            <div class="sort-options">
                                <select class="form-control form-control-sm" id="sortSelect" onchange="sortDiaryList()">
                                    <option value="date-desc">최신순</option>
                                    <option value="date-asc">오래된순</option>
                                    <option value="type">유형별</option>
                                </select>
                            </div>
                        </div>

                        <div class="diary-timeline" id="diaryTimeline">
                            <!-- Dynamically populated timeline items will appear here -->
                            <div class="empty-state" id="emptyState">
                                <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">아직 기록이 없습니다</h5>
                                <p class="text-muted">첫 메모를 추가하거나 활동을 시작해보세요!</p>
                            </div>
                        </div>

                        <!-- Load More Button -->
                        <div class="text-center mt-4" id="loadMoreContainer" style="display: none;">
                            <button class="btn btn-pet-outline" onclick="loadMoreDiaryEntries()">
                                <i class="fas fa-chevron-down mr-2"></i>
                                더보기
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Diary Entry Modal -->
        <div class="modal fade" id="diaryEntryModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
                <div class="modal-content" style="border-radius: 1.5rem; border: none;">
                    <div class="modal-header" style="border-bottom: 2px solid #e9ecef; padding: 1.5rem 2rem;">
                        <h5 class="modal-title" style="font-size: 1.25rem; font-weight: 700; color: #212529;">
                            <i class="fas fa-pen mr-2" style="color: #9775FA;"></i>
                            <span id="modalTitle">메모 추가하기</span>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal"
                            style="font-size: 1.5rem; opacity: 0.5;">
                            <span>&times;</span>
                        </button>
                    </div>

                    <div class="modal-body" style="padding: 2rem;">
                        <form id="diaryEntryForm">
                            <input type="hidden" id="entryId" name="id">
                            <input type="hidden" id="existingImages" name="existingImages">

                            <!-- Entry Type -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-tag mr-1"></i>
                                    기록 유형 <span class="text-danger">*</span>
                                </label>
                                <select class="form-control" id="entryType" name="type" required>
                                    <option value="">선택하세요</option>
                                    <option value="memo">일반 메모</option>
                                    <option value="special">특별한 날/기념일</option>
                                    <option value="health">건강 기록</option>
                                    <option value="food">식사/간식</option>
                                    <option value="grooming">미용</option>
                                    <option value="training">훈련</option>
                                    <option value="other">기타</option>
                                </select>
                            </div>

                            <!-- Title -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-heading mr-1"></i>
                                    제목 <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="entryTitle" name="title"
                                    placeholder="예: 우리 뭉치 생일" required maxlength="100">
                            </div>

                            <!-- Date and Time -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>
                                            <i class="fas fa-calendar mr-1"></i>
                                            날짜 <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" class="form-control" id="entryDate" name="dateStr" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>
                                            <i class="fas fa-clock mr-1"></i>
                                            시간
                                        </label>
                                        <input type="time" class="form-control" id="entryTime" name="timeStr">
                                    </div>
                                </div>
                            </div>

                            <!-- Content -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-comment mr-1"></i>
                                    내용 <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" id="entryContent" name="content" rows="5"
                                    placeholder="오늘 있었던 일을 자세히 적어주세요..." required></textarea>
                            </div>

                            <!-- Image Upload -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-image mr-1"></i>
                                    사진 첨부 (선택사항)
                                </label>
                                <div class="custom-file">
                                    <input type="file" class="custom-file-input" id="entryImages" name="images"
                                        accept="image/*" multiple onchange="previewImages(this)">
                                    <label class="custom-file-label" for="entryImages">파일 선택</label>
                                </div>
                                <small class="form-text text-muted">
                                    최대 5장까지 업로드 가능 (JPG, PNG, GIF)
                                </small>
                                <div id="imagePreviewContainer" class="mt-3 row"></div>
                            </div>

                            <!-- Tags -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-tags mr-1"></i>
                                    태그 (선택사항)
                                </label>
                                <input type="text" class="form-control" id="entryTags" name="tags"
                                    placeholder="#행복 #건강 #생일 (스페이스로 구분)">
                                <small class="form-text text-muted">
                                    태그를 추가하면 나중에 쉽게 찾을 수 있어요
                                </small>
                            </div>

                            <!-- Pet Selection (if multiple pets) -->
                            <div class="form-group">
                                <label>
                                    <i class="fas fa-paw mr-1"></i>
                                    반려동물 선택
                                </label>
                                <select class="form-control" id="entryPet" name="petId">
                                    <option value="">전체</option>
                                    <!-- Dynamically populated pet list -->
                                </select>
                            </div>
                        </form>
                    </div>

                    <div class="modal-footer" style="border-top: 2px solid #e9ecef; padding: 1rem 2rem;">
                        <button type="button" class="btn btn-outline-secondary" data-dismiss="modal"
                            style="height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                            <i class="fas fa-times mr-2"></i> 취소
                        </button>
                        <button type="button" class="btn btn-primary" onclick="saveDiaryEntry()"
                            style="background: linear-gradient(135deg, #9775FA, #7950F2); border: none; height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                            <i class="fas fa-save mr-2"></i> 저장하기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- View Detail Modal -->
        <div class="modal fade" id="diaryDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
                <div class="modal-content" style="border-radius: 1.5rem; border: none;">
                    <div class="modal-header" style="border-bottom: 2px solid #e9ecef; padding: 1.5rem 2rem;">
                        <h5 class="modal-title" style="font-size: 1.25rem; font-weight: 700;" id="detailTitle"></h5>
                        <button type="button" class="close" data-dismiss="modal"
                            style="font-size: 1.5rem; opacity: 0.5;">
                            <span>&times;</span>
                        </button>
                    </div>

                    <div class="modal-body" style="padding: 2rem;">
                        <div id="detailContent"></div>
                    </div>

                    <div class="modal-footer" style="border-top: 2px solid #e9ecef; padding: 1rem 2rem;">
                        <button type="button" class="btn btn-outline-danger" onclick="deleteDiaryEntry()"
                            style="height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                            <i class="fas fa-trash mr-2"></i> 삭제
                        </button>
                        <button type="button" class="btn btn-outline-primary" onclick="editDiaryEntry()"
                            style="height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                            <i class="fas fa-edit mr-2"></i> 수정
                        </button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal"
                            style="height: 2.75rem; border-radius: 0.75rem; font-weight: 600; padding: 0 1.5rem;">
                            닫기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- FullCalendar JS -->
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>

        <script>
            (function () {
                let calendar;
                let allEvents = [];
                let currentFilter = 'all';
                let currentView = 'calendar';
                let currentEntryId = null;
                let pets = [];
                let currentPetFilter = '';
                let keptImages = []; // Array to store existing images being kept during edit

                const eventTypeConfig = {
                    walk: {
                        color: '#20C997',
                        icon: 'fa-walking',
                        label: '산책'
                    },
                    homecam: {
                        color: '#FFD43B',
                        icon: 'fa-video',
                        label: '홈캠'
                    },
                    hospital: {
                        color: '#FF6B6B',
                        icon: 'fa-hospital',
                        label: '병원'
                    },
                    anniversary: {
                        color: '#FCC419',
                        icon: 'fa-birthday-cake',
                        label: '기념일'
                    },
                    food: {
                        color: '#38D9A9',
                        icon: 'fa-utensils',
                        label: '식사'
                    },
                    grooming: {
                        color: '#74C0FC',
                        icon: 'fa-cut',
                        label: '미용'
                    },
                    training: {
                        color: '#FF922B',
                        icon: 'fa-graduation-cap',
                        label: '훈련'
                    },
                    other: {
                        color: '#868E96',
                        icon: 'fa-ellipsis-h',
                        label: '기타'
                    }
                };

                // Initialize when page loads
                document.addEventListener('DOMContentLoaded', function () {
                    initializeCalendar();
                    loadPets();
                    loadDiaryData();
                    setDefaultDate();
                });

                function initializeCalendar() {
                    const calendarEl = document.getElementById('calendar');

                    calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'dayGridMonth',
                        locale: 'ko',
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                        },
                        buttonText: {
                            today: '오늘',
                            month: '월',
                            week: '주',
                            day: '일',
                            list: '목록'
                        },
                        height: 'auto',
                        navLinks: true,
                        editable: false,
                        dayMaxEvents: 3,
                        eventClick: function (info) {
                            showDiaryDetail(info.event);
                        },
                        events: [] // Will be populated by loadDiaryData()
                    });

                    calendar.render();
                }

                function setDefaultDate() {
                    const today = new Date();
                    const dateStr = today.toISOString().split('T')[0];
                    document.getElementById('entryDate').value = dateStr;
                }

                function loadPets() {
                    fetch('/api/diary/pets')
                        .then(response => response.json())
                        .then(data => {
                            pets = data;
                            const petFilter = document.getElementById('petFilter');
                            const entryPet = document.getElementById('entryPet');

                            // Clear existing options except first
                            while (petFilter.options.length > 1) petFilter.remove(1);
                            while (entryPet.options.length > 1) entryPet.remove(1);

                            data.forEach(pet => {
                                // Filter dropdown
                                const option1 = new Option(pet.name, pet.petId);
                                petFilter.add(option1);

                                // Modal dropdown
                                const option2 = new Option(pet.name, pet.petId);
                                entryPet.add(option2);
                            });
                        })
                        .catch(error => console.error('Error loading pets:', error));
                }

                window.filterByPet = function () {
                    currentPetFilter = document.getElementById('petFilter').value;
                    loadDiaryData();
                };

                // Load diary data from backend
                function loadDiaryData() {
                    let url = '/api/diary/entries';
                    const params = new URLSearchParams();
                    if (currentPetFilter) {
                        params.append('petId', currentPetFilter);
                    }

                    // Add timestamp to prevent caching
                    params.append('_t', new Date().getTime());

                    if (params.toString()) {
                        url += '?' + params.toString();
                    }

                    fetch(url)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(data => {
                            allEvents = data;
                            updateCalendar();
                            updateStatistics();
                            renderListView();
                        })
                        .catch(error => {
                            console.error('Error loading diary data:', error);
                            // Show error state in UI
                            const timeline = document.getElementById('diaryTimeline');
                            if (timeline) {
                                timeline.innerHTML = `
                            <div class="text-center py-5">
                                <i class="fas fa-exclamation-circle fa-3x text-danger mb-3"></i>
                                <h5 class="text-muted">데이터를 불러오는데 실패했습니다</h5>
                                <p class="text-muted">잠시 후 다시 시도해주세요</p>
                            </div>
                        `;
                            }
                        });
                }

                function updateCalendar() {
                    const filteredEvents = currentFilter === 'all'
                        ? allEvents
                        : allEvents.filter(evt => evt.type === currentFilter);

                    const calendarEvents = filteredEvents.map(evt => {
                        const config = eventTypeConfig[evt.type] || eventTypeConfig.other;
                        return {
                            id: evt.id,
                            title: evt.title,
                            start: evt.date,
                            backgroundColor: config.color,
                            borderColor: config.color,
                            extendedProps: evt
                        };
                    });

                    calendar.removeAllEvents();
                    calendar.addEventSource(calendarEvents);
                }

                function updateStatistics() {
                    const stats = {
                        total: allEvents.length,
                        walk: allEvents.filter(e => e.type === 'walk').length,
                        homecam: allEvents.filter(e => e.type === 'homecam').length,
                        special: allEvents.filter(e => e.type === 'special').length
                    };

                    document.getElementById('totalRecords').textContent = stats.total;
                    document.getElementById('walkRecords').textContent = stats.walk;
                    document.getElementById('homecamRecords').textContent = stats.homecam;
                    document.getElementById('specialRecords').textContent = stats.special;
                }

                function renderListView() {
                    const timeline = document.getElementById('diaryTimeline');
                    const emptyState = document.getElementById('emptyState');

                    if (!timeline || !emptyState) return;

                    const filteredEvents = currentFilter === 'all'
                        ? allEvents
                        : allEvents.filter(evt => evt.type === currentFilter);

                    timeline.innerHTML = ''; // Clear existing content

                    if (filteredEvents.length === 0) {
                        emptyState.style.display = 'block';
                        timeline.appendChild(emptyState);
                        return;
                    }

                    emptyState.style.display = 'none';

                    filteredEvents.forEach(entry => {
                        const config = eventTypeConfig[entry.type] || eventTypeConfig.other;
                        const itemHtml = createTimelineItem(entry, config);

                        const div = document.createElement('div');
                        div.innerHTML = itemHtml;
                        div.onclick = function (e) {
                            // Prevent click when clicking on map or buttons
                            if (e.target.closest('.btn') || e.target.closest('.map-container') || e.target.closest('.entry-images')) return;
                            showDiaryDetailById(entry.id);
                        };
                        timeline.appendChild(div);

                        // Initialize map for walk logs
                        if (entry.type === 'walk' && entry.meta) {
                            setTimeout(() => {
                                initMap(entry.id, entry.meta);
                            }, 100);
                        }
                    });
                }

                function createTimelineItem(entry, config) {
                    // Parse images
                    let images = [];
                    if (entry.images) {
                        if (Array.isArray(entry.images)) {
                            images = entry.images;
                        } else if (typeof entry.images === 'string' && entry.images.trim() !== '') {
                            images = entry.images.split(',').filter(img => img.trim() !== '');
                        }
                    }

                    return `
    <div class="diary-item" data-type="\${entry.type}">
        <div class="diary-item-icon" style="background: linear-gradient(135deg, \${config.color}, \${config.color}dd);">
            <i class="fas \${config.icon}"></i>
        </div>
        <div class="diary-item-content">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <h5 class="diary-item-title">
                        \${entry.title}
                        \${entry.isAuto ? '<span class="badge badge-primary ml-2">자동</span>' : '<span class="badge badge-secondary ml-2">수동</span>'}
                    </h5>
                    <p class="diary-item-date">
                        <i class="fas fa-calendar"></i> \${formatDate(entry.date)}
                    </p>
                </div>
                <span class="badge" style="background-color: \${config.color};">\${config.label}</span>
            </div>
            <p class="diary-item-preview">\${entry.content || ''}</p>
            \${images.length > 0 ? `
                        < div class="diary-item-images mt-2 mb-2" >
                            <div class="row no-gutters">
                                \${images.slice(0, 4).map(img => `
                            <div class="col-3 px-1">
                                <img src="\${img}" class="img-fluid rounded" style="height: 60px; object-fit: cover; width: 100%;" alt="Diary Image">
                            </div>
                        `).join('')}
                            </div>
                </div >
                        ` : ''}
            \${entry.meta && entry.type !== 'walk' ? `< div class="diary-item-meta" >\${ entry.meta }</div > ` : ''}
            \${entry.type === 'walk' && entry.meta ? `< div id = "map-\${entry.id}" class="map-container" style = "width:100%; height:200px; margin-top:10px; border-radius:8px;" ></div > ` : ''}
        </div>
    </div>
`;
                }

                function formatDate(dateStr) {
                    const date = new Date(dateStr);
                    return date.toLocaleDateString('ko-KR', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                        weekday: 'short'
                    });
                }

                // Switch between calendar and list view
                window.switchView = function (view) {
                    currentView = view;

                    if (view === 'calendar') {
                        document.getElementById('calendarView').style.display = 'block';
                        document.getElementById('listView').style.display = 'none';
                        document.getElementById('calendarViewBtn').classList.add('active');
                        document.getElementById('listViewBtn').classList.remove('active');
                    } else {
                        document.getElementById('calendarView').style.display = 'none';
                        document.getElementById('listView').style.display = 'block';
                        document.getElementById('calendarViewBtn').classList.remove('active');
                        document.getElementById('listViewBtn').classList.add('active');
                    }
                };

                // Filter diary by type
                window.filterDiaryType = function (type) {
                    currentFilter = type;

                    // Update active button
                    document.querySelectorAll('.filter-tag').forEach(btn => {
                        btn.classList.remove('active');
                    });
                    document.querySelector(`[data-type="\${type}"]`).classList.add('active');

                    updateCalendar();
                    renderListView();
                };

                // Open add diary modal
                window.openAddDiaryModal = function () {
                    currentEntryId = null;
                    document.getElementById('modalTitle').textContent = '메모 추가하기';
                    document.getElementById('diaryEntryForm').reset();
                    document.getElementById('entryId').value = '';
                    document.getElementById('existingImages').value = '';
                    keptImages = [];
                    document.getElementById('imagePreviewContainer').innerHTML = '';
                    setDefaultDate();
                    $('#diaryEntryModal').modal('show');
                };

                // Show diary detail
                function showDiaryDetail(event) {
                    const entry = event.extendedProps;
                    showDiaryDetailById(event.id);
                }

                window.showDiaryDetailById = function (id) {
                    const entry = allEvents.find(e => e.id === id);
                    if (!entry) return;

                    currentEntryId = id;
                    const config = eventTypeConfig[entry.type] || eventTypeConfig.other;

                    // Parse images
                    let images = [];
                    if (entry.images) {
                        if (Array.isArray(entry.images)) {
                            images = entry.images;
                        } else if (typeof entry.images === 'string' && entry.images.trim() !== '') {
                            images = entry.images.split(',').filter(img => img.trim() !== '');
                        }
                    }

                    document.getElementById('detailTitle').innerHTML = `
    <i class="fas \${config.icon} mr-2" style="color: \${config.color};"></i>
    \${entry.title}
`;

                    document.getElementById('detailContent').innerHTML = `
    <div class="entry-detail-content">
        <div class="detail-meta mb-3">
            <span class="badge" style="background-color: \${config.color};">\${config.label}</span>
            \${entry.isAuto ? '<span class="badge badge-primary ml-2">자동 기록</span>' : '<span class="badge badge-secondary ml-2">수동 기록</span>'}
        </div>
        <p class="text-muted mb-3">
            <i class="fas fa-calendar mr-2"></i>\${formatDate(entry.date)}
            \${entry.time ? `< i class="fas fa-clock ml-3 mr-2" ></i >\${ entry.time } ` : ''}
        </p>
        <div class="entry-content">
            \${entry.content || ''}
        </div>
        \${images.length > 0 ? `
                        < div class="entry-images mt-3" >
                            <div class="row">
                                \${images.map(img => `
                        <div class="col-md-4 mb-2">
                            <img src="\${img}" class="img-fluid rounded" alt="Diary image">
                        </div>
                    `).join('')}
                            </div>
            </div >
                        ` : ''}
        \${entry.tags ? `
                        < div class="entry-tags mt-3" >
                    \${
                        entry.tags.split(' ').map(tag => `
                    <span class="badge badge-light">\${tag}</span>
                `).join('')
                    }
            </div >
                        ` : ''}
        
        \${entry.type === 'walk' && entry.meta ? `
                        < div id = "map-detail-\${entry.id}" style = "width:100%; height:200px; margin-top:10px; border-radius:8px;" ></div >
                            ` : ''}
    </div>
`;

                    // Hide/Show Edit/Delete buttons based on type
                    const footer = document.querySelector('#diaryDetailModal .modal-footer');
                    const editBtn = footer.querySelector('button[onclick="editDiaryEntry()"]');

                    footer.style.display = 'flex';

                    if (entry.type === 'walk' || entry.isAuto) {
                        // Hide edit button for auto-generated entries like walk, but allow delete
                        if (editBtn) editBtn.style.display = 'none';
                    } else {
                        if (editBtn) editBtn.style.display = 'inline-block';
                    }

                    $('#diaryDetailModal').modal('show');

                    // Initialize map for walk logs in detail view
                    if (entry.type === 'walk' && entry.meta) {
                        setTimeout(() => {
                            initMap('detail-' + entry.id, entry.meta);
                        }, 200); // Slightly longer delay for modal animation
                    }
                };

                // Initialize Kakao Map for Walk Log
                window.initMap = function (id, routeData) {
                    try {
                        const container = document.getElementById(`map-\${id}`);
                        if (!container) {
                            // console.warn(`Map container map-\${id} not found`);
                            return;
                        }

                        // Ensure container has dimensions
                        if (container.offsetHeight === 0) {
                            container.style.height = '200px';
                        }

                        const options = {
                            center: new kakao.maps.LatLng(33.450701, 126.570667),
                            level: 3
                        };

                        const map = new kakao.maps.Map(container, options);

                        // Parse route data
                        let path = [];
                        let parsedData = routeData;

                        if (typeof routeData === 'string') {
                            try {
                                parsedData = JSON.parse(routeData);
                            } catch (e) {
                                console.error("Failed to parse route data", e);
                                return;
                            }
                        }

                        if (Array.isArray(parsedData)) {
                            path = parsedData.map(coord => {
                                return new kakao.maps.LatLng(coord.lat || coord.y, coord.lng || coord.x);
                            });
                        }

                        if (path.length > 0) {
                            // Draw polyline
                            const polyline = new kakao.maps.Polyline({
                                path: path,
                                strokeWeight: 5,
                                strokeColor: '#FF0000',
                                strokeOpacity: 0.7,
                                strokeStyle: 'solid'
                            });
                            polyline.setMap(map);

                            // Set bounds
                            const bounds = new kakao.maps.LatLngBounds();
                            path.forEach(point => bounds.extend(point));
                            map.setBounds(bounds);

                            // Relayout to ensure map renders correctly
                            setTimeout(() => {
                                map.relayout();
                                map.setBounds(bounds);
                            }, 100);
                        }
                    } catch (e) {
                        console.error('Error initializing map for entry ' + id, e);
                    }
                };

                // Save diary entry
                window.saveDiaryEntry = function () {
                    const form = document.getElementById('diaryEntryForm');
                    if (!form.checkValidity()) {
                        form.reportValidity();
                        return;
                    }

                    const formData = new FormData(form);

                    // Add dateStr and timeStr explicitly
                    formData.set('dateStr', document.getElementById('entryDate').value);
                    formData.set('timeStr', document.getElementById('entryTime').value);

                    const url = '/api/diary/entries';
                    const isUpdate = !!document.getElementById('entryId').value;
                    const method = isUpdate ? 'PUT' : 'POST';

                    fetch(url, {
                        method: method,
                        body: formData
                    })
                        .then(response => {
                            if (response.ok) {
                                $('#diaryEntryModal').modal('hide');
                                loadDiaryData(); // Reload data
                                alert('저장되었습니다!');
                            } else {
                                return response.text().then(text => { throw new Error(text) });
                            }
                        })
                        .catch(error => {
                            console.error('Error saving diary entry:', error);
                            alert('저장 중 오류가 발생했습니다: ' + error.message);
                        });
                };

                // Edit diary entry
                window.editDiaryEntry = function (id) {
                    const targetId = id || currentEntryId;
                    const entry = allEvents.find(e => e.id === targetId);
                    if (!entry) return;

                    currentEntryId = targetId;

                    $('#diaryDetailModal').modal('hide');

                    // Populate form with existing data
                    document.getElementById('modalTitle').textContent = '메모 수정하기';
                    document.getElementById('entryId').value = entry.id;
                    document.getElementById('entryType').value = entry.type;
                    document.getElementById('entryTitle').value = entry.title;

                    // Handle date format
                    if (entry.date) {
                        const dateObj = new Date(entry.date);
                        const year = dateObj.getFullYear();
                        const month = String(dateObj.getMonth() + 1).padStart(2, '0');
                        const day = String(dateObj.getDate()).padStart(2, '0');
                        const hours = String(dateObj.getHours()).padStart(2, '0');
                        const minutes = String(dateObj.getMinutes()).padStart(2, '0');

                        document.getElementById('entryDate').value = `\${year}-\${month}-\${day}`;
                        document.getElementById('entryTime').value = `\${hours}:\${minutes}`;
                    }

                    document.getElementById('entryContent').value = entry.content || '';
                    document.getElementById('entryTags').value = entry.tags || '';
                    document.getElementById('entryPet').value = entry.petId || '';

                    // Handle existing images
                    keptImages = [];
                    if (entry.images) {
                        if (Array.isArray(entry.images)) {
                            keptImages = [...entry.images];
                        } else if (typeof entry.images === 'string' && entry.images.trim() !== '') {
                            keptImages = entry.images.split(',').filter(img => img.trim() !== '');
                        }
                    }
                    document.getElementById('existingImages').value = keptImages.join(',');

                    // Clear file input
                    document.getElementById('entryImages').value = '';
                    document.querySelector('.custom-file-label').textContent = '파일 선택';

                    renderPreviews();

                    $('#diaryEntryModal').modal('show');
                };

                // Delete diary entry
                window.deleteDiaryEntry = function () {
                    const id = currentEntryId;
                    if (!id) return;

                    const entry = allEvents.find(e => e.id === id);
                    const type = entry ? entry.type : '';

                    if (!confirm('정말 삭제하시겠습니까?')) return;

                    fetch(`/api/diary/entries/\${id}?type=\${type}`, {
                        method: 'DELETE'
                    })
                        .then(response => {
                            if (response.ok) {
                                $('#diaryEntryModal').modal('hide');
                                $('#diaryDetailModal').modal('hide');
                                loadDiaryData();
                                alert('삭제되었습니다!');
                            } else {
                                alert('삭제 중 오류가 발생했습니다.');
                            }
                        })
                        .catch(error => {
                            console.error('Error deleting diary entry:', error);
                            alert('삭제 중 오류가 발생했습니다.');
                        });
                };

                // Sort diary list
                window.sortDiaryList = function () {
                    const sortValue = document.getElementById('sortSelect').value;

                    if (sortValue === 'date-desc') {
                        allEvents.sort((a, b) => new Date(b.date) - new Date(a.date));
                    } else if (sortValue === 'date-asc') {
                        allEvents.sort((a, b) => new Date(a.date) - new Date(b.date));
                    } else if (sortValue === 'type') {
                        allEvents.sort((a, b) => a.type.localeCompare(b.type));
                    }

                    renderListView();
                };

                // Load more diary entries
                window.loadMoreDiaryEntries = function () {
                    console.log('Load more entries');
                };

                // Preview images
                window.previewImages = function (input) {
                    renderPreviews();
                };

                // Render all previews (existing + new)
                function renderPreviews() {
                    const container = document.getElementById('imagePreviewContainer');
                    container.innerHTML = '';

                    const input = document.getElementById('entryImages');
                    let totalCount = keptImages.length;

                    // 1. Render existing images
                    keptImages.forEach((img, index) => {
                        const col = document.createElement('div');
                        col.className = 'col-md-3 mb-2';
                        col.innerHTML = `
                            <div class="position-relative">
                                <img src="\${img}" class="img-fluid rounded" alt="Existing Image" style="height: 100px; object-fit: cover; width: 100%;">
                                <button type="button" class="btn btn-sm btn-danger position-absolute"
                                    style="top: 5px; right: 20px;" onclick="removeExistingImage(\${index})">
                                    <i class="fas fa-times"></i>
                                </button>
                                <span class="badge badge-secondary position-absolute" style="bottom: 5px; right: 20px;">기존</span>
                            </div>
                        `;
                        container.appendChild(col);
                    });

                    // 2. Render new files
                    if (input.files) {
                        Array.from(input.files).forEach((file, index) => {
                            if (totalCount >= 5) return; // Max 5 images total
                            totalCount++;

                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const col = document.createElement('div');
                                col.className = 'col-md-3 mb-2';
                                col.innerHTML = `
                                    <div class="position-relative">
                                        <img src="\${e.target.result}" class="img-fluid rounded" alt="New Image" style="height: 100px; object-fit: cover; width: 100%;">
                                        <span class="badge badge-success position-absolute" style="bottom: 5px; right: 20px;">신규</span>
                                    </div>
                                `;
                                container.appendChild(col);
                            };
                            reader.readAsDataURL(file);
                        });

                        // Update file input label
                        const newFileCount = Math.min(input.files.length, 5 - keptImages.length);
                        const label = document.querySelector('.custom-file-label');
                        if (newFileCount > 0 || keptImages.length > 0) {
                            label.textContent = `총 \${keptImages.length + newFileCount}개 파일`;
                        } else {
                            label.textContent = '파일 선택';
                        }
                    }
                }

                window.removeExistingImage = function (index) {
                    keptImages.splice(index, 1);
                    document.getElementById('existingImages').value = keptImages.join(',');
                    renderPreviews();
                };

                window.removePreviewImage = function (index) {
                    // Cannot easily remove from input.files, so we just reset the input for now or ignore
                    // For better UX, we would need a DataTransfer object to manipulate files, 
                    // but for simplicity, we'll just rely on re-selecting files if user wants to change new uploads.
                    // Or we could implement a custom file list management.
                    // For now, let's just clear the input if they want to remove new files.
                    document.getElementById('entryImages').value = '';
                    renderPreviews();
                };
            })();
        </script>
        <!-- Kakao Map SDK -->
        <script
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=55e3779d3a4e94654971764756e0a939&libraries=services"></script>