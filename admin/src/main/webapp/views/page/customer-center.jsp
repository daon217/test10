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
                                <th>등록일</th>
                                <th>상태</th>
                                <th class="datatable-nosort">내용</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${inquiries}" var="inquiry" varStatus="status">
                                <tr>
                                    <td class="table-plus">${status.count}</td>
                                    <td><c:out value="${inquiry.title}"/></td>
                                    <td><c:out value="${inquiry.username}"/></td>
                                    <td><c:out value="${inquiry.createdAt}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inquiry.status eq 'ANSWERED'}">
                                                <span class="badge badge-success">답변완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning">답변대기</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 300px;">
                                            <c:out value="${inquiry.content}"/>
                                        </div>
                                    </td>
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