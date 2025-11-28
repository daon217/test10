<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- 채팅 패널 (우측 슬라이드) -->
        <div class="chat-panel" id="chatPanel">
            <div class="chat-header">
                <div class="d-flex align-items-center">
                    <img src="https://via.placeholder.com/40x40?text=User" alt="프로필" class="rounded-circle mr-2"
                        width="40">
                    <div>
                        <h6 class="mb-0" id="chatUserName">상대방 이름</h6>
                        <small>온라인</small>
                    </div>
                </div>
                <button class="btn btn-sm text-white" onclick="closeChat()">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="chat-body" id="chatBody">
                <!-- 메시지들이 여기에 표시됨 -->
                <div class="message received">
                    안녕하세요! 산책 조건에 대해 문의드리고 싶은데요.
                    <div class="message-time">오후 3:24</div>
                </div>
                <div class="message sent">
                    네, 무엇이든 물어보세요!
                    <div class="message-time">오후 3:25</div>
                </div>
                <div class="message received">
                    몽이가 다른 강아지를 무서워하나요?
                    <div class="message-time">오후 3:26</div>
                </div>
                <div class="message sent">
                    처음엔 조금 경계하지만 금방 친해져요. 차분하게 다가가면 괜찮습니다.
                    <div class="message-time">오후 3:27</div>
                </div>
            </div>

            <div class="chat-footer">
                <div class="input-group">
                    <input type="text" class="form-control" id="chatInput" placeholder="메시지를 입력하세요..."
                        onkeypress="if(event.keyCode==13) sendMessage()">
                    <div class="input-group-append">
                        <button class="btn btn-pet-primary" onclick="sendMessage()">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 채팅 패널 배경 오버레이 -->
        <div class="chat-overlay" id="chatOverlay" onclick="closeChat()"></div>

        <style>
            .chat-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1049;
                display: none;
            }

            .chat-overlay.active {
                display: block;
            }

            .chat-panel.active+.chat-overlay {
                display: block;
            }

            .message-time {
                font-size: 0.75rem;
                color: rgba(255, 255, 255, 0.7);
                margin-top: 5px;
            }

            .message.received .message-time {
                color: #999;
            }
        </style>

        <script>
            function closeChat() {
                const panel = document.getElementById('chatPanel');
                const overlay = document.getElementById('chatOverlay');
                if (panel) {
                    panel.classList.remove('active');
                }
                if (overlay) {
                    overlay.classList.remove('active');
                }
            }

            function sendMessage() {
                const input = document.getElementById('chatInput');
                const message = input.value.trim();

                if (!message) return;

                // 메시지 추가
                const chatBody = document.getElementById('chatBody');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message sent';

                const now = new Date();
                const timeStr = now.getHours() + ':' + now.getMinutes().toString().padStart(2, '0');

                messageDiv.innerHTML = message + '<div class="message-time">' + timeStr + '</div>';
                chatBody.appendChild(messageDiv);

                // 스크롤 아래로
                chatBody.scrollTop = chatBody.scrollHeight;

                // 입력창 초기화
                input.value = '';

                // 실제로는 서버에 WebSocket으로 전송
            }

            // ESC 키로 채팅 닫기
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeChat();
                }
            });
        </script>