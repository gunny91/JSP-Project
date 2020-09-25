<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.shopping.CartDAO" %>
<%
request.setCharacterEncoding("UTF-8");

String	book_kind	= request.getParameter("book_kind");
String	book_id		= request.getParameter("book_id");
String	book_title	= request.getParameter("book_title");
String	book_image	= request.getParameter("book_image");
String	buy_price	= request.getParameter("buy_price");
String	buyer		= (String)session.getAttribute("id");
String	buy_count	= request.getParameter("buy_count");

/*
System.out.println("book_kind:" + book_kind);
System.out.println("book_id:" + book_id);
System.out.println("book_title:" + book_title);
System.out.println("book_image:" + book_image);
System.out.println("buy_price:" + buy_price);
System.out.println("buyer:" + buyer);
System.out.println("buy_count:" + buy_count);
*/
%>

<jsp:useBean id="cart" scope="page" class="bookstore.shopping.CartDTO">
</jsp:useBean>

<% 
//같은 책(book_id)에 대해서
//책방에 있는 재고, 장바구니에 담겨있는 구매예정수량, 추가로 구매할 예정수량을
//검사하여 카트에 담을 수 있는지 검사한다.

//현재 책방에 있는 책의 수량을 구한다.
int rtnBookCount = 0;
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
rtnBookCount = bookStoreDAO.getBookIdCount(Integer.parseInt(book_id));

//장바구니에 담겨있는 책의 수량을 구한다.
int cartBookCount = 0;
CartDAO cartDAO = CartDAO.getInstance();
cartBookCount = cartDAO.getBookIdCount(buyer, Integer.parseInt(book_id));

System.out.println("buy_count: " + buy_count);
System.out.println("rtnBookCount: " + rtnBookCount);
System.out.println("cartBookCount: " + cartBookCount);

final int BUY_COUNT = Integer.parseInt(buy_count);
// 책의 재고수량은 변동이 된다.(다른 사용자가 구매를 하기 때문에.....)
if(rtnBookCount < 1) {
	%><script>alert('현재 재고가 없습니다.'); history.go(-1);</script><%
} else if(BUY_COUNT < 1) {
	%><script>alert('주문은 최소 1권이상 하셔야 합니다.'); history.go(-1);</script><%
} else if(BUY_COUNT > rtnBookCount) {
	%><script>alert('주문하시려는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%
} else if(cartBookCount > rtnBookCount) {
	%><script>alert('장바구니에 담겨져 있는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%
} else if((BUY_COUNT + cartBookCount) > rtnBookCount) {
	%><script>alert('장바구니에 담겨져 있는 수량 + 추가할 수량이 재고보다 많습니다.\n\n수량을 확인하신 후에 장바구니에 담아주세요.'); history.go(-1);</script><%
} else {
	cart.setBook_id		(Integer.parseInt(book_id));
	cart.setBook_image	(book_image);
	cart.setBook_title	(book_title);
	cart.setBuy_count	(Integer.parseInt(buy_count));
	cart.setBuy_price	(Integer.parseInt(buy_price));
	cart.setBuyer		(buyer);
	
	cartDAO.insertCart(cart);
	//장바구니에 정상적으로 물품을 담았으면 장바구니 목록으로 이동한다.
	response.sendRedirect("cartList.jsp?book_kind="+book_kind);
}

%>












