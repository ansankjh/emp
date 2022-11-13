<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
	// 1. 요청분석
	String boardNo = request.getParameter("boardNo");
	// 수정 실패시 리다이렉시에는 null값이 아니고 메시지가 넘어올수있다
	// updateActionMsg로 해주면 더 좋다
	String msg = request.getParameter("msg");	
	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// System.out.println("로딩성공"); 로딩성공 디버깅
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn + "<-연결성공"); 연결 디버깅
	
	// 연결 후 sql 쿼리문 변수에 저장
	String sql = "SELECT board_no boardNo, board_title boardTitle, board_content boardContent , board_writer boardWriter, createdate from board where board_no=?";
	
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setString(1, boardNo);
	
	// 쿼리 실행 메서드
	ResultSet rs = stmt.executeQuery();
	// if문 블록안의 값은 밖에선 쓸수 없기 때문에 저장할 변수가 있어야한다.
	// 저장받을 변수들 초기화
	String boardTitle = null;
	String boardContent = null;
	String boardWriter = null;
	String createdate = null;
	if(rs.next()) { // ResultSet은 처음에 첫번째 행 이전에 커서가 존재해서 next를 이용하여 커서를 한칸씩 이동하면서 다음 행이 있으면 true를 반환하는 코드다.
		boardTitle = rs.getString("boardTitle");
		boardContent = rs.getString("boardContent");
		boardWriter = rs.getString("boardWriter");
		createdate = rs.getString("createdate");		
	}
	// 3. 출력
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
			.td {
				line-height: 150px;
			}
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<h1 align="center">게시글 수정</h1>
		<!-- msg 파라메타 값이 있으면 출력 -->		
			<%
				if(msg !=null) {
			%>
					<div class="center text-danger"><%=msg%></div>
			<%
				}
			%>
		<form method="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
			<div class="container">
				<table class="table table-striped center" style="width:600px;" align="center">
					<tr>
						<td>번호</td>
						<td>
							<input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td>제목</td>
						<td>
							<input type="text" name="boardTitle" value="<%=boardTitle%>">
						</td>
					</tr>
					<tr>
						<td class="td">내용</td>
						<td>
							<textarea cols="40" rows="5" name="boardContent"><%=boardContent%></textarea>						
						</td>
					</tr>
					<tr>
						<td>글쓴이</td>
						<td>
							<input type="text" name="boardWriter" value="<%=boardWriter%>" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td>생성날짜</td>
						<td>
							<input type="text" name="createdate" value="<%=createdate%>" readonly="readonly">
						</td>
					</tr>		
					<tr>
						<td>수정 비밀번호</td>
						<td>
							<input type="password" name="boardPw">
						</td>
					</tr>		
				</table>
			</div>
			<div class="center">
				<button type="submit">수정</button>
			</div>	
		</form>
	</body>
</html>