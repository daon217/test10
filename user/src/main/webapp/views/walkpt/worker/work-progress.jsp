<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

        <div class="walkpt-container">
            <div class="container-fluid">
                <h3 class="mb-4"><i class="fas fa-running"></i> 산책 진행 중</h3>

                <div class="monitor-container">
                    <!-- 좌측: 지도/경로 영역 -->
                    <div class="map-placeholder">
                        <div class="text-center">
                            <i class="fas fa-map-marked-alt" style="font-size: 3rem;"></i>
                            <p class="mt-3">지도/경로 표시 영역</p>
                            <small class="text-muted">(실제 지도 API 연동 예정)</small>
                        </div>
                    </div>

                    <!-- 우측: 정보 사이드바 -->
                    <div class="monitor-sidebar">
                        <!-- 세션 정보 -->
                        <div class="mb-4">
                            <h5><i class="fas fa-info-circle"></i> 산책 정보</h5>
                            <div class="mt-3">
                                <p><strong>반려인:</strong> 홍길동님</p>
                                <p><strong>반려동물:</strong> 몽이 (포메라니안)</p>
                                <p><strong>시작 시간:</strong> 오후 3:00</p>
                                <p>
                                    <strong>현재 상태:</strong>
                                    <span class="badge badge-success" id="walkStatus">진행 중</span>
                                </p>
                            </div>
                        </div>

                        <hr>

                        <!-- 타이머 및 거리 -->
                        <div class="monitor-stats mb-4">
                            <div class="stat-item">
                                <div class="stat-value" id="timerDisplay">00:00</div>
                                <div class="stat-label">경과 시간</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="distanceDisplay">0.0km</div>
                                <div class="stat-label">이동 거리</div>
                            </div>
                        </div>

                        <!-- 컨트롤 버튼 -->
                        <div class="mb-4">
                            <button class="btn btn-success btn-block mb-2" id="startBtn" onclick="startWalkSession()">
                                <i class="fas fa-play"></i> 산책 시작
                            </button>
                            <button class="btn btn-warning btn-block mb-2" id="pauseBtn" onclick="pauseWalk()"
                                style="display: none;">
                                <i class="fas fa-pause"></i> 일시 정지
                            </button>
                            <button class="btn btn-info btn-block mb-2" id="resumeBtn" onclick="resumeWalk()"
                                style="display: none;">
                                <i class="fas fa-play"></i> 재개
                            </button>
                            <button class="btn btn-danger btn-block" id="endBtn" onclick="endWalkSession()"
                                style="display: none;">
                                <i class="fas fa-stop"></i> 산책 종료
                            </button>
                        </div>

                        <hr>

                        <!-- 로그 입력 -->
                        <div class="mb-3">
                            <h6><i class="fas fa-clipboard-list"></i> 활동 로그</h6>
                            <div class="input-group mb-2">
                                <input type="text" class="form-control form-control-sm" id="logInput"
                                    placeholder="예: 공원 도착">
                                <div class="input-group-append">
                                    <button class="btn btn-pet-primary btn-sm" onclick="addLog()">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- 로그 리스트 -->
                        <div class="log-list mb-3" id="logList">
                            <div class="log-item">
                                <span class="log-time">15:00</span>
                                <span>대기 중</span>
                            </div>
                        </div>

                        <hr>

                        <!-- 사진 업로드 -->
                        <div class="mb-3">
                            <h6><i class="fas fa-camera"></i> 사진 업로드</h6>
                            <input type="file" class="form-control-file" id="photoUpload" accept="image/*" multiple>
                            <div id="photoPreview" class="d-flex flex-wrap mt-2"></div>
                        </div>

                        <hr>

                        <!-- 환경 활동 체크 -->
                        <div class="mb-3">
                            <h6><i class="fas fa-recycle"></i> 환경 활동</h6>
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="litter"
                                    onchange="logEcoActivity('쓰레기 줍기', this.checked)">
                                <label class="custom-control-label" for="litter">쓰레기 줍기</label>
                            </div>
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="recycle"
                                    onchange="logEcoActivity('분리수거', this.checked)">
                                <label class="custom-control-label" for="recycle">분리수거</label>
                            </div>
                        </div>

                        <hr>

                        <!-- 채팅 버튼 -->
                        <button class="btn btn-pet-secondary btn-block mb-2" onclick="openChat()">
                            <i class="fas fa-comment"></i> 채팅 열기
                        </button>
                        <button class="btn btn-pet-outline btn-block" onclick="alert('영상 통화 기능은 준비 중입니다')">
                            <i class="fas fa-video"></i> 영상 통화 (준비 중)
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../chat/panel.jsp" />

        <script>
            let walkStarted = false;
            let walkPaused = false;
            let startTime = 0;
            let elapsedSeconds = 0;
            let timerInterval = null;
            let distance = 0.0;

            function startWalkSession() {
                if (!walkStarted) {
                    walkStarted = true;
                    startTime = Date.now();
                    addLog('산책 시작');

                    document.getElementById('startBtn').style.display = 'none';
                    document.getElementById('pauseBtn').style.display = 'block';
                    document.getElementById('endBtn').style.display = 'block';
                    document.getElementById('walkStatus').textContent = '진행 중';
                    document.getElementById('walkStatus').className = 'badge badge-success';

                    // 타이머 시작
                    timerInterval = setInterval(updateTimer, 1000);

                    // 거리 시뮬레이션
                    setInterval(updateDistance, 5000);

                    showToast('산책이 시작되었습니다', 'success');
                }
            }

            function pauseWalk() {
                walkPaused = true;
                clearInterval(timerInterval);
                addLog('일시 정지');

                document.getElementById('pauseBtn').style.display = 'none';
                document.getElementById('resumeBtn').style.display = 'block';
                document.getElementById('walkStatus').textContent = '일시 정지';
                document.getElementById('walkStatus').className = 'badge badge-warning';
            }

            function resumeWalk() {
                walkPaused = false;
                timerInterval = setInterval(updateTimer, 1000);
                addLog('재개');

                document.getElementById('resumeBtn').style.display = 'none';
                document.getElementById('pauseBtn').style.display = 'block';
                document.getElementById('walkStatus').textContent = '진행 중';
                document.getElementById('walkStatus').className = 'badge badge-success';
            }

            function endWalkSession() {
                showConfirmModal('산책 종료', '산책을 종료하시겠습니까?', function () {
                    clearInterval(timerInterval);
                    addLog('산책 종료');

                    document.getElementById('walkStatus').textContent = '완료';
                    document.getElementById('walkStatus').className = 'badge badge-secondary';
                    document.getElementById('pauseBtn').style.display = 'none';
                    document.getElementById('resumeBtn').style.display = 'none';
                    document.getElementById('endBtn').style.display = 'none';

                    showToast('산책이 종료되었습니다. 수고하셨습니다!', 'success');

                    setTimeout(function () {
                        window.location.href = '<c:url value="/walkpt/worker/application-status"/>';
                    }, 2000);
                });
            }

            function updateTimer() {
                if (!walkPaused) {
                    elapsedSeconds++;
                    const minutes = Math.floor(elapsedSeconds / 60);
                    const seconds = elapsedSeconds % 60;
                    document.getElementById('timerDisplay').textContent =
                        minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
                }
            }

            function updateDistance() {
                if (walkStarted && !walkPaused) {
                    distance += 0.1 + Math.random() * 0.1;
                    document.getElementById('distanceDisplay').textContent = distance.toFixed(1) + 'km';
                }
            }

            function addLog(text = null) {
                const logText = text || document.getElementById('logInput').value.trim();
                if (!logText) return;

                const now = new Date();
                const timeStr = now.getHours().toString().padStart(2, '0') + ':' +
                    now.getMinutes().toString().padStart(2, '0');

                const logItem = document.createElement('div');
                logItem.className = 'log-item';
                logItem.innerHTML = `<span class="log-time">${timeStr}</span><span>${logText}</span>`;

                document.getElementById('logList').appendChild(logItem);

                if (!text) {
                    document.getElementById('logInput').value = '';
                }
            }

            function logEcoActivity(activity, checked) {
                if (checked) {
                    addLog(`환경 활동: ${activity}`);
                }
            }

            // 사진 업로드
            document.getElementById('photoUpload').addEventListener('change', function (e) {
                const files = e.target.files;
                const preview = document.getElementById('photoPreview');

                for (let file of files) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'mr-2 mb-2 rounded';
                        img.style.width = '80px';
                        img.style.height = '80px';
                        img.style.objectFit = 'cover';
                        preview.appendChild(img);
                    };
                    reader.readAsDataURL(file);
                }

                addLog('사진 업로드');
                showToast('사진이 업로드되었습니다', 'success');
            });

            function openChat() {
                const panel = document.getElementById('chatPanel');
                if (panel) {
                    panel.classList.add('active');
                }
            }
        </script>