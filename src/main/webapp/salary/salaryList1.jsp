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
	
	// 변수초기화
	String listSql = null;
	String cntSql = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	
	// 동적쿼리 
	// listSql : null이면 employees와 salaries 테이블 2개를 묶어서 부서번호를 오름차순으로 조회하는 쿼리문/ null이 아니면 LIKE에 입력된  first_name 또는 last_name의 행을 조회하는 쿼리문
	// cntSql : null이면 salaries의 전체 행의수를 가져오는 쿼리문 / null이 아니면 first_name 또는 last_name에서 LIKE에 입력된 값과 일치하는 값을 가진 행을 가져오는 쿼리문	
	
	if(word == null) {
		listSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
		word = "";
	} else {
		listSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setString(2, "%"+word+"%");
		listStmt.setInt(3, beginRow);
		listStmt.setInt(4, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	
	
	
	/*
	// 총 행의수 쿼리 
		String cntSql = "SELECT COUNT(*) cnt FROM salaries";
		// 쿼리 객체 생성
		PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	*/
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
	
	/*
	// 쿼리문 작성
	String listSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	// 쿼리 객체 생성
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	
	// 쿼리 ?값 지정
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, rowPerPage);
	*/
	
	// 쿼리 실행
	ResultSet listRs = listStmt.executeQuery();
	
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(listRs.next()) {
	Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = listRs.getInt("empNo");
		s.salary = listRs.getInt("salary");
		s.fromDate = listRs.getString("fromDate");
		s.toDate = listRs.getString("toDate");
		s.emp.firstName = listRs.getString("firstName");
		s.emp.lastName = listRs.getString("lastName");
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
		<br>
		<!-- 내용 검색창 -->
		<form method="get" action="<%=request.getContextPath()%>/salary/salaryList1.jsp">
			<div align="center">
				<label for="word">내용 검색</label>
				<input type="text" name="word" id="word" value="<%=word%>"> <!-- value에 word를 입력하여 a태그로 보낸 word값을 출력한다(다음페이지에도 word값 자동출력) -->
				<button type="submit">검색</button>
			</div>
		</form>
		<br>
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
		<!-- 페이징 --> <!-- 다음페이지에도 검색한 값으로 목록이 나올수있게 word값을 보내준다. -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1" class="btn btn-success button">처음</a>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-success button">이전</a>
			<%
				}			
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-success button">다음</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>" class="btn btn-success button">마지막</a>
		</div>
		</body>
</html>