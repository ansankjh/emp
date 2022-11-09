<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	// 한글 안깨지게 utf-8인코딩
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	// System.out.println("로딩 성공"); 로딩성공 디버깅 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn +"<-- conn연결성공"); 연결성공 디버깅
	
	// 쿼리문 sql변수에 저장
	String sql = "delete from departments where dept_no = ?";
	// 접속한 db에 쿼리 작성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// deptNo값 지정
	stmt.setString(1, deptNo);
	
	// 실행 및 디버깅 변수 설정
	int row = stmt.executeUpdate();
	// 디버깅
	if(row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제성공");
	}
	
	// delete후 List로 자동으로 돌아가도록 강제
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>