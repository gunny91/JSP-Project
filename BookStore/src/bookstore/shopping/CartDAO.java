package bookstore.shopping;

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
// public class CartDAO
//----------------------------------------------------------------------------------------------
public class CartDAO {

	//----------------------------------------------------------------------------------------------
	// MemberDAO 인스턴스를 생성한다.
	//----------------------------------------------------------------------------------------------
	private static CartDAO instance = new CartDAO();

	//----------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//----------------------------------------------------------------------------------------------
	public static CartDAO getInstance() {
		return instance;
	} // End - public static CartDAO getInstance()

	//----------------------------------------------------------------------------------------------
	// 기본 생성자
	//----------------------------------------------------------------------------------------------
	private CartDAO() {}
	
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
	// 장바구니에서 특정 사용자가 담은 book_id에 해당하는 수량을 구한다.
	//----------------------------------------------------------------------------------------------
	public int getBookIdCount(String buyer, int bookId) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					rtnCount	= 0;
		
		try {
			//작업할 DB에 연결된 정보를 가져온다.
			conn	= getConnection();

			//질문할 내용을 작성한다.
			//장바구니에서 같은 사용자이면서 book_id가 같은 것을 더 한 것을 추출한다.
			sql	 = "SELECT SUM(buy_count) FROM cart ";
			sql	+= "WHERE buyer = ? AND book_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString	(1, buyer);
			pstmt.setInt	(2, bookId);

			//쿼리문장을 실행시키고, 결과를 ResultSet에 담는다.
			rs = pstmt.executeQuery();

			System.out.println("PSTMT:" + pstmt);
			//찾은 결과가 있으면 넘겨줄 변수에 저장한다.
			if(rs.next()) {
				rtnCount = rs.getInt(1);
				System.out.println("rtnCount:" + rtnCount);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCount;	//찾은 책의 수량을 넘겨준다.
	} // End - public byte getBookIdCount(String buyer, int bookId)
	
	//----------------------------------------------------------------------------------------------
	// [장바구니에 담기] 버튼을 클릭하면 수행된다.
	//----------------------------------------------------------------------------------------------
	public void insertCart(CartDTO cart) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn = getConnection();
			
			sql  = "INSERT INTO cart ";
			sql += "(book_id, buyer, book_title, buy_price, buy_count, book_image) ";
			sql += "VALUES (?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt 	(1, cart.getBook_id());
			pstmt.setString (2, cart.getBuyer());
			pstmt.setString (3, cart.getBook_title());
			pstmt.setInt	(4, cart.getBuy_price());
			pstmt.setInt	(5, cart.getBuy_count());
			pstmt.setString	(6, cart.getBook_image());
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertCart(CartDTO cart)
	
	//----------------------------------------------------------------------------------------------
	// 사용자 아이디에 해당하는 장바구니의 개수를 구하는 메서드
	//----------------------------------------------------------------------------------------------
	public int getListCount(String buyerId) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					rtnCount	= 0;
		
		try {
			conn	= getConnection();
			sql		= "SELECT COUNT(*) FROM cart WHERE buyer = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyerId);
			rs		= pstmt.executeQuery();
			
			if(rs.next()) {
				rtnCount = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCount;
	} // End - public int getListCount(String buyerId)
	
	//----------------------------------------------------------------------------------------------
	// buyer에 해당하는 장바구니의 모든 정보를 추출한다.
	//----------------------------------------------------------------------------------------------
	public List<CartDTO> getCart(String buyerId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		CartDTO				cart	= null;
		List<CartDTO>		lists	= null;
		
		try {
			conn	= getConnection();
			sql		= "SELECT * FROM cart WHERE buyer = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyerId);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<CartDTO>();
			while(rs.next()) {
				cart = new CartDTO();
				
				cart.setCart_id		(rs.getInt("cart_id"));
				cart.setBook_id		(rs.getInt("book_id"));
				cart.setBook_title	(rs.getString("book_title"));
				cart.setBuy_price	(rs.getInt("buy_price"));
				cart.setBuy_count	(rs.getByte("buy_count"));
				cart.setBook_image	(rs.getString("book_image"));
				
				lists.add(cart);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return lists;
	} // End - public List<CartDTO> getCart(String buyerID)
	
	//----------------------------------------------------------------------------------------------
	// 선택한 하나의 장바구니만 부우기
	//----------------------------------------------------------------------------------------------
	public void deleteList(int cart_id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn	= getConnection();
			sql		= "DELETE FROM cart WHERE cart_id = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, cart_id);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // public void deleteList(int cart_id)
	
	//----------------------------------------------------------------------------------------------
	// buyer에 해당하는 장바구니를 모두 비운다.
	//----------------------------------------------------------------------------------------------
	public void deleteAll(String buyer) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn	= getConnection();
			sql		= "DELETE FROM cart WHERE buyer = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			
			int rtnCount = pstmt.executeUpdate();
			if(rtnCount > 0) {
				System.out.println(rtnCount + "건이 삭제되었습니다.");
			} else {
				System.out.println("삭제하는데 문제가 발생하였습니다.");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void deleteAll(String buyer)
	
	//----------------------------------------------------------------------------------------------
	// 장바구니에 담겨져 있는 수량을 변경한다.
	//----------------------------------------------------------------------------------------------
	public void updateCount(int cart_id, int count) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn	= getConnection();
			sql		= "UPDATE cart SET buy_count=? WHERE cart_id=?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setInt(1, count);
			pstmt.setInt(2, cart_id);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void updateCount(int cart_id, int count)
	
	//----------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------
	
} // End - public class CartDAO









