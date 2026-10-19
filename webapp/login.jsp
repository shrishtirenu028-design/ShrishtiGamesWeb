<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Log in - ShrishtiGames</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head><body>
<%
  if (session.getAttribute("username") != null) { response.sendRedirect("home.jsp"); return; }
%>
<%@ include file="nav.jspf" %>
<div class="wrap narrow"><div class="card">
  <h2>Log in</h2>
  <% if ("1".equals(request.getParameter("registered"))) { %><div class="msg ok">Account created. Log in to play.</div><% } %>
  <% if ("1".equals(request.getParameter("loggedout"))) { %><div class="msg info">You have been logged out.</div><% } %>
  <% if (request.getAttribute("error") != null) { %><div class="msg err"><%= request.getAttribute("error").toString().replace("<","&lt;") %></div><% } %>
  <form method="post" action="login">
    <label for="u">Username</label>
    <input type="text" id="u" name="username" value="<%= request.getAttribute("username") == null ? "" : request.getAttribute("username").toString().replace("\"","&quot;").replace("<","&lt;") %>" required>
    <label for="p">Password</label>
    <input type="password" id="p" name="password" required>
    <button class="btn full" type="submit">Log in</button>
  </form>
  <p>New here? <a href="register.jsp">Create an account</a></p>
</div></div></body></html>
