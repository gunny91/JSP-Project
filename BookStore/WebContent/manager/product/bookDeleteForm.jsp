<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>

<%
String managerId ="";
managerId = (String)session.getAttribute("managerId");
if(managerId==null || managerId.equals("")){
	response.sendRedirect("../logon/managerLoginForm.jsp");
}else{
	try {
		int book_id = Integer.parseInt(request.getParameter("book_id"));
		String book_kind = request.getParameter("book_kind");
%>

<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>책삭제</title>
</head>
<body>
<div class="container">

	<p>책삭제</p>
	<br>
		<div class="col-sm-offset-6">
		<h4>
		<a href="../managerMain.jsp" class="btn btn-info" aria-pressed="true"> 관리자 메인으로</a>
		<a href="bookList.jsp?book_kind=<%=book_kind%>" class="btn btn-info" aria-pressed="true">목록으로</a>
	    </h4>
	</div>
	
	<form class="form-horizontal" method="post" name="delForm"
		action="bookDeletePro.jsp?book_id=<%= book_id%>&book_kind=<%=book_kind%>" >
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<h2 align="center">책삭제</h2>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2"><h2>책아이디</h2></div>
			<div class="col-sm-2">
				<h2 align=left><%= book_id%></h2>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2"></div>
			<div class="col-sm-2">
				<input type="button" class="btn btn-primary" value="삭제" name="btn_Del" id="btn_Del"/>
			</div>
		</div>
	</form>

</div>

<script src="../../js/jquery-3.5.1.min.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<script>
$(function() {
	$("#btn_Del").on("click", function() {
		var result = confirm('정말 삭제 하시겠습니까?'); 
		if(result) { //true 
			location.replace('bookDeletePro.jsp?book_id=<%= book_id%>&book_kind=<%=URLEncoder.encode(book_kind, "UTF-8")%>'); 
			// location.replace('bookDeletePro.jsp?book_id=<%= book_id%>&book_kind=<%=book_kind%>'); 
		} else { //flase
			location.href='bookList.jsp';
		} 
	});
});
</script>

	
</body>
</html>
<% 
	}catch(Exception e){
		e.printStackTrace();
	}
}
%>
