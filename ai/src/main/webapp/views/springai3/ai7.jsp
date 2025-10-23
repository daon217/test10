<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
    let ai6 = {
        // 주기적 분석을 위한 인터벌 변수
        analysisInterval: null,
        // AI에 보낼 고정 질문
        ANALYSIS_QUESTION: "영상의 상황이 어떤 상황인지 자세히 설명해주세요. 현재 시각도 언급해 주세요.",
        // 분석 주기 (60000ms = 1분)
        ANALYSIS_INTERVAL_MS: 60000,
        // 분석 실행 상태
        isAnalysisRunning: false,

        init:function(){
            this.previewCamera('video');
            $('#startAnalysis').click(() => this.startAnalysisLoop());
            $('#stopAnalysis').click(() => this.stopAnalysisLoop());
            this.updateButtonState(false); // 초기 상태는 중지
        },

        // 버튼 상태를 업데이트하는 유틸리티 함수
        updateButtonState: function(isRunning) {
            this.isAnalysisRunning = isRunning;
            if (isRunning) {
                $('#startAnalysis').prop('disabled', true).text('분석 실행 중...');
                $('#stopAnalysis').prop('disabled', false).text('분석 중지');
                $('#statusMessage').text('분석 주기: 1분마다. 다음 분석을 기다리는 중입니다.');
            } else {
                $('#startAnalysis').prop('disabled', false).text('분석 시작');
                $('#stopAnalysis').prop('disabled', true).text('분석 중지');
                $('#statusMessage').text('분석을 시작하려면 "분석 시작" 버튼을 누르세요.');
            }
        },

        startAnalysisLoop: function() {
            if (this.isAnalysisRunning) return;

            // 기존 인터벌이 있다면 중지 (안전 장치)
            if (this.analysisInterval) {
                clearInterval(this.analysisInterval);
            }

            this.updateButtonState(true); // 버튼 상태: 실행 중

            // 최초 실행 (버튼 누르자마자 한 번 실행)
            this.captureFrame("video", (pngBlob) => {
                if (pngBlob) this.send(pngBlob);
            });

            // 주기적인 캡처 및 전송 시작
            this.analysisInterval = setInterval(() => {
                this.captureFrame("video", (pngBlob) => {
                    if (pngBlob) {
                        this.send(pngBlob);
                    }
                });
            }, this.ANALYSIS_INTERVAL_MS);
        },

        stopAnalysisLoop: function() {
            if (!this.isAnalysisRunning) return;

            clearInterval(this.analysisInterval);
            this.analysisInterval = null;
            this.updateButtonState(false); // 버튼 상태: 중지됨
        },

        previewCamera:function(videoId){
            const video = document.getElementById(videoId);
            //카메라를 활성화하고 <video>에서 보여주기
            navigator.mediaDevices.getUserMedia({ video: true })
                .then((stream) => {
                    video.srcObject = stream;
                    video.play();
                })
                .catch((error) => {
                    console.error('카메라 접근 에러:', error);
                    $('#statusMessage').text('⚠️ 카메라 접근에 실패했습니다. (에러: ' + error.name + ')');
                });
        },
        captureFrame:function(videoId, handleFrame){
            const video = document.getElementById(videoId);
            //캔버스를 생성해서 비디오 크기와 동일하게 맞춤
            const canvas = document.createElement('canvas');
            // 비디오가 로드되지 않았을 경우 캡처하지 않음
            if (video.videoWidth === 0 || video.videoHeight === 0) {
                handleFrame(null);
                return;
            }

            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;

            // 캔버스로부터  2D로 드로잉하는 Context를 얻어냄
            const context = canvas.getContext('2d');
            // 비디오 프레임을 캔버스에 드로잉
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            // 드로잉된 프레임을 PNG 포맷의 blob 데이터로 얻기
            canvas.toBlob((blob) => {
                handleFrame(blob);
            }, 'image/png');
        },
        send: async function(pngBlob){
            if (!this.isAnalysisRunning) return; // 중지 상태라면 요청 보내지 않음

            // 분석 요청이 시작됨을 UI로 알림
            const tempUUID = 'temp-' + crypto.randomUUID();
            this.displayTempMessage("이미지 분석 및 텍스트 생성 중...", tempUUID);


            // 멀티파트 폼 구성하기
            const formData = new FormData();
            formData.append("question", this.ANALYSIS_QUESTION);
            formData.append('attach', pngBlob, 'frame.png');

            // 1. 이미지 분석 스트림 요청 및 결과 수집
            const analysisResponse = await fetch('/ai3/image-analysis', {
                method: "post",
                headers: {
                    'Accept': 'application/x-ndjson'
                },
                body: formData
            });

            const reader = analysisResponse.body.getReader();
            const decoder = new TextDecoder("utf-8");
            let content = "";

            // 결과 표시를 위한 새로운 UI 생성
            let uuid = this.makeUi("result");
            // 임시 메시지 제거
            $('#media-' + tempUUID).remove();

            // 스트리밍된 내용을 수집 및 실시간 업데이트
            while (true) {
                const {value, done} = await reader.read();
                if (done) break;
                let chunk = decoder.decode(value);
                content += chunk;
                $('#'+uuid).html(content)
            }

            // 2. 분석 결과 TTS 요청 및 재생
            const finalContent = content.trim();
            if (finalContent.length > 0) {
                this.playAnalysisAudio(finalContent);
            }
        },

        // 3. TTS 요청 및 오디오 재생 함수 추가
        playAnalysisAudio: async function(text) {
            const audioPlayer = document.getElementById("audioPlayer");
            $('#statusMessage').text('분석 결과를 음성으로 읽는 중... 🔊');

            try {
                // TTS 엔드포인트 호출 (audio/mpeg 스트림 반환 예상)
                const response = await fetch('/ai3/tts', {
                    method: "post",
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/octet-stream'
                    },
                    body: new URLSearchParams({ text: text })
                });

                // springai.js에 정의된 함수를 사용하여 오디오 스트리밍 재생
                await springai.voice.playAudioFormStreamingData(response, audioPlayer);

                // 오디오 재생 완료 시 상태 메시지 복구
                audioPlayer.addEventListener("ended", () => {
                    this.updateButtonState(true); // 분석 실행 중 상태로 복구
                }, { once: true });

            } catch (error) {
                console.error('TTS 또는 오디오 재생 오류:', error);
                // 오류 발생 시에도 분석은 계속 (버튼 상태는 실행 중으로 유지)
                this.updateButtonState(true);
            }
        },

        displayTempMessage: function(message, uuid) {
            const tempForm = `
                <div class="media border p-3" id="media-${uuid}">
                    <div class="media-body">
                      <h6>GPT4 분석 (요청 중)</h6>
                      <p id="${uuid}"><span class="spinner-border spinner-border-sm"></span> ${message}</p>
                    </div>
                    <img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;">
                </div>
            `;
            $('#result').prepend(tempForm);
        },

        makeUi:function(target){
            let uuid = "id-" + crypto.randomUUID();
            let aForm = `
                  <div class="media border p-3">
                    <div class="media-body">
                      <h6>GPT4 분석 결과 (${new Date().toLocaleTimeString('ko-KR')})</h6>
                      <p><pre id="`+uuid+`"></pre></p>
                    </div>
                    <img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;">
                  </div>
            `;
            $('#'+target).prepend(aForm);
            return uuid;
        }

    }

    $(()=>{
        ai6.init();
    });
</script>


<div class="col-sm-10">
    <h2>Spring AI 7 - 영상 상황 자동 분석 및 음성 안내</h2>

    <div class="row">
        <div class="col-sm-9">
            <div class="row mb-3">
                <div class="col-sm-12">
                    <button type="button" class="btn btn-success" id="startAnalysis">분석 시작</button>
                    <button type="button" class="btn btn-danger" id="stopAnalysis" disabled>분석 중지</button>
                    <span class="text-muted ml-3" id="statusMessage">분석을 시작하려면 "분석 시작" 버튼을 누르세요.</span>
                    <audio id="audioPlayer" controls style="display:none;"></audio>
                </div>
            </div>

            <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 300px;">
                <p class="text-info">카메라를 활성화하고 버튼을 누르면 1분마다 영상 상황을 분석하고 음성으로 안내합니다.</p>
            </div>
        </div>

        <div class="col-sm-3">
            <video id="video" src="" alt="실시간 비디오" style="width: 100%; max-width: 300px; border: 1px solid #ccc;" autoplay />
        </div>

    </div>
</div>