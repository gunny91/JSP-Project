<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDTO" %>
<%@ page import="bookstore.shopping.CartDAO" %>
<%@ page import="java.util.List" %> <% //여러건의 데이터를 사용하기 위해서 %>
<%@ page import="java.text.NumberFormat" %> <% //숫자를 형식에 맞춰 보여주기 위해서 %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <% //사진을 가져오기 위해서 %>
<%
//목적 : 로그인한 사용자에게 장바구니에 담은 정보를 보여주자!!!!!!

//로그인한 상태인가?
if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
}
		
//사용자 아이디를 알아야 사용자 아이디에 해당하는 정보를 가져올 수 있으므로
//먼저 세션에서 사용자 정보를 추출한다.
String 	buyer		= (String)session.getAttribute("id");
String	book_kind	= request.getParameter("book_kind");

//작업에 필요한 변수들을 정의한다.
int number	= 0; 	//화면에 데이터 건수를 일련번호로 보여주기 위해서
int count	= 0;	//사용자 아이디에 해당하는 장바구니의 개수를 저장할 변수
int total	= 0;	//사용자 아이디에 해당하는 장바구니에 물품들을 계산할 총금액

//이미지 파일 작업에 필요한 변수와 설정을 한다.
String	realFolder	= "";
String	saveFolder	= "/imageFile";
ServletContext context = getServletContext();
realFolder = context.getRealPath(saveFolder);

//사용자 아이디에 해당하는 정보를 가져온다.
List<CartDTO>	cartLists	= null;
CartDTO			cartList	= null;

CartDAO	cartDAO = CartDAO.getInstance();
count	= cartDAO.getListCount(buyer);

//가져온 정보를 화면에 출력한다.
//정보를 보고 삭제하거나, 구매확정을 한다.
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>장바구니 목록</title>
</head>
<body>

<jsp:include page="../module/top.jsp"/>
<%if(count < 1) { //보여줄 장바구니의 내용이 없으면 %>
	<h2><span class="label label-success">장 바 구 니</span></h2><hr>
	<h3>장바구니에 담긴 물품이 없습니다.</h3><hr>
	<input class="btn btn-info btn-xs" type="button" value="책방둘러보기"
	onclick="javascript:window.location='bookList.jsp?book_kind=<%=book_kind%>'">
<% } else { 
	cartLists = cartDAO.getCart(buyer); //화면에 보여줄 데이터를 가져온다.
%>
<div class="container">
	<h3><span class="label label-primary">장 바 구 니</span></h3>
	<form name="cartForm" method="post" action="updateCartPro.jsp">
		<table class="table table-bordered table-striped table-hover">
			<tr class="info">
				<td width= "50">번호</td>
				<td width="300">책 제 목</td>
				<td width= "50">이미지</td>
				<td width="100">판매가격</td>
				<td width="150">수량</td>
				<td width="150">금액</td>
			</tr>
			<% //장바구니의 개수만큼 작업을 반복한다.
			for(int i = 0; i < cartLists.size(); i++) {  
				cartList = cartLists.get(i);
				
			%>
			<tr>
				<td><%=++number %></td>
				<td><%=cartList.getBook_title() %></td>
				<td><%=cartList.getBook_image() %></td>
				<td><%=cartList.getBuy_price() %></td>
				<td><%=cartList.getBuy_count() %></td>
				<td><%=cartList.getBuy_price() * cartList.getBuy_count() %></td>
			</tr>
			<% } %>
		</table>
	
	
	</form>
</div>


<% } %>
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>













