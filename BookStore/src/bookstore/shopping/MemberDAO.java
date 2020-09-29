package bookstore.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import bookstore.master.BookStoreDAO;

public class MemberDAO {

	//----------------------------------------------------------------------------------------------
	// MemberDAO 인스턴스를 생성한다.
	//----------------------------------------------------------------------------------------------
	private static MemberDAO instance = new MemberDAO();

	//----------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//----------------------------------------------------------------------------------------------
	public static MemberDAO getInstance() {
		return instance;
	} // End - public static MemberDAO getInstance()

	//----------------------------------------------------------------------------------------------
	// 기본 생성자
	//----------------------------------------------------------------------------------------------
	private MemberDAO() {}
	
	//----------------------------------------------------------------------------------------------
	// 커넥션 풀로 부터 커넥션 객체를 얻어내는 메서드
	//----------------------------------------------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context	initCtx = new InitialContext();
		Context envCtx  = (Context)	 initCtx.lookup("java:comp/env");
		DataSource ds	= (DataSource)envCtx.lookup("jdbc/bookstoredb");
		return ds.getConnection();
	} // End - private Connection getConnection()

	//----------------------------------------------------------------------------------------------
	// 회원 인증 메서드
	//----------------------------------------------------------------------------------------------
	public int userCheck(String id, String passwd) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				dbpasswd	= "";
		int					rtnVal		= -1;
		
		try {
			conn  = getConnection();
			
			sql   = "SELECT passwd FROM member WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setNString(1, id);
			rs    = pstmt.executeQuery();
			
			if(rs.next()) { //id에 해당하는 자료가 있다면
				//찾은 비밀번호를 가지고 전페이지에서 넘겨준 비밀번호와 비교한다.
				dbpasswd = rs.getString("passwd");
				
				if(dbpasswd.equals(passwd)) { //비밀번호가 일치하면
					rtnVal = 1;	//인증에 성공
				} else {
					rtnVal = 0; //비밀번호가 일치하지 않는다.
				}
			} else { //id에 해당하는 자료가 없다면 => 해당 아이디 자체가 존재하지 않는다.
				rtnVal = -1;
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close(); 	  } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int managerCheck(String id, String passwd)

	//-----------------------------------------------------------------------------------------------------
	// 회원id가 존재하는지 검사한다.
	//-----------------------------------------------------------------------------------------------------
	public int confirmId(String id) throws Exception {
		Connection			conn 	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		int					rtnVal	= -1;

		try {
			conn  = getConnection();
			sql   = "SELECT id FROM member WHERE id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) { //select문에 해당하는 자료가 1건이라도 있는 경우
				rtnVal = 1;
			} else { //select문에 해당하는 자료가 1건도 없는 경우
				rtnVal = -1;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int confirmId(String id)


	//-----------------------------------------------------------------------------------------------------
	// 회원 가입 메서드
	//-----------------------------------------------------------------------------------------------------
	public void insertMember(MemberDTO member) throws Exception {
		Connection			conn 	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";

		try {
			conn  = getConnection();
			//테이블에 모든 컬럼에 대해 값을 집어 넣으므로 컬럼명부분은 생략해도 된다.
			//sql   = "INSERT INTO member (id,passwd,name,reg_date,tel,address) VALUE(?, ?, ?, ?, ?, ?)";
			sql   = "INSERT INTO member VALUES (?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString		(1, member.getId());
			pstmt.setString		(2, member.getPasswd());
			pstmt.setString		(3, member.getName());
			pstmt.setTimestamp	(4, member.getReg_date());
			pstmt.setString		(5, member.getTel());
			pstmt.setString		(6, member.getAddress());
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertMember(CustomerDataBean member)
	
	//-----------------------------------------------------------------------------------------------------
	// 회원 id에 해당하는 회원정보를 추출한다.
	//-----------------------------------------------------------------------------------------------------
	public MemberDTO getMember(String id) throws Exception {
		//데이터 추출에 사용할 변수등을 준비한다.
		Connection				conn	= null;
		PreparedStatement		pstmt	= null;
		ResultSet				rs		= null;
		String					sql		= "";
		MemberDTO				member	= null;
		
		try {
			//DB와 연결한다.
			conn 	= getConnection();
			
			//질문(Query)을 준비한다.
			//WHERE id => 테이블의 컬럼명
			sql  	= "SELECT * FROM member WHERE id = ?";
			pstmt	= conn.prepareStatement(sql);
			//질문에 포함할 조건(?) 등을 준비한다.
			pstmt.setString(1, id); //id => 입력받은 파라미터 값
			
			//질문할 준비가 모두 끝나면 실행한다.
			rs = pstmt.executeQuery();
			
			System.out.println("getMember pstmt:" + pstmt);
			
			if(rs.next()) {
				//실행결과를 getMember를 호출한 곳에 넘겨줄 준비를 한다.
				member = new MemberDTO();
				
				//rs.getString("id") 의 id => 테이블의 컬럼 명이다. 
				member.setId		(rs.getString("id"));
				member.setPasswd	(rs.getString(2));
				member.setName		(rs.getString("name"));
				member.setReg_date	(rs.getTimestamp("reg_date"));
				member.setTel		(rs.getString(5));
				member.setAddress	(rs.getString("address"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//사용한 자원을 닫는다.
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		//문제가 없으면 데이터를 호출한 곳에 넘겨준다.
		return member;
	} // End - public MemberDTO getMember(String id)
	
	//-----------------------------------------------------------------------------------------------------
	// 회원 정보 수정
	//-----------------------------------------------------------------------------------------------------
     public void updateMember(MemberDTO member) throws Exception {
    	 Connection conn = null;
         PreparedStatement pstmt = null;
       
         try {
        	 conn = getConnection();
           
             pstmt = conn.prepareStatement(
               "update member set passwd=?,name=?,tel=?,address=? "+
               "where id=?");
             pstmt.setString(1, member.getPasswd());
             pstmt.setString(2, member.getName());
             pstmt.setString(3, member.getTel());
             pstmt.setString(4, member.getAddress());
             pstmt.setString(5, member.getId());
           
             pstmt.executeUpdate();
         }catch(Exception ex) {
             ex.printStackTrace();
         }finally {
             if (pstmt != null) 
            	 try { pstmt.close(); } catch(SQLException ex) {}
             if (conn != null) 
            	 try { conn.close(); } catch(SQLException ex) {}
         }
     }
   
 	//-----------------------------------------------------------------------------------------------------
 	//-----------------------------------------------------------------------------------------------------
     public int deleteMember(String id, String passwd) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs= null;
         String dbpasswd="";
         int x=-1;
         
         try {
			 conn = getConnection();

             pstmt = conn.prepareStatement(
           	  "select passwd from member where id = ?");
             pstmt.setString(1, id);
             rs = pstmt.executeQuery();
           
			 if(rs.next()){
				 dbpasswd= rs.getString("passwd"); 
				 if(dbpasswd.equals(passwd)){
					 pstmt = conn.prepareStatement("delete from member where id=?");
                     pstmt.setString(1, id);
                     pstmt.executeUpdate();
					 x= 1; //비밀번호가 맞은 경우
				 }else
					 x= 0; //비밀번호가 틀린 경우
			 }
         }catch(Exception ex) {
             ex.printStackTrace();
         }finally {
             if (rs != null) 
            	 try { rs.close(); } catch(SQLException ex) {}
             if (pstmt != null) 
            	 try { pstmt.close(); } catch(SQLException ex) {}
             if (conn != null) 
            	 try { conn.close(); } catch(SQLException ex) {}
         }
		 return x;
     }

	//-----------------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------------------


}








