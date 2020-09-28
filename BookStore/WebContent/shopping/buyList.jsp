<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.BuyDTO" %>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%
if(session.getAttribute("id") == null || session.getAttribute("id").equals("")) {
	response.sendRedirect("shopMain.jsp");
}

String buyer = (String)session.getAttribute("id");

List<BuyDTO>	buyLists	= null;
BuyDTO			buyList		= null;
int					count		= 0;	//총구매건수
int					sum			= 0;	//소계금액
int					total		= 0;	//총금액
long				compareId	= 0;	//현재 buy_id와 비교하기 위한 변수

String	realFolder	= "";
String	saveFolder	= "/imageFile";
ServletContext context = getServletContext();
realFolder	= context.getRealPath(saveFolder);
realFolder	= "http://localhost:8088/BookShop/imageFile";

//사용할 Bean과 연결을 한 후에 보여줄 자료가 있는 지 건수를 먼저 조사한다.
BuyDAO buyProcess = BuyDAO.getInstance();
count = buyProcess.getListCount(buyer);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>구매 목록</title>
</head>
<body>
	
<!-- 화면 상단에 메뉴파일을 불러오자. -->
<jsp:include page="../module/top.jsp" flush="false"/>
<br><br><br>

<%
	//구매한 내역이 없는 경우
if(count < 1) {
%>
	<table class="table table-bordered table-striped nanum table-hover">
		<tr class="info">
			<td align=center><h2>구매하신 내역이 없습니다.</h2></td>
		</tr>
	</table>
<%
	} else { //구매한 내역이 있으면 화면에 보여준다.
	buyLists = buyProcess.getBuyList(buyer);
%>
	<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
		<table class="table">
			<tr>
				<td colspan=6 align=center>
					<h3><span class="label label-success">구 매 목 록</span></h3>
				</td>
			</tr>
			<tr class=info>
				<td width="100" align=center>번호</td>
				<td width="300" align=center>제  목</td>
				<td width= "80" align=center>배송상태</td>
				<td width= "50" align=center>구매가격</td>
				<td width= "50" align=center>수량</td>
				<td width= "50" align=center>금액</td>
			</tr>
			<%
				for(int i = 0; i < buyLists.size(); i++) {
					buyList = buyLists.get(i);	//데이터를 한건 추출한다.
					
					//소계를 구하기 위해 현재 데이터의 바로 다음 데이터의 buy_id를 구한다.
					//다음 buy_id를 구하는데, 현재 buy_id가 마지막 데이터라면
					//다음 데이터를 구할 수 없으므로 -1일때까지만 구한다.
					if(i < buyLists.size() - 1) {
						BuyDTO compare = buyLists.get(i+1);
						compareId = compare.getBuy_id();
					}
			%>
			<tr>
				<td align=center><%=buyList.getBuy_id() %></td>
				<td align=left>
					<img src="<%=realFolder %>/<%=buyList.getBook_image() %>" width=30 height=50 align=middle />
					<%=buyList.getBook_title() %>
				</td>
				<td align=left>
					<% if(buyList.getSanction().equals("상품준비중")) { %>
						<span class="glyphicon glyphicon-gift gi-2x"></span>
					<% } else if(buyList.getSanction().equals("배송중")) { %>
						<span class="glyphicon glyphicon-send gi-2x"></span>
					<% } else if(buyList.getSanction().equals("배송완료")) { %>
						<span class="glyphicon glyphicon-home gi-2x"></span>
					<% } %>
					<%=buyList.getSanction() %>
				</td>
				<td align=right><%=NumberFormat.getInstance().format(buyList.getBuy_price()) %>&nbsp;원</td>
				<td align=right><%=NumberFormat.getInstance().format(buyList.getBuy_count()) %>&nbsp;권</td>
				<td align=right>
					<%=NumberFormat.getInstance().format(buyList.getBuy_price() * buyList.getBuy_count()) %>&nbsp;원
					<% sum += buyList.getBuy_price() * buyList.getBuy_count(); %>
				</td>
			</tr>
			<% //데이터를 한 건 출력을 완료하면 현재buy_id와 다음 buy_id값을 비교한다.
			   //현재buy_id와 다음 buy_id값이 다르거나, 현재buy_id가 마지막 데이터면 소계를 출력한다.
				if((buyList.getBuy_id() != compareId) || (i == buyLists.size()-1)) {   
			%>
			<tr class=danger>
				<td colspan=6 align=right>
					<b>소  계 : <%=NumberFormat.getInstance().format(sum) %>원</b>
					<% total += sum; sum = 0; compareId = buyList.getBuy_id(); %>
				</td>
			</tr>
			<%	} // End - if
			} // End - for %>
			<tr class=primary>
				<td colspan=6 align=right>
					<h3>총 구매금액 : <%=NumberFormat.getInstance().format(total) %>원</h3>
				</td>
			</tr>
		</table>
	</div>

<% } %>

</body>
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</html>






















