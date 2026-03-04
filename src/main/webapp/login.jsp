<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView Resort - Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 2rem;
        }

        .login-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .login-card h1 {
            text-align: center;
            color: #0066cc;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 5px rgba(0, 102, 204, 0.3);
        }

        .login-btn {
            width: 100%;
            padding: 0.75rem;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .login-btn:hover {
            background-color: #003366;
        }

        .error-message {
            color: #f44336;
            padding: 0.75rem;
            background-color: #ffebee;
            border-radius: 4px;
            margin-bottom: 1rem;
            display: none;
        }

        .success-message {
            color: #4CAF50;
            padding: 0.75rem;
            background-color: #e8f5e9;
            border-radius: 4px;
            margin-bottom: 1rem;
            display: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <h1>🏖️ OceanView Resort</h1>
            <h2 style="text-align: center; color: #666; font-size: 1.2rem; margin-bottom: 1.5rem;">Management System</h2>

            <%
                String errorMessage = request.getParameter("error");
                String successMessage = request.getParameter("success");
            %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="error-message" style="display: block;">
                    <%= errorMessage %>
                </div>
            <% } %>

            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="success-message" style="display: block;">
                    <%= successMessage %>
                </div>
            <% } %>

            <form id="loginForm" method="POST" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="login-btn">Login</button>
            </form>

            <p style="text-align: center; margin-top: 1.5rem; color: #666;">
                Enterprise System v3.0 - DISTINCTION
            </p>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Form submission with validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                showNotification('Please enter both username and password', 'error');
            }
        });
    </script>
</body>
</html>

