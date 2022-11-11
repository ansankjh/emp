<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentPw = request.getParameter("commentPw");
	
	// 2. 요청 처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// 비밀번호 비교 쿼리문
	String pwSql = "DELETE FROM comment WHERE comment_no=? AND board_no=? AND comment_pw=?";
	// 쿼리 객체 생성
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	// 쿼리문 ?값 지정
	pwStmt.setInt(1, commentNo);
	pwStmt.setInt(2, boardNo);
	pwStmt.setString(3, commentPw);
	// 쿼리 실행
	
	int row = pwStmt.executeUpdate();
	
	if(row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?commentNo="+commentNo+"&boardNo="+boardNo);
	} else {
		String msg = URLEncoder.encode("비밀번호 오류","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?commentNo="+commentNo+"&boardNo="+boardNo+"&msg="+msg);
	}

%>