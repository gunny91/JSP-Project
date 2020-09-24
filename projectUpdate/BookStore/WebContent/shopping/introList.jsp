<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="bookstore.master.BookDTO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
String	realFolder	= "";	//웹 애플리케이션상의 절대 경로
/*
String	filename	= "";
MultipartRequest imageUp = null;

String	saveFolder	= "/imageFile";	//파일이 업로드되는 폴더를 정한다.
String	encType		= "utf-8";		//인코딩 타입
int		maxSize		= 5*1024*1024;	//최대 업로드될 파일의 최대크기 => 5MB

//현재 jsp페이지의 웹 애플리케이션 상의 절대 경로를 구한다.
ServletContext	context	= getServletContext();
realFolder	= context.getRealPath(saveFolder);
*/
// ** 조심 : 경로명은 대소문자를 구분한다. **
realFolder = "http://localhost:8094/BookShop/imageFile";

//도서의 종류별로 신간서적을 최대 3권까지 화면에 보여주자!!!
%>

<br><br><br>
<h2 align=center>신간소개</h2><hr>
<%
BookDTO bookLists[] = null;
bookLists = new BookDTO[3];
int number = 0;
String book_kindName = "";

BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();

//책 종류(book_kind)는 100,200,300으로 저장되어있으므로 for문을 이용해서 100,200,300에 대한 책자료를 가져온다.
for(int i = 1; i <= 3; i++)
{
	//bookLists = (BookDTO)bookStoreDAO.getBooks(i+"00", 3);
	
	//책 종류에 따른 데이터가 없으면 건너 뛴다.
	if(bookLists == null) {
		//없는 값(NULL)을 디스플레이하려고 하면 이곳에서 프로그램이 멈춘다.
		continue;
	}
	//책 종류의 값인 100,200,300이 무엇을 말하는지 이해하기 어려우므로, 이 값을 문학,외국어,영어로 사용한다.
	if     (bookLists[0].getBook_kind().equals("100"))	book_kindName = "문학";
	else if(bookLists[0].getBook_kind().equals("200"))	book_kindName = "외국어";
	else if(bookLists[0].getBook_kind().equals("300"))	book_kindName = "컴퓨터";

%>
	<br>
	<table class="table table-bordered table-striped nanum table-hover">
		<tr class=info height=30>
			<td width=550>
				<font size="+1">
					<b><%=book_kindName%> 분류의 신간목록:
						<a href="list.jsp?book_kind=<%=bookLists[0].getBook_kind()%>">더보기</a>
					</b>
				</font>
			</td>
		</tr>
	</table>
	<%
	int bookCount = bookStoreDAO.getBookCount(bookLists[0].getBook_kind());
	if(bookCount >= 3) bookCount = 3;
	
	for(int j = 0; j < bookCount; j++) {	//책 종류별로 최대 3번까지 반복한다.
	%>
	<table class="table table-bordered table-striped nanum table-hover">
		<tr height=30>
			<td rowspan="4" width="100">
				<a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>&book_kind=<%=bookLists[j].getBook_kind()%>">
				<img src="<%=realFolder%>/<%=bookLists[j].getBook_image()%>" border="0" width="60" height="90"></a>
			</td>
			<td width=350>
				<font size="+1">
					<b><a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>&book_kind=<%=bookLists[j].getBook_kind()%>">
						<%=bookLists[j].getBook_title()%></a></b>
				</font>
			</td>
			<td rowspan="4" width="100">
				<%if(bookLists[j].getBook_count() <= 0) { %>
					<h4 align=center><b><font color="red">일시품절</font></b></h4>
				<% } else { %>
					<h4 align=center><b><font color="blue">구매가능</font></b></h4>
				<% } %>
			</td>
		</tr>
		<tr>
			<td>출판사 : <%=bookLists[j].getPublishing_com() %></td>
		</tr>
		<tr>
			<td>저  자 : <%=bookLists[j].getAuthor() %></td>
		</tr>
		<tr>
			<td>정  가 : <%=NumberFormat.getInstance().format(bookLists[j].getBook_price())%>원&nbsp;&nbsp;&nbsp;
				할인율 : <%=bookLists[j].getDiscount_rate()%>%&nbsp;&nbsp;&nbsp;
				<b><font color="red">
				판매가 : <%=NumberFormat.getInstance().format((int)(bookLists[j].getBook_price()*((double)(100-bookLists[j].getDiscount_rate())/100)))%>원
				</font></b>
			</td>
		</tr>
	</table>

<%
	} // End - for
} // End - for
%>




















