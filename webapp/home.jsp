<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Games - ShrishtiGames</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="nav.jspf" %>
<div class="wrap">
  <h1 class="hello">Hi <%= session.getAttribute("username") %>, ready to play?</h1>
  <p>Pick a game below. Your progress is saved while you stay logged in.</p>
  <div class="games">
    <div class="card game hm"><div class="top">🔤</div><div class="body">
      <h3>Hangman</h3>
      <p class="rule">Guess the hidden word one letter at a time. You can make 6 mistakes.</p>
      <a class="btn" href="hangman?new=1">Play Hangman</a></div></div>
    <div class="card game wg"><div class="top">🟩</div><div class="body">
      <h3>Word Guess</h3>
      <p class="rule">Find the 5-letter word in 6 tries. Green means right spot, yellow means wrong spot.</p>
      <a class="btn" href="wordguess?new=1">Play Word Guess</a></div></div>
    <div class="card game mm"><div class="top">🔢</div><div class="body">
      <h3>Matching Numbers</h3>
      <p class="rule">Clear the board by picking two numbers that are equal or add up to 10.</p>
      <a class="btn" href="matching?new=1">Play Matching</a></div></div>
  </div>
</div>
</body>
</html>
