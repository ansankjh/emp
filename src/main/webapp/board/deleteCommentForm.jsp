<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
		<h1 align="center">댓글 삭제</h1>
		<% // 비밀번호 틀려서 실패시 넘어올 메시지 출력
			if(msg != null) {
		%>
				<div><%=msg%></div>
		<%
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<div class="center">
				삭제 비밀번호 :
				<input type="password" name="commentPw">
				<button type="submit">삭제</button>
			</div>
		</form>
	</body>
</html>