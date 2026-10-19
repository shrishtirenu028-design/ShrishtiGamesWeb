<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>ShrishtiGames</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head><body>
<%
  if (session.getAttribute("username") != null) { response.sendRedirect("home.jsp"); return; }
%>
<%@ include file="nav.jspf" %>
<div class="wrap center">
  <h1 style="font-size:3rem">ShrishtiGames</h1>
  <p>Three quick brain games: Hangman, Word Guess and Matching Numbers.</p>
  <a class="btn" href="login.jsp">Log in</a> <a class="btn alt" href="register.jsp">Create account</a>
</div></body></html>
