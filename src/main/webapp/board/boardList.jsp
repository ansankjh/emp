<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 모델데이터를 생성
	// final을 붙여주면 변경 안되는 상수가 된다. 상수변수는 대문자로 적고 언더바로 단어 사이를 구분
	final int ROW_PER_PAGE = 10; // 페이지당 나타낼 목록의 수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ... Limit ?(beginRow), ?(ROW_PER_PAGE) 페이지의 시작행을 나타낸다.
	
	Class.forName("org.mariadb.jdbc.Driver"); //  드라이버 불러오기
	// System.out.println("로딩성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234"); // 드라이버에 접속완
	// System.out.println("드라이버 접속완료"); // 드라이버에 접속 완료
	
	// 전체 행의수를 저장하는 쿼리문
	String contSql = "SELECT COUNT(*) cnt FROM board";
	// 저장한 쿼리문으로 쿼리 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(contSql);
	// ResultSet 쿼리실행결과로 객체(cntRs)의 값을 반환 executeQuery()<- SELECT문을 수행할때 사용 
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) { // 전체 행의수
		cnt = cntRs.getInt("cnt");
	}
	
	// 올림을 하게 되면 5.3 -> 6.0, 5.0->5.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	// board 넘버를 오름차순으로 컬럼을 SELECT하는 쿼리문 저장 
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	// 저장한 쿼리문으로 쿼리 객체 생성
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	// SELECT LIMIT값 지정
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	// 생성한 쿼리 객체를 실행
	ResultSet listRs = listStmt.executeQuery();
	// 보편적이지 못한 while문 대신 foreach문을 사용하기 위해 ArrayList를 사용하여 배열 생성
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");		
		boardList.add(b);
		
	}
	
	// 3. 출력
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>boardList</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<h1>자유 게시판</h1>	
		<!-- 3. 모델데이터(ArrayList<Board>) 출력 -->
		<div>
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">게시글입력</a>
		</div>
		<table class="table table-striped">
			<tr>		
				<th>번호</th>
				<th>제목</th>			
			</tr>
			
			<%
				for(Board b : boardList) { // foreach문 boardList 배열이 가진 요소를 반복시킨다.(no,title)
			%>
					<tr>
						<td><%=b.boardNo%></td>
						<!-- 제목 클릭시 상세보기로 이동 -->
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a>
						</td>					
					</tr>
			<%
				}
			%>
		</table>	
		<!-- 3-2. 페이징 -->
		<div>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
			<%
				if(currentPage > 1){ // 현재 페이지가 1보다 커야 이전 버튼이 생긴다.
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
			%>
			
			<span><%=currentPage%></span>
			
			<%
				if(currentPage < lastPage) { // 현재 페이지가 마지막 페이지가 아닐때까지만 다음 버튼 출력
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				}
			%>		
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
		</div>
	</body>
</html>