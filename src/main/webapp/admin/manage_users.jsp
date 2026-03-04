ke unwanted things <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.AccountDAO" %>
<%@ page import="oceanview.model.SysAccount" %>
<%@ page import="java.util.List" %>
<%
    // ── RBAC Guard ──────────────────────────────────────────────
    if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    AccountDAO dao = new AccountDAO();
    List<SysAccount> users = dao.getAllAccountsForAdmin();
    String loggedIn = (String) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management | OceanView Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body>

<!-- ══════════════════════════════════════════════
     SIDEBAR
══════════════════════════════════════════════ -->
<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
        <span>OceanView Admin</span>
    </div>
    <div class="sidebar-role">Administrator</div>
    <nav class="sidebar-nav">
        <a href="dashboard.jsp"    class="nav-link">        <span class="nav-icon">📊</span> Executive Dashboard</a>
        <a href="manage_users.jsp" class="nav-link active"><span class="nav-icon">👥</span> Manage Staff Access</a>
        <a href="admin_ledger.jsp" class="nav-link">        <span class="nav-icon">📋</span> Global Financial Ledger</a>
        <a href="help.jsp"         class="nav-link">        <span class="nav-icon">📖</span> Administrator Guide</a>
        <div class="sidebar-divider"></div>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Secure Logout
        </a>
    </div>
</aside>

<!-- ══════════════════════════════════════════════
     MAIN CONTENT
══════════════════════════════════════════════ -->
<main class="admin-main">

    <!-- Page Title -->
    <div class="exec-header">
        <div>
            <h1>System Access Control</h1>
            <p>Viewing as <strong style="color:white;"><%= loggedIn %></strong>. Manage all registered system accounts and role assignments.</p>
        </div>
        <div class="status-badge">
            <div class="status-dot"></div>
            <span><%= users.size() %> Accounts Active</span>
        </div>
    </div>

    <!-- Summary Row -->
    <div class="summary-row no-print">
        <span>Total accounts: <strong><%= users.size() %></strong></span>
        <%
            long adminCount = users.stream().filter(u -> "ADMIN".equals(u.getAccessLevel())).count();
            long staffCount = users.stream().filter(u -> "STAFF".equals(u.getAccessLevel())).count();
        %>
        <span>Admins: <strong><%= adminCount %></strong></span>
        <span>Staff: <strong><%= staffCount %></strong></span>
        <span style="margin-left:auto; color: var(--admin-muted); font-size:0.8rem;">
            🔒 Passwords are stored as salted SHA-256 hashes — never plaintext.
        </span>
    </div>

    <!-- User Table -->
    <div class="card">
        <div class="card-header">
            <div>
                <div class="card-title">Registered System Accounts</div>
                <div class="card-subtitle">All accounts with their assigned access level and creation date</div>
            </div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Account ID</th>
                        <th>Username</th>
                        <th>Access Role</th>
                        <th>Security</th>
                        <th>Created At</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding: 2rem; color: var(--admin-muted);">
                            No accounts found in the system.
                        </td>
                    </tr>
                    <% } else {
                        int rowNum = 0;
                        for (SysAccount u : users) {
                            rowNum++;
                            boolean isCurrentUser = u.getLoginName().equals(loggedIn);
                    %>
                    <tr>
                        <td style="color: var(--admin-muted); font-size: 0.82rem;"><%= rowNum %></td>
                        <td><strong style="color: var(--admin-muted);">#<%= u.getAccountId() %></strong></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:32px; height:32px; border-radius:50%; background: <%= "ADMIN".equals(u.getAccessLevel()) ? "#fee2e2" : "#dcfce7" %>; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.85rem; color: <%= "ADMIN".equals(u.getAccessLevel()) ? "#991b1b" : "#166534" %>;">
                                    <%= u.getLoginName().substring(0,1).toUpperCase() %>
                                </div>
                                <span style="font-weight:600;"><%= u.getLoginName() %></span>
                                <% if (isCurrentUser) { %>
                                    <span class="badge badge-info">You</span>
                                <% } %>
                            </div>
                        </td>
                        <td>
                            <span class="badge <%= "ADMIN".equals(u.getAccessLevel()) ? "badge-admin" : "badge-staff" %>">
                                <%= u.getAccessLevel() %>
                            </span>
                        </td>
                        <td>
                            <span style="font-size:0.82rem; color: var(--admin-muted);">
                                🔐 SHA-256 + Salt
                            </span>
                        </td>
                        <td style="color: var(--admin-muted); font-size: 0.85rem;">
                            <%= u.getSecureSalt() %>
                        </td>
                        <td>
                            <% if (isCurrentUser) { %>
                                <span style="font-size:0.8rem; color:var(--admin-muted);">Current Session</span>
                            <% } else { %>
                                <button class="btn btn-sm btn-outline" onclick="alert('Access revocation requires direct DB administration for security reasons.\n\nThis prevents accidental lockout.')">
                                    Revoke Access
                                </button>
                            <% } %>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Security Notice -->
    <div class="alert alert-info no-print">
        🔐 <strong>Security Architecture:</strong>
        All passwords are stored using SHA-256 cryptographic hashing with unique per-account salts.
        No plaintext passwords are ever stored or transmitted. Account creation is handled
        through the <code>SecuritySetupTool.java</code> class to ensure proper hash generation.
    </div>

</main>
</body>
</html>

