package oceanview.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Enterprise Security Middleware.
 * Enforces session checks, RBAC routing, and prevents back-button cache issues.
 */
@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);
        String userRole = isLoggedIn ? (String) session.getAttribute("userRole") : null;

        // 🛡️ SECURITY RULE: Prevent Back Button Access after Logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // Allow public assets and login actions to bypass the filter
        if (uri.endsWith("login.jsp") || uri.endsWith("/authenticate") ||
            uri.endsWith("/logout") || uri.contains("/css/") ||
            uri.contains("/js/") || uri.endsWith("test.jsp")) {

            // If user is already logged in and tries to go to login.jsp, redirect them to their dashboard
            if (isLoggedIn && uri.endsWith("login.jsp")) {
                if ("ADMIN".equals(userRole)) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard.jsp");
                }
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // 🔒 Check if user is trying to access protected areas without a session
        if (!isLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First");
            return;
        }

        // 🛡️ ROLE-BASED ACCESS CONTROL (RBAC)
        if (uri.contains("/admin/") && !"ADMIN".equals(userRole)) {
            // Staff trying to access Admin pages
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        if (uri.contains("/staff/") && !"STAFF".equals(userRole) && !"ADMIN".equals(userRole)) {
            // Restrict unknown roles from staff pages
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // ✅ Passed all security checks
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
