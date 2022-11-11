<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	// post로 보냈으니 utf-8로 인코딩
	// Form에서 보낸값 받기	
	request.setCharacterEncoding("utf-8");	
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	// 받은 값이 null이거나 공백으로 넘어왔으면 Form으로 메시지랑 함께 돌아가도록 강제 
	if(boardTitle == null || boardContent == null || boardWriter == null 
		|| boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("")) {
		String msg = URLEncoder.encode("제목,내용,글쓴이를 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg); // get방식 주소창에 문자열 인코딩
		return;
	}
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// System.out.println("로딩성공"); db로딩 디버깅
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println("연결성공"); db연결 성공	
	
	// INSERT 쿼리문 작성 INSERT문은 INTO문과 VALUE절을 사용하여 새로운 레코드를 테이블에 추가한다.
	String sql = "INSERT INTO board(board_title, board_content, board_writer, createdate, board_pw) values(?, ?, ?, curdate(), '1234')";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// 쿼리문 ?값 지정	
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	
	// 쿼리 실행
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("추가성공");
	} else {
		System.out.println("추가없음");
	}
	
	// INSERT후 List로 돌아가도록 강제하기
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>