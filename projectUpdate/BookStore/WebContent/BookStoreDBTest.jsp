<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>BookStore DB Test (Connection Pool Test Program)</title>
</head>
<body>
	<table width="550" border="1">
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			String url = "jdbc:mysql://localhost:3306/bookstoredb?useSSL=false";
			String id = "bookmaster";
			String pw = "294079814";
			
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url,id,pw);
			String sql = "select * from manager";
			pstmt = conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
	
			while(rs.next()){
				String gid= rs.getString("managerId");
				String gpw = rs.getString("managerPw");
			%>

			
				<tr>
					<td width="250"><%=gid %></td>
					<td width="250"><%=gpw %></td>
				</tr>
			
		<%
			}
		}catch(Exception e){
			e.printStackTrace();
			e.getMessage();
			out.println("Failed to call the manager table");
		}finally{
			if(rs !=null || pstmt !=null || conn !=null )
				try{
					rs.close();
					pstmt.close();
					conn.close(); 
				}catch(Exception e){e.printStackTrace();}
			//if(pstmt !=null ) try{pstmt.close();}catch(Exception e){e.printStackTrace();}
			//if(conn !=null ) try{conn.close();}catch(Exception e){e.printStackTrace();}
		}
	
		
	%>
	</table>
</body>
</html>