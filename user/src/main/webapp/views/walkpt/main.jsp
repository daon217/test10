<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <link rel="stylesheet" href="<c:url value='/css/walkpt.css'/>">

            <div class="walkpt-container">
                <div class="container">
                    <!-- 서비스 헤더 -->
                    <div class="text-center mb-5">
                        <h1 class="mb-3">
                            <i class="fas fa-handshake text-primary"></i> 산책 알바 & 산책 파트너
                        </h1>
                        <p class="lead text-secondary">
                            산책 알바를 구인/구직하며 때로는 반려동물과 같이 산책할 파트너를 구하는 서비스
                        </p>
                        <p class="lead text-secondary">
                            오른쪽 하단의 파란색 채팅 버튼으로 AI 도우미를 통해 간단하게 조회도 가능
                        </p>
                    </div>

                    <!-- 탭 및 액션 버튼 -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <ul class="nav nav-tabs walkpt-tabs border-0" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="tab" href="#jobPostings" role="tab">
                                    <i class="fas fa-clipboard-list"></i> 구인 글 보기
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#workerPostings" role="tab">
                                    <i class="fas fa-user-check"></i> 구직 글 보기
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#togetherWalk" role="tab">
                                    <i class="fas fa-users"></i> 함께 산책하기
                                </a>
                            </li>
                        </ul>
                        <div class="action-buttons">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="<c:url value='/walkpt/owner/post-write'/>"
                                        class="btn btn-pet-primary mr-2">
                                        <i class="fas fa-plus"></i> 구인 글 작성
                                    </a>
                                    <a href="<c:url value='/walkpt/worker/job-post-write'/>"
                                        class="btn btn-pet-secondary mr-2">
                                        <i class="fas fa-plus"></i> 구직 글 작성
                                    </a>
                                    <a href="<c:url value='/walkpt/togetherwalk/write'/>" class="btn btn-pet-info">
                                        <i class="fas fa-plus"></i> 함께 산책하기
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-pet-primary mr-2" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 구인 글 작성
                                    </button>
                                    <button class="btn btn-pet-secondary mr-2" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 구직 글 작성
                                    </button>
                                    <button class="btn btn-pet-info" onclick="showLoginRequired()">
                                        <i class="fas fa-plus"></i> 함께 산책하기
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 탭 컨텐츠 -->
                    <div class="tab-content mt-5">
                        <!-- 구인 글 목록 -->
                        <div class="tab-pane fade show active" id="jobPostings" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-clipboard-list"></i> 최근 구인 글</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty ownerPosts}">
                                        <c:forEach items="${ownerPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-calendar-alt"></i> ${post.walkDate}
                                                            ${post.walkTime}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-dog"></i> ${post.petName}
                                                            (${post.petBreed}, ${post.petAge}살)
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-won-sign"></i> 시급
                                                            <fmt:formatNumber value="${post.payAmount}" type="number" />
                                                            원
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="<c:url value='/walkpt/owner/post-detail?id=${post.postId}'/>"
                                                            class="btn btn-pet-outline btn-sm btn-block">
                                                            <i class="fas fa-eye"></i> 상세보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 구인 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <a href="<c:url value='/walkpt/worker/job-list'/>" class="btn btn-pet-primary">
                                    <i class="fas fa-plus-circle"></i> 더 많은 구인 글 보기
                                </a>
                            </div>
                        </div>

                        <!-- 구직 글 목록 -->
                        <div class="tab-pane fade" id="workerPostings" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-user-check"></i> 최근 구직 글</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty workerPosts}">
                                        <c:forEach items="${workerPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">구직 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-user"></i> ${post.userName}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-clock"></i> ${post.walkTime}
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="#" class="btn btn-pet-outline btn-sm btn-block"
                                                            onclick="alert('준비 중입니다.')">
                                                            <i class="fas fa-eye"></i> 이력서 보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 구직 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <button class="btn btn-pet-primary" onclick="alert('준비 중입니다.')">
                                    <i class="fas fa-plus-circle"></i> 더 많은 구직 글 보기
                                </button>
                            </div>
                        </div>

                        <!-- 함께 산책하기 목록 -->
                        <div class="tab-pane fade" id="togetherWalk" role="tabpanel">
                            <h4 class="mb-4"><i class="fas fa-users"></i> 함께 산책하기</h4>
                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty togetherPosts}">
                                        <c:forEach items="${togetherPosts}" var="post">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="walkpt-card">
                                                    <div class="walkpt-card-header">
                                                        <h5 class="walkpt-card-title">${post.title}</h5>
                                                        <span class="walkpt-badge badge-recruiting">모집 중</span>
                                                    </div>
                                                    <div class="walkpt-card-body">
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-user"></i> ${post.userName}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-map-marker-alt"></i> ${post.location}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-calendar-alt"></i> ${post.walkDate}
                                                            ${post.walkTime}
                                                        </p>
                                                        <p class="walkpt-card-info">
                                                            <i class="fas fa-dog"></i> ${post.petName}
                                                            (${post.petBreed}, ${post.petAge}살)
                                                        </p>
                                                    </div>
                                                    <div class="walkpt-card-footer">
                                                        <a href="<c:url value='/walkpt/togetherwalk/detail?id=${post.postId}'/>"
                                                            class="btn btn-pet-outline btn-sm btn-block">
                                                            <i class="fas fa-eye"></i> 상세보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center py-5">
                                            <p class="text-muted">등록된 함께 산책하기 글이 없습니다.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center mt-4">
                                <a href="<c:url value='/walkpt/togetherwalk/list'/>" class="btn btn-pet-primary">
                                    <i class="fas fa-plus-circle"></i> 더 많은 글 보기
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chatbot Floating Button -->
            <button id="walkptChatBtn" class="btn btn-primary rounded-circle shadow-lg"
                style="position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px; z-index: 1000; font-size: 24px;">
                <i class="fas fa-comments"></i>
            </button>

            <!-- Chatbot Modal -->
            <div class="modal fade" id="walkptChatModal" tabindex="-1" role="dialog"
                aria-labelledby="walkptChatModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content d-flex flex-column" style="height: 80vh;">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="walkptChatModalLabel">
                                <i class="fas fa-robot mr-2"></i> AI 도우미
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body d-flex flex-column flex-grow-1 p-0" style="overflow: hidden;">
                            <!-- Chat Messages Area -->
                            <div id="chatMessages" class="flex-grow-1 p-3"
                                style="overflow-y: auto; background-color: #f8f9fa;">
                                <div class="chat-message bot-message mb-3">
                                    <div class="p-3 bg-white rounded shadow-sm d-inline-block" style="max-width: 80%;">
                                        안녕하세요! <strong>AI 도우미</strong>입니다.<br>
                                        산책 알바/알바생을 찾거나, 함께 산책할 파트너를 찾아드릴 수 있어요.<br><br>



                                        이렇게 물어보세요:
                                        <ul class="pl-3 mb-0 mt-2" style="font-size: 0.9rem;">
                                            <li>"강남역 근처에 내가 할 만한 알바 구해줘"</li>
                                            <li>"주말에 내 강아지 산책 시켜줄 사람"</li>
                                            <li>"말티즈 같이 산책할 친구 찾아요"</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Input Area -->
                            <div class="p-3 bg-white border-top">
                                <div class="input-group">
                                    <input type="text" id="chatInput" class="form-control"
                                        placeholder="Type your request..." aria-label="Type your request...">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="button" id="sendChatBtn">
                                            <i class="fas fa-paper-plane"></i> Send
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 로그인 필요 모달 및 공통 함수 -->
            <jsp:include page="common/modals.jsp" />

            <script>
                // 로그인 필요 모달 표시
                function showLoginRequired() {
                    $('#loginRequiredModal').modal('show');
                }

                window.addEventListener('load', function () {
                    // Base URL for WalkPT
                    var contextPath = "${pageContext.request.contextPath}";

                    // Open Chat Modal
                    $('#walkptChatBtn').click(function () {
                        var isLoggedIn = ${ sessionScope.user != null ? 'true' : 'false'
                    };
                    if (!isLoggedIn) {
                        showLoginRequired();
                        return false;
                    }
                    $('#walkptChatModal').modal('show');
                });

                // Send Message
                $('#sendChatBtn').click(sendMessage);
                $('#chatInput').keypress(function (e) {
                    if (e.which == 13) {
                        sendMessage();
                    }
                });

                function sendMessage() {
                    var message = $('#chatInput').val().trim();
                    if (!message) return;

                    // Add User Message
                    appendMessage(message, 'user');
                    $('#chatInput').val('');

                    // Show Loading
                    var loadingId = appendLoading();

                    // Call API
                    $.ajax({
                        url: contextPath + '/walkpt/chat',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ message: message }),
                        success: function (response) {
                            removeLoading(loadingId);
                            if (response.status === 'success') {
                                appendMessage(response.reply, 'bot');
                                if (response.posts && response.posts.length > 0) {
                                    appendPosts(response.posts, response.aiAnalysis.category);
                                }
                            } else {
                                appendMessage('Error: ' + response.message, 'bot');
                            }
                        },
                        error: function (xhr, status, error) {
                            removeLoading(loadingId);
                            appendMessage('Sorry, something went wrong. Please try again.', 'bot');
                        }
                    });
                }

                function appendMessage(text, sender) {
                    var alignment = sender === 'user' ? 'text-right' : 'text-left';
                    var bgClass = sender === 'user' ? 'bg-primary text-white' : 'bg-white text-dark';

                    var html = '<div class="chat-message ' + sender + '-message mb-3 ' + alignment + '">';
                    html += '<div class="p-3 rounded shadow-sm d-inline-block ' + bgClass + '" style="max-width: 80%; text-align: left;">';
                    html += text;
                    html += '</div></div>';

                    $('#chatMessages').append(html);
                    scrollToBottom();
                }

                function appendLoading() {
                    var id = 'loading-' + Date.now();
                    var html = '<div id="' + id + '" class="chat-message bot-message mb-3 text-left">';
                    html += '<div class="p-3 bg-white rounded shadow-sm d-inline-block">';
                    html += '<i class="fas fa-spinner fa-spin"></i> Thinking...';
                    html += '</div></div>';

                    $('#chatMessages').append(html);
                    scrollToBottom();
                    return id;
                }

                function removeLoading(id) {
                    $('#' + id).remove();
                }

                function appendPosts(posts, category) {
                    var html = '<div class="row mb-3">';
                    posts.forEach(function (post) {
                        var detailPath = (category === 'TOGETHER') ? 'togetherwalk/detail' : 'owner/post-detail';
                        var postUrl = contextPath + '/walkpt/' + detailPath + '?id=' + post.postId;

                        html += '<div class="col-md-6 mb-2">';
                        html += '<div class="card h-100">';
                        html += '<div class="card-body p-2">';
                        html += '<h6 class="card-title text-truncate">' + post.title + '</h6>';
                        html += '<p class="card-text small mb-1"><i class="fas fa-map-marker-alt"></i> ' + (post.location || 'N/A') + '</p>';
                        html += '<p class="card-text small mb-1"><i class="fas fa-calendar"></i> ' + (post.walkDate || '') + ' ' + (post.walkTime || '') + '</p>';
                        html += '<a href="' + postUrl + '" class="btn btn-sm btn-outline-primary btn-block mt-2">View</a>';
                        html += '</div></div></div>';
                    });
                    html += '</div>';
                    $('#chatMessages').append(html);
                    scrollToBottom();
                }

                function scrollToBottom() {
                    var chatMessages = document.getElementById('chatMessages');
                    setTimeout(function () {
                        if (chatMessages) {
                            chatMessages.scrollTop = chatMessages.scrollHeight;
                        }
                    }, 50);
                }
                });
            </script>