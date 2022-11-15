<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- HashMap<키,값>, ArrayList<요소> ArrayList<HashMap<,>> -->
<%
	// 1) 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");

	// 페이징 currentPage....	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2) 요청처리
	// 페이징 rowPerPage ....
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	// db로딩,연결,쿼리문,쿼리객체
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "wkqk1234";
	Class.forName(driver); // 드라이버로딩
	// conn객체에 대표적으로 저장가능한건 쿼리 드라이버연결하는 메서드
	// 주소체계 3가지 방법
	// 1. ("프로토콜://255.255.255.255","","") ip
	// 2. ("프로토콜://www.gdu.co.kr","","") 도메인
	// 3. ("프로토콜://주소:포트번호","","")
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리문, 쿼리객체 변수 초기화
	String cntSql = null;
	String joinSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement joinStmt = null;
	
	if(word == null) {
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
		joinSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_Name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		joinStmt = conn.prepareStatement(joinSql);
		joinStmt.setInt(1, beginRow);
		joinStmt.setInt(2, rowPerPage);
		word = "";
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
		joinSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ? ";
		joinStmt = conn.prepareStatement(joinSql);
		joinStmt.setString(1, "%"+word+"%");
		joinStmt.setString(2, "%"+word+"%");
		joinStmt.setInt(3, beginRow);
		joinStmt.setInt(4, rowPerPage);
	}
	
	/*
	// 행의수 쿼리문
	String cntSql = "SELECT COUNT(*) cnt FROM salaries";
	// 행의수 쿼리 객체생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	*/
	// 쿼리 실행
	ResultSet cntRs = cntStmt.executeQuery();
	// cnt 초기화
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	
	/* join쿼리문
	// FROM절이 젤먼저 실행되고 ON절 실행되고 SELECT절 실행되고 마지막으로 ORDER BY절 실행 CONCAT으로 괄호안의것을 name으로 합친다
	String joinSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
	PreparedStatement joinStmt = conn.prepareStatement(joinSql);
	joinStmt.setInt(1, beginRow);
	joinStmt.setInt(2, rowPerPage);
	*/
	ResultSet joinRs = joinStmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(joinRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", joinRs.getInt("empNo"));
		m.put("salary", joinRs.getInt("salary"));
		m.put("fromDate", joinRs.getString("fromDate"));
		m.put("name", joinRs.getString("name"));
		list.add(m);
	}
	cntRs.close();
	joinRs.close();
	joinStmt.close();
	cntStmt.close();
	conn.close(); // 드라이버 연결을 끊는 메서드
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
		<title>salaryMaqpList</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<h1 align="center">연봉 목록[<%=currentPage%>]</h1>
		<br>
		<form method="get" action="<%=request.getContextPath()%>/salary/salaryMapList.jsp">
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
					<th>사원이름</th>
					<th>연봉</th>
					<th>계약일자</th>
				</tr>
				<%
					for(HashMap<String, Object> m : list) {
				%>
						<tr>
							<td><%=m.get("empNo")%></td>
							<td><%=m.get("name")%></td>
							<td><%=m.get("salary")%></td>
							<td><%=m.get("fromDate")%></td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
		<!-- 페이징 -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1" class="btn btn-info">처음</a>
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-info">이전</a>
			<%
				}
				
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-info">다음</a>
			<%
				}
			%>			
			<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>" class="btn btn-info">마지막</a>
		</div>
	</body>
</html>