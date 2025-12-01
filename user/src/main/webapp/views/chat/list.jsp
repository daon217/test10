<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">채팅</h2>
            <p class="mb-0 text-muted">최근 대화한 채팅방 목록입니다.</p>
        </div>
        <a href="<c:url value='/'/>" class="btn btn-outline-secondary btn-sm">홈으로</a>
    </div>

    <div class="list-group">
        <a href="#" class="list-group-item list-group-item-action">
            <div class="d-flex w-100 justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <img src="https://via.placeholder.com/56" alt="프로필" class="rounded mr-3" width="56" height="56">
                    <div>
                        <h5 class="mb-1">산책 메이트 구해요</h5>
                        <p class="mb-1 text-muted">내일 저녁 7시쯤 한강공원에서 산책 어때요?</p>
                        <small class="text-secondary">투투맘 · 성수동</small>
                    </div>
                </div>
                <div class="text-right">
                    <small class="text-muted">5분 전</small>
                    <div>
                        <span class="badge badge-primary">3</span>
                    </div>
                </div>
            </div>
        </a>

        <a href="#" class="list-group-item list-group-item-action">
            <div class="d-flex w-100 justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <img src="https://via.placeholder.com/56" alt="프로필" class="rounded mr-3" width="56" height="56">
                    <div>
                        <h5 class="mb-1">강아지 용품 나눔</h5>
                        <p class="mb-1 text-muted">소형견 옷 몇 개 있어요. 사이즈 확인해보세요.</p>
                        <small class="text-secondary">초코아빠 · 잠실새내</small>
                    </div>
                </div>
                <div class="text-right">
                    <small class="text-muted">어제</small>
                    <div>
                        <span class="badge badge-light text-muted">읽음</span>
                    </div>
                </div>
            </div>
        </a>

        <a href="#" class="list-group-item list-group-item-action">
            <div class="d-flex w-100 justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <img src="https://via.placeholder.com/56" alt="프로필" class="rounded mr-3" width="56" height="56">
                    <div>
                        <h5 class="mb-1">미용 예약 문의</h5>
                        <p class="mb-1 text-muted">토요일 오후 자리 가능할까요?</p>
                        <small class="text-secondary">봄이네 · 망원동</small>
                    </div>
                </div>
                <div class="text-right">
                    <small class="text-muted">3일 전</small>
                    <div>
                        <span class="badge badge-primary">1</span>
                    </div>
                </div>
            </div>
        </a>
    </div>
</div>
