<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.CartDTO" %>
<%@ page import="bookstore.shopping.CartDAO" %>
<%@ page import="bookstore.shopping.MemberDTO" %>
<%@ page import="bookstore.shopping.MemberDAO" %>
<%@ page import="bookstore.shopping.BankDTO" %>
<%@ page import="bookstore.shopping.BuyDTO" %>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
/*
구매확정전 화면을 구성한다.
확정된 장바구니의 수량, 구매예정금액을 보여준다.
사용자에 대한 정보를 보여주고, 배송지 정보는 수정할 수 있게 한다.
*/

//세션 아이디가 있는지(정상적으로 로그인하고 입장하였는지) 검사한다.
if(session.getAttribute("id") == null || session.getAttribute("id").equals("")) {
	response.sendRedirect("shopMain.jsp");
}
//전페이지에서 넘겨준 정보를 가져온다.
String	book_kind	= request.getParameter("book_kind");
String	buyer		= (String)session.getAttribute("id");

CartDTO			cartList	=	null;
List<CartDTO>	cartLists	=	null;
List<BankDTO>	bankLists	=	null;
MemberDTO		member		=	null;

int		number		= 0;
int		totalAmount	= 0;

String			realFolder	= "";
String			saveFolder	= "/imageFile";
ServletContext	context		= getServletContext();
//realFolder					= context.getRealPath(saveFolder);
realFolder					= "http://localhost:8088/BookStore/imageFile";

//buyer에 해당하는 Cart의 모든 정보를 가져온다.
CartDAO		cartDAO		= CartDAO.getInstance();
cartLists	= cartDAO.getCart(buyer);

//구매자에 대한 정보를 가져온다.
MemberDAO	memberDAO	= MemberDAO.getInstance();
member		= memberDAO.getMember(buyer);

//송금할 은행의 정보를 가져온다.
BuyDAO		buyDAO		= BuyDAO.getInstance();
bankLists	= buyDAO.getAccount();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>Insert title here</title>
</head>
<body>

<jsp:include page="../module/top.jsp"/>

<div class="container">
	<h3 align="center"><b>구매 목록</b></h3>
	<table class="table table-striped table-hover">
		<tr class="info">
			<td width= "50" align="center">번호</td>
			<td width="300" align="center">제목</td>
			<td width="100" align="center">판매가격</td>
			<td width= "50" align="center">수량</td>
			<td width= "50" align="center">구매금액</td>
		</tr>
		<% //추출한 장바구니 건수만큼 화면에 출력한다.
		for(int i = 0; i < cartLists.size(); i++) {
			//cartLists에서 한건을 추출한 후에 화면에 자료를 출력한다.
			cartList = cartLists.get(i); %> 
		<tr>
			<td align=right><%=++number%></td>
			<td>
				<img src="<%=realFolder%>/<%=cartList.getBook_image()%>" width="30" height="50">
				&nbsp;&nbsp;<%=cartList.getBook_title()%>
			</td>
			<td align="right" valign="bottom">
				<%=NumberFormat.getInstance().format(cartList.getBuy_price())%> 원
			</td>
			<td align=right>
				<%=NumberFormat.getInstance().format(cartList.getBuy_count())%> 권
			</td>
			<td align=right>
				<%=NumberFormat.getInstance().format(cartList.getBuy_price()*cartList.getBuy_count())%> 원
				<% totalAmount += cartList.getBuy_price()*cartList.getBuy_count(); %>			
			</td>
		</tr>
		<% } //장바구니에 있는 모든 데이터의 출력이 끝났다. %>
		<tr class="danger">
			<td colspan="5" align="right">
				<b><font size="+1">총 구매금액 : 
				<%=NumberFormat.getInstance().format(totalAmount)%> 원</font></b>
			</td>
		</tr>
	</table>

	<form class="form-horizontal" method="post" name="buyInput" action="buyPro.jsp">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-3">
				<h3 align=center>주문자 정보</h3>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">이  름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="name" name="name"
					value="<%=member.getName()%>" disabled/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">전화번호</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="tel" name="tel"
					value="<%=member.getTel()%>" disabled/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">결제계좌</label>
			<div class="col-sm-3">
				<select class="form-control" id="account" name="account">
				<% //계좌번호, 은행명, 계좌소유주를 하나로 합쳐서
				   //option 항목에 보이게 한다.
				for(int i = 0; i < bankLists.size(); i++) {
					String accountList = bankLists.get(i).getAccount() + " "
									   + bankLists.get(i).getBank()    + " "
									   + bankLists.get(i).getName();
				%>
					<option value="<%=bankLists.get(i).getAccount()%>">
						<%=accountList%>
					</option>
				<% } %>
				</select>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-3">
				<h3 align="center">배송지 정보</h3>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">이  름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="deliveryName" name="deliveryName"
					value="<%=member.getName()%>"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">전화번호</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="deliveryTel" name="deliveryTel"
					value="<%=member.getTel()%>"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">주  소</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" id="deliveryAddress" name="deliveryAddress"
					value="<%=member.getAddress()%>"/>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-4">
				<input class="btn btn-primary btn-sm" type="submit" value="구매확인">&nbsp;&nbsp;
				<input class="btn btn-danger btn-sm" type="submit" value="취소"
					onclick="javascript:window.location='cartList.jsp?book_kind=all'"/>
			</div>
		</div>
	</form>
</div>


<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
	
</body>
</html>





















