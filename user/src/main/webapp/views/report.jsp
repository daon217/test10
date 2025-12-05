<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mypage.css'/>">

<!-- 행동 리포트 컨테이너 -->
<div class="mypage-container">
    <div class="mypage-wrapper">

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

<script src="<c:url value='/js/mypage.js'/>"></script>
