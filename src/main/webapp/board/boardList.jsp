<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	
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
	
	// 동적쿼리
	// 쿼리문 집어넣을 변수랑 객체 넣을 변수 초기화
	// null값 입력되면 원래 나오는 list , 단어가 입력되면 no 오름차순으로 board테이블에서 검색한 내용과(content) 같은 내용(content)을 포함한 no,title 나오게하는 쿼리 행의수 또한 내용(content)을 포함한 행의수 출력하게하는 쿼리
	
	String cntSql = null;
	String listSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement listStmt = null;	
	if(word == null) {
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
		word = "";
	}  else {
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");			
	}
	/*
	// 전체 행의수를 저장하는 쿼리문
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	// 저장한 쿼리문으로 쿼리 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	// ResultSet 쿼리실행결과로 객체(cntRs)의 값을 반환 executeQuery()<- SELECT문을 수행할때 사용 
	*/
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) { // 전체 행의수
		cnt = cntRs.getInt("cnt");
	}
	
	// 올림을 하게 되면 5.3 -> 6.0, 5.0->5.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	/*
	// board 넘버를 오름차순으로 컬럼을 SELECT하는 쿼리문 저장 
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	// 저장한 쿼리문으로 쿼리 객체 생성
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	// SELECT LIMIT값 지정
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	*/
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
		<style>
			.center {
				text-align : center;
				font-size : 15pt;
				font-weight : bold;
			}
			.button {
				text-align : center;
				width : 350px ;
				height : 40px;				
			}
			.button2 {
				text-align : center;
				width : 250px ;
				height : 30px;				
			}
			.btFont {
				font-size : 15pt;
				text-align : center;			
				line-height : 30px;
			}
			.btFont2 {
				font-size : 15pt;
				text-align : center;			
				line-height : 20px;
			}
			</style>
		<meta charset="UTF-8">
		<title>boardList</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp 구성 -->
		<div align="center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<h1 align="center">자유 게시판<%=currentPage%></h1>	
		<br>
		<!-- 내용 검색창 -->
		<form method="get" action="<%=request.getContextPath()%>/board/boardList.jsp">
			<div align="center">
				<label for="word">내용 검색</label>
				<input type="text" name="word" id="word" value="<%=word%>">
				<button type="submit">검색</button>
			</div>			
		</form>		
		<br>		
		<!-- 3. 모델데이터(ArrayList<Board>) 출력 -->		
		<div class="container">
			<table class="table table-striped center" style="width:950px;" align="center">
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
		</div>
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp?" class="btn btn-success button"><span class="btFont">게시글입력</span></a>
		</div>
		<!-- 3-2. 페이징 -->
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" class="btn btn-info button2"><span class="btFont2">처음</span></a>
			<%
				if(currentPage > 1 && word == ""){ // 현재 페이지가 1보다 커야 이전 버튼이 생긴다.
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-info button2"><span class="btFont2">이전</span></a>
			<%
				} else if(currentPage > 1 && word != "") {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-info button2"><span class="btFont2">이전</span></a>	
			<%
				}
				if(currentPage < lastPage &&  word == "") { // 현재 페이지가 마지막 페이지가 아닐때까지만 다음 버튼 출력
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-info button2"><span class="btFont2">다음</span></a>
			<%
				} else if(currentPage <lastPage && word != ""){
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-info button2"><span class="btFont2">다음</span></a>
			<%
				}
			%>		
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" class="btn btn-info button2"><span class="btFont2">마지막</span></a>	
		</div>
		
	</body>
</html>