<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %> <!-- vo.Salary -->
<%@ page import = "java.util.*" %>
<%
	// 1 요구사항 분석(페이징)
	// 현재 페이지 만들기
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");

	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2 요청처리(드라이버로딩->드라이버연결->쿼리문작성->쿼리객체생성->쿼리실행)
	// 한페이지에 넣을 목록수
	int rowPerPage = 10;
	// 페이지당 시작할 행의 첫번째 숫자
	int beginRow = (currentPage - 1) * rowPerPage;
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "wkqk1234");	
	
	// 총 행의수 쿼리 
		String cntSql = "SELECT COUNT(*) cnt FROM salaries";
		// 쿼리 객체 생성
		PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	
		// 쿼리 실행
		ResultSet cntRs = cntStmt.executeQuery();
		int cnt = 0;
		if(cntRs.next()) {
			cnt = cntRs.getInt("cnt");
		}
		// System.out.println(cnt);
		// 마지막 페이지 구하기
		int lastPage = cnt / rowPerPage;
		// System.out.println(lastPage);
	/*
	SELECT s.emp_no empNo
		, s.salary salary
		, s.from_date fromDate
		, s.to_date toDate
		, e.first_name firstName 
		, e.last_name lastName
	FROM
	salaries s INNER JOIN employees e 
	ON s.emp_no = e.emp_no
	LIMIT ?, ?
	*/
	
	
	// 쿼리문 작성
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// 쿼리 ?값 지정
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	
	// 쿼리 실행
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(rs.next()) {
	Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
  
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
			.button {
				text-align : center;
				width : 200px ;
				height : 40px;				
			}
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<h1 align="center">연봉관리[<%=currentPage%>]</h1>
		<div class="container">
			<table class="table table-striped center" style="width:950px;" align="center">
				<tr>
					<th>부서번호</th>
					<th>연봉</th>
					<th>계약갱신</th>
					<th>계약만료</th>
					<th>퍼스트네임</th>
					<th>라스트네임</th>
				</tr>
			<%
				for(Salary s : salaryList) {
			%>
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						<td><%=s.emp.firstName%></td>
						<td><%=s.emp.lastName%></td>
					</tr>
			<%
				}
			%>
			</table>
		</div>
		<!-- 페이징 -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1" class="btn btn-success button">처음</a>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>" class="btn btn-success button">이전</a>
			<%
				}			
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>" class="btn btn-success button">다음</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>" class="btn btn-success button">마지막</a>
		</div>
		</body>
</html>