<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createdate = request.getParameter("createdate");
	String boardPw = request.getParameter("boardPw");
	
	// 2. 요청 처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// 쿼리문 작성 UPDATE문은 WHERE절의 조건을 만족하는것 레코드만 수정한다.
	String sql = "UPDATE board set board_title=?, board_Content=? where board_no=? AND board_pw=?";
	// 작성한 쿼리문으로 쿼리객체생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리문 값 지정
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setInt(3, boardNo);
	stmt.setString(4, boardPw);
	// 쿼리 실행
	int row = stmt.executeUpdate();
	
	if(row == 1) { // row가 1이면 삭제성공이므로 List로 돌아가고/ row가 0이면 msg와 함께 deleBoardForm으로 돌아가기
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
%>
