<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="bookstore.shopping.BuyMonthDTO" %>
<%

	request.setCharacterEncoding("utf-8");
	//Session check
	String managerId="";
	managerId=(String)session.getAttribute("managerId");
	if(managerId ==null || managerId.equals("")){response.sendRedirect("../logon/managerLoginForm.jsp");}

	//검색할 년도 저장할 변수
	String year = request.getParameter("year");
	//검색할 년도에 해당하는 데이터를 가져온다.
	
	BuyMonthDTO buyMonthList= null;
	BuyDAO buyDAO =BuyDAO.getInstance();
	buyMonthList = buyDAO.buyMonth(year);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>Monthly Selling STAT Data</title>
</head>
<body>

	<div class="container">
		
		<h4 align="center"><b>월별 판매 현황</b></h4>
		<form class="form-horizontal" method="post" name="monthStatesForm" action="monthStatsForm.jsp">
			<div class="form-groun">
				<div class="col-sm-1">
					<h4> <span class="label label-info">검색년도</span></h4>
				</div>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="year" name="year" placeholder="Enter year"/>
				</div>
				<div class="col-sm-2">
					<input class="btn btn-danger btn-sm" type="submit" value="Search" action="javascript:window.location=monthStatsForm.jsp"/>
					<input class="btn btn-info btn-sm" type="button" value="Go to Main..." onclick="javascript:window.location='../managerMain.jsp'"/>
				</div>
			</div>
		
			<table class="table table-bordered" width="700" cellpadding="0" cellspacing="0" align="center">
				<thead>
					<tr class="info" height="30">
						<td align="center">January</td>
						<td align="center">Febrary</td>
						<td align="center">March</td>
						<td align="center">April</td>											
						<td align="center">May</td>
						<td align="center">Jun</td>
						<td align="center">July</td>
						<td align="center">August</td>
						<td align="center">September</td>
						<td align="center">October</td>
						<td align="center">November</td>
						<td align="center">December</td>
					</tr>
				</thead>
				
				
				<tbody>
				<tr>
						<td align ="right"><%=buyMonthList.getMonth01() %> </td>
						<td align ="right"><%=buyMonthList.getMonth02() %> </td>
						<td align ="right"><%=buyMonthList.getMonth03() %> </td>
						<td align ="right"><%=buyMonthList.getMonth04() %> </td>
						<td align ="right"><%=buyMonthList.getMonth05() %> </td>
						<td align ="right"><%=buyMonthList.getMonth06() %> </td>
						<td align ="right"><%=buyMonthList.getMonth07() %> </td>
						<td align ="right"><%=buyMonthList.getMonth08() %> </td>
						<td align ="right"><%=buyMonthList.getMonth09() %> </td>
						<td align ="right"><%=buyMonthList.getMonth10() %> </td>
						<td align ="right"><%=buyMonthList.getMonth11() %> </td>
						<td align ="right"><%=buyMonthList.getMonth12() %> </td>
				</tr>	
				
				<tr class="danger">
					<td align="right" colspan="12">
						<h4>
							<p class="bg-danger"> Total Amount <%=buyMonthList.getTotal() %></p>
						</h4>
					</td>
				</tr>
						
				</tbody>
				
			</table>
		</form>
	</div>
	
	
	<script src="../../js/jquery-3.5.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>