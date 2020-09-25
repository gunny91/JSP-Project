<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="bookstore.shopping.CartDAO" %>

<%
	String cart_id = request.getParameter("cart_id");
	String buy_count = request.getParameter("buy_count");
	String buy_countOld = request.getParameter("buy_count");
	String book_kind = request.getParameter("book_kind");
	String book_id = request.getParameter("book_id");
	if(session.getAttribute("id")==null){
		response.sendRedirect("shopMain.jsp");
		
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Cart count change</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
	
	<div class="container">
		<h2>Cart amout change</h2>
			<form class="form-inline" method="post" name="updateForm">
				<div class="form-group">
					<label class="sr-only">변경 수량</label>
					<input type="text" class="form-control" name="buy_count" size= "4" value="<%=buy_count%>"placeholder="Buy count"/>

					<input type="hidden" class="form-control" name="buy_countOld" value="<%=buy_countOld %>">
					<input type="hidden" class="form-control" name="cart_id" value="<%=cart_id %>">
					<input type="hidden" class="form-control" name="book_kind" value="<%=book_kind %>">
					<input type="hidden" class="form-control" name="book_id" value="<%=book_id %>">
									
				
				</div>
				<input type="submit" align="center"  class="btn btn-info btn-submit" value="submit" onclick="cartUpdate(); return false;" onFocus="this.blur()"/>
			</form>
	</div>
	
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script src="../js/bsfunction.js"></script>
	
	<script>
	function cartUpdate(){
		var result = confirm("Want to revise it?");
		if(result ==true){
			updateForm.action ="./updateCartPro.jsp";
			updateForm.submit();
		}else{
			history.go(-1);
		}
	}
	</script>
</body>
</html>