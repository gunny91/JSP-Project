<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="../module/top.jsp"/>
<jsp:include page="./intro.jsp"/>

<div class="container-fluid">
	<div class="row">
		<div class="col-sm-2">
			<jsp:include page="intro.jsp"/>
		</div>
		<div class="col-sm-8">
			<jsp:include page="intro.jsp"/>
		</div>
		<div class="col-sm-2">
			<jsp:include page="intro.jsp"/>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<jsp:include page="intro.jsp"/>
		</div>
	</div>
</div>	

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>









