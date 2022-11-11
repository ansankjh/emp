<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1; // 현재 페이지 1(첫페이지)
	if(request.getParameter("currentPage") != null) { // 현재 페이지 요청해서 null이 아니면 정수화시켜서 현재 페이지 저장
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10; // 한페이지에 몇개 볼지 
	
	Class.forName("org.mariadb.jdbc.Driver"); // db로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234"); // db 연결
	// lastPage 구하는 코드
	String countSql = "SELECT COUNT(*) FROM employees"; // SELECT 쿼리문 countSql에 참조값 저장
	PreparedStatement countStmt = conn.prepareStatement(countSql); // db에 countSql의 참조값으로 쿼리 작성
	ResultSet countRs = countStmt.executeQuery(); // 쿼리 실행
	int count = 0; // count 초기화
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage !=0) {
		lastPage = lastPage +1; // lastPage++, alstPage+=1
	}
	// 한페이지당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage*(currentPage-1));
	empStmt.setInt(2, rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
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
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>	
	<h1>사원목록</h1>
	<div>현재 페이지 : <%=currentPage%></div>
	<table>
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
					<td><a href=""><%=e.firstName%></a></td>
					<td><%=e.lastName%></td>					
				</tr>
		<%
			}
		%>
	</table>
	
	
	<!-- 페이징 코드 -->
	<div>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1) {				
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>	
		<%	
			}
		%>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
	</div>
</body>
</html>