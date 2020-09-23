<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BookDTO" %>
<%@ page import="bookstore.master.BscodeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("utf-8");

//세션의 값을 가져온다. 
String managerId = "";
managerId = (String)session.getAttribute("managerId");

//세션 값이 없으면 로그인 페이지로 이동시킨다.
if(managerId == null || managerId.equals("")) {
	//response.sendRedirect("../logon/managerLoginForm.jsp");
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('로그인을 하셔야 합니다.')");
	pw.println("location.href='../logon/managerLoginForm.jsp?useSSl=false'");
	pw.println("</script>");
} else {
	try {
		//리스트 화면에서 넘겨준 book_id와 book_kind를 가져온다.
		int 	book_id 	= Integer.parseInt(request.getParameter("book_id"));
		String	book_kind	= request.getParameter("book_kind");
		
		//도서타입에 대한 데이터를 가져온다.
		List<BscodeDTO>	bookTypes 	= null;
		BscodeDTO 		bookType 	= null;
		BookStoreDAO 	bookStoreDAO = BookStoreDAO.getInstance();
		bookTypes 		= bookStoreDAO.getBookTypes();

		BookDTO			book			= bookStoreDAO.getBook(book_id);
		
		Timestamp	nowTime	= new Timestamp(System.currentTimeMillis());
		//String author = "David";
		//substring(3) => 인덱스번호 3번포함 이후의 모든 값을 가져온다. => id
		//substring(1, 4) => 인덱스번호 1번부터 4번 앞까지 => avi 
		int lastYear = Integer.parseInt(nowTime.toString().substring(0, 4));
		//2020-10-2334334 => (0, 4) => 2020
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>책 정보 수정</title>
</head>
<body>

<div class="container">
	<form class="form-horizontal" method="post" name="updateform"
			action="bookUpdatePro.jsp" enctype="multipart/form-data">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align=center>책 정보 수정</h2>
			</div>
			<div class="col-sm-3">
				<h5>
				<a href="../managerMain.jsp" class="btn btn-info">메인메뉴</a>
				<a href="bookList.jsp?book_kind=<%=book_kind %>" class="btn btn-info">목록으로</a>
				</h5>
			</div>
		</div>	
		<div class="form-group">
			<label class="control-label col-sm-2">분류 선택</label>
			<div class="col-sm-2">
				<select class="form-control" name="book_kind">
					<%for(int i = 0; i < bookTypes.size(); i++) {
						bookType = (BscodeDTO)bookTypes.get(i); 
						String gType = bookType.getId(); %>
					<option value="<%=bookType.getId()%>" <%if(book.getBook_kind().equals(bookType.getId())) {%>selected<%} %> ><%=bookType.getName()%></option>
						<% } %>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">제  목</label>
			<div class="col-sm-8">
				<input type="text" class="form-control" name="book_title" onkeydown="nextFocus(book_price)" size=50 maxlength=100
						value="<%=book.getBook_title()%>">
				<input type="hidden" name="book_id" value="<%=book_id %>">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">가  격</label>
			<div class="col-sm-2">
				<input type="text" class="form-control" name="book_price" onkeydown="nextFocus(book_count)" size=10 maxlength=9
						value="<%=book.getBook_price()%>">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">수  량</label>
			<div class="col-sm-2">
				<input type="text" class="form-control" name="book_count" onkeydown="nextFocus(author)" size=5 maxlength=5
						value="<%=book.getBook_count()%>">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">저  자</label>
			<div class="col-sm-5">
				<input type="text" class="form-control" name="author" onkeydown="nextFocus(book_content)" size=40 maxlength=40
						value="<%=book.getAuthor()%>">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">출판사</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" name="publishing_com" onkeydown="nextFocus(publishing_year)" size=30 maxlength=30
						value="<%=book.getPublishing_com()%>">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">출판일</label>
			<div class="col-sm-2">
				<select class="form-control" name="publishing_year" onkeydown="nextFocus(publishing_month)">
					<% for(int i = lastYear; i >= 2010; i--) { %>
					<option value="<%=i %>"
						<%if(Integer.parseInt(book.getPublishing_date().substring(0, 4)) == i) {%>selected<%} %> ><%=i%></option>
					<% } %>
				</select>
			</div>
			<div class="col-sm-1">
				<select class="form-control" name="publishing_month" onkeydown="nextFocus(publishing_day)">
					<% for(int i = 1; i <= 12; i++) { %>
					<option value="<%=i %>"
						<%if(Integer.parseInt(book.getPublishing_date().substring(5, 7)) == i) {%>selected<%} %> ><%=i%></option>
					<% } %>
				</select>
			</div>
			<div class="col-sm-1">
				<select class="form-control" name="publishing_day" onkeydown="nextFocus(book_image)">
					<% for(int i = 1; i <= 31; i++) { %>
					<option value="<%=i %>"
						<%if(Integer.parseInt(book.getPublishing_date().substring(8)) == i) {%>selected<%} %> ><%=i%></option>
					<% } %>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">이미지명</label>
			<div class="col-sm-4">
				<input type="file" class="form-control" name="book_image" onchange="fileSelect(this)"/>
			</div>
			<div class="col-sm-2">
				<h4><%=book.getBook_image() %></h4>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">내  용</label>
			<div class="col-sm-7">
				<textarea class="form-control col-sm-5" name="book_content" id="book_content" rows="10" cols="100"><%=book.getBook_content()%></textarea>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-sm-2">할인율</label>
			<div class="col-sm-1">
				<input type="text" class="form-control" name="discount_rate" onkeydown="nextFocus(btn_Ok)" size=5 maxlength=2
						value="<%=book.getDiscount_rate()%>">
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2">
				<button type="button" class="btn btn-primary" onclick="bookUpdateCheckForm(this.form)" name="btn_Ok">수정</button>
				<button type="reset"  class="btn btn-warning">다시작성</button>		
			</div>							
		</div>
	</form>

</div>

</body>
	<script src="../../js/jquery-3.5.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script src="../../js/bsfunction.js" type="text/javascript"></script>
	<script>
	function nextFocus(where)
	{
		if(event.keyCode == 13) {
			where.focus();
		}
	}
	function fileSelect(fs) {
		document.getElementById('book_content').focus();
		//document.getElementByName("book_content").focus();
	}
	</script>
</html>

<%
	} catch(Exception e) {
		e.printStackTrace();
	}
}
%>

















