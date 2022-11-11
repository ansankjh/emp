<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// SELECT문 작성
	String sql = "SELECT comment_pw FROM comment WHERE comment_pw = ?";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리문 ?값 지정
	stmt.setString(1, commentPw);
	// executeQuery를 통해 쿼리를 실행하면 ResultSet타입으로 반환하여 결과가 저장
	ResultSet rs  = stmt.executeQuery(); // 쿼리 실행
	if(rs.next() != true) { // 쿼리 실행해서 중복되면 msg 출력
		String msg = URLEncoder.encode("비밀번호 오류","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	
	
	
	// 쿼리문 작성
	String sql2 = "INSERT INTO comment(board_no, comment_content, comment_pw, createdate) values(?, ?, ?, curdate())";
	// 쿼리 객체 생성
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	//쿼리문 ?값 지정
	stmt2.setInt(1, boardNo);
	stmt2.setString(2, commentContent);
	stmt2.setString(3, commentPw);
	
	// 쿼리 실행
	
	int row = stmt2.executeUpdate();

	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	
	
%>
