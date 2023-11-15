package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/sideproject";
			String dbID = "root";
			String dbPassword = "rootpw";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //DB오류시 빈 문자열 반환
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; //첫번쨰 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //DB오류시 빈 문자열 반환
	}
	
	public int write(String bbsTitle, String userID, String bbsContent, String bbsAddress, String imgFileName) {
		String SQL = "INSERT INTO bbs (bbsTitle, userID, bbsContent, bbsAddress, imgURL, bbsAvailable) VALUES (?, ?, ?, ?, ?, ?)";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, bbsTitle);
	        pstmt.setString(2, userID);
	        pstmt.setString(3, bbsContent);
	        pstmt.setString(4, bbsAddress);
	        pstmt.setString(5, imgFileName);
	        pstmt.setInt(6, 1); // 여기서는 기본값으로 1(사용 가능) 설정
	        return pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // DB 오류
	}
}
