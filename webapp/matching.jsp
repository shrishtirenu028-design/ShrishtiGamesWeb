<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Matching Numbers - ShrishtiGames</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
  int[] board = (int[]) session.getAttribute("mmBoard");
  if (board == null) { response.sendRedirect("matching"); return; }
  int sel   = (Integer) session.getAttribute("mmSel");
  int moves = (Integer) session.getAttribute("mmMoves");
  int left = 0;
  for (int v : board) if (v != 0) left++;
  boolean won = (left == 0);
  int percent = (16 - left) * 100 / 16;
%>
<%@ include file="nav.jspf" %>
<div class="wrap narrow center" style="max-width:520px">
  <div class="card">
    <h2>Matching Numbers</h2>
    <p>Pick two numbers that are <b>equal</b> or <b>add up to 10</b>.</p>
    <p>Moves: <b><%= moves %></b> &nbsp;|&nbsp; Cleared: <b><%= percent %>%</b></p>
    <div class="bar"><span style="width:<%= percent %>%"></span></div>
    <% if (session.getAttribute("mmMsg") != null) { %>
      <div class="msg info"><%= session.getAttribute("mmMsg") %></div>
    <% } %>
    <% if (won) { %><div class="msg ok">Board cleared in <%= moves %> moves. Well done!</div><% } %>
    <form method="post" action="matching">
      <div class="board">
        <% for (int i = 0; i < 16; i++) {
             boolean gone = (board[i] == 0);
             String cls = "cell" + (gone ? " gone" : " n" + board[i]) + (i == sel ? " sel" : ""); %>
          <button type="submit" name="pick" value="<%= i %>" class="<%= cls %>"
                  <%= gone ? "disabled" : "" %>><%= gone ? "" : board[i] %></button>
        <% } %>
      </div>
    </form>
    <p>
      <a class="btn alt" href="matching?new=1">New board</a>
      <a href="home.jsp" style="margin-left:.8rem">Back to games</a>
    </p>
  </div>
</div>
</body>
</html>
