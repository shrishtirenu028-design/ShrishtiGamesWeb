<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hangman - ShrishtiGames</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
  String word = (String) session.getAttribute("hmWord");
  if (word == null) { response.sendRedirect("hangman"); return; }
  String guessed = (String) session.getAttribute("hmGuessed");
  int wrong = (Integer) session.getAttribute("hmWrong");
  boolean won = true;
  for (char ch : word.toCharArray()) if (guessed.indexOf(ch) < 0) won = false;
  boolean lost = wrong >= 6;
  boolean over = won || lost;
%>
<%@ include file="nav.jspf" %>
<div class="wrap narrow center" style="max-width:560px">
  <div class="card">
    <h2>Hangman</h2>
    <svg class="hang" viewBox="0 0 200 220" role="img" aria-label="<%= wrong %> of 6 body parts drawn">
      <line class="g" x1="20"  y1="210" x2="130" y2="210"/>
      <line class="g" x1="60"  y1="210" x2="60"  y2="20"/>
      <line class="g" x1="60"  y1="20"  x2="140" y2="20"/>
      <line class="g" x1="140" y1="20"  x2="140" y2="48"/>
      <% if (wrong > 0) { %><circle class="p" cx="140" cy="68" r="20"/><% } %>
      <% if (wrong > 1) { %><line class="p" x1="140" y1="88"  x2="140" y2="148"/><% } %>
      <% if (wrong > 2) { %><line class="p" x1="140" y1="105" x2="112" y2="132"/><% } %>
      <% if (wrong > 3) { %><line class="p" x1="140" y1="105" x2="168" y2="132"/><% } %>
      <% if (wrong > 4) { %><line class="p" x1="140" y1="148" x2="116" y2="186"/><% } %>
      <% if (wrong > 5) { %><line class="p" x1="140" y1="148" x2="164" y2="186"/><% } %>
    </svg>
    <div class="hearts" aria-label="<%= 6 - wrong %> lives left">
      <% for (int i = 0; i < 6; i++) { %><%= i < wrong ? "🖤" : "❤️" %><% } %>
    </div>
    <div class="slots">
      <% for (char ch : word.toCharArray()) {
           boolean known = guessed.indexOf(ch) >= 0; %>
        <span class="slot <%= (!known && lost) ? "miss" : "" %>"><%= (known || lost) ? ch : "" %></span>
      <% } %>
    </div>
    <% if (won)  { %><div class="msg ok">You won! The word was <b><%= word %></b>.</div><% } %>
    <% if (lost) { %><div class="msg err">Game over! The word was <b><%= word %></b>.</div><% } %>
    <form method="post" action="hangman">
      <div class="keys">
        <% for (char ch = 'A'; ch <= 'Z'; ch++) {
             boolean used = guessed.indexOf(ch) >= 0;
             String cls = used ? (word.indexOf(ch) >= 0 ? "hit" : "no") : ""; %>
          <button type="submit" name="letter" value="<%= ch %>" class="<%= cls %>"
                  <%= (over || used) ? "disabled" : "" %>><%= ch %></button>
        <% } %>
      </div>
    </form>
    <p style="margin-top:1.5rem">
      <a class="btn alt" href="hangman?new=1">New word</a>
      <a href="home.jsp" style="margin-left:.8rem">Back to games</a>
    </p>
  </div>
</div>
</body>
</html>
