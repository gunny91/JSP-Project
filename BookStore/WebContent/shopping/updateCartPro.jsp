<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDAO" %>
<%@ page import="bookstore.master.BookStoreDAO" %>

<% 

	if(session.getAttribute("id")==null){response.sendRedirect("shopMain.jsp");}
	
	String	book_kind	= request.getParameter("book_kind");
	String	book_id		= request.getParameter("book_id");
	String	cart_id	= request.getParameter("cart_id");
	
	String	buy_countOld	= request.getParameter("buy_count");
	String	buy_count	= request.getParameter("buy_count");

	String	buyer		= (String)session.getAttribute("id");
	
	//책방 재고
	int rtnBookCount =0;
	BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
	rtnBookCount=bookStoreDAO.getBookIdCount(Integer.parseInt(book_id));
	
	//장바구니 수량
	int cartBookCount =0;
	CartDAO cartDAO = CartDAO.getInstance();
	cartBookCount = cartDAO.getBookIdCount(buyer,Integer.parseInt(book_id));
	
	int buyCount = Integer.parseInt(buy_count);
	int buyCountOld = Integer.parseInt(buy_countOld);
	
	//책방 재고, 구매 수량 비교 후, 수량 업데이트
	if(rtnBookCount <1){
		%><script>alert("No stuck"); history.go(-1);</script><%
	}else if (buyCount<1){
		%><script> alert('order more than a book'); history.go(-1);</script> <%
	}	
	else if(buyCount > rtnBookCount){
		%><script> alert('Too much !'); history.go(-1);</script> <%
	}
	else if( (buyCount+cartBookCount - buyCountOld )> rtnBookCount){
		%><script> alert('주문하실 수량이 재고수량보다 많습니다. \n\n 수량을 확인 후에 다시 해라!'); history.go(-1);</script> <%
	}else{
		cartDAO.updateCount(Integer.parseInt(cart_id),Integer.parseInt(buy_count));
		response.sendRedirect("cartList.jsp?book_kind="+book_kind);
	}
	

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateCartPro</title>
</head>
<body>

</body>
</html>