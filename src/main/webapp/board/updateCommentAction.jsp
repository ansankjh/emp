<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// 쿼리문 작성
	String sql = "UPDATE comment set comment_content=? WHERE comment_no=? AND board_no=? AND comment_pw=?";
	// 쿼리 객체생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리문 ?값 지정
	stmt.setString(1, commentContent);			
	stmt.setInt(2, commentNo);
	stmt.setInt(3, boardNo);
	stmt.setString(4, commentPw);
	
	
	int row = stmt.executeUpdate();
	
	if(row == 1) { // Form에서 입력된 commentPw값과 쿼리에 있는 commentPw값이 일치하면 수정성공 불일치하면 비밀번호 확인하세요 메시지 보냄
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?commentNo="+commentNo+"&boardNo="+boardNo);
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?commentNo="+commentNo+"&boardNo="+boardNo+"&msg="+msg);
	}
	
%>
