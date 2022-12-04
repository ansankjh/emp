package db;

import java.sql.*;

public class DBUtil {
	public Connection getConnection() throws Exception {
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "wkqk1234");
		
		return conn;
	}
	// void : 리턴값이 없다
	public void close(ResultSet rs, PreparedStatement stmt, Connection conn) throws Exception {
		if(rs != null) {
			rs.close();
		}
		if(stmt != null) {
			stmt.close();
		}
		if(conn != null) {
			conn.close();
		}
	}
}
