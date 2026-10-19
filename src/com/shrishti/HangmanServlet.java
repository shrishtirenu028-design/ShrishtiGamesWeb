package com.shrishti;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Random;

/** Game state lives in the HttpSession: hmWord, hmGuessed, hmWrong. */
@WebServlet("/hangman")
public class HangmanServlet extends HttpServlet {
    static final String[] WORDS = {"JAVA", "SERVLET", "SESSION", "TOMCAT", "DATABASE", "BROWSER", "KEYBOARD",
            "PROGRAM", "NETWORK", "COMPUTER", "VARIABLE", "FUNCTION", "INTERFACE", "PACKAGE", "THREAD", "COMPILER"};

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession();
        if (s.getAttribute("hmWord") == null || "1".equals(req.getParameter("new"))) {
            s.setAttribute("hmWord", WORDS[new Random().nextInt(WORDS.length)]);
            s.setAttribute("hmGuessed", "");
            s.setAttribute("hmWrong", 0);
        }
        req.getRequestDispatcher("/hangman.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession();
        String word = (String) s.getAttribute("hmWord");
        String letter = req.getParameter("letter");
        if (word != null && letter != null && letter.matches("[A-Za-z]")) {
            letter = letter.toUpperCase();
            String guessed = (String) s.getAttribute("hmGuessed");
            int wrong = (Integer) s.getAttribute("hmWrong");
            boolean won = word.chars().allMatch(ch -> guessed.indexOf(ch) >= 0);
            if (!won && wrong < 6 && !guessed.contains(letter)) {
                s.setAttribute("hmGuessed", guessed + letter);
                if (!word.contains(letter)) s.setAttribute("hmWrong", wrong + 1);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/hangman");
    }
}
