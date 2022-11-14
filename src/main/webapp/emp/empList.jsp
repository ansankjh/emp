<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%	
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");

	// 현재페이지 초기화 -> 페이징코드 받기
	// 1 currentPage(현재페이지)가 null이 아니면 currentPage 출력
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// System.out.println(currentPage); / =1
			
	// 2
	int rowPerPage = 10; // 한페이지에 표시할 갯수
	// db로딩 -> db연결 -> 쿼리문 생성 -> lastPage 구현
	Class.forName("org.mariadb.jdbc.Driver"); // db로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234"); // 자바연결
	// 동적쿼리
	// 변수초기화
	String countSql = null;
	String empSql = null;
	PreparedStatement countStmt = null;
	PreparedStatement empStmt = null;
	if(word == null) {
		countSql = "SELECT COUNT(*) FROM employees";
		countStmt = conn.prepareStatement(countSql);
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage*(currentPage-1));
		empStmt.setInt(2, rowPerPage);
		word = "";
	} else {
		countSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+word+"%");
		countStmt.setString(2, "%"+word+"%");
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setString(2, "%"+word+"%");
		empStmt.setInt(3, rowPerPage*(currentPage-1));
		empStmt.setInt(4, rowPerPage);
	}
	
	/*
	// 전체행의 갯수를 가져오는 함수를 countSql에 저장
	String countSql = "SELECT COUNT(*) FROM employees"; // COUNT(*) <-- 전체행의 갯수 가져오는 함수
	
	// conn.prepareStatement 메서드를 사용하여 PreparedStatement 클래스의 객체 countStmt 생성
	PreparedStatement countStmt = conn.prepareStatement(countSql); 
	*/
	// 쿼리 실행
	ResultSet countRs = countStmt.executeQuery();
	
	// count초기화
	int count = 0;
	if(countRs.next()) { // 행이 카운트 될때마다 count값 교체 즉, count는 행의 갯수
		count = countRs.getInt("COUNT(*)");
	}
	// System.out.println(count);
	// 페이지마다 행을 10개씩 받을거니까 count(행의 총 갯수)/페이지마다받을 행의수(rowPerPage)
	// lastPage초기화
	// 총행/페이지당행수가 나누어떨어지지 않는 경우 행의 총 갯수가 30만24개이고 30만개는 10개씩 해서 3만페이지로 끝 나머지 24개가 2페이지하고도 3페이지남아서 페이지수가 3만3개
	// lastpage의 값을 정하는 식이다.
	int lastPage = count / rowPerPage; // 300024 / 10 = 30024
	if(count % rowPerPage !=0) {  
		lastPage = lastPage+1;
	}
	
	// 한페이지에 출력할 emp목록
	// employees테이블에서 선택한 컬럼을 emp_no열의 오름차순으로 정렬한다.라는 쿼리문 empSql에 저장 
	/*
		SELECT emp_no empNo, first_name firstName, last_name lastName
		FROM employees
		WHERE first_name LIKE ? OR last_name LIKE ?
		ORDER by emp_no ASC LIMIT ?, ?
		
		empStmt.setString(1, ?);
		empStmt.setString(2, ?);
		empStmt.setInt(3, ?);
		empStmt.setInt(4, ?);
	*/
	/*
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	// empStmt객체 생성
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	
	// 미리 지정한 empStmt쿼리문의 ?값을 채워준다. ?(), ?(한페이지에 표시할 목록의 수) 
	empStmt.setInt(1, rowPerPage*(currentPage-1)); 
	empStmt.setInt(2, rowPerPage);
	*/
	ResultSet empRs = empStmt.executeQuery();
	// System.out.println(empRs);
	
	//   
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
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
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div align="center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1 align="center">사원목록</h1>
		<br>
		<!-- 내용 검색창 -->
		<form method="get" action="<%=request.getContextPath()%>/emp/empList.jsp">
			<div align="center">
				<label for="word">내용 검색</label>
				<input type="text" name="word" id="word" value="<%=word%>">
				<button type="submit">검색</button>
			</div>
		</form>
		<br>
		<div align="center">현재 페이지 : <%=currentPage%></div>
		<div class="container">
			<table class="table table-striped center" style="width:950px;" align="center">
				<tr>
					<th>사원번호</th>
					<th>퍼스트네임</th>
					<th>라스트네임</th>
				</tr>
				<%
					for(Employee e : empList) {
				%>
						<tr>
							<td><%=e.empNo%></td>
							<td><%=e.firstName%></td>
							<td><%=e.lastName%></td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
		
		<!-- 페이징 코드 -->
		<div class="center">
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
			<%
				if(currentPage > 1 && word == "") {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				} else if (currentPage > 1 && word != "") {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%
				}
				
				if(currentPage <lastPage && word == "") {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				} else if (currentPage <lastPage && word != "") {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
			<%
				}
			%>
			
			
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
		</div>		
	</body>
</html>
