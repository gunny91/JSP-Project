<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
request.setCharacterEncoding("utf-8");

String	realFolder	= "";	//웹 어플리케이션 상의 절대경로
String	filename	= "";	//파일이름을 저장할 변수
MultipartRequest imageUp = null;

String	saveFolder	= "/imageFile";	//파일이 업로드되는 폴더
String	encType		= "utf-8";		//인코딩 타입
int		maxSize		= 5*1024*1024;	//업로드될 파일의 최대크기 => 5MB

//현재 jsp페이지의 웹 어플리케이션 상의 절대 경로를 구한다.
ServletContext	context = getServletContext();
realFolder = context.getRealPath(saveFolder);

try {
	//전송을 담당할 컴포넌트를 생성하고 파일을 전송한다.
	//전송할 파일명을 가지고 있는 객체, 서버상의 절대경로, 업로드될 파일의 최대크기, 문자코드,
	//기본 보안 적용
	imageUp = new MultipartRequest(request, realFolder, maxSize, encType,
			new DefaultFileRenamePolicy());
	
	//전송한 파일의 정보를 가져온다.
	Enumeration<?> files = imageUp.getFileNames();
	
	//파일의 정보가 있다면
	while(files.hasMoreElements()) {
		//input 태그의 속성이 file인 태그의 name속성값 : 파라미터 이름
		String name = (String)files.nextElement();
		//서버에 저장된 파일 이름
		filename = imageUp.getFilesystemName(name);
	}
} catch(Exception e) {
	e.printStackTrace();
}

//BookDTO book = new BookDTO(); 아래의 jsp표준액션과 같은 문장이다.
%>
<jsp:useBean id="book" scope="page" class="bookstore.master.BookDTO"></jsp:useBean>
<%
//이미지명의 값이 null인 것을 처리하기 위해 추가한다.
int imageStatus = 0;
if(filename == null || filename.equals("")) {
	imageStatus = 0; //이미지명의 값이 null로 넘어온 경우
} else {
	imageStatus = 1; //이미지명의 값이 들어있는 경우
}

String	book_kind		= imageUp.getParameter("book_kind");
String	book_title		= imageUp.getParameter("book_title");
String	book_price		= imageUp.getParameter("book_price");
String	book_count		= imageUp.getParameter("book_count");
String	author			= imageUp.getParameter("author");
String	publishing_com	= imageUp.getParameter("publishing_com");
String	book_content	= imageUp.getParameter("book_content");
String	discount_rate	= imageUp.getParameter("discount_rate");

String	year			= imageUp.getParameter("publishing_year");
//월 과 일이 한자리이면 앞에 0을 붙여서 2자리로 만든다.
String month = (imageUp.getParameter("publishing_month").length() == 1) ?
		"0" + imageUp.getParameter("publishing_month")				    :
			imageUp.getParameter("publishing_month");
String day = (imageUp.getParameter("publishing_day").length() == 1) ?
		"0" + imageUp.getParameter("publishing_day")				:
			imageUp.getParameter("publishing_day");

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
						
//이미지값이 있는지 없는지를 알려주기 위해서 imageStatus값을 같이 넘겨준다.
int result = bookStoreDAO.insertBook(book, imageStatus);

if(result == -1) { //책의 정보를 등록하는 중에 문제가 생긴 경우
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('책등록을 하지 못하였습니다.\\n잠시 후에 다시 시도해 주십시오.')");
	pw.println("history.back()");
	pw.println("</script>");
} else { //책의 정보 등록이 완료된 경우
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('책등록을 완료하였습니다.')");
	pw.println("location.href='bookList.jsp?book_kind="+book_kind+"'");
	pw.println("</script>");
	//response.sendRedirect("bookList.jsp?book_kind="+book_kind);
}
%>









