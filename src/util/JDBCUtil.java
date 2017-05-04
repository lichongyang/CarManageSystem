package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCUtil {
	private static final String URL="jdbc:mysql://localhost:3306/liu?useUnicode=true&characterEncoding=utf8";
	private static final String DRIVER="com.mysql.jdbc.Driver";
	private static final String USER="root";
	private static final String PWD="000000";
	
	
	/*
	 * 获取数据库连接Connection
	 * @return connection
	 */
	public static Connection getConnection(){
		Connection conn = null;
		try{
			Class.forName(DRIVER);
			conn = DriverManager.getConnection(URL, USER, PWD);
		}catch(ClassNotFoundException e){
			e.printStackTrace();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return conn;
	}
	/*
	 * 关闭数据库连接
	 */
	public static void closeConnection(Connection conn,Statement stmt,PreparedStatement psmt,ResultSet rs){
		try{
			if(rs!=null){
				rs.close();
			}
			if(psmt!=null){
				psmt.close();
			}
			if(stmt!=null){
				stmt.close();
			}
			if(conn!=null){
				conn.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}	
	}
}


