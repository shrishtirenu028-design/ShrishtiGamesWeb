<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Register - ShrishtiGames</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head><body>
<%@ include file="nav.jspf" %>
<div class="wrap narrow"><div class="card">
  <h2>Create account</h2>
  <% if (request.getAttribute("error") != null) { %><div class="msg err"><%= request.getAttribute("error").toString().replace("<","&lt;") %></div><% } %>
  <form method="post" action="register">
    <label for="u">Username</label>
    <input type="text" id="u" name="username" value="<%= request.getAttribute("username") == null ? "" : request.getAttribute("username").toString().replace("\"","&quot;").replace("<","&lt;") %>" required>
    <label for="e">Email</label>
    <input type="email" id="e" name="email" value="<%= request.getAttribute("email") == null ? "" : request.getAttribute("email").toString().replace("\"","&quot;").replace("<","&lt;") %>" required>
    <label for="p">Password (6+ characters)</label>
    <input type="password" id="p" name="password" minlength="6" required>
    <label for="c">Confirm password</label>
    <input type="password" id="c" name="confirm" required>
    <button class="btn full" type="submit">Register</button>
  </form>
  <p>Already registered? <a href="login.jsp">Log in</a></p>
</div></div></body></html>
