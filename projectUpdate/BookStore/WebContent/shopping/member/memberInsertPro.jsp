<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookstore.shopping.MemberDAO" %>
<%@ page import="bookstore.shopping.MemberDTO" %>
<%@ page import="java.sql.Timestamp" %>

<%
request.setCharacterEncoding("utf-8");
//System.out.println("memberInsertPro.jsp......");


String id		= request.getParameter("id");
String passwd	= request.getParameter("passwd");
String name		= request.getParameter("name");
String tel		= request.getParameter("tel1") + "-" + request.getParameter("tel2")
		+ "-" + request.getParameter("tel3");
String address	= request.getParameter("address");
%>

<jsp:useBean id="member" scope="page"
           class="bookstore.shopping.MemberDTO">
</jsp:useBean>
<%
//MemberDTO membe = new MemberDTO();

member.setId(id);
member.setPasswd(passwd);
member.setName(name);
member.setTel(tel);
member.setAddress(address);
member.setReg_date(new Timestamp(System.currentTimeMillis()));

MemberDAO customerDAO = MemberDAO.getInstance();
customerDAO.insertMember(member);
response.sendRedirect("../shopMain.jsp");
%>
