<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.MemberDTO" %>
<%@ page import="bookstore.shopping.MemberDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!-- 회원정보 수정/탈퇴를 하기 위해서는 회원정보가 필요하다. 
	회원정보를 가져오는 기능이 있는 곳(DAO)에 연결하여 작업의뢰를 한다.
	가져오기 위해서 회원정보데이터를 실어나를 그릇(DTO)가 필요하다.
	
	전화번호 값에 대한 처리 : 
	  테이블은 하나의 컬럼이나 화면은 3개의 입력필드로 되어있다.
	  [010]-[1234]-[5678]  	[010-1234-5678]
	  
	  회원정보 수정/탈퇴 => 회원정보가져오기(DA0) => 수정작업 또는 탈퇴
	  					 =>	확인여부페이지 => PRO => DAO
-->
<%
//세션에서 회원의 아이디값을 추출한다.
String id = (String)session.getAttribute("id");
System.out.println("세션값:"+id);

//세션 점검을 한다.
if(session.getAttribute("id") == null || id.equals("")) {
	System.out.println("세션값이 null이예요111.");
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('세션값 체크 중입니다.')");
	pw.println("location.href='../shopMain.jsp'");
	pw.println("</script>");
	
	//response.sendRedirect("../shopMain.jsp");
} else {
	System.out.println("세션값이 이상해요.");
}

//세션 점검을 한다.
if(id == null || id.equals("")) {
	System.out.println("세션값이 null이예요222.");
	response.sendRedirect("../shopMain.jsp");
} else {
	System.out.println("세션값이 이상해요.");
}

//회원정보 수정/탈퇴를 하기 위해서는 회원정보가 필요하다. 
MemberDTO member = null;

//세션에서 회원의 아이디값을 추출한다.
//String id = (String)session.getAttribute("id");

//세션에 들어있는 아이디값에 해당하는 회원의 정보를 가져온다.
//회원정보를 가져오는 기능이 있는 곳(DAO)에 연결하여 작업의뢰를 한다.
MemberDAO memberDAO = MemberDAO.getInstance();
member = memberDAO.getMember(id);

//전화번호 값에 대한 처리 => 전화번호 값을 화면에 맞게 나눈다.
String	tel1	= "";
String	tel2	= "";
String	tel3	= "";

//010-1234-567  
//010-1234-5678
tel1 = member.getTel().substring(0, 3);
if(member.getTel().length() == 12) {
	tel2 = member.getTel().substring(4,  7);
	tel3 = member.getTel().substring(8, 12);
} else {
	tel2 = member.getTel().substring(4,  8);
	tel3 = member.getTel().substring(9, 13);
}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<!-- 부트스트랩을 사용하려면 부트스트랩의 css를 가져온다. -->
	<!-- CDN방식으로 사용할 것인가? 프로젝트에 파일을 가져다 쓸 것인가? -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>회원정보 수정/탈퇴</title>
</head>

<body>

<div class="container">
	<form class="form-horizontal" method="post" name="memUpDelForm"
			action="memberUpDelModalForm.jsp">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">회원정보수정/탈퇴</h2>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">아이디</label>
			<div class="col-sm-3">
				<h4><%=id %></h4>
				<input type="hidden" id="id" name="id" value="<%=id %>"> 
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호</label>
			<div class="col-sm-3">
				<input type="password" class="form-control" id="passwd" 
					name="passwd" maxlength="16" placeholder="Enter Password">
			</div>		
		</div>	
		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호확인</label>
			<div class="col-sm-3">
				<input type="password" class="form-control" id="repasswd" 
					name="repasswd" maxlength="16" placeholder="Enter Password">
			</div>		
		</div>	
		<div class="form-group">
			<label class="control-label col-sm-2">이 름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="name" 
					name="name" maxlength="10" value="<%=member.getName()%>">
			</div>		
		</div>	
		<div class="form-group">
			<label class="control-label col-sm-2">주 소</label>
			<div class="col-sm-7">
				<input type="text" class="form-control" id="address" 
					name="address" maxlength="100" value="<%=member.getAddress()%>">
			</div>		
		</div>	
		<div class="form-group">
			<label class="control-label col-sm-2">전화번호</label>
			<div class="col-sm-2">
				<select class="form-control" name="tel1">
					<option value="010" <%if(tel1.equals("010")) {%> selected<%}%>>010</option>
					<option value="011" <%if(tel1.equals("011")) {%> selected<%}%>>011</option>
					<option value="017" <%if(tel1.equals("017")) {%> selected<%}%>>017</option>
					<option value="018" <%if(tel1.equals("018")) {%> selected<%}%>>018</option>
					<option value="019" <%if(tel1.equals("019")) {%> selected<%}%>>019</option>
				</select>
			</div>
			<div class="input-group col-sm-3">
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel2"
						maxlength="4" value="<%=tel2 %>">
				</div>
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel3"
						maxlength="4" value="<%=tel3 %>">
				</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
				<button type="button" class="btn btn-success"
				onclick="memberUpDelCheckForm(this.form,'UP')">회원정보수정</button>
				<button type="button" class="btn btn-danger"
				onclick="memberUpDelCheckForm(this.form,'DEL')">회원탈퇴</button>
			</div>		
		</div>	
	</form>

</div>

	
<!-- 부트스트랩의 기능을 사용하기 위해서는 jquery가 필요하다. -->
<script src="../../js/jquery-3.5.1.min.js"></script>

<!-- 부트스트랩의 기능을 사용하기 위해서 부트스트랩의 js를 가져온다. -->
<script src="../../bootstrap/js/bootstrap.min.js"></script>

<!-- 입력필드 등의 검사를 하기 위해서 만든 스크립트를 불러온다. -->
<script src="../../js/bsfunction.js"></script>
</body>
</html>















