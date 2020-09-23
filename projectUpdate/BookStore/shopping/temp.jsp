<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	
	
	<script src="../js/jquery-3.5.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
	<script>
		var $input=$("#buyCount");
		$("buyCount").on('input',function()){
			$("#btotalAmount").text(
					"총구매가 :"+ Number(<%=buy_price)%>)* Number($('#buy_count').val())
			});
	
	</script>

</body>
</html>