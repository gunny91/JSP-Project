package bookstore.shopping;

import java.sql.Connection;

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

}
