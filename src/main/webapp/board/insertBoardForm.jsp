<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String msg = request.getParameter("msg");
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
			.td {							
				line-height: 150px;
			}
		</style>
		<meta charset="UTF-8">
		<title>insertBoardForm</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp로 구성 -->
		<div class="center"> <!-- include는 절대주소를 적을때 ContextPath를 못쓴다 예를들면 7반의 누구를 부를건데 밖에서 부르면 7반의 누구인데 7반에서 부르면 이름만 부르면 된다 -->
			<jsp:include page = "/inc/menu.jsp"></jsp:include>
		</div>
		<h1 align="center">게시글 쓰기</h1>
		<!-- msg 파라메타 값이 있으면 출력 -->		
			<%
				if(msg !=null) {
			%>
					<div class="center text-danger"><%=msg%></div>
			<%
				}
			%>
		<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
			<div class="container">
				<table class="table table-striped center" style="width:500px;" align="center">				
					<tr>
						<td>제목</td>
						<td>
							<input type="text" name="boardTitle">
						</td>
					</tr>
					<tr>
						<td class="td">내용</td>
						<td>
							<textarea cols="22" rows="5" name="boardContent"></textarea>
						</td>
					</tr>		
					<tr>
						<td>글쓴이</td>
						<td>
							<input type="text" name="boardWriter">
						</td>
					</tr>
					<tr>
						<td>생성날짜</td>
						<td></td>
					</tr>				
				</table>
				<div class="center">
					<button type="submit">게시글 추가</button>
				</div>
			</div>
		
		</form>
	</body>
</html>