<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.MemberDAO" %>
<%@ page import="java.sql.Timestamp" %>   
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("utf-8");
String	buyer	= (String)session.getAttribute("id");

String	mode	= request.getParameter("mode");
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");
String	name	= request.getParameter("name");
String	tel		= request.getParameter("tel");
String	address	= request.getParameter("address");
%>

<jsp:useBean id="member" scope="page" class="bookstore.shopping.MemberDTO">
</jsp:useBean>

<%
member.setId(id);
member.setPasswd(passwd);
member.setName(name);
member.setTel(tel);
member.setAddress(address);
member.setReg_date(new Timestamp(System.currentTimeMillis()));

MemberDAO customerProcess = MemberDAO.getInstance();

if(mode.equals("UP")) {
	customerProcess.updateMember(member);
} else if(mode.equals("DEL")) {
	customerProcess.deleteMember(id, passwd);
	//회원탈퇴를 하면 세션을 소멸시킨다.
	session.invalidate();
} else {
	response.sendRedirect("../shopMain.jsp");
}
response.sendRedirect("../shopMain.jsp");
%>


























