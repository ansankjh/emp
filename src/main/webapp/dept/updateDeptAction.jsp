<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.Department" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // utf-8 인코딩
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}
	// 한개씩 난잡하게 있는것보다 Department 클래스의 dept 변수 하나로 묶어서 정리 해두는게 편하다?
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // 2-1. 로딩
	// System.out.println("로딩 성공");
	// 2-2. 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn + "<-- conn 연결성공"); // 연결 성공 디버깅
	
	String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?"; // 쿼리 입력전에 동일한 dept_name이 있는지 확인검사
	PreparedStatement stmt1 = conn.prepareStatement(sql1); // stmt2에 sql2 작성
	stmt1.setString(1, deptName); // sql2에 들어갈 값
	ResultSet rs  = stmt1.executeQuery(); // 쿼리 실행
	if(rs.next()) { // 쿼리 실행해서 중복되면 msg 출력
		String msg = URLEncoder.encode(deptName+"은 이미 존재하여 사용할 수 없습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 실행할 쿼리문 sql 변수에 저장
	String sql2 = "UPDATE departments set dept_name=? where dept_no=?";
	
	// 쿼리 작성
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	// sql update문에 들어갈 sql	
	stmt2.setString(1, dept.deptName);
	stmt2.setString(2, dept.deptNo);
	
	// 실행 및 디버깅 변수 설정
	int row = stmt2.executeUpdate();
	
	/* 디버깅 
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	*/
	
	// update후 List로 자동으로 돌아가도록 강제
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
