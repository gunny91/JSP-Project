<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="bookstore.shopping.BuyMonthDTO" %>
<%@ page import="java.util.List" %>
<%
request.setCharacterEncoding("utf-8");
//세션 검사
String managerId = "";
managerId = (String)session.getAttribute("managerId");
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp");
}
//검색할 년도를 저장할 변수
String year = request.getParameter("year");

//검색할 년도에 해당하는 데이터를 가져온다.

BuyMonthDTO buyMonthList = null;
BuyDAO buyDAO = BuyDAO.getInstance();
buyMonthList  = buyDAO.buyMonth(year);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="../../css/morris.css" rel="stylesheet">
	<title>년도에 따른 월별 판매량</title>
</head>
<body>

<div class="container">

<h4 align="center"><b>월별 판매 현황</b></h4>
<form class="form-horizontal" method="post" name="monthStatsForm" action="monthStatsForm.jsp">
	<div class="form-groun">
		<div class="col-sm-1">
			<h4><span class="label label-info">검색년도</span></h4>
		</div>
		<div class="col-sm-2">
			<input type="text" class="form-control" id="year" name="year" placeholder="Enter Year"/>
		</div>
		<div class="col-sm-2">
			<input class="btn btn-danger btn-sm" type="submit" value="검색하기"
				action="javascript:window.location=monthStatsForm.jsp"/>
			<input class="btn btn-info btn-sm" type="button" value="메인으로"
				onclick="javascript:window.location='../managerMain.jsp'"/>
		</div>
	</div>
	
	<table class="table table-bordered" width="700" cellpadding="0" cellspacing="0" align="center">
		<thead>
			<tr class="info" height="30">
				<td align="center">1월</td>
				<td align="center">2월</td>
				<td align="center">3월</td>
				<td align="center">4월</td>
				<td align="center">5월</td>
				<td align="center">6월</td>
				<td align="center">7월</td>
				<td align="center">8월</td>
				<td align="center">9월</td>
				<td align="center">10월</td>
				<td align="center">11월</td>
				<td align="center">12월</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td align="right"><%=buyMonthList.getMonth01() %></td>
				<td align="right"><%=buyMonthList.getMonth02() %></td>
				<td align="right"><%=buyMonthList.getMonth03() %></td>
				<td align="right"><%=buyMonthList.getMonth04() %></td>
				<td align="right"><%=buyMonthList.getMonth05() %></td>
				<td align="right"><%=buyMonthList.getMonth06() %></td>
				<td align="right"><%=buyMonthList.getMonth07() %></td>
				<td align="right"><%=buyMonthList.getMonth08() %></td>
				<td align="right"><%=buyMonthList.getMonth09() %></td>
				<td align="right"><%=buyMonthList.getMonth10() %></td>
				<td align="right"><%=buyMonthList.getMonth11() %></td>
				<td align="right"><%=buyMonthList.getMonth12() %></td>
			</tr>
			<tr class="danger">
				<td align="right" colspan="12">
					<h4>
						<p class="bg-danger">총 판매수량 : <%=buyMonthList.getTotal() %></p>
					</h4>
				</td>
			</tr>
		</tbody>
	</table>
</form>

</div>

<div id="myFirstChart" style="height: 300px;"></div>

<script src="../../js/jquery-3.5.1.min.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<script src="../../js/morris.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script>
var m01 = <%=year%> + "-01";
var m02 = <%=year%> + "-02";
var m03 = <%=year%> + "-03";
var m04 = <%=year%> + "-04";
var m05 = <%=year%> + "-05";
var m06 = <%=year%> + "-06";
var m07 = <%=year%> + "-07";
var m08 = <%=year%> + "-08";
var m09 = <%=year%> + "-09";
var m10 = <%=year%> + "-10";
var m11 = <%=year%> + "-11";
var m12 = <%=year%> + "-12";

new Morris.Line({
	//그래프를 표시하기 위한 객체의 ID
	element:	'myFirstChart',
	//그래프 데이터. 각 요소가 하나의 그래프 상의 값에 해당한다.
	data: [
		{ year: m01, value: <%=buyMonthList.getMonth01()%> },
		{ year: m02, value: <%=buyMonthList.getMonth02()%> },
		{ year: m03, value: <%=buyMonthList.getMonth03()%> },
		{ year: m04, value: <%=buyMonthList.getMonth04()%> },
		{ year: m05, value: <%=buyMonthList.getMonth05()%> },
		{ year: m06, value: <%=buyMonthList.getMonth06()%> },
		{ year: m07, value: <%=buyMonthList.getMonth07()%> },
		{ year: m08, value: <%=buyMonthList.getMonth08()%> },
		{ year: m09, value: <%=buyMonthList.getMonth09()%> },
		{ year: m10, value: <%=buyMonthList.getMonth10()%> },
		{ year: m11, value: <%=buyMonthList.getMonth11()%> },
		{ year: m12, value: <%=buyMonthList.getMonth12()%> }
	],
	// 그래프 데이터에서 x축에 해당하는 값의 이름
	xkey: 'year',
	// 그래프 데이터에서 y축에 해당하는 값의 이름
	ykeys: ['value'],
	// 각 값에 대해서 마우스 오버시 표시하기 위한 레이블
	labels: ['value']
});
</script>

</body>
</html>








