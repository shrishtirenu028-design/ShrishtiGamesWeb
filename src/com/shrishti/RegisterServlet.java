package com.shrishti;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username") == null ? "" : req.getParameter("username").trim();
        String email = req.getParameter("email") == null ? "" : req.getParameter("email").trim();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String confirm = req.getParameter("confirm");

        String error = null;
        if (!username.matches("[A-Za-z0-9_]{3,30}")) error = "Username must be 3-30 letters, digits or underscores.";
        else if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) error = "Enter a valid email address.";
        else if (password.length() < 6) error = "Password must be at least 6 characters.";
        else if (!password.equals(confirm)) error = "Passwords do not match.";

        if (error == null) {
            try (Connection c = DBUtil.getConnection()) {
                try (PreparedStatement ps = c.prepareStatement("SELECT 1 FROM users WHERE username=? OR email=?")) {
                    ps.setString(1, username); ps.setString(2, email);
                    if (ps.executeQuery().next()) error = "That username or email is already registered.";
                }
                if (error == null) {
                    try (PreparedStatement ps = c.prepareStatement(
                            "INSERT INTO users(username,email,password_hash) VALUES(?,?,?)")) {
                        ps.setString(1, username); ps.setString(2, email); ps.setString(3, DBUtil.hash(password));
                        ps.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                error = "Database error: " + e.getMessage();
            }
        }
        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=1");
        }
    }
}
