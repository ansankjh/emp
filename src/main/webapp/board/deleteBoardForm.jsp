<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 삭제 실패시 리다이렉시에는 null값이 아니고 메시지가 넘어올수있다
	// deleteActionMsg로 해주면 더 좋다
	String msg = request.getParameter("msg");  
%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			.center {
				text-align : center;
				font-size : 15pt;
				font-weight : bold;
			}
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>		
		<h1 align="center">[<%=boardNo%>번] 게시글삭제</h1>
		<% // 비밀번호 틀려서 실패시 넘어올 메시지 출력
			if(msg != null) {
		%>
				<div class="center text-danger"><%=msg%></div>
		<%
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">		
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<div class="center">
				삭제 비밀번호 :				
				<input type="password" name="boardPw">		
				<button type="submit">삭제</button>
			</div>		
		</form>
	</body>
</html>