<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.shopping.CartDAO" %>
<%
//세션값이 없으면 메인페이지로 돌려보낸다. 
if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
}

//이전페이지에서 넘겨준 데이터를 추출한다.
String	cart_id			= request.getParameter("cart_id");
String	buy_count		= request.getParameter("buy_count");
String	buy_countOld	= request.getParameter("buy_countOld");
String	book_kind		= request.getParameter("book_kind");
String	book_id			= request.getParameter("book_id");

String	buyer			= (String)session.getAttribute("id");

//책방의 재고를 구한다.
int rtnBookCount	= 0;
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
rtnBookCount = bookStoreDAO.getBookIdCount(Integer.parseInt(book_id));

//장바구니에 담겨있는 수량을 구한다.
int cartBookCount	= 0;
CartDAO cartDAO = CartDAO.getInstance();
cartBookCount = cartDAO.getBookIdCount(buyer, Integer.parseInt(book_id));

int buyCount 	= Integer.parseInt(buy_count);
int buyCountOld	= Integer.parseInt(buy_countOld);

//책방의 재고와 내가 구매하려는 수량을 비교한 후에 정상적이면 수량을 업데이트한다.
if(rtnBookCount < 1) {
	%><script>alert("현재 재고가 없습니다."); history.go(-1);</script><%
} else if(buyCount < 1) {
	%><script>alert("주문은 최소 1권 이상하셔야 합니다."); history.go(-1);</script><%
} else if(buyCount > rtnBookCount) {
	%><script>alert("주문하신 수량이 재고수량보다 많습니다."); history.go(-1);</script><%
} else if((cartBookCount+buyCount-buyCountOld) > rtnBookCount) {
	%><script>alert("주문하실 수량이 재고수량보다 많습니다.\n\n수량을 확인하신 후에 다시 시도하십시오."); history.go(-1);</script><%
} else {
	cartDAO.updateCount(Integer.parseInt(cart_id), buyCount);
	response.sendRedirect("cartList.jsp?book_kind=" + book_kind);
}
%>














