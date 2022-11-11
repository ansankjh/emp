<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<style>
			.wrapper {
				display: flex;
				justify-content: center;
				align-items: center;
				min-height: 100vh;
				text-align: center;
			}
			.button {
				text-align : center;
				width : 500px ;
				height : 150px;				
			}
			.btFont {
				font-size : 50pt;
				text-align : center;			
				line-height : 125px;
			}
			.center {
				text-align : center;
				font-size : 20pt;
				font-weight : bold;
			}
		</style>
		<meta charset="UTF-8">
		<title>index</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body class="bg-dark">	
		<!-- 메뉴 partial jsp로 구성 -->
		<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
			<jsp:include page = "./inc/menu.jsp"></jsp:include>
		</div>
			
		<table class="wrapper">
			<tr>
				<td><h1 class="text-info">INDEX</h1></td>
			</tr>
			<tr>
				<td>
					<a class="btn btn-warning button" href="<%=request.getContextPath()%>/dept/deptList.jsp"><span class="btFont">부서 관리</span></a>
					<a class="btn btn-warning button" href="<%=request.getContextPath()%>/emp/empList.jsp"><span class="btFont">사원 관리</span></a>
					<a class="btn btn-warning button" href="<%=request.getContextPath()%>/board/boardList.jsp"><span class="btFont">게시판 관리</span></a>
				</td>
			</tr>
		</table>	
	</body>
</html>