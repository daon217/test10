<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
        <div class="page-header">
            <div class="row">
                <div class="col-md-6 col-sm-12">
                    <div class="title">
                        <h4>고객센터 관리</h4>
                    </div>
                    <nav aria-label="breadcrumb" role="navigation">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/index">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">고객센터</li>
                        </ol>
                    </nav>
                </div>
            </div>
        </div>

        <div class="card-box mb-30">
            <div class="pd-20">
                <h4 class="text-blue h4">1:1 문의 내역</h4>
            </div>
            <div class="pb-20">
                <c:choose>
                    <c:when test="${empty inquiries}">
                        <p class="text-muted px-4 pb-3">등록된 문의가 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table table stripe hover nowrap">
                            <thead>
                            <tr>
                                <th class="table-plus datatable-nosort">번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                    <%-- 내용 컬럼 너비를 45%로 넓게 설정 --%>
                                <th class="datatable-nosort" style="width: 45%;">내용</th>
                                <th>1:1 채팅</th>
                                    <%-- 등록일 컬럼 너비를 10%로 좁게 설정 --%>
                                <th style="width: 10%;">등록일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${inquiries}" var="inquiry" varStatus="status">
                                <tr>
                                    <td class="table-plus">${status.count}</td>
                                    <td><c:out value="${inquiry.title}"/></td>
                                    <td><c:out value="${inquiry.username}"/></td>
                                    <td>
                                            <%-- max-width를 300px -> 500px로 늘려 내용이 더 길게 보이도록 함 --%>
                                        <div class="text-truncate" style="max-width: 500px;">
                                            <c:out value="${inquiry.content}"/>
                                        </div>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-primary" onclick="location.href='/admin/chat/room?userId=${inquiry.username}'">
                                            <i class="fa fa-comments"></i> 채팅하기
                                        </button>
                                    </td>
                                    <td><c:out value="${inquiry.createdAt}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>