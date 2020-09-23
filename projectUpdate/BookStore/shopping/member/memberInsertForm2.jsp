<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>회원가입</title>
</head>
<body>

<div class="container">
	<!-- 회원가입 자료를 입력할 폼을 만든다. -->
	<!-- 입력할 정보 => 아이디, 비밀번호, 비밀번호확인, 이름, 전화번호, 주소 -->
	<form class="form-horizontal" method="post" name="memInsForm" action="memberInsertPro.jsp">
		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-6">
				<h2 align="center">회원가입</h2>
			</div>
		</div>
		<div class="form-group">
			<label for="id" class="col-sm-2 control-label">아이디</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="id" name="id" 
					maxlength="16" placeholder="Enter ID"/>
			</div>
			<input class="btn btn-warning btn-sm" type="button"
				name="confirm_id" value="dd" 
				onclick="test()">
			<input class="btn btn-warning btn-sm" type="button"
				name="confirm_id" value="중복확인" 
				onclick="confirmId(document.memInsForm.id.value)">
		</div>
		<div class="form-group">
			<label for="passwd" class="col-sm-3 control-label">비밀번호</label>
			<div class="col-sm-9">
				<input type="password" class="form-control" placeholder="비밀번호" name="passwd" maxlength="20"/>
			</div>				
		</div>
		<div class="form-group">
			<label for="passwdCheck" class="col-sm-3 control-label">비밀번호 확인</label>
			<div class="col-sm-9">
				<input type="password" class="form-control" placeholder="비밀번호 확인" name="passwdCheck" maxlength="20"/>
			</div>
		</div>
		<div class="form-group">
			<label for="name" class="col-sm-3 control-label">이름</label>
			<div class="col-sm-9">
				<input type="text" class="form-control" placeholder="이름" name="name" maxlength="20"/>
			</div>
		</div>
		<div class="form-group">
			<label for="tel" class="col-sm-3 control-label">전화번호</label>
			<div class="col-sm-9">
				<input type="text" class="form-control" placeholder="전화번호" name="tel" maxlength="30"/>
			</div>
		</div>
		<div class="form-group">
			<label for="address" class="col-sm-3 control-label">주소</label>
			<div class="col-sm-9">
				<input type="text" class="form-control" placeholder="주소" name="address" maxlength="100"/>
			</div>
		</div>
		<div class="col-sm-offset-3 col-sm-6">
			<input type="submit" class="btn btn-primary form-control" value="회원가입"/>
		</div>
	</form>
</div>

<!-- Script -->
<script src="../../js/jquery-3.5.1.min.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<script src="../../js/bsfunction.js"></script>

</body>
</html>