<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	// 2. 요청처리
	// 드라이버 불러올때 필요한 변수 초기화
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "wkqk1234";
	
	// 드라이버로딩
	Class.forName(driver);
	// 드라이버 연결
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	// 동적 쿼리
	// 쿼리 들어갈 변수 초기화
	String listSql = null;
	String cntSql = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	// 쿼리문 작성
	if(word == null) {
		// 쿼리문
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY d.dept_no LIMIT ?, ?";
		// 쿼리객체
		listStmt = conn.prepareStatement(listSql);
		// 쿼리 ?값 지정
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, rowPerPage);
		// cnt쿼리문
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		// 쿼리객체
		cntStmt = conn.prepareStatement(cntSql);
		word = "";
	} else {
		// null값 아닐때 쿼리문
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE first_name LIKE ? ORDER BY d.dept_no LIMIT ?, ?";
		// 쿼리객체
		listStmt = conn.prepareStatement(listSql);
		// 쿼리 ?값 지정
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, rowPerPage);
		// null이 아닐때 행의수 가져오는 쿼리문
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ?";
		// 쿼리 객체
		cntStmt = conn.prepareStatement(cntSql);
		// 쿼리 ?값 지정
		cntStmt.setString(1, "%"+word+"%");
	}
	
	/*
	// 총 행의 수 가져오는 쿼리문 작성
	String cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
	// 쿼리객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	*/
	// 쿼리 실행
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	/*
	// 쿼리문 작성
	String listSql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY d.dept_no LIMIT ?, ?";
	// 쿼리객체 생성
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	// 쿼리문 ?값 지정
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, rowPerPage);
	*/
	
	// 쿼리 실행
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<HashMap<String, Object>> empList = new ArrayList<HashMap<String, Object>>();
	while(listRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("empNo", listRs.getInt("empNo"));
			m.put("firstName", listRs.getString("firstName"));
			m.put("deptName", listRs.getString("deptName"));
			m.put("fromDate", listRs.getString("fromDate"));
			m.put("toDate", listRs.getString("toDate"));
			empList.add(m);
	}
	
	cntRs.close();
	listRs.close();
	cntStmt.close();
	listStmt.close();
	conn.close();	
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
		<form action="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp">
			<div class="center">			
				<label for="word">검색어 : </label>
				<input type="text" name="word" id="word" value="<%=word%>">
				<button type="submit">검색</button>				
			</div>
		</form>
		<br>
		<table class="table table-striped center" style="width:950px;" align="center">
			<tr>
				<th>사원번호</th>
				<th>퍼스트네임</th>
				<th>부서명</th>
				<th>계약일자</th>
				<th>만료일자</th>
			<tr>
			<%
				for(HashMap<String, Object> m : empList) {
			%>
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("firstName")%></td>
						<td><%=m.get("deptName")%></td>
						<td><%=m.get("fromDate")%></td>
						<td><%=m.get("toDate")%></td>
					</tr>
			<%
				}
			%>
		</table>
		<!-- 페이징 -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=1&word=<%=word%>" class="btn btn-info">처음</a>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-info">이전</a>
			<%
				}
			
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-info">다음</a>
			<%
				}
			%>			
			<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="btn btn-info">마지막</a>
		</div>
	</body>
</html>