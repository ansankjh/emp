<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.util.*" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 댓글 페이징에 사용할 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String msg = request.getParameter("msg");
	// 2. 요청처리
	// 드라이버 로딩	
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","wkqk1234");
	// board_no와 같은 행을 SELECT하는 쿼리를 저장 (SELECT:테이블에 있는 데이터 조회하는 쿼리문)
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	// 저장한 쿼리문으로 쿼리 객체 생성
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	// board_no 값 지정(쿼리문의 ?값 지정)
	boardStmt.setInt(1, boardNo);
	// 쿼리 실행
	ResultSet boardRs = boardStmt.executeQuery();
	
	// Board클래스로 타입 묶기
	// board타입의 board NO,Title,Content,Writer
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	// ----------------------------------------------댓글 부분----------------------------------------------------------
	/*
	SELECT comment_no commentNo, board_no boardNo, comment_content commentContent FROM comment WHERE board_no = ?
			ORDER BY comment_no DESC
			 LIMIT (currentPage-1)*ROW_PER_PAGE, 5
	*/
	
	
	// 한페이지에 표시할 목록 수
	int rowPerPage = 5;
	// 시작할 행의 번호? LIMIT ?(beginRow), ?(rowPerPage)
	int beginRow = (currentPage-1)*rowPerPage;
	// 총 행의 수 구하는 쿼리문 작성
	String countSql = "SELECT COUNT(*) cnt FROM comment";
	// 쿼리 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(countSql);
	// 쿼리 실행
	ResultSet cntRs = cntStmt.executeQuery();
	// cnt 초기화
	// 쿼리의 커서가 한열씩 이동하면서 true면 cnt를 반환 커서는 ResultSet 안에서만 움직인다.
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	// 마지막 페이지 총행의수/한페이지당표시할목록의수
	int lastPage = cnt / rowPerPage;
	
	// 쿼리문 작성
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?,?";
	// 쿼리 객체 생성
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	// 쿼리문 ?값 지정
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	// 쿼리 실행
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	
	// 3
%>
<!DOCTYPE html>
<html>
	<head>
		<style>			
			.td {						
				line-height: 250px;
			}
			.td2 {
				width: 100px;	
			}
			.td3 {
				width: 200px;
			}
			.center {
				text-align : center;
				font-size : 15pt;
				font-weight : bold;
			}
			.center2 {
				text-align : center;
				font-size : 12pt;
				font-weight : bold;
			}
			.font {
				font-size : 15pt;
			}
			.font2 {
				font-size : 20pt;
			}
			.button {
				text-align : center;
				width : 50px ;
				height : 40px;	
			}
			.btFont {
				font-size : 8pt;
				text-align : center;							
				font-weight : bold;
			}
		</style>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp 구성 -->
		<div align="center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1 align="center">게시글 상세보기</h1>		
		<div class="container">
			<table class="table table-striped center" style="width:1000px;" align="center">
				<tr>
					<td class="td2">번호</td>
					<td><%=board.boardNo%></td>
				</tr>
				<tr>
					<td class="td2">제목</td>
					<td><%=board.boardTitle%></td>
				</tr>
				<tr>
					<td class="td td2">내용</td>
					<td><%=board.boardContent%></td>
				</tr>
				<tr>
					<td class="td2">글쓴이</td>
					<td><%=board.boardWriter%></td>
				</tr>
				<tr>
					<td class="td2">생성날짜</td>
					<td><%=board.createdate%></td>
				</tr>
			</table>
		</div>
		<div colspan = "4" class = "center">
			<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">게시글 수정</a>
			<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">게시글 삭제</a>
		</div>		
		
		
		
		<div>
			<!-- 댓글 목록 -->
			<h2 align="center">댓글 목록</h2>
			<%
				for(Comment c : commentList) {
			%>
					<div>
						<table class="table table-striped center" style="width:1000px;" align="center">
							<tr>
								<td class="font td3">
									<%=c.commentNo%>번 댓글
									<div>
										<a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>" class="btn btn-info button"><span class="btFont">수정</span></a>
										<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>" class="btn btn-info button"><span class="btFont">삭제</span></a>					
									</div>
								</td>
								<td><%=c.commentContent%></td>
							</tr>							
						</table>
					</div>			
			<%
				}
			%>
			
		</div>
		<div>
			<!-- 댓글입력 폼 -->
			<% // 비밀번호 틀려서 실패시 넘어올 메시지 출력
				if(msg != null) {
			%>
					<div><%=msg%></div>
			<%
				}
			%>
			<form method="post" action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
				<input type="hidden" name="boardNo" value="<%=board.boardNo %>"> <!-- 부모글번호 히든으로 넘겨주기 -->
				<div class="container" align="center">
					<table class="table table-striped center2" style="width:1000px;" align="center">
						<tr>
							<td class="td2">댓글입력</td>
							<td>
								<textarea rows="3" cols="80" name="commentContent"></textarea>								
							</td>
						</tr>
						<tr>
							<td class="td2">비밀번호</td>
							<td>
								<input type="password" name="commentPw">
								<button type="submit">댓글입력</button>
							</td>
						</tr>						
					</table>
					<!-- 댓글 페이징 -->
					<%
						if(currentPage > 1) {
					%>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>" class="btn btn-info button2">이전</a>
					<%
						}
					%>
						<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>" class="btn btn-info button2">다음</a>
					<%
						}
					%>
				</div>
				
			</form>
		</div>
	</body>
</html>