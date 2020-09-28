<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDAO" %>
<%@ page import="bookstore.shopping.CartDTO" %>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="java.util.List"%>

<%
	request.setCharacterEncoding("utf-8");

	if(session.getAttribute("id") == null || session.getAttribute("id").equals("")) {
		response.sendRedirect("shopMain.jsp");
	}else{
		//전페이지에서 넘어온 데이터를 추출
		String account = request.getParameter("account");
		String deliveryName = request.getParameter("deliveryName");
		String deliveryTel = request.getParameter("deliveryTel");
		String deliveryAddress = request.getParameter("deliveryAddress");
		String buyer = (String)session.getAttribute("id");
		
		CartDAO cart = CartDAO.getInstance();
		List<CartDTO> cartLists = cart.getCart(buyer);
		
		BuyDAO buy = BuyDAO.getInstance();	
		buy.insertBuy(cartLists, buyer, account, deliveryName, deliveryTel, deliveryAddress);
		
		response.sendRedirect("buyList.jsp");
	}
%>