<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partial jsp 페이지 사용할 코드 -->
<a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-info">홈으로</a>
<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-info">부서관리</a>
<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-info">사원관리</a>
<a href="<%=request.getContextPath()%>" class="btn btn-info">연봉관리</a>
<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-info">게시판관리</a>