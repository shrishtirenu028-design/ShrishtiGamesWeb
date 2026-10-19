<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Word Guess - ShrishtiGames</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
  String target = (String) session.getAttribute("wgTarget");
  if (target == null) { response.sendRedirect("wordguess"); return; }
  java.util.List<String> guesses = (java.util.List<String>) session.getAttribute("wgGuesses");
  java.util.List<String> results = (java.util.List<String>) session.getAttribute("wgResults");
  boolean won  = !guesses.isEmpty() && guesses.get(guesses.size() - 1).equals(target);
  boolean lost = !won && guesses.size() >= 6;
  java.util.Map<Character, Character> st = new java.util.HashMap<>();
  for (int i = 0; i < guesses.size(); i++) {
    for (int c = 0; c < 5; c++) {
      char L = guesses.get(i).charAt(c), R = results.get(i).charAt(c);
      Character old = st.get(L);
      if (old == null || R == 'G' || (R == 'Y' && old == 'X')) st.put(L, R);
    }
  }
  String[] kbRows = {"QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"};
%>
<%@ include file="nav.jspf" %>
<div class="wrap narrow center" style="max-width:500px">
  <div class="card">
    <h2>Word Guess</h2>
    <p>Attempt <b><%= Math.min(guesses.size() + ((won || lost) ? 0 : 1), 6) %></b> of 6</p>
    <% for (int r = 0; r < 6; r++) { %>
      <div class="row">
        <% for (int c = 0; c < 5; c++) {
             if (r < guesses.size()) {
               boolean latest = (r == guesses.size() - 1); %>
          <div class="tile <%= results.get(r).charAt(c) %> <%= latest ? "pop" : "" %>"
               style="animation-delay:<%= c * 120 %>ms"><%= guesses.get(r).charAt(c) %></div>
        <%   } else { %><div class="tile"></div><% }
           } %>
      </div>
    <% } %>
    <% if (session.getAttribute("wgMsg") != null) { %>
      <div class="msg err"><%= session.getAttribute("wgMsg") %></div>
    <% } %>
    <% if (won)  { %><div class="msg ok">Brilliant! You got it in <%= guesses.size() %> tries.</div><% } %>
    <% if (lost) { %><div class="msg err">Out of tries. The word was <b><%= target %></b>.</div><% } %>
    <% if (!won && !lost) { %>
      <form method="post" action="wordguess">
        <input class="guess" type="text" name="guess" maxlength="5" minlength="5"
               pattern="[A-Za-z]{5}" autocomplete="off" autofocus required
               placeholder="TYPE" aria-label="Your 5-letter guess">
        <button class="btn full" type="submit">Guess</button>
      </form>
    <% } %>
    <div class="kb">
      <% for (String row : kbRows) { %>
        <div class="krow">
          <% for (char ch : row.toCharArray()) {
               Character s = st.get(ch); %>
            <span class="<%= s == null ? "" : s %>"><%= ch %></span>
          <% } %>
        </div>
      <% } %>
    </div>
    <p class="legend">Green = right spot · Yellow = wrong spot · Grey = not in word</p>
    <p style="margin-top:1rem">
      <a class="btn alt" href="wordguess?new=1">New word</a>
      <a href="home.jsp" style="margin-left:.8rem">Back to games</a>
    </p>
  </div>
</div>
</body>
</html>
