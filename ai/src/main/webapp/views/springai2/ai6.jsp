<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    let ai6 = {
        menuCategories: [],
        init: function() {
            $('#send').click(() => this.send());
            $('#question').keypress((e) => {
                if (e.which === 13 && !e.shiftKey) {
                    this.send();
                    return false;
                }
            });
            $('#spinner').css('visibility', 'hidden');
            this.fetchMenu();
        },
        fetchMenu: async function() {
            try {
                const response = await fetch('/ai2/shop/menu');
                if (!response.ok) {
                    throw new Error('메뉴 정보를 불러오지 못했습니다.');
                }
                const categories = await response.json();
                this.menuCategories = categories;
                this.renderMenuModal(categories);
            } catch (e) {
                console.error(e);
                $('#menuModalBody').html('<div class="alert alert-danger">메뉴를 불러오는 중 오류가 발생했습니다.</div>');
            }
        },
        send: async function() {
            const question = $('#question').val().trim();
            if (!question) return;

            $('#spinner').css('visibility', 'visible');
            this.displayUserMessage(question);
            $('#question').val('');

            let uuid = this.makeAssistantUI();

            try {
                const response = await fetch('/ai2/shop/order', {
                    method: 'post',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ question })
                });

                if (!response.ok) {
                    throw new Error('주문 요청에 실패했습니다.');
                }

                const result = await response.json();
                this.renderResponse(uuid, result);
            } catch (e) {
                console.error(e);
                $('#' + uuid).html('<div class="alert alert-danger">요청 처리 중 오류가 발생했습니다. 다시 시도해주세요.</div>');
            } finally {
                $('#spinner').css('visibility', 'hidden');
            }
        },
        renderResponse: function(uuid, res) {
            let html = `<p>${res.message || '응답 메시지가 없습니다.'}</p>`;

            if (Array.isArray(res.unavailableItems) && res.unavailableItems.length > 0) {
                html += `<div class="alert alert-warning"><strong>주문 불가:</strong> ${res.unavailableItems.join(', ')}</div>`;
            }

            if (Array.isArray(res.clarificationQuestions) && res.clarificationQuestions.length > 0) {
                html += `<div class="alert alert-info"><strong>추가 확인 필요:</strong><br>${res.clarificationQuestions.join('<br>')}</div>`;
            }

            const items = res.orderData && Array.isArray(res.orderData.order_items) ? res.orderData.order_items : [];
            if (items.length > 0) {
                let total = 0;
                let orderSummaryHtml = '<ul class="list-unstyled">';

                items.forEach(item => {
                    const quantity = item.quantity || 0;
                    const price = item.price || 0;
                    const itemTotal = quantity * price;
                    total += itemTotal;

                    html += `
                        <div class="card mb-2 shadow-sm">
                            <div class="row no-gutters align-items-center">
                                <div class="col-md-3 text-center">
                                    <img src="<c:url value="/image/${item.image_name}"/>" class="img-fluid p-2" style="max-height:100px;">
                                </div>
                                <div class="col-md-9">
                                    <div class="card-body py-2">
                                        <h5 class="card-title mb-1">${item.menu_name}</h5>
                                        <p class="card-text mb-0">수량: ${quantity}개</p>
                                        <p class="card-text mb-0">단가: ${price.toLocaleString()}원</p>
                                        <p class="card-text font-weight-bold">합계: ${itemTotal.toLocaleString()}원</p>
                                    </div>
                                </div>
                            </div>
                        </div>`;

                    orderSummaryHtml += `<li>${item.menu_name} (${quantity}개) - ${itemTotal.toLocaleString()}원</li>`;
                });

                orderSummaryHtml += '</ul><hr>';
                html += `<div class="mt-3 p-3 border-top bg-light"><h6>주문서</h6>${orderSummaryHtml}<h5>총 주문 금액: ${total.toLocaleString()}원</h5></div>`;
            }

            if (Array.isArray(res.menuCategories) && res.menuCategories.length > 0) {
                this.menuCategories = res.menuCategories;
                this.renderMenuModal(res.menuCategories);
            }

            if (res.status && res.status.toUpperCase() === 'SHOW_MENU') {
                $('#menuModal').modal('show');
            }

            $('#' + uuid).html(html);
        },
        displayUserMessage: function(msg) {
            const escapedMsg = msg.replace(/</g, '&lt;').replace(/>/g, '&gt;');
            const qForm = `<div class="media border p-3"><img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;"><div class="media-body"><h6>고객</h6><p>${escapedMsg}</p></div></div>`;
            $('#result').prepend(qForm);
        },
        makeAssistantUI: function() {
            const uuid = 'id-' + crypto.randomUUID();
            const aForm = `<div class="media border p-3"><div class="media-body"><h6>주문 도우미</h6><div id="${uuid}"><span class="spinner-border spinner-border-sm"></span> 생각 중...</div></div><img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;"></div>`;
            $('#result').prepend(aForm);
            return uuid;
        },
        renderMenuModal: function(categories) {
            if (!Array.isArray(categories) || categories.length === 0) {
                $('#menuModalBody').html('<p class="text-muted">메뉴 정보가 없습니다.</p>');
                return;
            }

            const html = categories.map(category => {
                const items = (category.items || []).map(item => `
                    <li class="list-group-item d-flex align-items-center justify-content-between">
                        <div>
                            <strong>${item.menu_name}</strong>
                            <div class="text-muted">${item.price.toLocaleString()}원</div>
                        </div>
                        <img src="<c:url value="/image/${item.image_name}"/>" style="width:50px;" class="rounded">
                    </li>`).join('');
                return `
                    <div class="mb-4">
                        <h6 class="border-bottom pb-1">[${category.category}]</h6>
                        <ul class="list-group list-group-flush">${items}</ul>
                    </div>`;
            }).join('');

            $('#menuModalBody').html(html);
        }
    };

    $(() => ai6.init());
</script>

<div class="col-sm-10">
    <h2>Spring AI 2 - AI6 주문 어시스턴트</h2>
    <div class="row mb-2">
        <div class="col-sm-6">
            <textarea id="question" class="form-control" rows="3">메뉴판 좀 보여줘</textarea>
        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-primary" id="send">Send</button>
        </div>
        <div class="col-sm-4">
            <button class="btn btn-primary" disabled>
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                Loading..
            </button>
        </div>
    </div>

    <div id="result" class="container p-3 my-3 border" style="overflow:auto; height:500px;"></div>
</div>

<div class="modal fade" id="menuModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">메뉴판</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="menuModalBody">
                <p class="text-muted">메뉴를 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>