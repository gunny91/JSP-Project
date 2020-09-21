<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%
//로그인을 하고 입장한 경우와 아닌 경우에 따라 메뉴를 다르게 보여주자!!!
if(session.getAttribute("id") == null)
{
%>
<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" 
				data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<h1><a class="navbar-brand" href="../shopping/shopMain.jsp">쇼핑몰</a></h1>	
		</div>
		<div>
			<!-- form-group이 있어야 삼선 버튼에 메뉴가 출력된다. -->
			<!-- button에 있는 data-target에는 #을 붙여야 아이디와 연결된다. -->
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<form class="navbar-form navbar-right" method="post"
					action="../shopping/logon/loginPro.jsp">
					<div class="form-group">
						<input type="text" class="form-controll" name="id" size="12"
							maxlength="12" placeholder="아이디"/>
						<input type="password" class="form-controll" name="passwd" size="12"
							maxlength="12" placeholder="비밀번호"/>
					</div>	
					<button type="submit" class="btn btn-primary">
						<span class="glyphicon glyphicon-log-in"></span> 로그인
					</button>
					<a href="../shopping/member/memberInsertForm.jsp" 
						class="btn btn-danger" aria-pressed="true">
						<span class="glyphicon glyphicon-user"></span> 회원가입	
					</a>
				</form>
			</div>
		</div>	
	</div>
</nav>
<%
} else { // 로그인이 정상적으로 된 경우 %>
<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" 
				data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<h1><a class="navbar-brand" href="../shopping/shopMain.jsp">쇼핑몰</a></h1>	
		</div>
		<div>
			<!-- form-group이 있어야 삼선 버튼에 메뉴가 출력된다. -->
			<!-- button에 있는 data-target에는 #을 붙여야 아이디와 연결된다. -->
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<p class="navbar-text"><b><%=session.getAttribute("id") %> 님, 
				즐거운 쇼핑시간 되십시오.</b></p>
				<a href="../shopping/shopMain.jsp" class="btn btn-success" aria-pressed="true">
					<span class="glyphicon glyphicon-eye-open"></span> 쇼핑계속하기</a>
					
				<a href="../shopping/cartList.jsp?book_kind=all" class="btn btn-primary" aria-pressed="true">
					<span class="glyphicon glyphicon-shopping-cart"></span> 쇼핑계속하기</a>
					
				<a href="../shopping/buyList.jsp" class="btn btn-warning" aria-passed="true">
					<span class="glyphicon glyphicon-list-alt"></span> 구매목록보기</a>
					
				<a href="../shopping/member/memberUpDelForm.jsp" class="btn btn-info" aria-pressed="true">
					<span class="glyphicon glyphicon-user"></span> 회원정보수정</a>
					
				<a href="../shopping/logon/logout.jsp" class="btn btn-danger" aria-pressed="true">
					<span class="glyphicon glyphicon-log-out"></span> 로그아웃</a>
			</div>
		</div>	
	</div>
</nav>
<% } %>












