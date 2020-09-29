<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDTO" %>
<%@ page import="bookstore.shopping.CartDAO" %>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%
request.setCharacterEncoding("utf-8");

//세션 아이디가 있는지(정상적으로 로그인하고 입장하였는지) 검사한다.
if(session.getAttribute("id") == null || session.getAttribute("id").equals("")) {
	response.sendRedirect("shopMain.jsp");
} else {
	//전페이지에서 넘어온 데이터를 추출한다.
	String	account			= request.getParameter("account");
	String	deliveryName	= request.getParameter("deliveryName");
	String	deliveryTel		= request.getParameter("deliveryTel");
	String	deliveryAddress	= request.getParameter("deliveryAddress");
	String	buyer			= (String)session.getAttribute("id");
	
	CartDAO cartDAO = CartDAO.getInstance();
	List<CartDTO> cartLists = cartDAO.getCart(buyer);
	
	BuyDAO	buyDAO	= BuyDAO.getInstance();
	buyDAO.insertBuy(cartLists, buyer, account, 
						deliveryName, deliveryTel, deliveryAddress);
	
	response.sendRedirect("buyList.jsp");
}
%>








