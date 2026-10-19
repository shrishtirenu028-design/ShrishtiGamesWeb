package com.shrishti;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/** 5-letter word, 6 attempts. Session keys: wgTarget, wgGuesses, wgResults, wgMsg. */
@WebServlet("/wordguess")
public class WordGuessServlet extends HttpServlet {
    static final String[] WORDS = {"APPLE", "BRAIN", "CHAIR", "DREAM", "EARTH", "FLAME", "GRAPE", "HOUSE",
            "IMAGE", "JOKER", "KNIFE", "LEMON", "MANGO", "NIGHT", "OCEAN", "PIANO", "QUEEN", "RIVER",
            "SNAKE", "TIGER", "UNCLE", "VIVID", "WATER", "YOUTH", "ZEBRA", "CLOUD", "SMILE", "PLANT"};

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession();
        if (s.getAttribute("wgTarget") == null || "1".equals(req.getParameter("new"))) {
            s.setAttribute("wgTarget", WORDS[new Random().nextInt(WORDS.length)]);
            s.setAttribute("wgGuesses", new ArrayList<String>());
            s.setAttribute("wgResults", new ArrayList<String>());
            s.removeAttribute("wgMsg");
        }
        req.getRequestDispatcher("/wordguess.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession();
        String target = (String) s.getAttribute("wgTarget");
        List<String> guesses = (List<String>) s.getAttribute("wgGuesses");
        List<String> results = (List<String>) s.getAttribute("wgResults");
        String g = req.getParameter("guess") == null ? "" : req.getParameter("guess").trim().toUpperCase();
        s.removeAttribute("wgMsg");

        boolean over = guesses.size() >= 6 || (!guesses.isEmpty() && guesses.get(guesses.size() - 1).equals(target));
        if (!over) {
            if (!g.matches("[A-Z]{5}")) {
                s.setAttribute("wgMsg", "Enter exactly 5 letters (A-Z).");
            } else {
                guesses.add(g);
                results.add(evaluate(g, target));
            }
        }
        resp.sendRedirect(req.getContextPath() + "/wordguess");
    }

    /** G = right letter, right place; Y = in word, wrong place; X = not in word. */
    static String evaluate(String guess, String target) {
        char[] r = {'X', 'X', 'X', 'X', 'X'};
        int[] left = new int[26];
        for (int i = 0; i < 5; i++) {
            if (guess.charAt(i) == target.charAt(i)) r[i] = 'G';
            else left[target.charAt(i) - 'A']++;
        }
        for (int i = 0; i < 5; i++) {
            if (r[i] == 'G') continue;
            int k = guess.charAt(i) - 'A';
            if (left[k] > 0) { r[i] = 'Y'; left[k]--; }
        }
        return new String(r);
    }
}
