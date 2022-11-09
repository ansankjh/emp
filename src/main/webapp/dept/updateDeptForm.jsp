<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.Department" %>
<%
	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	//updateDeptForm.jsp를 직접 호출 하면 deptNo는 null값이 되므로 무조건 deptList.jsp에서 실행하게 만든다.
	if(deptNo == null) { 
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}

	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// System.out.println("로딩성공"); 드라이버 로딩 성공 디버깅
	// mariadb 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// System.out.println(conn + "<--conn연결 성공"); db 연결성공 디버깅
	
	// 실행할 쿼리문 sql 변수에 저장
	String sql = "SELECT dept_name deptName from departments where dept_no =?";
	
	// 쿼리 작성
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	// 쿼리 실행 메서드
	ResultSet rs = stmt.executeQuery();
	
	// if 블럭 안에 쓰면 밖에서 못쓰기 때문에 블럭 밖에서 변수를 지정해놓고 블럭안의 값을 저장해둔다
	// 변수를 지정해놨기 때문에 if문 안에다가 출력을 적을 필요가 없어진다. 요청과 출력을 분리
	
	Department dept = null;
	
	if(rs.next()) {
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<style>
		.button {
				text-align : center;
				width : 200px ;
				height : 50px;				
			}
			.btFont {
				font-size : 20pt;
				text-align : center;			
				line-height : 40px;
			}
			.center {
				text-align : center;
				font-size : 20pt;
				font-weight : bold;
			}
		</style>
		<meta charset="UTF-8">
		<title>updateDeptForm</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp로 구성 -->
		<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
			<jsp:include page = "../inc/menu.jsp"></jsp:include>
		</div>
	
		<div><h2 align="center">부서명 변경</h2></div>
		<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
			<div class="container" align="center">
				<table class="table table-striped" style="width:300px;" align="center">
					<tr>
						<td>DEPTNO</td>
						<td> <!-- readonly="readonly" 사용해서 수정 불가능 -->
							<input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td>DEPTNAME</td>
						<td>
							<input type="text" name="deptName" value="<%=dept.deptName%>">
						</td>						
					</tr>				
				</table>
			</div>
			<div align="center">
				<button type="submit"><span>변경</span></button>
			</div>
		</form>
	
	</body>
</html>