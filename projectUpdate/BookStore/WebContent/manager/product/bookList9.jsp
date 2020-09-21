<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BookDTO" %>
<%@ page import="bookstore.master.BscodeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%! SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분"); %>
<%
//세션의 값을 가져온다. 
String managerId = "";
managerId = (String)session.getAttribute("managerId");

//세션 값이 없으면 로그인 페이지로 이동시킨다.
if(managerId == null || managerId.equals("")) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('로그인을 하셔야 합니다.')");
	pw.println("location.href='logon/managerLoginForm.jsp?useSSl=false'");
	pw.println("</script>");
}

//화면에 보여줄 정보를 담을 저장소
List<BookDTO> bookList = null;
String book_kind = "";
//이 페이지로 들어올 때 가지고 온 책의 종류를 알아낸다.
book_kind = request.getParameter("book_kind");

//도서타입에 대한 데이터를 가져온다.
List<BscodeDTO> bookTypes = null;
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
bookTypes = bookStoreDAO.getBookTypes();

BscodeDTO bookType = null;

//한 페이지에서 보여줄 게시글의 개수를 정의한다.
final int NUM_OF_PAGE = 3;

//현재 페이지의 값을 저장할 변수. 페이지 값이 없는 경우는 기본 1로 한다.
int pageNumber = 1;

//다른 페이지에서 페이지 값을 가지고 오는 경우는 넘겨받은 값으로 지정한다.
//웹에서 넘어오는 모든 데이터는 자동 문자열로 처리되기 때문에 다른 타입으로 사용하려면
//형변환 처리를 해주어야 한다.
if(request.getParameter("pageNumber") != null) {
	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
}

//int startRow = pageNumber * NUM_OF_PAGE -(NUM_OF_PAGE-1);
int startRow = (pageNumber-1) * NUM_OF_PAGE + 1;//전 페이지의 마지막 줄 + 1
int endRow   = pageNumber * NUM_OF_PAGE;//현재 페이지의 마지막 줄
int totalCount = 0; //화면에 보여줄 전체 데이터 건수
int number   = 0; //현재 화면에 보이는 게시글의 일련번호

//화면에 보여줄 데이터의 건수를 알아본다.
totalCount = bookStoreDAO.getBookCount(book_kind);

//보여줄 데이터가 있으면 책 종류에 해당하는 모든 책의 정보를 가져온다.
if(totalCount > 0) {
	bookList = bookStoreDAO.getBooks(book_kind, startRow, NUM_OF_PAGE);
}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>도서 목록</title>
</head>
<body>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<h3 align="center"><span class="label label-primary">책 목록</span></h3>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<h4 align="center"><span class="label label-info"><%=totalCount %>권</span></h4>
		</div>
	</div>
	<table class="table">
		<tr>
			<td>
				<div class="btn-group">
					<button type="button" class="btn btn-default dropdown=toggle"
						data-toggle="dropdown" aria-expanded="false">
						도서종류<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="bookList.jsp?book_kind=all">전체목록보기</a></li>
						<%for(int i = 0; i < bookTypes.size(); i++) {
							bookType = (BscodeDTO)bookTypes.get(i); %>
						<li><a href="bookList.jsp?book_kind=<%=bookType.getId()%>"><%=bookType.getName()%></a></li>
						<% } %>
					</ul>
				</div>
			</td>
			<td align=right>
				<h5>
					<a href="bookRegisterForm.jsp" class="btn btn-primary">책 등록</a>
					<a href="../managerMain.jsp"   class="btn btn-info">메인메뉴</a>
				</h5>
			</td>
		</tr>
	</table>

<% //검색된 책이 하나도 없다면
if(totalCount < 1) {
	out.println("<table class='table table-bordered'>");
	out.println("<tr>");
	out.println("<td align=center><h2>등록된 책이 없습니다.</h2></td>");
	out.println("</tr>");
	out.println("</table>");
} else {
%>
	<table class="table table-bordered table-striped table-hover">
		<tr class="info">
			<td align=center width=20>번호</td>
			<td align=center width=34>책분류</td>
			<td align=center width=99>제목</td>
			<td align=center width=40>가격</td>
			<td align=center width=30>수량</td>
			
			<td align=center width=70>저자</td>
			<td align=center width=70>출판사</td>
			<td align=center width=50>출판일</td>
			<td align=center width=50>책이미지</td>
			<td align=center width=24>할인율</td>
			
			<td align=center width=100>등록일</td>
			<td align=center width=50>수정</td>
			<td align=center width=50>삭제</td>
		</tr>
		<% //검색된 데이터 건수만큼만 화면에 보여준다.
		int pageNo = 0;
		pageNo = (pageNumber -1) * NUM_OF_PAGE;
		for(int i = 0; i < bookList.size(); i++) 
		{
			BookDTO book = (BookDTO)bookList.get(i);
		%>
		<tr>
			<td align=right><%=++pageNo %></td>
			<td align=center><%=book.getBook_kind() %></td>
			<td align=left><%=book.getBook_title() %></td>
			<td align=right><%=NumberFormat.getInstance().format(book.getBook_price()) %>원</td>
			<%if(book.getBook_count() < 1) { %>
			<td align=center><font color=red>일시품절</font></td>
			<% } else { %>
			<td align=right><%=NumberFormat.getInstance().format(book.getBook_count()) %>권</td>
			<% } %>
			<td><%=book.getAuthor() %></td>
			<td><%=book.getPublishing_com() %></td>
			<td><%=book.getPublishing_date() %></td>
			<td><%=book.getBook_image() %>
			<td align=right><%=book.getDiscount_rate() %></td>
			<td><%=sdf.format(book.getReg_date()) %></td>
			<td align=center>
				<a href="bookUpdateForm.jsp?book_id=
				<%=book.getBook_id()%>&book_kind=<%=book.getBook_kind()%>">수정</a>
			</td>
			<td align=center>
				<a href="bookDeleteForm.jsp?book_id=
				<%=book.getBook_id()%>&book_kind=<%=book.getBook_kind()%>">삭제</a>
			</td>
		</tr>
		<% } // End - for %>
	</table>
	
	<h6 align=center>
	<%
	if(totalCount > 0) {
		//pageCount : 보여져야할 페이지의 수
		//보여줄 페이지는 종류에 따른 전체 게시글 수를 나누어 나머지가 생기면 1page를 추가한다.
		//짜투리 게시글은 1페이지를 별도로 한다.
		int pageCount = totalCount / NUM_OF_PAGE 
				+ (totalCount % NUM_OF_PAGE == 0 ? 0 : 1);
	
		//화면 하단에 보여지는 페이지의 개수
		int pageBlock = 3; 
		//선택한 페이지번호가 pageBlock내에 있으면 startPage를 하단에 보여줄 번호의 맨 앞번호로 한다.
		//현재페이지가 5, 페이지블럭이 3이라면 하단에는 [4][5][6]을 보여준다.
		//??? pageNumber 가 1인 경우 0 나누기 3 문제??????
		int startPage = (int)((pageNumber-1)/NUM_OF_PAGE)*pageBlock+1;
		int endPage   = startPage + pageBlock - 1;
		
		//계산한 endPage가 실제 가지고 있는 페이지 수보다 많으면 가장 마지막 페이지의 값을 endPage로 한다.
		if(endPage > pageCount) endPage = pageCount;
		
		
		//하단에 페이지 번호를 보여준다.
		for(int num = startPage; num <= endPage; num++) { %>
			<a href="bookList.jsp?
			pageNumber=<%=num%>&book_kind=<%=book_kind%>">[<%=num%>]</a>
		<%}
		
	}
	%>
	</h6>
	

<% } %>
</div>
	<script src="../../js/jquery-3.5.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>













