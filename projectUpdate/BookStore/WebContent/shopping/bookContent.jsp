<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BookDTO" %>
<%@ page import="bookstore.master.BscodeDTO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>

<%
//이전 페이지에서 넘겨준 정보를 가져온다.
String	book_id		= request.getParameter("book_id");
String	book_kind  	= request.getParameter("book_kind");
String	id			= "";
int		buy_price	= 0;

//이미지 파일을 보여주어야 하므로 관련된 부분을 준비한다.
String	realFolder	= "";
String	saveFolder	= "/imageFile";
ServletContext context  = getServletContext();
realFolder				= context.getRealPath(saveFolder);
realFolder	= "http://localhost:8088/BookStore/imageFile";
//System.out.println("readFolder:"+realFolder);
//////////////////////////////////////////

//세션정보가 있는 사람과 없는 사람의 차이를 둔다.(장바구니에 담기)
if(session.getAttribute("id") == null) {
	id = "NOT";
} else {
	id = (String)session.getAttribute("id");
}

//화면에 보여줄 정보를 DB에서 가져온다.(book_id에 해당하는 책의 정보)
BookDTO book = null;
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
book = bookStoreDAO.getBook(Integer.parseInt(book_id));

//판매가x구매권수 => 구매금액 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>도서 상세 정보</title>
</head>
<body>

<jsp:include page="../module/top.jsp"/>

<!-- 책의 상세정보를 보고 수량을 입력한 후 OK를 하면 카드에 내용을 담는다. -->
<div class="container">
<form name="inform" method="post" action="cartInsert.jsp">
	<table class="table" border="1">
		<tr>
			<td rowspan="9" width="150">
				<img src="<%=realFolder%>/<%=book.getBook_image()%>" 
						border="0" width="150" height="200"/> 
			</td>
			<td width="500">
				<font size="+1"><b><%=book.getBook_title()%></b></font>
			</td>
		</tr>
		<tr><td width="500">저  자 : <%=book.getAuthor()%></td></tr>
		<tr><td width="500">출판사 : <%=book.getPublishing_com()%></td></tr>
		<tr><td width="500">출판일 : <%=book.getPublishing_date()%></td></tr>
		<tr><td width="500">정  가 : <%=NumberFormat.getInstance().format(book.getBook_price())%>원</td></tr>
		<tr><td width="500">할인율 : <font color="blue"><%=book.getDiscount_rate()%>%</font></td></tr>
		<%buy_price = book.getBook_price() * (100-book.getDiscount_rate())/100; %>
		<tr><td width="500">판매가 : <font color="red"><b><%=NumberFormat.getInstance().format(buy_price)%>원</b></font></td></tr>
		<tr><td width="500">재고수량 : <%=book.getBook_count()%>권
				<%if(book.getBook_count() <= 0) {%>
					<font color="red"><b>일시품절</b></font>
				<% } else {
					//로그인 한 사람의 경우 재고가 있으면 장바구니에 담을 수 있게 한다.
					if(!id.equals("NOT")) { %>
					  구매수량: <input type="text" id="buyCount" size="4" name="buy_count" value="1">권
					  <b><font color="red"><label id="totalAmount"></label></font></b>
					  <input type="hidden" name="book_id" value="<%=book_id%>">
					  <input type="hidden" name="book_image" value="<%=book.getBook_image()%>">
					  <input type="hidden" name="book_title" value="<%=book.getBook_title()%>">
					  <input type="hidden" name="buy_price" value="<%=buy_price%>">
					  <input type="hidden" name="book_kind" value="<%=book.getBook_kind()%>">
					  <input type="submit" value="장바구니에 담기">
				<% } 
				} %>
			</td>
		</tr>
		<tr>
			<td width="500">
				<input type="button" value="책방둘러보기"
					onclick="javascript:window.location='bookList.jsp?book_kind=<%=book.getBook_kind()%>'"/>
				<input type="button" value="메인으로"
					onclick="javascript:window.location='shopMain.jsp'"/>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><%=book.getBook_content()%></td>
		</tr>
	</table>
</form>
</div>
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script>
	//var count = document.getElementById("buyCount").value;
	//alert(count);
	//.toLocaleString() : 자바스크립트에서 값을 단위로 표시하기 위해서 사용.
	var $input = $("#buyCount");
	$("#buyCount").on('input', function() {
		$('#totalAmount').text(
			"총구매가 :" + (Number(<%=buy_price%>) * Number($('#buyCount').val())).toLocaleString() + "원");
	});
	</script>
</body>
</html>

















