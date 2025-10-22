<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let ai41 = {
        init: function() {
            $('#send').click(() => this.send());
            $('#question').keypress((e) => {
                if(e.which == 13 && !e.shiftKey) { // Shift+Enter는 줄바꿈 허용
                    this.send();
                    return false;
                }
            });
            $('#spinner').css('visibility', 'hidden');
        },

        send: async function() {
            let question = $('#question').val().trim();
            if (!question) return;

            $('#spinner').css('visibility', 'visible');
            this.displayUserMessage(question); // 사용자 메시지 먼저 표시
            $('#question').val(''); // 입력창 비우기

            const response = await fetch('/ai1/few-shot-prompt2', {
                method: "post",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ question })
            });

            const jsonString = await response.text();
            let uuid = this.makeAssistantUI();

            try {
                const res = JSON.parse(jsonString);
                this.renderResponse(uuid, res);
            } catch (e) {
                console.error("JSON 파싱 실패:", e, jsonString);
                $('#' + uuid).html("<div class='alert alert-danger'>응답 처리 중 오류가 발생했습니다. 원문: " + jsonString + "</div>");
            }

            $('#spinner').css('visibility', 'hidden');
        },

        // AI 응답에 따른 함수
        renderResponse: function(uuid, res) {
            let html = `<p>${res.message || '응답 메시지가 없습니다.'}</p>`; // AI의 기본 메시지 표시

            //  주문 불가 메뉴가 있다면 경고창 표시
            if (res.unavailableItems && res.unavailableItems.length > 0) {
                html += `<div class="alert alert-warning"><strong>주문 불가:</strong> ${res.unavailableItems.join(', ')}</div>`;
            }

            // 명확한 질문이 필요하다면 안내창 표시
            if (res.clarificationQuestions && res.clarificationQuestions.length > 0) {
                html += `<div class="alert alert-info"><strong>질문:</strong> ${res.clarificationQuestions.join('<br>')}</div>`;
            }

            // 유효한 주문 내역이 있다면 카드 형태로
            const items = res.orderData?.order_items;
            if (items && items.length > 0) {
                let total = 0;
                let orderSummaryHtml = '<ul class="list-unstyled">';

                items.forEach(item => {
                    let itemTotal = item.price * item.quantity;
                    total += itemTotal;

                    // 주문 아이템 카드
                    html += `
                      <div class="card mb-2 shadow-sm">
                        <div class="row no-gutters align-items-center">
                          <div class="col-md-3 text-center">
                            <img src="<c:url value="/image/${item.image_name}"/>" class="img-fluid p-2" style="max-height:100px;">
                          </div>
                          <div class="col-md-9">
                            <div class="card-body py-2">
                              <h5 class="card-title mb-1">${item.menu_name}</h5>
                              <p class="card-text mb-0">수량: ${item.quantity}개</p>
                              <p class="card-text mb-0">단가: ${item.price.toLocaleString()}원</p>
                              <p class="card-text font-weight-bold">합계: ${itemTotal.toLocaleString()}원</p>
                            </div>
                          </div>
                        </div>
                      </div>`;

                    // 주문 요약 리스트 아이템
                    orderSummaryHtml += `<li>${item.menu_name} (${item.quantity}개) - ${itemTotal.toLocaleString()}원</li>`;
                });

                orderSummaryHtml += '</ul><hr>';

                // 주문 요약 및 총합
                html += `<div class="mt-3 p-3 border-top bg-light"><h6>주문서</h6>${orderSummaryHtml}<h5>총 주문 금액: ${total.toLocaleString()}원</h5></div>`;
            }

            // 4. 메뉴판을 보여달라는 요청(SHOW_MENU)이면 모달 띄우기
            if (res.status === 'SHOW_MENU') {
                $('#menuModal').modal('show');
            }

            $('#' + uuid).html(html);
        },

        // 사용자 메시지를 화면에 표시하는 함수
        displayUserMessage: function(msg) {
            const escapedMsg = msg.replace(/</g, "&lt;").replace(/>/g, "&gt;");
            let qForm = `<div class="media border p-3"><img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;"><div class="media-body"><h6>고객</h6><p>${escapedMsg}</p></div></div>`;
            $('#result').prepend(qForm);
        },

        makeAssistantUI: function() {
            let uuid = "id-" + crypto.randomUUID();
            let aForm = `<div class="media border p-3"><div class="media-body"><h6>주문 도우미</h6><div id="${uuid}"><span class="spinner-border spinner-border-sm"></span> 생각 중...</div></div><img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;"></div>`;
            $('#result').prepend(aForm);
            return uuid;
        }
    }

    $(() => {
        ai41.init();
    });
</script>

<div class="col-sm-10">
    <h2>Spring AI 4-1 Few shot Prompt</h2>
    <div class="row mb-2">
        <div class="col-sm-6">
            <textarea id="question" class="form-control">돼지국밥 2개랑 수육 소짜 하나, 그리고 사이다 3개 주세요.</textarea>
        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-primary" id="send">Send</button>
        </div>
        <div class="col-sm-2">
            <button class="btn btn-info" data-toggle="modal" data-target="#menuModal">메뉴판</button>
        </div>
        <div class="col-sm-2">
            <button class="btn btn-primary" disabled>
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                Loading..
            </button>
        </div>
    </div>

    <div id="result" class="container p-3 my-3 border" style="overflow:auto; height:500px;"></div>
</div>

<!-- 메뉴판 모달 -->
<div class="modal fade" id="menuModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">메뉴판</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h6>[국밥]</h6>
                <ul>
                    <li>소머리국밥 - 11,000원 <img src="<c:url value="/image/k1.jpg"/>" style="width:50px;"></li>
                    <li>돼지국밥 - 9,000원 <img src="<c:url value="/image/k2.jpg"/>" style="width:50px;"></li>
                    <li>순대국밥 - 9,000원 <img src="<c:url value="/image/k3.jpg"/>" style="width:50px;"></li>
                    <li>내장국밥 - 10,000원 <img src="<c:url value="/image/k4.jpg"/>" style="width:50px;"></li>
                    <li>얼큰이국밥 - 9,500원 <img src="<c:url value="/image/k5.jpg"/>" style="width:50px;"></li>
                    <li>설렁탕국밥 - 10,000원 <img src="<c:url value="/image/k6.jpg"/>" style="width:50px;"></li>
                    <li>뼈해장국 - 10,000원 <img src="<c:url value="/image/k7.jpg"/>" style="width:50px;"></li>
                    <li>김치말이국밥 - 9,000원 <img src="<c:url value="/image/k8.jpg"/>" style="width:50px;"></li>
                </ul>
                <h6>[사이드]</h6>
                <ul>
                    <li>순대 - 12,000원 <img src="<c:url value="/image/k9.jpg"/>" style="width:50px;"></li>
                    <li>수육(대) - 20,000원 <img src="<c:url value="/image/k10.jpg"/>" style="width:50px;"></li>
                    <li>수육(중) - 18,000원 <img src="<c:url value="/image/k11.jpg"/>" style="width:50px;"></li>
                    <li>수육(소) - 15,000원 <img src="<c:url value="/image/k12.jpg"/>" style="width:50px;"></li>
                    <li>머리고기 - 22,000원 <img src="<c:url value="/image/k13.jpg"/>" style="width:50px;"></li>
                    <li>편육 - 10,000원 <img src="<c:url value="/image/k14.jpg"/>" style="width:50px;"></li>
                </ul>
                <h6>[음료]</h6>
                <ul>
                    <li>콜라 - 2,000원 <img src="<c:url value="/image/k15.jpg"/>" style="width:50px;"></li>
                    <li>사이다 - 2,000원 <img src="<c:url value="/image/k16.jpg"/>"style="width:50px;"></li>
                    <li>아이스티 - 3,000원 <img src="<c:url value="/image/k17.jpg"/>" style="width:50px;"></li>
                    <li>식혜 - 3,000원 <img src="<c:url value="/image/k18.jpg"/>" style="width:50px;"></li>
                    <li>수정과 - 3,000원 <img src="<c:url value="/image/k19.jpg"/>" style="width:50px;"></li>
                </ul>
            </div>
        </div>
    </div>
</div>
