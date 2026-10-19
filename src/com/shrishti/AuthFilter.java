package com.shrishti;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Blocks every page except the public ones unless a logged-in session exists. */
@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) rq;
        HttpServletResponse resp = (HttpServletResponse) rs;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        boolean isPublic = path.equals("/") || path.equals("/index.jsp") || path.equals("/login.jsp")
                || path.equals("/register.jsp") || path.equals("/login") || path.equals("/register")
                || path.equals("/logout") || path.startsWith("/css/");
        if (isPublic) { chain.doFilter(rq, rs); return; }

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        // stop the browser Back button showing protected pages after logout
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        chain.doFilter(rq, rs);
    }
}
