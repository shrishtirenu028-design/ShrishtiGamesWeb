package com.shrishti;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username") == null ? "" : req.getParameter("username").trim();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String error = null;
        int userId = -1;

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT id FROM users WHERE username=? AND password_hash=?")) {
            ps.setString(1, username);
            ps.setString(2, DBUtil.hash(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) userId = rs.getInt(1);
            else error = "Invalid username or password.";
        } catch (SQLException e) {
            error = "Database error: " + e.getMessage();
        }

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("username", username);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        // Drop any old session (prevents session fixation) and start a fresh one
        HttpSession old = req.getSession(false);
        if (old != null) old.invalidate();
        HttpSession session = req.getSession(true);
        session.setAttribute("userId", userId);
        session.setAttribute("username", username);
        session.setMaxInactiveInterval(30 * 60);
        resp.sendRedirect(req.getContextPath() + "/home.jsp");
    }
}
