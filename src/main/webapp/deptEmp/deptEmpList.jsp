<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 도메인 사용하는 방법
	// 1. 요청분석
	// 페이징할거
	request.setCharacterEncoding("utf-8");	
	String word = request.getParameter("word");
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 한 페이지당 표시할 목록의 수
	int rowPerPage = 10;
	// 페이지마다 표시될 첫번째 행의 숫자
	int beginRow = (currentPage-1) * rowPerPage;
	// 2. 요청처리
	// 드라이버 로딩/연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "wkqk1234";
	// 드라이버 로딩		
	Class.forName(driver);
	// 드라이버 연결
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 동적쿼리
	// 변수 초기화
	String empSql = null;
	String cntSql = null;
	PreparedStatement empStmt = null;
	PreparedStatement cntStmt = null;
	
	// 쿼리문 작성
	if(word == null) {
		// INNER JOIN 쿼리문 작성
		empSql = "SELECT de.emp_no empNo, de.dept_no deptNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY d.dept_no LIMIT ?, ?";
		// 쿼리객체 생성
		empStmt = conn.prepareStatement(empSql);
		// 쿼리 ?값 지정
		empStmt.setInt(1, beginRow);
		empStmt.setInt(2, rowPerPage);
		// 행의수 가져오는 쿼리문 작성
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		// 쿼리 객체 생성
		cntStmt = conn.prepareStatement(cntSql);
		word = "";
	} else {
		// null이 아닌경우 쿼리문 INNER JOIN 쿼리문
		empSql = "SELECT de.emp_no empNo, de.dept_no deptNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE first_name LIKE ? ORDER BY d.dept_no LIMIT ?, ?";
		// 쿼리문 객체 생성
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setInt(2, beginRow);
		empStmt.setInt(3, rowPerPage);
		// null이 아닌경우 행의수 가져오는 쿼리문
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ?";
		// 쿼리 객체생성
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	/*
	// 쿼리문 작성
	String cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
	// 쿼리 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	*/
	int cnt = 0;
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}	
	int lastPage = cnt / rowPerPage;
	/*
	// 쿼리문 작성
	String empSql = "SELECT de.emp_no empNo, de.dept_no deptNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY d.dept_no LIMIT ?, ?";
	// 목록 조회하는 쿼리 실행
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, beginRow);
	empStmt.setInt(2, rowPerPage);
	*/
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<DeptEmp> empList = new ArrayList<DeptEmp>();
	while(empRs.next()) {
		DeptEmp de = new DeptEmp();
			de.emp = new Employee();
			de.dept = new Department();
			de.emp.empNo = empRs.getInt("empNo");
			de.emp.firstName = empRs.getString("firstName");
			de.dept.deptName = empRs.getString("deptName");
			de.fromDate = empRs.getString("fromDate");
			de.toDate= empRs.getString("toDate");
			empList.add(de);				
	}
	cntRs.close();
	empRs.close();
	empStmt.close();
	cntStmt.close();
	conn.close(); // 
%>
<%	
	/*
	// DeptEmp.class가 없다면 도메인 타입이 없다면	
	// deptEmpMapList.jsp
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		//...	
	}
	*/ 
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
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<h1 align="center">계약기간[<%=currentPage%>]</h1>
		<br>		
		<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">
			<div class="center">
				<label for="word">검색어 : </label>
				<input type="text" name="word" id="word" value="<%=word%>">
				<button type="submit">검색</button>
			</div>
		</form>
		
		<br>
		<div class="container">
			<table class="table table-striped center" style="width:950px;" align="center">
				<tr>
					<th>사원번호</th>
					<th>퍼스트네임</th>
					<th>부서명</th>
					<th>계약일자</th>
					<th>만료일자</th>
				</tr>		
				<%
					for(DeptEmp de : empList) {
				%>
						<tr>
							<td><%=de.emp.empNo%></td>
							<td><%=de.emp.firstName%></td>
							<td><%=de.dept.deptName%></td>
							<td><%=de.fromDate%></td>
							<td><%=de.toDate%></td>
						</tr>
				<%
					}
				%>		
			</table>
		</div>
		<!-- 페이징 -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>" class="btn btn-info">처음</a>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-info">이전</a>
			<%
				}
				
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-info">다음</a>
			<%
				}
			%>			
			<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="btn btn-info">마지막</a>
		</div>
	</body>
</html>