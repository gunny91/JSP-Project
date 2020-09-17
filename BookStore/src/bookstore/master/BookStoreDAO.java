package bookstore.master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//----------------------------------------------------------------------------------------------
// class StoreBookDAO
//----------------------------------------------------------------------------------------------
public class BookStoreDAO 
{
	//----------------------------------------------------------------------------------------------
	// StoreBookDAO 인스턴스를 생성한다.
	//----------------------------------------------------------------------------------------------
	private static BookStoreDAO instance = new BookStoreDAO();

	//----------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//----------------------------------------------------------------------------------------------
	public static BookStoreDAO getInstance() {
		return instance;
	} // End - public static StoreBookDAO getInstance()

	//----------------------------------------------------------------------------------------------
	// 기본 생성자
	//----------------------------------------------------------------------------------------------
	private BookStoreDAO() {}
	
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
	// 관리자 인증 메서드
	//----------------------------------------------------------------------------------------------
	public int managerCheck(String id, String passwd) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		String				dbpasswd	= "";
		int					rtnVal		= -1;
		
		try {
			conn  = getConnection();
			
			sql   = "SELECT managerPw FROM manager WHERE managerId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setNString(1, id);
			rs    = pstmt.executeQuery();
			
			if(rs.next()) { //id에 해당하는 자료가 있다면
				//찾은 비밀번호를 가지고 전페이지에서 넘겨준 비밀번호와 비교한다.
				dbpasswd = rs.getString("managerPw");
				
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
	
	//----------------------------------------------------------------------------------------------
	// 도서 종류 데이터를 추출한다.
	//----------------------------------------------------------------------------------------------
	public List<BscodeDTO> getBookTypes() throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BscodeDTO>		bookTypes	= null;
		
		try {
			sql 	= "SELECT * FROM BSCODE";
			conn	= getConnection();
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			//찾아온 책의 타입에 대한 정보를 담는다.
			if(rs.next()) {
				bookTypes = new ArrayList<BscodeDTO>();
				do {
					BscodeDTO bookType = new BscodeDTO();
					
					bookType.setId	(rs.getString("id"));
					bookType.setName(rs.getString("name"));
					
					bookTypes.add(bookType);
				} while(rs.next());
			}
			/*
			bookTypes = new ArrayList<BscodeDTO>();
			while(rs.next()) {
				BscodeDTO bookType = new BscodeDTO();
				bookType.setId	(rs.getString("id"));
				bookType.setName(rs.getString("name"));
				bookTypes.add(bookType);
			}
			*/
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close(); 	  } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		
		return bookTypes;
	} // End - public ArrayList<BscodeDTO> getBookTypes()

	//----------------------------------------------------------------------------------------------
	// 책의 정보를 등록한다.
	//----------------------------------------------------------------------------------------------
	public int insertBook(BookDTO book, int imageStatus) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
	
		try {
			conn = getConnection();
			sql  = " INSERT INTO BOOK ";
			sql += " (book_id, book_kind, book_title, book_price, book_count, ";
			sql += "  author, publishing_com, publishing_date, book_content, ";
			sql += "discount_rate, reg_date ";
			if(imageStatus == 1) {
				sql += ", book_image) ";
				sql += " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
			} else {
				sql += " ) ";
				sql += " VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			}
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt		( 1, book.getBook_id());
			pstmt.setString		( 2, book.getBook_kind());
			pstmt.setString		( 3, book.getBook_title());
			pstmt.setInt		( 4, book.getBook_price());
			pstmt.setShort		( 5, book.getBook_count());
			
			pstmt.setString		( 6, book.getAuthor());
			pstmt.setString		( 7, book.getPublishing_com());
			pstmt.setString		( 8, book.getPublishing_date());
			pstmt.setString		( 9, book.getBook_content());
			pstmt.setByte		(10, book.getDiscount_rate());
			
			pstmt.setTimestamp	(11, book.getReg_date());
			if(imageStatus == 1) {
				pstmt.setString	(12, book.getBook_image());
			}
			return pstmt.executeUpdate();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return -1;
	} // End - public int insertBook(BookDTO book, int imageStatus)
	
	//----------------------------------------------------------------------------------------------
	// 책의 종류에 따른 데이터 건수를 구하는 메서드
	//----------------------------------------------------------------------------------------------
	public int getBookCount(String book_kind) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql1		= "";
		String				sql2		= "";
		int					rtnCount	= 0;
		
		try {
			conn = getConnection();
			sql1 = " SELECT COUNT(*) FROM book ";
			sql2 = " WHERE book_kind =?";
			
			if(book_kind.equals("all")) {
				pstmt = conn.prepareStatement(sql1);
			} else {
				pstmt = conn.prepareStatement(sql1+sql2);
				pstmt.setString(1, book_kind);
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				rtnCount = rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close(); 	  } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCount;
	} // End - public int getBookCount(String book_kind)

	//----------------------------------------------------------------------------------------------
	// 책 종류에 따른 책의 정보를 추출한다.
	//----------------------------------------------------------------------------------------------
	public List<BookDTO> getBooks(String book_kind, int start, int count)
		throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql1		= "";
		String				sql2		= "";
		String				sql3		= "";
		List<BookDTO>		bookList	= null;

		try {
			conn = getConnection();
			sql1 = " SELECT ";
			sql1+= " bk.book_id, bs.name, bk.book_title, bk.book_price, bk.book_count, ";
			sql1+= " bk.author, bk.publishing_com, bk.publishing_date, bk.book_content, ";
			sql1+= " bk.book_image, bk.discount_rate, bk.reg_date ";
			sql1+= " FROM BOOK bk, BSCODE bs ";
			sql1+= " WHERE bk.book_kind = bs.id ";
			sql2 = " AND bk.book_kind = ? ";
			sql3 = " ORDER BY bk.reg_date DESC limit ?,?";
					
			if(book_kind.equals("all")) {
				pstmt = conn.prepareStatement(sql1+sql3);
				pstmt.setInt(1, start-1);
				pstmt.setInt(2, count);
			} else {
				pstmt = conn.prepareStatement(sql1+sql2+sql3);
				pstmt.setString(1, book_kind);
				pstmt.setInt(2, start-1);
				pstmt.setInt(3, count);
			}
			rs = pstmt.executeQuery();
			
			//찾은 책의 정보를 담는다.
			bookList = new ArrayList<BookDTO>();
			while(rs.next()) {
				BookDTO book = new BookDTO();
				book.setBook_id(rs.getInt("bk.book_id"));
				book.setBook_kind(rs.getString("bs.name"));
				book.setBook_title(rs.getString("bk.book_title"));
				book.setBook_price(rs.getInt("bk.book_price"));
				book.setBook_count(rs.getShort("bk.book_count"));
				
				book.setAuthor(rs.getString("bk.author"));
				book.setPublishing_com(rs.getString("bk.publishing_com"));
				book.setPublishing_date(rs.getString("bk.publishing_date"));
				book.setBook_image(rs.getString("bk.book_image"));
				book.setDiscount_rate(rs.getByte("bk.discount_rate"));
				book.setReg_date(rs.getTimestamp("bk.reg_date"));
				
				bookList.add(book);
			}
			
			
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close(); 	  } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return bookList;
	} // End - public List<BookDTO> getBooks(String book_kind, int start, int count)

	//----------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------



} // End - class StoreBookDAO















