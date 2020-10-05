package bookstore.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BuyDAO {

	//----------------------------------------------------------------------------------------------
	// BuyDAO 인스턴스를 생성한다.
	//----------------------------------------------------------------------------------------------
	private static BuyDAO instance = new BuyDAO();
	//----------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//----------------------------------------------------------------------------------------------
	public static BuyDAO getInstance() {
		return instance;
	} // End - public static BuyDAO getInstance()
	//----------------------------------------------------------------------------------------------
	// 기본 생성자
	//----------------------------------------------------------------------------------------------
	private BuyDAO() {}

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
	// bank 테이블에 있는 모든 정보를 추출하는 메서드
	//----------------------------------------------------------------------------------------------
	public List<BankDTO> getAccount() throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BankDTO>		accountList	= null;
		
		try {
			conn	= getConnection();
			sql		= "SELECT * FROM bank";
			pstmt	= conn.prepareStatement(sql);
			rs		= pstmt.executeQuery();
			
			//처음으로 데이터 커서를 이동할 수 있다면,
			//데이터가 한 건이라도 있다는 것이다.
			if(rs.next()) {
				accountList = new ArrayList<BankDTO>();
				do {
					BankDTO	bankDTO = new BankDTO();
					
					bankDTO.setAccount	(rs.getString("account"));
					bankDTO.setBank		(rs.getString("bank"));
					bankDTO.setName		(rs.getString("name"));
					
					accountList.add(bankDTO);
				} while(rs.next());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return accountList;
	} // End - public List<BankDTO> getAccount()
	
	//----------------------------------------------------------------------------------------------
	// [구매확정] 버튼을 누르면 발생하는 TRANSACTION
	//----------------------------------------------------------------------------------------------
	public void insertBuy(List<CartDTO> lists, String id, String account, 
			String deliveryName, String deliveryTel, String deliveryAddress) 
					throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		Timestamp			reg_date	= null;
		String				sql			= "";
		String				maxDate		= "";
		String				number		= "";
		String				todayDate	= "";
		String				compareDate	= "";
		long				buyId		= 0;
		short				nowCount	= 0;
			
		try {
			//커넥션 풀의 정보를 가져온다.
			conn = getConnection();
			
			//구매번호를 추출하는 작업을 한다.
			//구매번호 : yyyymmdd + 일련번호(5)
			//시스템에서 일자를 가져온다.
			reg_date = new Timestamp(System.currentTimeMillis());
			System.out.print("reg_date:" + reg_date);
			todayDate = reg_date.toString();
			
			//reg_date => 2020-09-28 14:39:17.072
			//년(4), 월(2), 일(2)를 잘라내어 compareDate에 저장한다.
			compareDate = todayDate.substring(0,  4)
						+ todayDate.substring(5,  7)
						+ todayDate.substring(8, 10);
			
			sql 	= "SELECT MAX(buy_id) FROM buy";
			pstmt	= conn.prepareStatement(sql);
			rs 		= pstmt.executeQuery();
			System.out.println("pstmt0:" + pstmt);
			
			rs.next();
			//구매내역이 한 건이라도 있는 경우
			if(rs.getLong(1) > 0) {
				//찾아온 데이터에서 년월일과 일련버호를 분리한다.
				Long val = new Long(rs.getLong(1));
				maxDate	 = val.toString().substring(0, 8); 	//yyyymmdd
				number   = val.toString().substring(8); 	//xxxxx
			
				//String.format("%05d", 표현될 대상)
				// %(명령 시작을 의미) 0(채워질 문자) 5(총 자리수) d(십진수로 된 정수)
			
				
				//오늘날짜와 테이블 데이터의 제일 큰 날짜가 같은 경우
				if(compareDate.equals(maxDate)) {
					//maxDate의 yyyymmdd가 오늘날짜와 같으면 number에 하나를 더해서
					//maxDate의 뒤에 number를 붙여 buyId를 만든다.
					buyId = Long.parseLong(maxDate 
						  + (String.format("%05d", Integer.parseInt(number)+1)));
				} else {
					//오늘날짜와 테이블 데이터의 제일 큰 날짜가 같지 않은 경우
					//오늘 날짜 뒤에 00001을 붙여서 buyId를 만든다.
					buyId = Long.parseLong(compareDate + (String.format("%05d", 1)));
				}
			} else { //구매내역이 한 건도 없는 경우
				//String.format("%05d", 1) 
				// ==> 1을 5자리형태로 표현하는데 빈자리수는 0으로 채운다.
				buyId = Long.parseLong(compareDate + (String.format("%05d", 1)));
			} // End - buyId 만들기
			System.out.println("buyId: " + buyId);
			
			//----------------------------------------------------------------------------------------------
			// Transaction 시작
			// 		insert buy, update book, delete cart
			//----------------------------------------------------------------------------------------------
			// MySQL 은 AutoCommit이 기본이므로 AutoCommint을 비활성화 시킨다.
			conn.setAutoCommit(false);
			
			//장부구니의 수량만큼 buy테이블에 입력작업을 반복한다.
			for(int i = 0; i < lists.size(); i++) {
				//lists에서 한 건을 추출한다.
				CartDTO cart = lists.get(i);
				
				//cart의 자료를 buy테이블에 추가한다.
				sql = "";
				sql  = "INSERT INTO buy (buy_id, buyer, book_id, book_title, ";
				sql += "buy_price, buy_count, book_image, buy_date, account, ";
				sql += "deliveryName, deliveryTel, deliveryAddress) ";
				sql += "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setLong		( 1, buyId);
				pstmt.setString		( 2, id);
				pstmt.setInt		( 3, cart.getBook_id());
				pstmt.setString		( 4, cart.getBook_title());
				pstmt.setInt		( 5, cart.getBuy_price());
				
				pstmt.setInt		( 6, cart.getBuy_count());
				pstmt.setString		( 7, cart.getBook_image());
				pstmt.setTimestamp	( 8, reg_date);
				pstmt.setString		( 9, account);
				pstmt.setString		(10, deliveryName);
				
				pstmt.setString		(11, deliveryTel);
				pstmt.setString		(12, deliveryAddress);
				
				pstmt.executeUpdate(); 
				System.out.println("pstmt1:" + pstmt);
				pstmt.clearParameters();
				pstmt.close();
			
				//장바구니에 있는 상품이 구매되었으므로
				//book 테이블에 있는 상품의 수량을 재조정해야 한다.
				sql 	= "";
				sql 	= "SELECT book_count FROM book WHERE book_id = ?"; 
				pstmt 	= conn.prepareStatement(sql);
				pstmt.setInt(1, cart.getBook_id());
				rs		= pstmt.executeQuery();
				System.out.println("pstmt2:" + pstmt);
				rs.next();
				
				//재고수량 - 구매수량 으로 책의 재고수량을 변경하기 위해서
				nowCount = (short)(rs.getShort(1) - cart.getBuy_count());
				
				sql		= "";
				sql		= "UPDATE book SET book_count = ? WHERE book_id = ?";
				pstmt	= conn.prepareStatement(sql);
				pstmt.setShort	(1, nowCount);
				pstmt.setInt	(2, cart.getBook_id());
				pstmt.executeUpdate();
				System.out.println("pstmt3:" + pstmt);
				pstmt.clearParameters();
			} // End - for
			
			//장바구니에 있는 물품들에 대한 계산과 재고조정이 끝났으므로 장바구니를 비운다.
			sql		= "";
			sql		= "DELETE FROM cart WHERE buyer = ?";
			pstmt	= conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			System.out.println("pstmt4:" + pstmt);
			pstmt.clearParameters();

			//----------------------------------------------------------------------------------------------
			// 모든 테이블에 대한 작업이 끝났으므로 commit()을 실행한다.
			//----------------------------------------------------------------------------------------------
			conn.commit();
			//AutoCommit를 다시 활성화 시킨다.
			conn.setAutoCommit(true);
			//----------------------------------------------------------------------------------------------
			// Transaction 종료
			//----------------------------------------------------------------------------------------------
		} catch (SQLException sqle) {
			//Transaction에 문제가 생기면 rollback시킨다.
			if(conn != null) {
				try {
					System.out.println("RollBack 발생......");
					conn.rollback(); //////////////
				} catch (SQLException sqle2) {
					sqle2.printStackTrace();
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertBuy(List<CartDTO> ........
	
	//-----------------------------------------------------------------------------------------------------
	// buyer id에 해당하는 레코드 건수를 추출하는 메서드
	//-----------------------------------------------------------------------------------------------------
	public int getListCount(String buyer_id) throws Exception {
		Connection			conn 		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		int					rtnCount	= 0;

		try {
			conn  = getConnection();
			sql   = "SELECT COUNT(*) FROM buy WHERE buyer = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer_id);
			rs    = pstmt.executeQuery();
			
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
	} // End - public int getListCount(String buyer_id)
	
	//-----------------------------------------------------------------------------------------------------
	// 구매자 id에 해당하는 구매목록을 추출한다.
	//-----------------------------------------------------------------------------------------------------
	public List<BuyDTO> getBuyList(String buyer_id) throws Exception {
		Connection			conn 		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		List<BuyDTO>	lists		= null;
		BuyDTO			buy			= null;

		try {
			conn  = getConnection();
			sql   = "SELECT * FROM buy WHERE buyer = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer_id);
			rs    = pstmt.executeQuery();
			
			lists = new ArrayList<BuyDTO>();
			
			while(rs.next()) {
				buy = new BuyDTO();
				
				buy.setBuy_id		(rs.getLong("buy_id"));
				buy.setBook_id		(rs.getInt("book_id"));
				buy.setBook_title	(rs.getString("book_title"));
				buy.setBuy_price	(rs.getInt("buy_price"));
				buy.setBuy_count	(rs.getByte("buy_count"));
				buy.setBook_image	(rs.getString("book_image"));
				buy.setSanction		(rs.getString("sanction"));
				
				lists.add(buy);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return lists;
	} // End - public List<BuyDataBean> getBuyList(String buyer_id)
	
	
	
	
	
	//----------------------------------------------------------------------------------------------
	// 입력받은 년도에 해당하는 판매수량을 월별(12건), 총수량의 값을 추출하는 메서드
	//----------------------------------------------------------------------------------------------
	public BuyMonthDTO buyMonth(String year) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		BuyMonthDTO			buyMonth	= null;
		
		try {
			conn	= getConnection();
			
			sql	 = "SELECT ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '01'  THEN buy_count END), 0) AS 'm01', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '02'  THEN buy_count END), 0) AS 'm02', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '03'  THEN buy_count END), 0) AS 'm03', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '04'  THEN buy_count END), 0) AS 'm04', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '05'  THEN buy_count END), 0) AS 'm05', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '06'  THEN buy_count END), 0) AS 'm06', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '07'  THEN buy_count END), 0) AS 'm07', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '08'  THEN buy_count END), 0) AS 'm08', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '09'  THEN buy_count END), 0) AS 'm09', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '10'  THEN buy_count END), 0) AS 'm10', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '11'  THEN buy_count END), 0) AS 'm11', ";
			sql += "IFNULL(SUM(CASE DATE_FORMAT(buy.buy_date, '%m') WHEN '12'  THEN buy_count END), 0) AS 'm12', ";
			sql += "IFNULL(SUM(buy_count), 0) AS 'tot' ";
			sql += "FROM buy ";
			sql += "WHERE DATE_FORMAT(buy.buy_date, '%Y') = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			rs    = pstmt.executeQuery();
			
			if(rs.next() ) {
				buyMonth = new BuyMonthDTO();
				
				//buyMonth에 select한 값을 넣는다.
				buyMonth.setMonth01(rs.getInt("m01"));
				buyMonth.setMonth02(rs.getInt("m02"));
				buyMonth.setMonth03(rs.getInt("m03"));
				buyMonth.setMonth04(rs.getInt("m04"));
				buyMonth.setMonth05(rs.getInt("m05"));

				buyMonth.setMonth06(rs.getInt("m06"));
				buyMonth.setMonth07(rs.getInt("m07"));
				buyMonth.setMonth08(rs.getInt("m08"));
				buyMonth.setMonth09(rs.getInt("m09"));
				buyMonth.setMonth10(rs.getInt("m10"));

				buyMonth.setMonth11(rs.getInt("m11"));
				buyMonth.setMonth12(rs.getInt("m12"));
				buyMonth.setTotal  (rs.getInt("tot"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return buyMonth;
	} // End - public BuyMonthDTO buyMonth(String year)	
	
} // End - public class BuyDAO




