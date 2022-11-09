<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// MVC구조 -> Model2프로젝트
	// 1. 요청분석(Controller)
	// 2. 업무처리(Model) -> 모델데이터가 남는다(단일값 or 자료구조형태(배열,리스트,....))
	// 2-1. mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// System.out.println("로딩완료"); 드라이버 로딩완료 디버깅 
	
	// 2-2. mariadb 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn + "<-- conn"); conn 연결 완료 디버깅
	// 실행할 쿼리문 sql변수에 저장
	String sql = "SELECT dept_no deptNo, dept_name deptName From departments ORDER BY dept_no ASC";
	// 접속 데이터베이스에 쿼리를 만들때 사용하는 메서드 
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리를 실행할때 사용하는 메서드
	ResultSet rs = stmt.executeQuery();	
	// <-- 모델데이터 Resultset은 일반적인 타입이 아니고 독립적인 타입도 아니다.
	// ResultSet rs라는 모델자료구조를 좀 더 일반적이고 독립적인 자료구조로 변경을 하자
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문.
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트,보고서)라고한다	
%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			.center {
				text-align : center;
				font-size : 20pt;
				font-weight : bold;
			}
			.button {
				text-align : center;
				width : 500px ;
				height : 50px;				
			}
			.btFont {
				font-size : 20pt;
				text-align : center;			
				line-height : 35px;
			}
		</style>
		<meta charset="UTF-8">
		<title>deptList</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp로 구성 -->
		<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
			<jsp:include page = "../inc/menu.jsp"></jsp:include>
		</div>
		
		<div class="container p-5 my-5 bg-dark text-white" style="width:950px;">
			<h1 align="center" >DEPT LIST</h1>
		</div>		
		<div class="container">
			<!-- 부서목록출력 -->
			<table class="table table-striped" style="width:950px;" align="center">
				<thead class="text-danger">
					<tr>
						<th class = "center">부서번호</th>
						<th class = "center">부서이름</th>
						<th class = "center">수정</th>
						<th class = "center">삭제</th>
					</tr>
				</thead>
				<tbody>
					<% // list에서 d로 값을 넣어 출력한다.
						for(Department d : list) {
					%>
							<tr>
								<td class = "center"><%=d.deptNo%></td>
								<td class = "center"><%=d.deptName%></td>
								<td class = "center"><a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>" class="btn btn-info">수정</a></td>
								<td class = "center"><a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>" class="btn btn-danger">삭제</a></td>								
							</tr>
					<%
						}
					%>
					<tr>
						<td colspan = "4" class = "center">				
							<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-primary button"><span class="btFont">부서추가</span></a>						
						</td>
					</tr>		
				</tbody>				
			</table>
		</div>
	</body>
</html>