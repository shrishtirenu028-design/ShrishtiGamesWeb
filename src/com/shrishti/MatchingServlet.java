package com.shrishti;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * 4x4 board. Pick two cells: they clear if the numbers are equal or add up to 10.
 * Session keys: mmBoard (int[16], 0 = cleared), mmSel (-1 = none), mmMoves, mmMsg.
 */
@WebServlet("/matching")
public class MatchingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession();
        if (s.getAttribute("mmBoard") == null || "1".equals(req.getParameter("new"))) newGame(s);
        req.getRequestDispatcher("/matching.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession();
        int[] board = (int[]) s.getAttribute("mmBoard");
        if (board == null) { newGame(s); board = (int[]) s.getAttribute("mmBoard"); }
        int sel = (Integer) s.getAttribute("mmSel");
        s.removeAttribute("mmMsg");
        try {
            int pick = Integer.parseInt(req.getParameter("pick"));
            if (pick >= 0 && pick < 16 && board[pick] != 0) {
                if (sel == -1) {
                    s.setAttribute("mmSel", pick);
                } else if (sel == pick) {
                    s.setAttribute("mmSel", -1);               // click again to deselect
                } else {
                    s.setAttribute("mmMoves", (Integer) s.getAttribute("mmMoves") + 1);
                    int a = board[sel], b = board[pick];
                    if (a == b || a + b == 10) {
                        board[sel] = 0; board[pick] = 0;
                        s.setAttribute("mmMsg", "Match! " + a + " and " + b);
                    } else {
                        s.setAttribute("mmMsg", a + " and " + b + " don't match. Equal or sum to 10 only.");
                    }
                    s.setAttribute("mmSel", -1);
                }
            }
        } catch (NumberFormatException ignored) { }
        resp.sendRedirect(req.getContextPath() + "/matching");
    }

    private void newGame(HttpSession s) {
        Random r = new Random();
        List<Integer> cells = new ArrayList<>();
        for (int i = 0; i < 8; i++) {                 // 8 pairs, each equal or summing to 10
            int a = 1 + r.nextInt(9);
            int b = r.nextBoolean() ? a : 10 - a;
            cells.add(a); cells.add(b);
        }
        Collections.shuffle(cells);
        int[] board = new int[16];
        for (int i = 0; i < 16; i++) board[i] = cells.get(i);
        s.setAttribute("mmBoard", board);
        s.setAttribute("mmSel", -1);
        s.setAttribute("mmMoves", 0);
        s.removeAttribute("mmMsg");
    }
}
