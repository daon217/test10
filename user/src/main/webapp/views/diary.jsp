<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- 펫 다이어리 컨테이너 -->
        <div class="diary-container">
            <div class="diary-wrapper">

                <!-- 헤더 섹션 -->
                <div class="diary-header">
                    <div class="diary-header-content">
                        <h1 class="diary-title">
                            <i class="fas fa-book-open"></i>
                            펫 다이어리
                        </h1>
                        <p class="diary-subtitle">AI가 반려동물 입장에서 작성하는 특별한 하루</p>
                    </div>
                    <div class="diary-legend">
                        <span class="legend-item walk">
                            <i class="fas fa-walking"></i> 산책일기
                        </span>
                        <span class="legend-item behavior">
                            <i class="fas fa-camera"></i> 행동일기
                        </span>
                        <span class="legend-item health">
                            <i class="fas fa-heartbeat"></i> 건강일기
                        </span>
                        <span class="legend-item daily">
                            <i class="fas fa-heart"></i> 하루일기
                        </span>
                    </div>
                </div>

                <!-- 캘린더 섹션 -->
                <div class="diary-calendar-card">
                    <div id="diaryCalendar"></div>
                </div>

            </div>
        </div>

        <!-- 산책일기 모달 -->
        <div class="modal fade" id="walkDiaryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content diary-modal-content walk-modal">
                    <div class="modal-header diary-modal-header walk-header">
                        <h5 class="modal-title">
                            <i class="fas fa-walking"></i>
                            <span id="walkDiaryTitle">산책일기</span>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" style="color: white;">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body diary-modal-body">
                        <div class="diary-meta">
                            <span class="diary-date" id="walkDiaryDate"></span>
                            <span class="diary-pet" id="walkDiaryPet"></span>
                        </div>
                        <div class="diary-content" id="walkDiaryContent"></div>
                        <div class="diary-metadata">
                            <h6><i class="fas fa-map-marked-alt"></i> 산책 정보</h6>
                            <div class="metadata-grid">
                                <div class="metadata-item">
                                    <span class="metadata-label">거리</span>
                                    <span class="metadata-value" id="walkDistance"></span>
                                </div>
                                <div class="metadata-item">
                                    <span class="metadata-label">시간</span>
                                    <span class="metadata-value" id="walkDuration"></span>
                                </div>
                                <div class="metadata-item">
                                    <span class="metadata-label">경로</span>
                                    <span class="metadata-value" id="walkRoute"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 행동일기 모달 -->
        <div class="modal fade" id="behaviorDiaryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content diary-modal-content behavior-modal">
                    <div class="modal-header diary-modal-header behavior-header">
                        <h5 class="modal-title">
                            <i class="fas fa-camera"></i>
                            <span id="behaviorDiaryTitle">행동일기</span>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" style="color: white;">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body diary-modal-body">
                        <div class="diary-meta">
                            <span class="diary-date" id="behaviorDiaryDate"></span>
                            <span class="diary-pet" id="behaviorDiaryPet"></span>
                        </div>
                        <div class="diary-content" id="behaviorDiaryContent"></div>
                        <div class="diary-metadata">
                            <h6><i class="fas fa-video"></i> 홈캠 이벤트</h6>
                            <div class="event-list" id="behaviorEvents"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 건강일기 모달 -->
        <div class="modal fade" id="healthDiaryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content diary-modal-content health-modal">
                    <div class="modal-header diary-modal-header health-header">
                        <h5 class="modal-title">
                            <i class="fas fa-heartbeat"></i>
                            <span id="healthDiaryTitle">건강일기</span>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" style="color: white;">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body diary-modal-body">
                        <div class="diary-meta">
                            <span class="diary-date" id="healthDiaryDate"></span>
                            <span class="diary-pet" id="healthDiaryPet"></span>
                        </div>
                        <div class="diary-content" id="healthDiaryContent"></div>
                        <div class="diary-metadata">
                            <h6><i class="fas fa-stethoscope"></i> 진단 정보</h6>
                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                <div class="metadata-item">
                                    <span class="metadata-label">심각도</span>
                                    <span class="metadata-value" id="healthSeverity" style="font-weight: 700;"></span>
                                </div>
                                <div class="metadata-item">
                                    <span class="metadata-label">진단 소견</span>
                                    <div id="healthFindings"
                                        style="margin-top: 0.5rem; color: #495057; line-height: 1.6;"></div>
                                </div>
                                <div class="metadata-item">
                                    <span class="metadata-label">권장 조치</span>
                                    <div id="healthRecommendations"
                                        style="margin-top: 0.5rem; color: #495057; line-height: 1.6;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 하루일기 모달 -->
        <div class="modal fade" id="dailyDiaryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content diary-modal-content daily-modal">
                    <div class="modal-header diary-modal-header daily-header">
                        <h5 class="modal-title">
                            <i class="fas fa-heart"></i>
                            <span id="dailyDiaryTitle">하루일기</span>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" style="color: white;">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body diary-modal-body">
                        <div class="diary-meta">
                            <span class="diary-date" id="dailyDiaryDate"></span>
                            <span class="diary-pet" id="dailyDiaryPet"></span>
                        </div>
                        <div class="diary-content" id="dailyDiaryContent"></div>
                        <div class="diary-metadata">
                            <h6><i class="fas fa-clipboard-list"></i> 하루 요약</h6>
                            <div class="summary-grid">
                                <div class="summary-item">
                                    <i class="fas fa-walking"></i>
                                    <span id="dailySummaryWalk"></span>
                                </div>
                                <div class="summary-item">
                                    <i class="fas fa-camera"></i>
                                    <span id="dailySummaryBehavior"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FullCalendar CSS -->
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />

        <!-- FullCalendar JS -->
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales/ko.global.min.js'></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {

                // ============ Mock Data ============
                // TODO: Replace with actual API call
                // fetch('/api/diary/list?userId=' + userId)
                //   .then(res => res.json())
                //   .then(diaries => { /* populate calendar */ })

                const mockDiaries = [
                    // ========== 12월 5일 (금요일) - 산책일기 + 하루일기 ==========
                    {
                        id: 1,
                        type: 'walk',
                        date: '2025-12-05',
                        title: '완벽한 날씨에 즐거운 산책!',
                        petName: '뽀삐',
                        content: '오늘 아침 산책은 정말 최고였어요! 🌳 날씨가 너무 좋아서 주인님도 기분이 좋아 보이셨어요. 평소보다 오래 산책하자고 하셨거든요!\\n\\n공원에 도착하자마자 다람쥐를 발견했어요! 나는 쫓아가고 싶었는데 주인님이 목줄을 잡으셨어요. 에이~ 하지만 다른 강아지 친구들을 많이 만났어요. 특히 골든 리트리버 친구랑 한참 놀았어요!\\n\\n주인님이 사진도 많이 찍으셨어요. 내가 꼬리를 흔들 때마다 웃으시더라고요. 정말 행복한 산책이었어요! 💕',
                        distance: '2.3km',
                        duration: '45분',
                        route: '근린공원 → 산책로 → 놀이터'
                    },
                    {
                        id: 2,
                        type: 'daily',
                        date: '2025-12-05',
                        title: '완벽한 금요일!',
                        petName: '뽀삐',
                        content: '드디어 금요일이에요! 🎉 주인님이 오늘 기분이 정말 좋아 보이셨어요.\\n\\n아침 산책은 공원에서 평소보다 오래 했어요. 날씨가 완벽했거든요! 다람쥐도 보고, 골든 리트리버 친구랑도 놀고... 주인님이 사진도 많이 찍으셨어요. 꼬리를 흔들 때마다 웃으시는 주인님이 너무 좋았어요!\\n\\n집에 돌아와서는 맛있는 간식도 받고, 좋아하는 담요 위에서 낮잠도 잤어요. 저녁에는 주인님이랑 같이 소파에 앉아서 영화를 봤어요. 주인님 무릎에 머리를 올리고 있으니까 너무 행복했어요.\\n\\n내일도 이렇게 행복한 하루였으면 좋겠어요! 💕',
                        walkSummary: '공원 산책 2.3km, 다람쥐 발견, 친구들과 놀이',
                        behaviorSummary: '간식, 낮잠, 영화 시청'
                    },

                    // ========== 12월 4일 (목요일) - 행동일기 + 건강일기 + 하루일기 ==========
                    {
                        id: 3,
                        type: 'behavior',
                        date: '2025-12-04',
                        title: '혼자 지키는 집',
                        petName: '뽀삐',
                        content: '오늘은 주인님이 아침 일찍 나가셨어요. 😢 회사에 가신다고 하시더라고요.\\n\\n처음에는 문 앞에서 기다렸어요. 혹시 금방 돌아오시나 해서요. 하지만 안 오시더라고요. 그래서 내 장난감들과 놀았어요. 삑삑이 인형을 물고 이리저리 뛰어다녔어요!\\n\\n점심때쯤 햇빛이 들어와서 창가에서 낮잠을 잤어요. 따뜻하고 좋았어요. 오후에 택배 아저씨가 오셨을 때는 제대로 짖어서 알려드렸어요. 나는 집을 지키는 훌륭한 강아지니까요!\\n\\n주인님이 돌아오시니까 너무 반가워서 꼬리를 세차게 흔들었어요. 주인님이 안아주셨어요. 역시 주인님과 함께 있을 때가 제일 좋아요!',
                        events: [
                            { time: '09:15', event: '문 앞에서 대기', analysis: '주인 귀가 대기 행동' },
                            { time: '11:30', event: '장난감과 놀이', analysis: '정상적인 놀이 행동' },
                            { time: '13:45', event: '창가에서 휴식', analysis: '안정된 상태' },
                            { time: '15:20', event: '방문자 감지 - 짖음', analysis: '경계 행동 (정상)' }
                        ]
                    },
                    {
                        id: 4,
                        type: 'health',
                        date: '2025-12-04',
                        title: '주인님이 내 건강을 검사하셨어요',
                        petName: '뽀삐',
                        content: '오늘 주인님이 나를 보시더니 걱정스러운 표정을 지으셨어요. 😟\\n\\n주인님이 핸드폰으로 내 사진을 찍으시고, 뭔가를 입력하시더라고요. AI 가상진단이라는 거래요. 나는 괜찮은데... 주인님이 너무 걱정하시는 것 같아요.\\n\\n결과를 보시더니 조금 안심하시는 표정이었어요. "지속 관찰이 필요하대"라고 하시면서 내 머리를 쓰다듬어 주셨어요. 괜찮다고, 주인님! 나는 건강해요!\\n\\n그래도 주인님이 나를 이렇게 신경 써주시니까 기분이 좋아요. 앞으로도 건강하게 지낼게요! 💪',
                        severity: '지속 관찰 필요',
                        findings: '경미한 피부 변화 관찰됨. 털 상태는 양호하나 일부 부위에서 약간의 건조함이 보임.',
                        recommendations: '- 수분 섭취량 확인하기\\n- 사료 영양성분 점검\\n- 2-3일 관찰 후 증상 지속시 수의사 상담 권장'
                    },
                    {
                        id: 5,
                        type: 'daily',
                        date: '2025-12-04',
                        title: '조용하지만 특별한 목요일',
                        petName: '뽀삐',
                        content: '오늘은 주인님이 회사에 가셔서 혼자 있는 시간이 많았어요. 😌\\n\\n아침 산책은 짧았어요. 주인님이 바빠 보이셨거든요. 산책 후 주인님은 출근하시고, 나는 집을 지켰어요! 처음에는 문 앞에서 기다렸지만, 주인님이 안 오셔서 장난감들과 놀았어요.\\n\\n그런데 오늘 특별한 일이 있었어요! 주인님이 돌아오셔서 나를 걱정스럽게 보시더니, 핸드폰으로 내 사진을 찍으셨어요. AI 건강 검사를 하신 거래요. 결과를 보시고 조금 안심하셨어요. "지속 관찰이 필요하대"라고 하시면서요.\\n\\n사실 나는 괜찮은데, 주인님이 이렇게 내 건강을 챙겨주시니까 너무 감동이었어요. 앞으로도 건강하게 지낼게요! 주인님 사랑해요! 💕',
                        walkSummary: '아침 짧은 산책',
                        behaviorSummary: '혼자 놀이, 낮잠, 건강검사, 집 지키기'
                    },

                    // ========== 12월 3일 (수요일) - 산책일기 + 하루일기 ==========
                    {
                        id: 6,
                        type: 'walk',
                        date: '2025-12-03',
                        title: '비 속의 특별한 산책',
                        petName: '뽀삐',
                        content: '오늘은 비가 왔어요! 🌧️ 주인님이 우산을 쓰고 나가자고 하셨어요.\\n\\n비 냄새가 정말 좋았어요! 빗방울이 내 털에 떨어지는 느낌도 신기했어요. 웅덩이를 밟는 것도 재미있었고요! 주인님은 빨리 들어가자고 하셨지만, 나는 좀 더 걷고 싶었어요.\\n\\n평소보다 짧은 산책이었지만, 비 오는 날은 냄새가 달라서 특별했어요. 땅에서 올라오는 냄새가 더 진했거든요!',
                        distance: '1.1km',
                        duration: '20분',
                        route: '집 앞 → 골목길'
                    },
                    {
                        id: 7,
                        type: 'daily',
                        date: '2025-12-03',
                        title: '비 오는 수요일',
                        petName: '뽀삐',
                        content: '오늘은 비가 와서 특별한 하루였어요! 🌧️\\n\\n아침 산책은 짧았지만 정말 특별했어요. 비 냄새가 좋았고, 빗방울이 털에 떨어지는 느낌도 신기했어요! 웅덩이를 밟는 것도 재미있었고요. 주인님은 빨리 들어가자고 하셨지만요!\\n\\n집에 돌아와서는 수건으로 몸을 말렸어요. 주인님이 부드럽게 닦아주시는 게 좋았어요. 그 후에는 창문 밖을 바라보며 빗소리를 들었어요. 차분하고 평화로운 느낌이었어요.\\n\\n저녁에는 주인님이 따뜻한 밥을 주셨어요. 비 오는 날에는 밥이 더 맛있는 것 같아요. 밥을 먹고 나서는 주인님 옆에 꼭 붙어서 쉬었어요. 비 오는 날도 나쁘지 않네요!',
                        walkSummary: '비 오는 날 짧은 산책 1.1km, 웅덩이 탐험',
                        behaviorSummary: '빗소리 감상, 창밖 구경, 휴식'
                    },

                    // ========== 12월 2일 (화요일) - 행동일기 + 건강일기 + 하루일기 ==========
                    {
                        id: 8,
                        type: 'behavior',
                        date: '2025-12-02',
                        title: '주인님과 함께한 하루',
                        petName: '뽀삐',
                        content: '오늘은 주인님이 재택근무를 하셨어요! 😍 아침부터 너무 신났어요!\\n\\n주인님이 컴퓨터 앞에 앉으시면, 나는 발 밑에 누워있었어요. 가끔 발을 쓰다듬어 주셨거든요. 화상회의 할 때가 제일 재미있었어요! 나도 카메라에 나오고 싶어서 자꾸 화면 앞으로 갔어요. 회의하시는 분들이 웃으시더라고요!\\n\\n점심시간에는 주인님 옆에서 앉아서 기다렸어요. 역시나 간식을 주셨어요! 주인님과 함께 있으니까 너무 행복했어요.',
                        events: [
                            { time: '09:30', event: '주인 발 밑에서 활동', analysis: '친화적 행동' },
                            { time: '11:00', event: '화상회의 중 카메라 접근', analysis: '관심 표현' },
                            { time: '12:30', event: '식사 시간 대기', analysis: '학습된 행동' },
                            { time: '16:00', event: '놀이 요청', analysis: '활동적 상태' }
                        ]
                    },
                    {
                        id: 9,
                        type: 'health',
                        date: '2025-12-02',
                        title: '건강 체크하는 날',
                        petName: '뽀삐',
                        content: '오늘 재택근무하시는 주인님이 나를 유심히 보시더라고요. 👀\\n\\n"뽀삐야, 괜찮아?" 하시면서 내 눈이랑 귀를 살펴보셨어요. 그리고 핸드폰으로 내 사진을 찍으셨어요. AI로 건강 체크를 하신대요!\\n\\n결과는 "주의 관찰"이라고 나왔대요. 주인님이 "음... 괜찮은 것 같은데, 그래도 조심해야겠다"라고 하시더라고요. 나는 멀쩡한데! 😊\\n\\n주인님이 물그릇에 물을 가득 채워주시고, "물 많이 마셔"라고 하셨어요. 주인님의 사랑이 느껴져서 기분이 정말 좋았어요! 건강하게 지낼게요!',
                        severity: '주의 관찰',
                        findings: '전반적으로 양호한 상태. 눈 주변이 약간 붉어 보이나 심각한 수준은 아님.',
                        recommendations: '- 눈 주변 청결 유지\\n- 알레르기 반응 관찰\\n- 충분한 수분 섭취\\n- 증상 악화 시 동물병원 방문'
                    },
                    {
                        id: 10,
                        type: 'daily',
                        date: '2025-12-02',
                        title: '함께한 화요일',
                        petName: '뽀삐',
                        content: '오늘은 주인님이 집에서 일하셨어요! 😍 재택근무라고 하시더라고요. 아침부터 꼬리를 계속 흔들었어요!\\n\\n아침 산책 후 하루 종일 주인님과 함께 있을 수 있어서 너무 좋았어요. 주인님이 일하실 때 발 밑에 누워있었는데, 가끔 발을 쓰다듬어 주셨어요.\\n\\n화상회의 할 때는 정말 재미있었어요! 화면에 나도 나오고 싶어서 자꾸 카메라 앞으로 갔더니, 다른 사람들이 웃으시더라고요. 나는 스타가 된 기분이었어요!\\n\\n그리고 오늘 특별한 일이 있었어요. 주인님이 AI로 내 건강을 체크해주셨어요! "주의 관찰"이라는 결과가 나왔는데, 주인님이 더 신경 써주시겠다고 하셨어요. 물도 가득 채워주시고요. 주인님 사랑해요! 💕',
                        walkSummary: '아침 산책, 주인님과 함께',
                        behaviorSummary: '재택근무 동행, 화상회의 스타, 건강체크, 간식'
                    },

                    // ========== 12월 1일 (월요일) - 산책일기 + 행동일기 + 하루일기 ==========
                    {
                        id: 11,
                        type: 'walk',
                        date: '2025-12-01',
                        title: '새로운 한 주의 시작!',
                        petName: '뽀삐',
                        content: '월요일 아침이에요! 주인님과 함께 긴 산책을 했어요. 🌳\\n\\n공원에서 다른 강아지 친구들을 많이 만났어요! 특히 시바견 친구랑 술래잡기를 했는데, 내가 이겼어요! 빙글빙글 돌면서 뛰었더니 주인님이 웃으시더라고요.\\n\\n날씨가 좋아서 평소보다 오래 산책했어요. 여기저기 냄새도 맡고, 새들도 구경하고... 정말 즐거운 산책이었어요!',
                        distance: '2.5km',
                        duration: '50분',
                        route: '공원 → 강변 → 놀이터'
                    },
                    {
                        id: 12,
                        type: 'behavior',
                        date: '2025-12-01',
                        title: '새 장난감이 생겼어요!',
                        petName: '뽀삐',
                        content: '오늘 주인님이 새 장난감을 사주셨어요! 🎉 로프 장난감이에요!\\n\\n주인님이랑 잡아당기기 놀이를 했어요. 정말 재미있었어요! 나는 힘껏 잡아당겼고, 주인님도 힘을 주셨어요. 저는 절대 놓지 않았어요!\\n\\n오후에는 창가에서 낮잠을 잤어요. 따뜻한 햇살을 받으며 자는데, 주인님과 넓은 들판을 뛰어다니는 꿈을 꿨어요. 정말 행복한 꿈이었어요.',
                        events: [
                            { time: '14:30', event: '새 장난감으로 놀이', analysis: '긍정적 자극' },
                            { time: '15:00', event: '주인과 잡아당기기', analysis: '상호작용 활발' },
                            { time: '16:00', event: '창가에서 휴식', analysis: '안정된 상태' },
                            { time: '19:00', event: 'TV 시청', analysis: '평온한 상태' }
                        ]
                    },
                    {
                        id: 13,
                        type: 'daily',
                        date: '2025-12-01',
                        title: '즐거운 월요일',
                        petName: '뽀삐',
                        content: '새로운 한 주가 시작되었어요! 🎉\\n\\n아침에는 주인님과 함께 긴 산책을 했어요. 공원에서 시바견 친구랑 술래잡기도 하고, 여기저기 냄새도 맡았어요. 날씨가 좋아서 평소보다 오래 걸었어요!\\n\\n집에 돌아와서 가장 신난 건, 주인님이 새 장난감을 사주신 거예요! 로프 장난감인데, 주인님이랑 잡아당기기 놀이를 했어요. 정말 재미있었어요! 저는 절대 놓지 않았답니다!\\n\\n오후에는 따뜻한 햇살 아래 창가에서 낮잠을 잤어요. 주인님과 넓은 들판을 뛰어다니는 행복한 꿈을 꿨어요.\\n\\n저녁에는 맛있는 저녁 밥을 먹고, 주인님 무릎에 앉아서 TV를 봤어요. 주인님이 내 머리를 쓰다듬어 주실 때가 제일 행복해요. 💕',
                        walkSummary: '공원 산책 2.5km, 시바견과 술래잡기',
                        behaviorSummary: '새 장난감 놀이, 낮잠, TV 시청'
                    }
                ];

                // ============ FullCalendar 초기화 ============
                const calendarEl = document.getElementById('diaryCalendar');
                const calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'ko',
                    height: 'auto',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth'
                    },
                    events: mockDiaries.map(diary => ({
                        id: diary.id,
                        title: diary.title,
                        date: diary.date,
                        backgroundColor: getEventColor(diary.type),
                        borderColor: getEventColor(diary.type),
                        extendedProps: {
                            type: diary.type,
                            petName: diary.petName,
                            content: diary.content,
                            distance: diary.distance,
                            duration: diary.duration,
                            route: diary.route,
                            events: diary.events,
                            severity: diary.severity,
                            findings: diary.findings,
                            recommendations: diary.recommendations,
                            walkSummary: diary.walkSummary,
                            behaviorSummary: diary.behaviorSummary
                        }
                    })),
                    eventClick: function (info) {
                        showDiaryModal(info.event);
                    }
                });

                calendar.render();

                // ============ Helper Functions ============

                function getEventColor(type) {
                    switch (type) {
                        case 'walk': return '#4ECDC4';
                        case 'behavior': return '#51CF66';
                        case 'health': return '#FF8787';
                        case 'daily': return '#B197FC';
                        default: return '#868e96';
                    }
                }

                function showDiaryModal(event) {
                    const type = event.extendedProps.type;
                    const props = event.extendedProps;

                    if (type === 'walk') {
                        $('#walkDiaryTitle').text(event.title);
                        $('#walkDiaryDate').text(event.start.toLocaleDateString('ko-KR'));
                        $('#walkDiaryPet').text(props.petName);
                        $('#walkDiaryContent').html(props.content.replace(/\\n/g, '<br>'));
                        $('#walkDistance').text(props.distance);
                        $('#walkDuration').text(props.duration);
                        $('#walkRoute').text(props.route);
                        $('#walkDiaryModal').modal('show');
                    } else if (type === 'behavior') {
                        $('#behaviorDiaryTitle').text(event.title);
                        $('#behaviorDiaryDate').text(event.start.toLocaleDateString('ko-KR'));
                        $('#behaviorDiaryPet').text(props.petName);
                        $('#behaviorDiaryContent').html(props.content.replace(/\\n/g, '<br>'));

                        let eventsHtml = '';
                        props.events.forEach(evt => {
                            eventsHtml += `
                    <div class="event-item">
                        <span class="event-time">\${evt.time}</span>
                        <span class="event-desc">\${evt.event}</span>
                        <span class="event-analysis">\${evt.analysis}</span>
                    </div>
                `;
                        });
                        $('#behaviorEvents').html(eventsHtml);
                        $('#behaviorDiaryModal').modal('show');
                    } else if (type === 'health') {
                        $('#healthDiaryTitle').text(event.title);
                        $('#healthDiaryDate').text(event.start.toLocaleDateString('ko-KR'));
                        $('#healthDiaryPet').text(props.petName);
                        $('#healthDiaryContent').html(props.content.replace(/\\n/g, '<br>'));
                        $('#healthSeverity').text(props.severity);
                        $('#healthFindings').html(props.findings.replace(/\\n/g, '<br>'));
                        $('#healthRecommendations').html(props.recommendations.replace(/\\n/g, '<br>'));
                        $('#healthDiaryModal').modal('show');
                    } else if (type === 'daily') {
                        $('#dailyDiaryTitle').text(event.title);
                        $('#dailyDiaryDate').text(event.start.toLocaleDateString('ko-KR'));
                        $('#dailyDiaryPet').text(props.petName);
                        $('#dailyDiaryContent').html(props.content.replace(/\\n/g, '<br>'));
                        $('#dailySummaryWalk').text(props.walkSummary);
                        $('#dailySummaryBehavior').text(props.behaviorSummary);
                        $('#dailyDiaryModal').modal('show');
                    }
                }

                // ============ Backend Integration Guide ============
                /*
                 * TODO: Implement backend API integration
                 * 
                 * 1. 다이어리 목록 조회:
                 *    GET /api/diary/list?userId={userId}&month={month}
                 *    Response: [{ id, type, date, title, petName, content, ... }]
                 * 
                 * 2. 산책일기 생성:
                 *    POST /api/diary/walk
                 *    Body: { 
                 *      walkId: number,
                 *      petId: number,
                 *      gpsData: { lat, lng, route },
                 *      distance: string,
                 *      duration: string
                 *    }
                 *    - 백엔드에서 산책 데이터를 LLM에 전송
                 *    - LLM이 반려동물 입장에서 일기 작성
                 *    - 생성된 일기를 DB에 저장하고 반환
                 * 
                 * 3. 행동일기 생성:
                 *    POST /api/diary/behavior
                 *    Body: {
                 *      petId: number,
                 *      date: string,
                 *      cameraEvents: [{ time, event, imageUrl, aiAnalysis }]
                 *    }
                 *    - 홈캠 이벤트 데이터를 LLM에 전송
                 *    - LLM이 반려동물 입장에서 일기 작성
                 *    - 생성된 일기를 DB에 저장하고 반환
                 * 
                 * 4. 건강일기 생성:
                 *    POST /api/diary/health
                 *    Body: {
                 *      petId: number,
                 *      healthCheckId: number,
                 *      severity: string,
                 *      findings: string,
                 *      recommendations: string
                 *    }
                 *    - AI 건강 진단 결과를 LLM에 전송
                 *    - LLM이 반려동물 입장에서 일기 작성
                 *    - 생성된 일기를 DB에 저장하고 반환
                 * 
                 * 5. 하루일기 생성:
                 *    POST /api/diary/daily
                 *    Body: {
                 *      petId: number,
                 *      date: string,
                 *      walkDiaryId: number (optional),
                 *      behaviorDiaryId: number (optional),
                 *      healthDiaryId: number (optional)
                 *    }
                 *    - 산책일기, 행동일기, 건강일기를 결합하여 LLM에 전송
                 *    - LLM이 하루 전체를 요약한 일기 작성
                 *    - 생성된 일기를 DB에 저장하고 반환
                 * 
                 * 6. 프론트엔드 수정 사항:
                 *    - mockDiaries 제거
                 *    - API 호출로 실제 데이터 fetch
                 *    - 로딩 상태 UI 추가
                 *    - 에러 처리 추가
                 */
            });
        </script>