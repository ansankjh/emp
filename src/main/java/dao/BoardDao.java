package dao;

import db.*;
import java.sql.*;
import java.util.*;
import vo.*;

public class BoardDao {
	// boardList 행의수
	public int countBoard() {
		// 리턴할 row 초기화
		int count = 0;
		// db타입 dbUtil 객체 초기화
		DBUtil dbUtil = null;
		// 드라이버 연결 객체 초기화
		Connection conn = null;
		// 쿼리 객체 초기화
		PreparedStatement stmt = null;
		// 쿼리 실행 객체 초기화
		ResultSet rs = null;
		// 쿼리문 작성
		String sql = "SELECT COUNT(*) FROM board";
		// try catch
		try {
			dbUtil = new DBUtil();
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt("COUNT(*)");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}		
		return count;
	}
	// 검색어 있을경우 나올 행의수	
	public int countBoardLike(String word) {
		// 리턴할 row 초기화
		int count = 0;
		// db타입 dbUtil 객체 초기화
		DBUtil dbUtil = null;
		// 드라이버 연결 객체 초기화
		Connection conn = null;
		// 쿼리 객체 초기화
		PreparedStatement stmt = null;
		// 쿼리 실행 객체 초기화
		ResultSet rs = null;
		// 쿼리문 작성
		String sql = "SELECT COUNT(*) FROM board WHERE board_content LIKE ?";
		// try catch
		try {
			dbUtil = new DBUtil();
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+word+"%");
			rs = stmt.executeQuery();			
			if(rs.next()) {
				count = rs.getInt("COUNT(*)");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}		
		return count;
	}
	// boardList.jsp 리스트 조회
	public ArrayList<Board> selectBoardList(int beginRow, int ROW_PER_PAGE) {
		ArrayList<Board> list = null;
		DBUtil dbUtil = null;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		try {
			dbUtil = new DBUtil();
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, ROW_PER_PAGE);
			rs = stmt.executeQuery();
			list = new ArrayList<Board>();
			while(rs.next()) {
				Board b = new Board();
				b.boardNo = rs.getInt("boardNo");
				b.boardTitle = rs.getString("boardTitle");
				list.add(b);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}		
		return list;
	}
	
	// boardList.jsp 검색어로 조회
		public ArrayList<Board> selectBoardListLike(int beginRow, int ROW_PER_PAGE, String word) {
			ArrayList<Board> list = null;
			DBUtil dbUtil = null;
			Connection conn = null;
			PreparedStatement stmt = null;
			ResultSet rs = null;
			String sql = "SELECT board_no boardNo, board_title boardTitle "
					+ " FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
			try {
				dbUtil = new DBUtil();
				conn = dbUtil.getConnection();
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%"+word+"%");
				stmt.setInt(2, beginRow);
				stmt.setInt(3, ROW_PER_PAGE);
				rs = stmt.executeQuery();
				list = new ArrayList<Board>();
				while(rs.next()) {
					Board b = new Board();
					b.boardNo = rs.getInt("boardNo");
					b.boardTitle = rs.getString("boardTitle");
					list.add(b);
				}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try {
					dbUtil.close(rs, stmt, conn);
				} catch(Exception e) {
					e.printStackTrace();
				}
			}		
			return list;
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
