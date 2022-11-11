<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 partial jsp로 구성 -->
	<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
		<jsp:include page = "/inc/menu.jsp"></jsp:include>
	</div>
	<h1>댓글 삭제</h1>
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
		삭제 비밀번호 :
		<input type="password" name="commentPw">
		<button type="submit">삭제</button>
	</form>
</body>
</html>