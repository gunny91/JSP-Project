<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.*"%>

<%
	session.invalidate();
	PrintWriter pw = response.getWriter();
	
	pw.println("<script>");
	pw.println("alert('Logged out!')");
	pw.println("location.href='../managerMain.jsp'");
	pw.println("</script>");

%>