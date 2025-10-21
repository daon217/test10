<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-sm-10">
  <h2>Today's Diary</h2>
  <p class="text-muted">${today}</p>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">${errorMessage}</div>
  </c:if>
  <c:if test="${not empty successMessage}">
    <div class="alert alert-success" role="alert">${successMessage}</div>
  </c:if>

  <form method="post" action="<c:url value='/diary/save'/>">
    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" class="form-control" id="title" name="title" value="${diaryForm.title}" placeholder="오늘의 제목을 입력하세요" required>
    </div>
    <div class="form-group">
      <label for="content">내용</label>
      <textarea class="form-control" id="content" name="content" rows="8" placeholder="오늘 하루를 자유롭게 작성해보세요" required>${diaryForm.content}</textarea>
    </div>
    <button type="submit" class="btn btn-primary">저장</button>
  </form>
</div>