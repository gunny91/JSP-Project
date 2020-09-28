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

	
	private static BuyDAO instance = new BuyDAO();

	//----------------------------------------------------------------------------------------------
	// 생성한 인스턴스의 정보를 알려준다.
	//----------------------------------------------------------------------------------------------
	public static BuyDAO getInstance() {
		return instance;
	} // End - public static CartDAO getInstance()

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

	public List<BankDTO> getAccount() throws Exception{
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql ="select * from bank";
		List<BankDTO> accountList= null;
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);			
			rs = pstmt.executeQuery();
			
			accountList = new ArrayList<BankDTO>();
			BankDTO bank = new BankDTO();
				
			while(rs.next()) {
				
				bank.setName(rs.getString("name"));
				bank.setBank(rs.getString("bank"));
				bank.setAccount(rs.getString("account"));
				accountList.add(bank);
			}
		
			
		}
		catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		
		return accountList;
	}
	
	
	public void insertBuy(List<CartDTO> lists, String id, String account, 
			String deliveryName, String deliveryTel,String deliveryAddress) throws Exception {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql ="";
		Timestamp reg_date =null;
		
		String maxDate ="";
		String number ="";
		String todayDate ="";
		String compareDate="";
		long buyId =0;
		short nowCount =0;
		
		try{
				conn = getConnection();
				
				//구매번호 추출
				//구매번호 : yyyymmdd + 일련번호(5)
				reg_date = new Timestamp(System.currentTimeMillis());
				System.out.println("reg_date "+reg_date);
				todayDate = reg_date.toString();
				
				//reg_date -> 2020, 09 , 28
				// year(4), month(2), date(2) 잘라내어 compareDate 에 저장
				compareDate = todayDate.substring(0,4) + todayDate.substring(5,7) + todayDate.substring(8,10);
				
				//find the max in buy_id from buy table
				sql="select max(buy_id) from buy";
				pstmt =conn.prepareStatement(sql);
				
				rs = pstmt.executeQuery();
				
				rs.next();
				//구매 내역이 한건 이상 있는 경우
				if(rs.getLong(1) > 0) {
					//년월일 분리
					Long val = new Long(rs.getLong(1));
					maxDate= val.toString().substring(0,8); // yyyymmdd
					number = val.toString().substring(8); //xxxxx
					//String.format("%05d" ,표현 대상)
					
					
					//오늘 날짜와 테이블의 제일 큰 날짜가 같은 경우
					if(compareDate.equals(maxDate)) {
						//maxdate의 yyyymmdd가 오늘 날짜와 같으면 number 에 +1 
						//maxdate 뒤에 number 붙여 buyid를 만든다
						buyId = Long.parseLong(maxDate +(String.format("%05d", Integer.parseInt(number)+1)));
						
					}else {
						buyId =Long.parseLong(compareDate + (String.format("%05d", 1)));
					}
					
				}else { //구매 내역이 한건도 없다.
					buyId =Long.parseLong(compareDate + (String.format("%05d", 1)));
				}
				
				
				//Transaction 
				//insert buy, update book, delete cart
				
				conn.setAutoCommit(false);
				sql ="";
				
				//장바구니의 수량만큼 buy 테이블에 입력작업을 반복
				for(int i =0; i < lists.size(); i++) {
					CartDTO cart = lists.get(i);
					
					sql = "insert into buy values(?,?,?,?,?,?,?,?,?,?,?,?)";
					
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setLong(1, buyId);
					pstmt.setString(2, id);
					pstmt.setInt(3, cart.getBook_id());
					pstmt.setString(4, cart.getBook_title());
					pstmt.setInt(5, cart.getBuy_price());
					pstmt.setString(7, cart.getBook_image());
					pstmt.setTimestamp(8, reg_date);
					pstmt.setString(9, account);
					pstmt.setString(10, deliveryName);
					pstmt.setString(11, deliveryTel);
					pstmt.setString(12,deliveryAddress);
					
					pstmt.executeUpdate();
					pstmt.clearParameters();
					pstmt.close();
				
				//book table 수량 조정
					
					pstmt = conn.prepareStatement("select book_count from book where book_id=?");
					
					pstmt.setInt(1, cart.getBook_id());
					
					rs.next();
					
					//재고 - 구매수량 하여 책의 재고수량을 변경
					nowCount = (short)(rs.getShort(1)-cart.getBuy_count());
					
					sql ="";
					sql ="update book set book_count =? where book_id=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setShort(1, nowCount);
					pstmt.setInt(2, cart.getBook_id());
					pstmt.executeUpdate();
					pstmt.clearParameters();
				
				}
				
				sql ="";
				sql ="delete from cart where buyer=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id );
				pstmt.executeUpdate(sql);
				pstmt.clearParameters();
				
				//commit;
				conn.commit();
				
				conn.setAutoCommit(true);
				
		}catch(SQLException sqle) {
			if(conn !=null) {
				try {
					conn.rollback();
				}catch(SQLException e){
					e.printStackTrace();
				}
			}
		}catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		
	}
	
	
}
