<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDAO" %>
<% //목적 : 장바구니의 담겨져 있는 수량을 변경한다.
String 	cart_id			= request.getParameter("cart_id");
String	buy_count		= request.getParameter("buy_count"); //변경될 수량
String	buy_countOld	= request.getParameter("buy_count"); //담겨져 있는 수량
String	book_kind		= request.getParameter("book_kind");
String	book_id			= request.getParameter("book_id");

//세션이 없으면 처음화면으로 돌려보낸다.
if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>장바구니에 담긴 책의 수량 변경</title>
</head>
<body>

<jsp:include page="../module/top.jsp"/>

<div class="container">
	<h2>장바구니 수량 변경</h2>
	<form class="form-inline" method="POST" name="updateForm">
		<div class="form-group">
			<label class="sr-only">변경할 수향</label>
			<input type="text" class="form-control" name="buy_count" size="4"
				value="<%=buy_count%>" placeholder="구매수량"/>
				
			<input type="hidden" class="form-control" name="buy_countOld"
				value="<%=buy_countOld%>"/>
				
			<input type="hidden" class="form-control" name="cart_id"
				value="<%=cart_id%>"/>
				
			<input type="hidden" class="form-control" name="book_kind"
				value="<%=book_kind%>"/>
				
			<input type="hidden" class="form-control" name="book_id"
				value="<%=book_id%>"/>
		</div>	
		<input type="submit" align="center" class="btn btn-danger btn-submit" value="수정"
			onclick="cartUpdate(); return false;"/>
	</form>
</div>
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script src="../js/bsfunction.js"></script>
	<script>
	function cartUpdate() {
		var rtnVal = confirm("수량을 수정하시겠습니까?");
		if(rtnVal == true) {
			updateForm.action = "./updateCartPro2.jsp";
			updateForm.submit();
		} else {
			history.go(-1); // history.back();와 같다.
		}
	}
	</script>
</body>
</html>










