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
                <table class="data-table table stripe hover nowrap">
                    <thead>
                    <tr>
                        <th class="table-plus datatable-nosort">번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>등록일</th>
                        <th>상태</th>
                        <th class="datatable-nosort">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="table-plus">1</td>
                        <td>로그인이 안됩니다.</td>
                        <td>hong123</td>
                        <td>2024-06-01</td>
                        <td><span class="badge badge-warning">답변대기</span></td>
                        <td>
                            <a class="btn btn-sm btn-primary" href="#"><i class="dw dw-edit2"></i> 답변하기</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="table-plus">2</td>
                        <td>CCTV 화면이 안나옵니다.</td>
                        <td>admin_sub</td>
                        <td>2024-05-28</td>
                        <td><span class="badge badge-success">답변완료</span></td>
                        <td>
                            <a class="btn btn-sm btn-secondary" href="#"><i class="dw dw-eye"></i> 확인</a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>