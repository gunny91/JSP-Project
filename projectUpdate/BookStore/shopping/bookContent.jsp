<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BookDTO" %>
<%@ page import="bookstore.master.BscodeDTO" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>

<%
	
	String book_kind= request.getParameter("book_kind");
	String book_id = request.getParameter("book_id");
	String id="";
	int buy_price = 0;
	
	String realFolder="";
	String saveFolder="/imageFile";
	ServletContext context =getServletContext();
	realFolder = context.getRealPath(saveFolder);
//	realFolder="http://localhost:8094/BookStore/imageFile";
	
	if(session.getAttribute(id)==null){
		id="NOT";
	}else{
		id = (String)session.getAttribute(id);
	}
	
	BookDTO book =null;
	BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
	book = bookStoreDAO.getBook(1);
	
	System.out.println("book"+book);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Book Content</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="../module/top.jsp"></jsp:include>

	<form name="inform" method="post" action="cartInsert.jsp">
		<table class="table">
			<tr>
				<td rowspan="8" width="150">
				<img src="<%=realFolder%>/<%=book.getBook_image()%>" border="0" width="150" height="200"/></td>
				<td width="500"><%=book.getBook_title() %>제목</td>
			</tr>
			<tr>
				<td width="500">저 자 : <%=book.getAuthor()%></td>
			</tr>
			<tr>
				<td width="500">출판사 : <%=book.getPublishing_com() %></td>
			</tr>
			<tr>
				<td width="500">출판일 : <%=book.getPublishing_date() %></td>
			</tr>
			<tr>
				<td width="500">정가 : <%=NumberFormat.getInstance().format(book.getBook_price()) %></td>
			</tr>
				<tr>
					<td width="500"><%buy_price = book.getBook_price()*((100 - book.getDiscount_rate()/100));%>할인율</td>
				</tr>
			<tr>
				<td width="500">판매가<font color="red"><%=NumberFormat.getInstance().format(buy_price)%> </font></td>
			</tr>
			<tr>
				<td width="500">재고수량 : <%=book.getBook_count() %>권</td>
			</tr>
			
				<%if(book.getBook_count() <=0){ %>
					<font color="red"><b>일시품절</b></font>
					<%}else{
						if(!id.equals("NOT")){ %>
						구매수량: <input type="text" id="buyCount" size="4" name="buy_count" value="1"/>권
										
					<%}
					}%>
					
			
			
			
			<tr>
				<td width="500">버 튼</td>
			</tr>
		</table>
	
	</form>
		<script src="../js/jquery-3.5.1.min.js"></script>
		<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>