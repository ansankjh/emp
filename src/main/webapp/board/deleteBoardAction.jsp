<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	// 2.
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// 쿼리문 작성 DELETE문은 WHERE절의 조건을 만족시키는 레코드만 삭제한다. WHERE절을 생략하면 테이블에 저장된 모든 데이터 삭제
	String sql = "DELETE FROM board WHERE board_no=? AND board_pw=?";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리 물음표값 지정
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	// executeUpdate 쿼리실행결과로 int값 반환&SELECT문을 제외하고 다른 쿼리문을 수행할때 사용되는 함수 
	int row = stmt.executeUpdate();
	
	if(row == 1) { // row가 1이면 삭제성공이므로 List로 돌아가고/ row가 0이면 msg와 함께 deleBoardForm으로 돌아가기
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
	
	
	// 3.
%>