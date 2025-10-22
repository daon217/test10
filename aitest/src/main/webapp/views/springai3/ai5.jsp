<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let ai5 = {
        init: function() {
            // 마이크 초기 상태 설정 (페이지 로드 시 음성 인식 대기)
            this.startVoiceQuestion();

            // 텍스트 입력 버튼 이벤트 설정
            $('#sendText').click(() => this.sendText());
            $('#textInput').keypress((e) => {
                if (e.which === 13 && !e.shiftKey) { // Enter 키 입력 시
                    this.sendText();
                    return false;
                }
            });

            $('#spinner').css('visibility', 'hidden');
        },

        // 음성 입력 시작 (마이크 초기화)
        startVoiceQuestion: function() {
            springai.voice.initMic(this);
            $('#status').html(this.makeVoiceStatusUI('음성으로 만들고자 하는 이미지를 설명하세요.'));
        },

        // 음성 상태 UI 생성
        makeVoiceStatusUI: function(message) {
            return `
                <div class="media border p-3">
                   <div class="speakerPulse"
                      style="width: 30px; height: 30px;
                      background: url('/image/speaker-yellow.png') no-repeat center center / contain;"></div>${message}
                </div>
            `;
        },

        // 텍스트 입력 처리 함수 (새로 추가된 기능)
        sendText: async function() {
            const question = $('#textInput').val().trim();
            if (!question) return;

            // 음성 입력 중지 (텍스트 입력 우선)
            if (springai.voice.mediaRecorder && springai.voice.mediaRecorder.state === 'recording') {
                springai.voice.mediaRecorder.stop();
                springai.voice.recognition.stop();
            }

            // UI 업데이트
            this.displayUserMessage(question, "텍스트 설명");
            $('#textInput').val('');
            $('#spinner').css('visibility', 'visible');
            $('#status').html('<p class="text-info">텍스트 설명을 받아 이미지 생성 시작...</p>');

            // 1. 이미지 생성 요청
            const generatedImageUUID = this.makeAssistantUI('이미지 생성 중...');
            await this.generateImage(question, generatedImageUUID);

            // 2. 이미지 설명 요청 (텍스트 질문으로 chat-text 호출)
            const explanationUUID = this.makeAssistantUI('생성된 이미지 설명 분석 중...');
            await this.getExplanation(question, explanationUUID);

            $('#spinner').css('visibility', 'hidden');
            this.startVoiceQuestion(); // 다시 음성 입력 대기 상태로 복귀
        },

        // 음성 녹음 완료 후 처리 (STT 및 이미지 생성, 설명)
        handleVoice: async function(mp3Blob) {
            $('#spinner').css('visibility', 'visible');
            $('#status').html('<p class="text-info">음성 인식을 위해 서버에 전송 중...</p>');

            // 1. STT (음성 -> 텍스트) 요청
            const formData = new FormData();
            formData.append("speech", mp3Blob, 'speech.mp3');

            const sttResponse = await fetch("/ai3/stt", {
                method: "post",
                headers: { 'Accept': 'text/plain' },
                body: formData
            });
            const questionText = await sttResponse.text();

            this.displayUserMessage(questionText, "음성 설명");

            // 2. 이미지 생성 요청
            const generatedImageUUID = this.makeAssistantUI('이미지 생성 중...');
            await this.generateImage(questionText, generatedImageUUID);

            // 3. 이미지 설명 요청
            const explanationUUID = this.makeAssistantUI('생성된 이미지 설명 분석 중...');
            await this.getExplanation(questionText, explanationUUID);

            $('#spinner').css('visibility', 'hidden');
            this.startVoiceQuestion(); // 다음 음성 입력 대기
        },

        // 이미지 생성 및 화면 표시
        generateImage: async function(question, targetUUID) {
            const response = await fetch('/ai3/image-generate', {
                method: "post",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ question })
            });

            const b64Json = await response.text();
            let html = '';

            if (!b64Json.includes("Error")) {
                const base64Src = "data:image/png;base64," + b64Json;
                html = `
                    <div class="p-3 my-2 border bg-light">
                        <img src="${base64Src}" class="img-fluid" alt="Generated Image" />
                        <p class="mt-2"><a href="${base64Src}" download="generated-${new Date().getTime()}.png" class="btn btn-sm btn-success">이미지 다운로드</a></p>
                    </div>
                `;
            } else {
                html = `<div class="alert alert-danger">이미지 생성 실패: ${b64Json}</div>`;
            }
            $('#' + targetUUID).html(html);
        },

        // 생성된 이미지에 대한 설명 요청 및 화면 표시 (버그 수정: 프롬프트 명시적 지정)
        getExplanation: async function(questionText, targetUUID) {
            // **문제 해결:** AI가 '그림 그릴 수 없다'는 답변을 피하고, 이미지를 설명하도록 프롬프트 수정
            // 기존 이미지 생성 요청(`questionText`)을 포함하여 AI의 역할을 '보조 역할'로 명시
            const newQuestion = `당신은 이미지 생성 AI의 보조 역할입니다. 사용자가 "${questionText}"라는 요청으로 이미지를 생성했습니다. 당신은 생성된 이미지에 대해 친절하게 설명해주세요. 그림을 그릴 수 없다는 말은 하지 말고, 사용자의 요청을 바탕으로 생성된 이미지를 설명하세요.`;

            const response = await fetch("/ai3/chat-text", {
                method: "post",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
                body: new URLSearchParams({ question: newQuestion })
            });

            const answerJson = await response.json();
            const textExplanation = answerJson.text || "설명을 가져오지 못했습니다.";

            const html = `<div class="p-3 my-2 border bg-light">
                            <strong>[AI 설명]:</strong> <p>${textExplanation}</p>
                          </div>`;
            $('#' + targetUUID).html(html);
        },

        // 사용자 메시지 UI 표시
        displayUserMessage: function(msg, type) {
            const escapedMsg = msg.replace(/</g, '&lt;').replace(/>/g, '&gt;');
            const qForm = `<div class="media border p-3"><img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;"><div class="media-body"><h6>고객 (${type})</h6><p>${escapedMsg}</p></div></div>`;
            $('#result').prepend(qForm);
        },

        // AI 응답 컨테이너 UI 생성
        makeAssistantUI: function(initialMessage) {
            const uuid = 'id-' + crypto.randomUUID();
            const aForm = `<div class="media border p-3"><div class="media-body"><h6>AI 응답</h6><div id="${uuid}"><span class="spinner-border spinner-border-sm"></span> ${initialMessage}</div></div><img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;"></div>`;
            $('#result').prepend(aForm);
            return uuid;
        }
    };

    $(() => {
        ai5.init();
    });
</script>


<div class="col-sm-10">
    <h2>Spring AI 5 - 음성/텍스트 이미지 생성기</h2>
    <p class="text-muted">원하는 이미지를 **텍스트로 입력**하거나 **음성으로 설명**하면, AI가 이미지를 생성하고 생성된 이미지에 대한 설명을 제공합니다.</p>

    <div class="row mb-2">
        <div class="col-sm-8">
            <textarea id="textInput" class="form-control" rows="3" placeholder="예: 구름 위를 걷는 고양이 로봇을 그려줘."></textarea>
        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-primary" id="sendText">텍스트로 생성</button>
        </div>
        <div class="col-sm-2">
            <button class="btn btn-primary" disabled >
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                Loading..
            </button>
        </div>
    </div>

    <div id="status" class="mb-3">
    </div>


    <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 500px;">
    </div>

</div>