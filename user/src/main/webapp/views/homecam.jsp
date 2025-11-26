<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="homecam-wrapper">
    <div class="container">
        <div class="row align-items-start">
            <div class="col-lg-7 mb-4">
                <div class="camera-card shadow-sm">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <div class="eyebrow">AI 홈캠 분석</div>
                            <h3 class="mb-0">실시간 재난·위험 감지</h3>
                        </div>
                        <div class="status-group text-right">
                            <span id="camera-status" class="status-badge">카메라 준비 중</span>
                            <span id="ai-status" class="status-badge neutral">AI 대기</span>
                        </div>
                    </div>

                    <div class="video-shell">
                        <video id="homecam-video" autoplay playsinline muted></video>
                        <div id="homecam-overlay" class="video-overlay">
                            <div class="overlay-content">
                                <div class="overlay-pulse"></div>
                                <p id="analysis-overlay-text" class="mb-1">카메라 초기화 중...</p>
                                <small>화면은 저장되지 않고 분석에만 사용됩니다.</small>
                            </div>
                        </div>
                    </div>

                    <div class="control-bar d-flex align-items-center">
                        <div class="control-left">
                            <button id="analysis-toggle" class="btn btn-pet-primary btn-sm" data-running="true">
                                <i class="fas fa-pause-circle mr-1"></i> 분석 일시정지
                            </button>
                            <button id="manual-capture" class="btn btn-outline-secondary btn-sm ml-2">
                                <i class="fas fa-bolt mr-1"></i> 즉시 분석
                            </button>
                        </div>
                        <div class="control-right">
                            <div class="question-input">
                                <label for="analysis-question" class="mb-0">분석 지시문</label>
                                <input id="analysis-question" type="text" class="form-control form-control-sm"
                                       value="연기, 화재, 붕괴, 폭발, 쓰러짐, 반려동물 위험 징후가 보이면 신고 근거를 설명하고 alert로 표시. 이상 없으면 NO_DISASTER_DETECTED만 답변"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5 mb-4">
                <div class="analysis-card shadow-sm">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <div class="eyebrow">AI 모니터링</div>
                            <h3 class="mb-0">실시간 분석 리포트</h3>
                        </div>
                        <span id="risk-indicator" class="risk-chip safe">안정</span>
                    </div>

                    <div class="analysis-highlight" id="alert-highlight">
                        <div class="highlight-label">최근 이벤트</div>
                        <h4 id="highlight-title">정상 상태</h4>
                        <p id="highlight-desc" class="mb-0">반려동물과 공간에 이상이 발견되지 않았어요.</p>
                    </div>

                    <div class="analysis-feed">
                        <div class="feed-header d-flex justify-content-between align-items-center">
                            <span>AI 스트리밍 로그</span>
                            <span class="feed-meta"><i class="fas fa-sync-alt mr-1"></i>20초마다 자동 분석</span>
                        </div>
                        <ul id="analysis-log" class="analysis-log mb-0">
                            <li class="placeholder">AI가 프레임을 수집하는 중입니다...</li>
                        </ul>
                    </div>

                    <div class="notice-box">
                        <i class="fas fa-shield-alt mr-2"></i>
                        영상은 저장되지 않으며, AI 분석과 긴급 알림 시뮬레이션에만 사용됩니다.
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>