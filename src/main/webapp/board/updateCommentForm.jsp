<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg");
	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234"); 	
	// 쿼리문 작성
	String sql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, createdate FROM comment WHERE comment_no=? AND board_no=? ";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리문 ?값 지정
	stmt.setInt(1, commentNo);
	stmt.setInt(2, boardNo);
	// 쿼리 실행
	ResultSet rs = stmt.executeQuery();
	
	// rs반복해서 Content랑 createdate 참조값 저장하기
	String commentContent = null;
	String createdate = null;
	while(rs.next()) {
		commentContent = rs.getString("commentContent");
		createdate = rs.getString("createdate");
	}	
%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			.td {
				line-height : 100px;
			}
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
		<h1 align="center">댓글 수정</h1>
		<!-- msg 파라메타 값이 있으면 출력 -->		
			<%
				if(msg !=null) {
			%>
					<div><%=msg%></div>
			<%
				}
			%>
		<form method="post" action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<div class>
				<table class="table table-striped center" style="width:950px;" align="center">
					<tr>
						<td class="td">수정할 내용 : </td>
						<td><textarea rows="3" cols="80"  name="commentContent"><%=commentContent%></textarea></td>
					</tr>
					<tr>
						<td>수정 비밀번호 : </td>
						<td>
							<input type="password" name="commentPw">
							<button type="submit">수정</button>
						</td>
					</tr>
				</table>
			</div>			
		</form>
	</body>
</html>