<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
String managerId = "";
//매니저의 세션 아이디를 가져온다.
managerId = (String)session.getAttribute("managerId");

//세션값이 없이 들어온 경우는 로그인 화면으로 보내다.
if(managerId == null || managerId.equals("")) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('로그인을 하셔야 합니다.')");
	pw.println("location.href='logon/managerLoginForm.jsp?useSSl=false'");
	pw.println("</script>");
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>관리자 메인 화면</title>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

<!-- 화면 최상단 부분 -->
<div class="container-fluid" 
	style="background-color:#F44336; color:#FFF; height:200px;">
	<h1>쇼 핑 몰 관 리</h1>
	<h3>관리자가 쇼핑몰에 관한 모든 것을 관리하는 페이지입니다.</h3>
	<p>메뉴바는 화면이 스클롤되면 최상단에 보이게 되고, 스크롤에서 제외됩니다.</p>
</div>

<!-- 관리자 메뉴바 -->
<nav class="navbar navbar-inverse" data-spy="affix" data-offset-top="197">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
				<span class="icon-bar"></span>	
				<span class="icon-bar"></span>	
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="#">BookStore</a>
		</div>
		<div>
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						 상품관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="product/bookRegisterForm.jsp">상품등록</a></li>
							<li><a href="product/bookList.jsp?book_kind=all">상품목록(수정/삭제)</a></li>
							
						</ul>
					</li>
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">
							Statistic Manage <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="statistic/monthStatsForm.jsp">Monthly Selling List (꺽은선)</a></li>
							<li><a href="statistic/monthBarStatsForm.jsp">Monthly Selling List (막대)</a></li>
							
						</ul>
					
					</li>
						
					<li><a href="logon/managerLogout.jsp">로그아웃</a>
				</ul>
			</div>
		</div>
	</div>
</nav>




	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>













