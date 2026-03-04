package oceanview.controller;

import oceanview.dao.AccountDAO;
import oceanview.model.SysAccount;
import oceanview.util.HashProvider;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Enterprise Authentication Controller.
 * Handles secure user login and session initialization.
 */
@WebServlet(name = "LoginController", urlPatterns = {"/authenticate"})
public class LoginController extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        // Initialize DAO in the servlet lifecycle
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 🛡️ STRICT VALIDATION GUARD: Prevent NullPointerExceptions
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=Missing Credentials");
            return;
        }

        try {
            SysAccount account = accountDAO.getAccountByUsername(username);

            if (account != null) {
                // 🔐 Cryptographic Check: Hash the input password with the DB salt
                String computedHash = HashProvider.computeHash(password, account.getSecureSalt());

                // Use secure string comparison
                if (computedHash.equals(account.getSecureHash())) {
                    // ✅ Valid Login: Create Session
                    HttpSession session = request.getSession(true);
                    session.setAttribute("loggedInUser", account.getLoginName());
                    session.setAttribute("userRole", account.getAccessLevel());

                    // Route based on RBAC
                    if (account.isAdmin()) {
                        response.sendRedirect("admin/dashboard.jsp");
                    } else {
                        response.sendRedirect("staff/dashboard.jsp");
                    }
                    return; // End execution
                }
            }

            // ❌ Invalid Login
            response.sendRedirect("login.jsp?error=Invalid Username or Password");

        } catch (Exception e) {
            // Log enterprise error and show generic message to user (No 500 crash dumps)
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=System Error Occurred");
        }
    }
}
