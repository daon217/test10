<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mypage.css'/>">

<div class="mypage-container">
    <div class="mypage-wrapper">

        <h2 class="section-title">
            <i class="fas fa-chart-line"></i>
            펫 분석 리포트
        </h2>
        <p class="text-muted mb-4">AI가 반려동물의 활동, 건강, 행동 데이터를 종합 분석한 리포트입니다</p>

        <div class="report-controls mb-4">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div class="btn-group mb-2" role="group">
                    <button type="button" class="btn btn-pet-outline" id="dailyBtn"
                            onclick="changeReportPeriod('daily')">
                        <i class="fas fa-calendar-day"></i> 일간
                    </button>
                    <button type="button" class="btn btn-pet-outline active" id="weeklyBtn"
                            onclick="changeReportPeriod('weekly')">
                        <i class="fas fa-calendar-week"></i> 주간
                    </button>
                    <button type="button" class="btn btn-pet-outline" id="monthlyBtn"
                            onclick="changeReportPeriod('monthly')">
                        <i class="fas fa-calendar-alt"></i> 월간
                    </button>
                </div>
                <div class="text-muted mb-2">
                    <small id="reportPeriodText">2025.12.01 - 2025.12.05 (5일간)</small>
                </div>
            </div>
        </div>

        <div class="row mb-4" id="stats Cards">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="report-stat-card">
                    <div class="report-stat-icon"
                         style="background: linear-gradient(135deg, #4ECDC4, #38D9A9);">
                        <i class="fas fa-walking"></i>
                    </div>
                    <div class="report-stat-content">
                        <h5>평균 산책 시간</h5>
                        <p class="report-stat-value" id="avgWalkTime">38분</p>
                        <span class="report-stat-change positive">
                                    <i class="fas fa-arrow-up"></i> 전주대비 15% 증가
                                </span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="report-stat-card">
                    <div class="report-stat-icon"
                         style="background: linear-gradient(135deg, #FF6B6B, #FA5252);">
                        <i class="fas fa-route"></i>
                    </div>
                    <div class="report-stat-content">
                        <h5>평균 산책 거리</h5>
                        <p class="report-stat-value" id="avgWalkDistance">1.97km</p>
                        <span class="report-stat-change positive">
                                    <i class="fas fa-arrow-up"></i> 전주대비 10% 증가
                                </span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="report-stat-card">
                    <div class="report-stat-icon"
                         style="background: linear-gradient(135deg, #FF8787, #FF6B9D);">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <div class="report-stat-content">
                        <h5>건강 체크</h5>
                        <p class="report-stat-value" id="healthCheckCount">2회</p>
                        <span class="report-stat-change neutral">
                                    <i class="fas fa-check-circle"></i> 전체 양호
                                </span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="report-stat-card">
                    <div class="report-stat-icon"
                         style="background: linear-gradient(135deg, #51CF66, #37B24D);">
                        <i class="fas fa-camera"></i>
                    </div>
                    <div class="report-stat-content">
                        <h5>홈캠 분석</h5>
                        <p class="report-stat-value" id="homecamEvents">8건</p>
                        <span class="report-stat-change positive">
                                    <i class="fas fa-smile"></i> 활동적
                                </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="info-card mb-4">
            <h3 class="info-card-title">
                <i class="fas fa-brain"></i>
                AI 종합 분석 리포트
            </h3>
            <div id="llmReport">
                <jsp:include page="common/ai_report_content.jsp" />
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6 mb-4">
                <div class="info-card">
                    <h3 class="info-card-title">
                        <i class="fas fa-chart-line"></i>
                        주간 산책 기록
                    </h3>
                    <div style="height: 250px; display: flex; align-items: center; justify-content: center;">
                        <canvas id="walkChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="info-card">
                    <h3 class="info-card-title">
                        <i class="fas fa-chart-pie"></i>
                        행동 유형 분포
                    </h3>
                    <div style="height: 250px; display: flex; align-items: center; justify-content: center;">
                        <canvas id="behaviorChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="info-card">
            <h3 class="info-card-title">
                <i class="fas fa-list"></i>
                상세 활동 기록f
            </h3>
            <div class="table-responsive">
                <table class="table table-hover" id="activityTable">
                    <thead>
                    <tr>
                        <th>날짜</th>
                        <th>활동 유형</th>
                        <th>상세 정보</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody id="activityTableBody">
                    <tr>
                        <td>2025-12-05</td>
                        <td><span class="badge badge-info">산책</span></td>
                        <td>공원 산책 2.3km / 45분</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 완료</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-04</td>
                        <td><span class="badge badge-warning">건강</span></td>
                        <td>AI 건강체크 - 지속 관찰 필요</td>
                        <td><span class="text-info"><i class="fas fa-eye"></i> 관찰중</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-04</td>
                        <td><span class="badge badge-success">행동</span></td>
                        <td>홈캠 이벤트 4건 기록</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 정상</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-03</td>
                        <td><span class="badge badge-info">산책</span></td>
                        <td>비 오는 날 산책 1.1km / 20분</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 완료</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-02</td>
                        <td><span class="badge badge-warning">건강</span></td>
                        <td>AI 건강체크 - 주의 관찰</td>
                        <td><span class="text-warning"><i class="fas fa-exclamation-circle"></i> 주의</span>
                        </td>
                    </tr>
                    <tr>
                        <td>2025-12-02</td>
                        <td><span class="badge badge-success">행동</span></td>
                        <td>홈캠 이벤트 4건 기록</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 정상</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-01</td>
                        <td><span class="badge badge-info">산책</span></td>
                        <td>공원 산책 2.5km / 50분</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 완료</span></td>
                    </tr>
                    <tr>
                        <td>2025-12-01</td>
                        <td><span class="badge badge-success">행동</span></td>
                        <td>홈캠 이벤트 4건 기록</td>
                        <td><span class="text-success"><i class="fas fa-check-circle"></i> 정상</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
    // ============ Mock Data (diary.jsp 데이터와 연동) ============
    const reportData = {
        weekly: {
            period: '2025.12.01 - 2025.12.05 (5일간)',
            walks: [
                { date: '2025-12-01', distance: 2.5, duration: 50, route: '공원 → 강변 → 놀이터' },
                { date: '2025-12-03', distance: 1.1, duration: 20, route: '집 앞 → 골목길' },
                { date: '2025-12-05', distance: 2.3, duration: 45, route: '근린공원 → 산책로 → 놀이터' }
            ],
            healthChecks: [
                { date: '2025-12-02', severity: '주의 관찰', findings: '눈 주변 경미한 붉음' },
                { date: '2025-12-04', severity: '지속 관찰 필요', findings: '경미한 피부 변화' }
            ],
            behaviors: [
                { date: '2025-12-01', eventCount: 4, type: '새 장난감 놀이' },
                { date: '2025-12-02', eventCount: 4, type: '재택근무 동행' },
                { date: '2025-12-04', eventCount: 4, type: '혼자 지키는 집' }
            ]
        },
        daily: {
            period: '2025-12-05 (1일간)',
            walks: [
                { date: '2025-12-05', distance: 2.3, duration: 45, route: '근린공원 → 산책로 → 놀이터' }
            ],
            healthChecks: [],
            behaviors: []
        },
        monthly: {
            period: '2025.12.01 - 2025.12.31 (31일간)',
            walks: [
                { date: '2025-12-01', distance: 2.5, duration: 50, route: '공원 → 강변 → 놀이터' },
                { date: '2025-12-03', distance: 1.1, duration: 20, route: '집 앞 → 골목길' },
                { date: '2025-12-05', distance: 2.3, duration: 45, route: '근린공원 → 산책로 → 놀이터' }
            ],
            healthChecks: [
                { date: '2025-12-02', severity: '주의 관찰', findings: '눈 주변 경미한 붉음' },
                { date: '2025-12-04', severity: '지속 관찰 필요', findings: '경미한 피부 변화' }
            ],
            behaviors: [
                { date: '2025-12-01', eventCount: 4, type: '새 장난감 놀이' },
                { date: '2025-12-02', eventCount: 4, type: '재택근무 동행' },
                { date: '2025-12-04', eventCount: 4, type: '혼자 지키는 집' }
            ]
        }
    };
    let currentPeriod = 'weekly';

    // ============ 리포트 기간 변경 ============
    function changeReportPeriod(period) {
        currentPeriod = period;
        // 버튼 활성화 상태 변경
        document.querySelectorAll('.btn-group .btn').forEach(btn => btn.classList.remove('active'));
        document.getElementById(period + 'Btn').classList.add('active');

        // 통계 업데이트
        updateStats(period);
        // 차트 업데이트
        updateCharts(period);
        // LLM 리포트 업데이트 (실제 구현 시 API 호출)
        updateLLMReport(period);
    }

    // ============ 통계 업데이트 ============
    function updateStats(period) {
        const data = reportData[period];
        document.getElementById('reportPeriodText').textContent = data.period;

        // 산책 평균 계산
        const walks = data.walks;
        const avgDistance = walks.length > 0
            ? (walks.reduce((sum, w) => sum + w.distance, 0) / walks.length).toFixed(2)
            : 0;
        const avgTime = walks.length > 0
            ? Math.round(walks.reduce((sum, w) => sum + w.duration, 0) / walks.length)
            : 0;
        document.getElementById('avgWalkDistance').textContent = avgDistance + 'km';
        document.getElementById('avgWalkTime').textContent = avgTime + '분';
        document.getElementById('healthCheckCount').textContent = data.healthChecks.length + '회';
        document.getElementById('homecamEvents').textContent =
            data.behaviors.reduce((sum, b) => sum + b.eventCount, 0) + '건';
    }

    // ============ 차트 업데이트 ============
    let walkChartInstance = null;
    let behaviorChartInstance = null;

    function updateCharts(period) {
        const data = reportData[period];
        // 산책 차트
        const walkCtx = document.getElementById('walkChart').getContext('2d');
        if (walkChartInstance) walkChartInstance.destroy();

        walkChartInstance = new Chart(walkCtx, {
            type: 'bar',
            data: {
                labels: data.walks.map(w => w.date.substring(5)),
                datasets: [{
                    label: '거리 (km)',
                    data: data.walks.map(w => w.distance),
                    backgroundColor: 'rgba(78, 205, 196, 0.8)',
                    borderColor: 'rgba(78, 205, 196, 1)',
                    borderWidth: 2
                }, {
                    label: '시간 (분)',
                    data: data.walks.map(w => w.duration),
                    backgroundColor: 'rgba(255, 107, 107, 0.8)',
                    borderColor: 'rgba(255, 107, 107, 1)',
                    borderWidth: 2
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
                }
            }
        });
        // 행동 차트
        const behaviorCtx = document.getElementById('behaviorChart').getContext('2d');
        if (behaviorChartInstance) behaviorChartInstance.destroy();

        const behaviorTypes = {};
        data.behaviors.forEach(b => {
            behaviorTypes[b.type] = (behaviorTypes[b.type] || 0) + b.eventCount;
        });
        behaviorChartInstance = new Chart(behaviorCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(behaviorTypes),
                datasets: [{
                    data: Object.values(behaviorTypes),
                    backgroundColor: [
                        'rgba(81, 207, 102, 0.8)',
                        'rgba(151, 117, 250, 0.8)',
                        'rgba(255, 212, 59, 0.8)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom'
                    }
                }
            }
        });
    }

    // ============ LLM 리포트 업데이트 ============
    function updateLLMReport(period) {
        // 실제 구현 시 API 호출 후 DOM 업데이트 로직 필요
    }

    // ============ 페이지 로드 시 초기화 ============
    document.addEventListener('DOMContentLoaded', function () {
        updateStats(currentPeriod);
        updateCharts(currentPeriod);
    });
</script>

<style>
    /* 리포트 전용 스타일 */
    .report-stat-card {
        background: white;
        border-radius: 1rem;
        padding: 1.5rem;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .report-stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    }

    .report-stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.5rem;
        flex-shrink: 0;
    }

    .report-stat-content {
        flex: 1;
    }

    .report-stat-content h5 {
        font-size: 0.875rem;
        color: #6c757d;
        margin-bottom: 0.5rem;
        font-weight: 600;
    }

    .report-stat-value {
        font-size: 1.75rem;
        font-weight: 700;
        color: #212529;
        margin: 0;
    }

    .report-stat-change {
        font-size: 0.75rem;
        font-weight: 600;
    }

    .report-stat-change.positive {
        color: #51CF66;
    }

    .report-stat-change.neutral {
        color: #868e96;
    }

    /* LLM 리포트 스타일 */
    .llm-report-content {
        padding: 1rem 0;
    }

    .llm-report-section {
        margin-bottom: 2rem;
        padding-bottom: 1.5rem;
        border-bottom: 1px solid #e9ecef;
    }

    .llm-report-section:last-child {
        border-bottom: none;
    }

    .llm-section-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #212529;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .llm-section-title i {
        color: #FF6B6B;
    }

    .llm-report-text {
        font-size: 1rem;
        line-height: 1.8;
        color: #495057;
        margin: 0;
    }

    .llm-recommendations {
        background: #f8f9fa;
        padding: 1.5rem;
        border-radius: 1rem;
    }

    .llm-recommendation-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .llm-recommendation-list li {
        padding: 0.75rem 0;
        border-bottom: 1px solid #dee2e6;
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
    }

    .llm-recommendation-list li:last-child {
        border-bottom: none;
    }

    .llm-recommendation-list li i {
        margin-top: 0.25rem;
        font-size: 1.1rem;
    }

    .llm-recommendation-list li strong {
        color: #212529;
    }
</style>