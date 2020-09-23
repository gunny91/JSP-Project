<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
request.setCharacterEncoding("utf-8");

String	realFolder	= "";	//웹 애플리케이션상의 절대 경로
String	filename	= "";
MultipartRequest imageUp = null;

String	saveFolder	= "/imageFile";	//파일이 업로드되는 폴더를 정한다.
String	encType		= "utf-8";		//인코딩 타입
int		maxSize		= 5*1024*1024;	//최대 업로드될 파일의 최대크기 => 5MB

//현재 jsp페이지의 웹 애플리케이션 상의 절대 경로를 구한다.
ServletContext	context	= getServletContext();
realFolder	= context.getRealPath(saveFolder);

try {
	//전송을 담당할 컴포넌트를 생성하고 파일을 전송한다.
	//전송할 파일명을 가지고 있는 객체, 서버상의 절대 경로, 최대 업로드될 파일 크기, 문자코드, 기본 보안 적용
	imageUp = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
	
	//전송한 파일 정보를 가져와 출력한다.
	Enumeration<?> files = imageUp.getFileNames();
	
	//파일의 정보가 있다면
	while(files.hasMoreElements()) {
		//input 태그의 속성이 file인 태그의 name 속성값 : 파라미터 이름
		String name = (String)files.nextElement();
		//서버에 저장된 파일 이름
		filename = imageUp.getFilesystemName(name);
	}
} catch(Exception e) {
	e.printStackTrace();
}
//ShopBookDataBean book = new ShopBookDataBean(); 아래의 jsp표준액션과 같은 문장이다.
%>
<jsp:useBean id="book" scope="page" class="bookstore.master.BookDTO"></jsp:useBean>

<%
//System.out.println("이미지명:"+filename);
int imageStatus = 0;
if(filename == null || filename.equals("")) {
	imageStatus = 0;	//이미지명의 값이 NULL로 넘어온 경우
} else {
	imageStatus = 1;	//새로운 이미지를 선택하여 이미지명이 들어있는 경우
}
//책 정보 수정에서는 입력과는 달리 어는 책인지를 가리키는 book_id가 필요하다.
int 	book_id			= Integer.parseInt(imageUp.getParameter("book_id"));
String	book_kind		= imageUp.getParameter("book_kind");
String	book_title		= imageUp.getParameter("book_title");
String	book_price		= imageUp.getParameter("book_price");
String	book_count		= imageUp.getParameter("book_count");
String	author			= imageUp.getParameter("author");
String	publishing_com	= imageUp.getParameter("publishing_com");
String	book_content	= imageUp.getParameter("book_content");
String	discount_rate	= imageUp.getParameter("discount_rate");

String	year	= imageUp.getParameter("publishing_year");
//월과 일이 한자리이면 앞에 0을 붙여서 저장한다.
String	month	=
(imageUp.getParameter("publishing_month").length() == 1) 	?
	"0" + imageUp.getParameter("publishing_month") 			:
	imageUp.getParameter("publishing_month");
String	day	=
			(imageUp.getParameter("publishing_day").length() == 1) 	?
				"0" + imageUp.getParameter("publishing_day") 		:
				imageUp.getParameter("publishing_day");
				
				
System.out.println("수정:"+book_count);
book.setBook_kind(book_kind);
book.setBook_title(book_title);
book.setBook_price(Integer.parseInt(book_price));
book.setBook_count(Short.parseShort(book_count));
book.setAuthor(author);

book.setPublishing_com(publishing_com);
book.setPublishing_date(year + "-" + month + "-" + day);
book.setBook_image(filename);
book.setBook_content(book_content);
book.setDiscount_rate(Byte.parseByte(discount_rate));
book.setReg_date(new Timestamp(System.currentTimeMillis()));

//DB와 연결을 한 후에 입력한 데이터를 넘겨주어 처리하게 한다.
BookStoreDAO bookStoreDAO = BookStoreDAO.getInstance();
//이미지값이 있는지 없는지를 알려주기 위해서 imageStatus를 같이 넘겨준다.
bookStoreDAO.updateBook(book, book_id, imageStatus); 

//다음 페이지로 이동을 한다.
//out.println("<h1>책을 등록하였습니다.</h1>");

//도서 목록 리스트 화면으로 이동한다.
response.sendRedirect("bookList.jsp?book_kind="+book_kind);
%>

























