<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	// insertDeptForm에 값 요청
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	// deptNo나 deptName에 null이나 공백("")이 들어가면 insertDeptForm 돌아가도록 강제 
	// 메서드 실행문구들은 리턴을 만나면 끝남 
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg); // get방식 주소창에 문자열 인코딩
		return;
	}
	// 이미 존재하는 ket(dept_no)값과 동일한 값이 입력되면 예외(에러)가 발생한다. 그래서 동일한 dept_no값이 입력 됐을때 예외가 발생하지 않도록 해야한다.
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// System.out.println("로딩성공"); 로딩확인 디버깅
	
	// mariadb에 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn + "<-- conn연결성공"); 연결확인 디버깅
	// dept_no 중복검사
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?"; // 쿼리 입력하기전에 동일한 dept_no가 존재하는지 확인검사
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물이 있다면 중복되는 dept_no가 이미 존재한다. 둘중 어느게 중복 됐는지는 어떻게 알아내는지?
		String msg = URLEncoder.encode("부서번호나 부서명이 중복됩니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}	
	
	// 중복검사 통과하면 입력
	// 실행할 쿼리문 sql 변수에 저장
	String sql2 = "INSERT INTO departments(dept_no, dept_name) values(?,?)";
	
	// 쿼리 작성
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	// sql insert문에 들어갈 sql	
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	// 실행 및 디버깅 변수 설정
	int row = stmt2.executeUpdate();
	
	/* 디버깅
	if(row == 1) {
		System.out.println("추가성공");
	} else {
		System.out.println("추가실패");
	}
	*/
	// insert후 List로 자동으로 돌아가도록 강제
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
