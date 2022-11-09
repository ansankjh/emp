<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			.center {
				text-align : center;
				font-size : 20pt;
				font-weight : bold;				
			}
			.font {
				font-size : 20pt;
				text-align : center;			
				line-height : 35px;
			}
		</style>
		<meta charset="UTF-8">
		<title>insertDeptForm</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>	
		<!-- 메뉴 partial jsp로 구성 -->
		<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
			<jsp:include page = "../inc/menu.jsp"></jsp:include>
		</div>
		
		<div class="center"><h1>부서추가</h1></div>
		<!-- msg 파라메타 값이 있으면 출력 -->		
		<%
			if(request.getParameter("msg") !=null) {
		%>
				<div><%=request.getParameter("msg")%></div>
		<%
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
			<div class="font container"> 
				<table class="table table-striped">
					<tr>
						<td>DEPTNO</td>
						<td>
							<input type="text" name="deptNo">
						</td>
					</tr>
					<tr>
						<td>DEPTNAME</td>
						<td>
							<input type="text" name="deptName">
						</td>						
					</tr>				
				</table>
				<div>
					<button type="submit">부서추가</button>
				</div>
			</div>	
		</form>
	</body>
</html>