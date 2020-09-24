<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	String mode = request.getParameter("mode");
	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");
	String name = request.getParameter("name");
	String tel = request.getParameter("tel") + "-" + request.getParameter("tel2") +"-"+request.getParameter("tel3");
	String address = request.getParameter("address");


%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>회원 정보 수정 탈퇴</title>
	
</head>
<body>
	<div class="container">
		<h2>회원 정보 <%if(mode.equals("UP")) {%> 수정 <%}else {%>탈퇴 <%} %></h2>
		<button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
		회원정보 <%if(mode.equals("UP")) {%> 수정 <%}else {%>탈퇴 <%} %>
		</button> 
		
				
	</div>

	<script src="../../js/jquery-3.5.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script src="../../js/bsfunction.js"></script>
</body>
</html>