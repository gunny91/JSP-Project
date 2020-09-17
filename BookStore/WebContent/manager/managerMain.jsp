<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%
	String managerId="";
	managerId=(String)session.getAttribute("managerId");
	
	if(managerId == null || managerId.equals("")){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('ID not found!')");
			pw.println("location.href='logon/managerLoginForm.jsp?useSSL=false'");
			pw.println("</script>");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<title>manager Main</title>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

<!--  Upper Screen part -->
	<div class="container-fluid" style="background-color:gray; color:#fff; height:200px;">
		<h1>Shopping mall manager</h1>
		<h3>Manager the shopping mall from admin</h3>
		<p>Menu bar appeared at the top when scrolling it</p>
	</div>
	
	<!-- Menu manage -->
	<nav class="navbar navbar-inverse" data-spy="affix" data-offset-top="197">
		<div class="container-fluid">
			<div class="navbar=header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon=bar"></span>
					<span class="icon=bar"></span>
					<span class="icon=bar"></span>
				</button>
			<a class="navbar-brand" href="#">bookstore</a>
			 </div>
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						 Product Management <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="product/bookRegisterForm.jsp">Product Registration</a></li>
							<li><a href="product/bookList.jsp">Book List (Revise/Delete)</a></li>
							
						</ul>
					</li>
			 		
			 		<li><a href="logon/managerLogout.jsp">Log Out</a></li>
			 	</ul>
			 </div>
		</div>
	</nav>
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script>
	</script>
</body>
</html>