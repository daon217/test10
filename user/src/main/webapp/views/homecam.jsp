<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<script>
    if (typeof ApexCharts === 'undefined') {
        window.ApexCharts = function() {
            return { render: function(){}, updateSeries: function(){} };
        };
    }
</script>

<div class="main-container">
    <div class="pd-ltr-20 xs-pd-20-10">
        <div class="min-height-200px">
            <div class="page-header" style="margin-bottom: 20px;">
                <div class="row">
                    <div class="col-12">
                        <div class="title">
                            <h4>Ai Home Cam</h4>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <div class="ai-analysis-card">
                        <div class="ai-analysis-header">
                            <h5 class="mb-1">AI 애완동물 상태요약</h5>
                            <span id="global-status" class="status waiting">연결 대기 중...</span>
                        </div>
                        <ul id="ai-analysis-history" class="ai-analysis-history placeholder">
                            <li>아직 수신된 분석 결과가 없습니다.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="row" id="cctv-grid-container"></div>

            <div class="row mt-3">
                <div class="col-12 text-center">
                    <button class="btn btn-primary btn-lg" onclick="location.reload()">
                        <i class="fa fa-refresh"></i> 시스템 재연결
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .ai-analysis-card {
        background: #101322; border-radius: 20px; padding: 24px; color: #f7f9ff;
        box-shadow: 0 20px 45px rgba(10, 12, 24, 0.45); border: 1px solid rgba(255,255,255,0.05); margin-bottom: 20px;
    }
    .ai-analysis-header { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 15px; }
    .ai-analysis-history { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 8px; }
    .ai-analysis-history.placeholder { color: rgba(255,255,255,0.5); }
    .ai-analysis-history li { background: rgba(255,255,255,0.08); border-radius: 14px; padding: 8px 14px; font-size: 0.85rem; display: flex; gap: 10px; }
    .ai-analysis-history li .time { font-weight: 600; color: rgba(255,255,255,0.9); }

    .status { font-size: 0.9rem; padding: 6px 14px; border-radius: 999px; background: rgba(255,255,255,0.08); font-weight: 600; color: #fff; }
    .status.waiting { background: rgba(255,255,255,0.12); }
    .status.safe { background: rgba(62, 201, 144, 0.2); color: #85f0c0; }
    .status.alert { background: rgba(255, 94, 94, 0.2); color: #ff9494; }

    .text-danger { color: #ff9494 !important; }
    .text-success { color: #85f0c0 !important; }

    .cctv-col { margin-bottom: 30px; }
    .cctv-card {
        background: #000; border-radius: 12px; overflow: hidden; position: relative;
        border: 2px solid #444; box-shadow: 0 10px 25px rgba(0,0,0,0.5);
        aspect-ratio: 16 / 9;
    }
    .cctv-card video { width: 100%; height: 100%; object-fit: contain; }

    .cctv-label {
        position: absolute; top: 15px; left: 15px;
        background: rgba(0, 0, 0, 0.6); color: white;
        padding: 5px 10px; border-radius: 4px;
        font-weight: bold; font-size: 14px; z-index: 10;
    }
    .loading-msg {
        position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
        color: #aaa; font-size: 1rem;
    }
</style>

<script>
    (function() {
        var grid = document.getElementById('cctv-grid-container');
        var historyEl = document.getElementById('ai-analysis-history');
        var globalStatusEl = document.getElementById('global-status');

        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var SIGNALING_URL = protocol + location.host + '/signal';
        var ANALYSIS_ENDPOINT = window.location.origin + '/cctv/api/analysis';

        var socket;
        var connections = new Map();

        function addHistory(timeText, summary, accentClass, cctvId) {
            if (historyEl.classList.contains('placeholder')) {
                historyEl.innerHTML = '';
                historyEl.classList.remove('placeholder');
            }
            var item = document.createElement('li');

            var sourceLabel = cctvId ? '[' + cctvId + '] ' : '';
            var content = '<span class="time">' + timeText + '</span>';
            content += '<span class="' + (accentClass || '') + '">' + sourceLabel + summary + '</span>';

            item.innerHTML = content;
            historyEl.prepend(item);

            if (historyEl.children.length > 7) {
                historyEl.removeChild(historyEl.lastElementChild);
            }
        }

        function start() {
            socket = new WebSocket(SIGNALING_URL);

            socket.onopen = function() {
                globalStatusEl.textContent = "홈캠 활성화";
                globalStatusEl.className = "status safe";
                socket.send(JSON.stringify({ "type": "viewer_joined" }));
            };

            socket.onmessage = function(event) {
                try {
                    var msg = JSON.parse(event.data);

                    if (msg.type === 'CCTV_ANALYSIS_RESULT') {
                        handleAnalysisResult(msg.payload);
                        return;
                    }

                    var id = msg.id || 'unknown';

                    if (msg.type === 'offer') {
                        handleOffer(id, msg);
                    } else if (msg.type === 'candidate') {
                        if (connections.has(id)) {
                            connections.get(id).addIceCandidate(new RTCIceCandidate(msg.candidate));
                        }
                    }
                } catch (e) { console.error(e); }
            };

            socket.onclose = function() {
                globalStatusEl.textContent = "서버 연결 끊김";
                globalStatusEl.className = "status alert";
            };
        }

        function handleOffer(cctvId, msg) {
            if (connections.has(cctvId)) {
                connections.get(cctvId).close();
                connections.delete(cctvId);
                var old = document.getElementById('card-' + cctvId);
                if(old) old.remove();
            }

            var col = document.createElement('div');
            col.className = 'col-xl-4 col-lg-4 col-md-6 cctv-col';
            col.id = 'card-' + cctvId;

            var html = '<div class="cctv-card">';
            html += '<span class="cctv-label">' + cctvId + '</span>';
            html += '<div class="loading-msg">연결 중...</div>';
            html += '<video id="video-' + cctvId + '" autoplay playsinline controls muted></video>';
            html += '</div>';

            col.innerHTML = html;
            grid.appendChild(col);

            var pc = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] });
            connections.set(cctvId, pc);

            pc.ontrack = function(e) {
                var vid = document.getElementById('video-' + cctvId);
                if (vid) {
                    vid.srcObject = e.streams[0];
                    col.querySelector('.loading-msg').style.display = 'none';
                }
            };

            pc.onicecandidate = function(e) {
                if (e.candidate) {
                    socket.send(JSON.stringify({ "type": "candidate", "id": cctvId, "candidate": e.candidate }));
                }
            };

            pc.setRemoteDescription({ type: 'offer', sdp: msg.sdp }).then(function() {
                return pc.createAnswer();
            }).then(function(answer) {
                return pc.setLocalDescription(answer);
            }).then(function() {
                socket.send(JSON.stringify({ "type": "answer", "id": cctvId, "sdp": pc.localDescription.sdp }));
            });
        }

        function handleAnalysisResult(payload) {
            var severity = payload.severity || 'normal';
            var msg = payload.message || '알 수 없는 응답';
            var timeText = new Date(payload.timestamp || Date.now()).toLocaleTimeString();

            if (severity === 'alert') {
                globalStatusEl.textContent = '위험 감지';
                globalStatusEl.className = 'status alert';
                addHistory(timeText, msg, 'text-danger', payload.cctvId);
            } else {
                globalStatusEl.textContent = '안전';
                globalStatusEl.className = 'status safe';
                addHistory(timeText, msg || '이상 없음', 'text-success', payload.cctvId);
            }
        }

        start();
    })();
</script>