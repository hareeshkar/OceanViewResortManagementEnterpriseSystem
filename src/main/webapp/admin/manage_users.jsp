<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.AccountDAO" %>
<%@ page import="oceanview.model.SysAccount" %>
<%@ page import="java.util.List" %>
<%
if (!"ADMIN".equals(session.getAttribute("userRole"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
AccountDAO dao = new AccountDAO();
List<SysAccount> users = dao.getAllAccountsForAdmin();
String loggedIn = (String) session.getAttribute("loggedInUser");
String pageMessage = request.getParameter("message");
String pageError   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Access | OceanView Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        /* ── Modal ── */
        .modal-backdrop {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(6px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal-backdrop.open { display: flex; }
        .modal {
            background: #14171b;
            border: 1px solid rgba(203,168,106,0.2);
            border-radius: 16px;
            padding: 36px 40px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 24px 80px rgba(0,0,0,0.6);
            animation: modalIn 0.4s cubic-bezier(0.19,1,0.22,1) forwards;
        }
        @keyframes modalIn {
            from { opacity:0; transform: translateY(24px) scale(0.97); }
            to   { opacity:1; transform: translateY(0) scale(1); }
        }
        .modal-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.5rem;
            font-weight: 400;
            color: #f4f0e6;
            margin-bottom: 6px;
        }
        .modal-subtitle {
            font-size: 0.8rem;
            color: var(--admin-muted);
            margin-bottom: 28px;
        }
        .form-field { margin-bottom: 18px; }
        .form-field label {
            display: block;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--admin-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 7px;
        }
        .form-field input,
        .form-field select {
            width: 100%;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.9rem;
            color: #f4f0e6;
            font-family: var(--font-ui, 'Outfit', sans-serif);
            outline: none;
            transition: border-color 0.3s;
        }
        .form-field input:focus,
        .form-field select:focus {
            border-color: rgba(203,168,106,0.5);
        }
        .form-field select option { background: #14171b; }
        .modal-actions {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }
        .btn-primary-modal {
            flex: 1;
            background: var(--admin-accent, #cba86a);
            color: #0b0d10;
            border: none;
            border-radius: 8px;
            padding: 11px 0;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            font-family: var(--font-ui, 'Outfit', sans-serif);
            transition: opacity 0.3s;
        }
        .btn-primary-modal:hover { opacity: 0.85; }
        .btn-cancel-modal {
            flex: 1;
            background: transparent;
            color: var(--admin-muted);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 8px;
            padding: 11px 0;
            font-size: 0.85rem;
            cursor: pointer;
            font-family: var(--font-ui, 'Outfit', sans-serif);
            transition: background 0.3s, color 0.3s;
        }
        .btn-cancel-modal:hover { background: rgba(255,255,255,0.04); color: #f4f0e6; }
        .btn-add-account {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 20px;
            background: rgba(203,168,106,0.12);
            border: 1px solid rgba(203,168,106,0.3);
            border-radius: 8px;
            color: var(--admin-accent, #cba86a);
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            font-family: var(--font-ui, 'Outfit', sans-serif);
            transition: background 0.3s;
        }
        .btn-add-account:hover { background: rgba(203,168,106,0.22); }
    </style>
</head>
<body>

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            <polyline points="9 22 9 12 15 12 15 22"/>
        </svg>
        <span>OceanView Admin</span>
    </div>
    <div class="sidebar-role">Administrator</div>
    <nav class="sidebar-nav">
        <a href="dashboard.jsp"    class="nav-link"><span class="nav-icon">📊</span> Dashboard</a>
        <a href="manage_users.jsp" class="nav-link active"><span class="nav-icon">👥</span> Staff Access</a>
        <a href="admin_ledger.jsp" class="nav-link"><span class="nav-icon">📋</span> Billing Ledger</a>
        <a href="help.jsp"         class="nav-link"><span class="nav-icon">📖</span> Guide</a>
        <div class="sidebar-divider"></div>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            Secure Logout
        </a>
    </div>
</aside>

<main class="admin-main">

    <div class="exec-header">
        <div>
            <h1>Staff Access Control</h1>
            <p>Logged in as <strong style="color:white;"><%= loggedIn %></strong>. Manage system accounts and role assignments.</p>
            <% if (pageMessage != null) { %>
            <div style="color:#5dbe8a; font-weight:600; margin-top:10px; font-size:0.88rem;">✓ <%= pageMessage %></div>
            <% } else if (pageError != null) { %>
            <div style="color:#e85d5d; font-weight:600; margin-top:10px; font-size:0.88rem;">✗ <%= pageError %></div>
            <% } %>
        </div>
        <div style="display:flex; align-items:center; gap:14px; flex-wrap:wrap;">
            <button class="btn-add-account" onclick="document.getElementById('addModal').classList.add('open')">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Add Account
            </button>
            <div class="status-badge">
                <div class="status-dot"></div>
                <span><%= users.size() %> Accounts</span>
            </div>
        </div>
    </div>

    <%
        long adminCount = users.stream().filter(u -> "ADMIN".equals(u.getAccessLevel())).count();
        long staffCount = users.stream().filter(u -> "STAFF".equals(u.getAccessLevel())).count();
    %>
    <div class="summary-row no-print">
        <span>Total: <strong><%= users.size() %></strong></span>
        <span>Admins: <strong><%= adminCount %></strong></span>
        <span>Staff: <strong><%= staffCount %></strong></span>
        <span style="margin-left:auto; color:var(--admin-muted); font-size:0.78rem;">🔒 Passwords stored as salted SHA-256 hashes</span>
    </div>

    <div class="card">
        <div class="card-header">
            <div>
                <div class="card-title">Registered System Accounts</div>
                <div class="card-subtitle">All accounts with assigned roles and creation dates</div>
            </div>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th><th>Account ID</th><th>Username</th><th>Role</th><th>Security</th><th>Created At</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% if (users.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center; padding:2.5rem; color:var(--admin-muted);">No accounts found.</td></tr>
                <% } else {
                    int rowNum = 0;
                    for (SysAccount u : users) {
                        rowNum++;
                        boolean isCurrentUser = u.getLoginName().equals(loggedIn);
                        String avatarBg    = "ADMIN".equals(u.getAccessLevel()) ? "rgba(232,93,93,0.12)" : "rgba(93,190,138,0.12)";
                        String avatarColor = "ADMIN".equals(u.getAccessLevel()) ? "#e85d5d" : "#5dbe8a";
                        String roleBadge   = "ADMIN".equals(u.getAccessLevel()) ? "badge-admin" : "badge-staff";
                %>
                    <tr>
                        <td style="color:var(--admin-muted); font-size:0.82rem;"><%= rowNum %></td>
                        <td><strong style="color:var(--admin-muted);">#<%= u.getAccountId() %></strong></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:9px;">
                                <div style="width:32px;height:32px;border-radius:50%;background:<%= avatarBg %>;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.85rem;color:<%= avatarColor %>;">
                                    <%= u.getLoginName().substring(0,1).toUpperCase() %>
                                </div>
                                <span style="font-weight:600;"><%= u.getLoginName() %></span>
                                <% if (isCurrentUser) { %><span class="badge badge-info">You</span><% } %>
                            </div>
                        </td>
                        <td><span class="badge <%= roleBadge %>"><%= u.getAccessLevel() %></span></td>
                        <td style="font-size:0.82rem; color:var(--admin-muted);">🔐 SHA-256 + Salt</td>
                        <td style="color:var(--admin-muted); font-size:0.85rem;"><%= u.getSecureSalt() %></td>
                        <td>
                            <% if (isCurrentUser) { %>
                                <span style="font-size:0.8rem; color:var(--admin-muted);">Current Session</span>
                            <% } else { %>
                                <form method="post" action="<%= request.getContextPath() %>/admin/deleteUser" style="display:inline;" onsubmit="return confirm('Revoke access for <%= u.getLoginName() %>? This cannot be undone.')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="accountId" value="<%= u.getAccountId() %>">
                                    <button type="submit" class="btn btn-sm btn-red">Revoke</button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="alert alert-info no-print" style="margin-top:24px;">
        🔐 <strong>Security:</strong> Passwords are hashed with SHA-256 + unique salt per account. New accounts can be created using the <em>Add Account</em> button above.
    </div>

</main>

<!-- ── Add Account Modal ── -->
<div class="modal-backdrop" id="addModal" onclick="if(event.target===this) this.classList.remove('open')">
    <div class="modal">
        <div class="modal-title">New System Account</div>
        <div class="modal-subtitle">Create a STAFF or ADMIN account. Password will be securely hashed.</div>
        <form method="post" action="<%= request.getContextPath() %>/admin/deleteUser">
            <input type="hidden" name="action" value="create">
            <div class="form-field">
                <label for="loginName">Username</label>
                <input type="text" id="loginName" name="loginName" placeholder="e.g. john_staff" required autocomplete="off">
            </div>
            <div class="form-field">
                <label for="password">Password <span style="color:var(--admin-muted); font-size:0.65rem; text-transform:none;">(min 6 characters)</span></label>
                <input type="password" id="password" name="password" placeholder="••••••••" required minlength="6" autocomplete="new-password">
            </div>
            <div class="form-field">
                <label for="accessLevel">Access Role</label>
                <select id="accessLevel" name="accessLevel" required>
                    <option value="STAFF" selected>STAFF — Front Desk Access</option>
                    <option value="ADMIN">ADMIN — Full System Access</option>
                </select>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel-modal" onclick="document.getElementById('addModal').classList.remove('open')">Cancel</button>
                <button type="submit" class="btn-primary-modal">Create Account</button>
            </div>
        </form>
    </div>
</div>

</body>

</html>
