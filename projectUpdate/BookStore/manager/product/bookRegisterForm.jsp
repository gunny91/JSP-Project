<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BscodeDTO" %>
<%
//세션이 있는지 검사한다.
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

Timestamp nowTime = new Timestamp(System.currentTimeMillis());
int lastYear = Integer.parseInt(nowTime.toString().substring(0, 4));

//도서타입에 대한 데이터를 가져온다.
List<BscodeDTO> bookTypes = null;
BscodeDTO bookType = null;
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
bookTypes = bookStoreDAO.getBookTypes();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>상품등록</title>
</head>
<body>

<div class="container">
	<form class="form-horizontal" name="writeform" action="bookRegisterPro.jsp"
		method="post" enctype="multipart/form-data">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">상품등록</h2>
			</div>
			<div class="col-sm-3">
				<a href="../managerMain.jsp" class="btn btn-success">메인메뉴</a>
				<a href="bookList.jsp?book_kind=all" class="btn btn-info">목록으로</a>
			</div>
		</div>
		<!--  
		<div class="form-group">
			<label class="control-label col-sm-2">분류 선택</label>
			<div class="col-sm-2">
				<select class="form-control" name="book_kind">
					<option value="100">문학</option>
					<option value="200">외국어</option>
					<option value="300">컴퓨터</option>
				</select>
			</div>
		</div>
		-->
		<div class="form-group">
			<label class="control-label col-sm-2">분류 선택</label>
			<div class="col-sm-2">
				<select class="form-control" name="book_kind" id="book_kind">
				<%for(int i = 0; i < bookTypes.size(); i++) { 
					bookType = (BscodeDTO)bookTypes.get(i); %>
					<option value="<%=bookType.getId()%>"><%=bookType.getName() %></option>
				<% } %>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">제  목</label>
			<div class="col-sm-8">
				<input type="text" class="form-control" maxlength="100" 
				name="book_title" onkeydown="nextFocus(book_price)" placeholder="제목"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">가  격</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" maxlength="8" 
					name="book_price" onkeydown="nextFocus(book_count)" placeholder="가격"/>
					<span class="input-group-addon">원</span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">수  량</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" maxlength="6" 
					name="book_count" onkeydown="nextFocus(author)" placeholder="수량"/>
					<span class="input-group-addon">권</span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">저  자</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" maxlength="40" 
				name="author" onkeydown="nextFocus(publishing_com)" placeholder="저자"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">출판사</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" maxlength="40" 
				name="publishing_com" onkeydown="nextFocus(publishing_year)" placeholder="출판사"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">출판일</label>
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_year" style="width:120px;"
						onkeydown="nextFocus(publishing_month)">
						<%for(int i = lastYear; i >= 2010; i--) {%>
						<option value="<%=i%>"><%=i%></option>
						<% } %>
					</select>
					<span class="input-group-addon">년</span>
				</div>
			</div>
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_month" style="width:120px;"
						onkeydown="nextFocus(publishing_day)">
						<%for(int i = 1; i <= 12; i++) {%>
						<option value="<%=i%>"><%=i%></option>
						<% } %>
					</select>
					<span class="input-group-addon">월</span>
				</div>
			</div>
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_day" style="width:120px;"
						onkeydown="nextFocus(book_image)">
						<%for(int i = 1; i <= 31; i++) {%>
						<option value="<%=i%>"><%=i%></option>
						<% } %>
					</select>
					<span class="input-group-addon">일</span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">이미지명</label>
			<div class="col-sm-4">
				<input type="file" class="form-control"  
				name="book_image" onkeydown="nextFocus(book_content)"/>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">내  용</label>
			<div class="col-sm-7">
				<textarea class="form-control col-sm-5" name="book_content"
				 rows="10" cols="100" placeholder="내용"></textarea>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">할인율</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" size="4" maxlength="10" 
					name="discount_rate" onkeydown="nextFocus(btn_OK)" placeholder="할인율"/>
					<span class="input-group-addon">%</span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2">
				<input type="button" class="btn btn-primary" value="등록"
				onclick="checkForm(this.form)" name="btn_OK"/>
				<input type="reset"  class="btn btn-warning" value="다시작성"/>
			</div>
		</div>
		
	</form>

</div>

	<script src="../../js/jquery-3.5.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script src="../../js/bsfunction.js"></script>
	<script>
	function nextFocus(where)
	{
		if(event.keyCode == 13)
			where.focus();
	}
	</script>
</body>
</html>













