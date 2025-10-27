<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap 4 Website Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>

    <script src="https://cdn.jsdelivr.net/npm/lamejs@1.2.0/lame.min.js"></script>

    <link href="/css/springai.css" rel="stylesheet" />
    <script src="/js/springai.js"></script>
    <style>
        .fakeimg {
            height: 200px;
            background: #aaa;
        }
        /* 음성 명령 아이콘 */
        .voice-nav-icon {
            width: 30px;
            height: 30px;
            cursor: pointer;
            display: inline-block;
            background: url('/image/speaker-green.png') no-repeat center center / contain;
        }
    </style>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
    <h1>SpringAI System</h1>
</div>
<ul class="nav justify-content-end">
    <li class="nav-item">
        <a class="nav-link" href="<c:url value="/register"/> ">Register</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="<c:url value="/login"/>">Login</a>
    </li>
    <%-- 음성 명령 아이콘 및 스피너 추가 --%>
    <li class="nav-item p-2 d-flex align-items-center">
        <div id="voice-nav-icon" class="voice-nav-icon speakerPulse"></div>
        <span id="voice-nav-spinner" class="spinner-border spinner-border-sm ml-2" style="display: none;"></span>
    </li>
</ul>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
    <a class="navbar-brand" href="<c:url value="/"/>">Home</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai1"/>">SrpingAi1</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai2"/>">SrpingAi2</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai3"/>">SrpingAi3</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai4"/>">SrpingAi4</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai5"/>">SrpingAi5</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container" style="margin-top:30px; margin-bottom: 30px;">
    <div class="row">
        <%-- Left Menu Start ........  --%>
        <c:choose>
            <c:when test="${left == null}">
                <jsp:include page="left.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${left}.jsp"/>
            </c:otherwise>
        </c:choose>

        <%-- Left Menu End ........  --%>
        <c:choose>
            <c:when test="${center == null}">
                <jsp:include page="center.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${center}.jsp"/>
            </c:otherwise>
        </c:choose>
        <%-- Center Start ........  --%>

        <%-- Center End ........  --%>
    </div>
</div>

<div class="text-center" style="background-color:black;
color: white; margin-bottom:0; max-height: 50px;">
    <p>Footer</p>
</div>

</body>

<c:if test="${activateVoiceNav == true}">
    <script>
        let voiceNav = {
            init: function() {
                // 초기 마이크 활성화 및 UI 설정
                this.startVoiceQuestion();
            },
            // 마이크 활성화 및 UI 설정
            startVoiceQuestion: function() {
                springai.voice.initMic(this);
                springai.voice.controlSpeakerAnimation('voice-nav-icon', true);
                $('#voice-nav-spinner').hide();
            },
            // 음성 녹음 완료 후 처리 (STT 및 내비게이션)
            handleVoice: async function(mp3Blob){

                // --- 디버깅용 텍스트 프롬프트 코드 제거 (원래 STT 로직 복원) ---
                springai.voice.controlSpeakerAnimation('voice-nav-icon', false);
                $('#voice-nav-spinner').show();

                // 1. STT (음성 -> 텍스트) 요청
                const formData = new FormData();
                formData.append("speech", mp3Blob, 'speech.mp3'); // Blob 에러가 발생하지 않도록 mp3Blob 사용

                const sttResponse = await fetch("/ai3/stt", {
                    method: "post",
                    headers: { 'Accept': 'text/plain' },
                    body: formData
                });
                const questionText = await sttResponse.text();

                // --- 디버깅 로그 유지 ---
                console.log("[VoiceNav Debug] 1. STT 결과 (questionText):", questionText);
                // -----------------------

                // 2. AI에게 명령을 분석하고 타겟 URL 요청
                const navResponse = await fetch("/ai3/target", {
                    method: "post",
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'text/plain'
                    },
                    body: new URLSearchParams({ questionText: questionText })
                });
                const targetUrl = (await navResponse.text()).trim();

                // --- 디버깅 로그 유지 ---
                console.log("[VoiceNav Debug] 2. AI 분석 결과 (targetUrl):", targetUrl);
                // -----------------------

                if (targetUrl && targetUrl !== "") {
                    console.log("[VoiceNav Debug] 3. 유효한 URL 확인. 페이지 이동 명령 실행:", targetUrl);
                    // 3. 페이지 이동
                    window.location.href = targetUrl;
                } else {
                    console.log("[VoiceNav Debug] 3. URL이 유효하지 않아 페이지 이동 실패. 재대기.");
                    // 이동 명령 실패 시, 다시 음성 대기 상태로 복귀
                    this.startVoiceQuestion();
                }
            }
        };

        $(() => {
            voiceNav.init();
        });
    </script>
</c:if>

</html>