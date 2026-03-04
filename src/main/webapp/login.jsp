<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView Resort | Secure Enterprise Login</title>
    <style>
        /* 🎨 UI DESIGN RULE: Pure CSS Variables & Flexbox */
        :root {
            --emerald-green: #2ecc71;
            --forest-green: #27ae60;
            --ocean-blue: #2980b9;
            --dark-bg: #2c3e50;
            --light-bg: #ecf0f1;
            --text-main: #34495e;
            --error-red: #e74c3c;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }

        body {
            background: linear-gradient(135deg, var(--dark-bg) 0%, var(--ocean-blue) 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .login-header h1 {
            color: var(--forest-green);
            font-size: 24px;
            margin-bottom: 10px;
        }

        .login-header p {
            color: var(--text-main);
            font-size: 14px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            color: var(--text-main);
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #bdc3c7;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--emerald-green);
        }

        .btn-login {
            width: 100%;
            background-color: var(--forest-green);
            color: white;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-login:hover {
            background-color: var(--emerald-green);
        }

        .alert-error {
            background-color: #fdeaea;
            color: var(--error-red);
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            border: 1px solid #fad2d2;
        }

        .alert-success {
            background-color: #eafaf1;
            color: var(--forest-green);
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            border: 1px solid #d5f5e3;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-header">
            <h1>🏨 OceanView Resort</h1>
            <p>Enterprise Management System</p>
        </div>

        <%-- Pure JSP Scriptlet for alert messages (No ES6/EL literal conflicts) --%>
        <%
            String errorMsg = request.getParameter("error");
            String successMsg = request.getParameter("msg");
            if (errorMsg != null && !errorMsg.trim().isEmpty()) {
        %>
            <div class="alert-error">⚠ <%= errorMsg %></div>
        <%
            } else if (successMsg != null && !successMsg.trim().isEmpty()) {
        %>
            <div class="alert-success">✅ <%= successMsg %></div>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/authenticate" method="POST">
            <div class="form-group">
                <label for="username">System Username</label>
                <!-- HTML5 Client-side validation: required -->
                <input type="text" id="username" name="username" required autocomplete="off" placeholder="Enter username">
            </div>

            <div class="form-group">
                <label for="password">Secure Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter password">
            </div>

            <button type="submit" class="btn-login">Secure Login</button>
        </form>
    </div>

</body>
</html>
