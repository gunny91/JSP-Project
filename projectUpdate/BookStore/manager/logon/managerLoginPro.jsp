<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bookstore.master.BookStoreDAO" %>
<%
	request.setCharacterEncoding("utf-8");

//전 페이지로 부터 아이디와 비밀번호를 가져온다.
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");

BookStoreDAO manager = BookStoreDAO.getInstance();
int check = manager.managerCheck(id, passwd);

PrintWriter pw = response.getWriter();
//의뢰한 결과에 따른 처리를 다르게 한다.
if(check == 1) {
	//정상적으로 로그인이 검증되면 세션을 발급한다.
	session.setAttribute("managerId", id);
	response.sendRedirect("../managerMain.jsp");
} else if(check == 0) {
	pw.println("<script>");
	pw.println("alert('비밀번호가 맞지 않습니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
} else {
	pw.println("<script>");
	pw.println("alert('아이디가 존재하지 않습니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
}
%>













