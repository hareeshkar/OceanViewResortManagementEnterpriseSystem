package oceanview.controller;

import oceanview.dao.AccountDAO;
import oceanview.util.HashProvider;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

/**
 * Servlet for handling user management operations (create / delete accounts).
 * Only accessible to ADMIN users.
 */
@WebServlet("/admin/deleteUser")
public class UserManagementController extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String accountIdStr = request.getParameter("accountId");
            try {
                int accountId = Integer.parseInt(accountIdStr);
                boolean deleted = accountDAO.deleteAccount(accountId);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?message=Account+deleted+successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?error=Failed+to+delete+account");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?error=Invalid+account+ID");
            }

        } else if ("create".equals(action)) {
            String loginName  = request.getParameter("loginName");
            String password   = request.getParameter("password");
            String accessLevel = request.getParameter("accessLevel");

            // Basic validation
            if (loginName == null || loginName.trim().isEmpty()
                    || password == null || password.length() < 6
                    || accessLevel == null || (!accessLevel.equals("STAFF") && !accessLevel.equals("ADMIN"))) {
                response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?error=Invalid+input.+Username+required+and+password+must+be+6%2B+characters.");
                return;
            }

            // Generate a unique salt and hash the password
            String salt = UUID.randomUUID().toString().replace("-", "").substring(0, 16).toUpperCase();
            String hash = HashProvider.computeHash(password, salt);

            boolean created = accountDAO.createAccount(loginName.trim(), hash, salt, accessLevel);
            if (created) {
                response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?message=Account+%22" + loginName.trim() + "%22+created+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp?error=Username+already+exists.+Choose+a+different+name.");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage_users.jsp");
        }
    }
}
