<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OceanView Resort | Secure Enterprise Login</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,400&family=Outfit:wght@200;300;400;500&display=swap"
            rel="stylesheet">
        <style>
            :root {
                --clr-bg: #0b0d10;
                --clr-surface: rgba(20, 23, 27, 0.55);
                --clr-text: #f4f0e6;
                --clr-text-dim: #7a8290;
                --clr-accent: #cba86a;
                --clr-accent-hover: #dfc08a;
                --clr-border: rgba(203, 168, 106, 0.18);
                --clr-input-bg: rgba(255, 255, 255, 0.04);
                --clr-input-border: rgba(255, 255, 255, 0.08);
                --clr-error: #e85d5d;
                --clr-success: #5dbe8a;
                --font-display: 'Cormorant Garamond', serif;
                --font-sans: 'Outfit', sans-serif;
                --ease-cinematic: cubic-bezier(0.19, 1, 0.22, 1);
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            html,
            body {
                height: 100%;
            }

            body {
                font-family: var(--font-sans);
                background-color: var(--clr-bg);
                color: var(--clr-text);
                display: flex;
                min-height: 100vh;
                -webkit-font-smoothing: antialiased;
                overflow: hidden;
            }

            ::selection {
                background: rgba(203, 168, 106, 0.3);
                color: #fff;
            }

            /* Noise Overlay */
            .noise {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                pointer-events: none;
                z-index: 9999;
                opacity: 0.04;
                background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
            }

            /* Left Panel — Atmospheric Branding */
            .brand-panel {
                flex: 1;
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 6vw;
                overflow: hidden;
            }

            .brand-panel::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-image: url('<%= request.getContextPath() %>/images/cinematic_resort_hero.png');
                background-size: cover;
                background-position: center;
                opacity: 0.25;
                z-index: 0;
            }

            .brand-panel::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(11, 13, 16, 0.9) 0%, rgba(11, 13, 16, 0.6) 50%, rgba(11, 13, 16, 0.9) 100%);
                z-index: 1;
            }

            .brand-inner {
                position: relative;
                z-index: 2;
            }

            .brand-label {
                font-family: var(--font-sans);
                text-transform: uppercase;
                letter-spacing: 0.35em;
                font-size: 0.65rem;
                color: var(--clr-accent);
                margin-bottom: 2.5rem;
                display: inline-block;
                border: 1px solid var(--clr-border);
                padding: 0.4rem 1.2rem;
                border-radius: 30px;
            }

            .brand-title {
                font-family: var(--font-display);
                font-size: clamp(3rem, 5vw, 5.5rem);
                font-weight: 400;
                line-height: 0.95;
                letter-spacing: -0.03em;
                margin-bottom: 1.5rem;
            }

            .brand-title .italic {
                font-style: italic;
                color: var(--clr-accent);
                font-weight: 300;
            }

            .brand-desc {
                font-size: 1rem;
                color: var(--clr-text-dim);
                max-width: 380px;
                line-height: 1.7;
            }

            /* Decorative SVG */
            .brand-svg {
                position: absolute;
                bottom: 5vw;
                left: 5vw;
                z-index: 2;
                opacity: 0.08;
            }

            /* Right Panel — Login Form */
            .login-panel {
                width: 520px;
                min-width: 420px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 4vw;
                position: relative;
                background: var(--clr-surface);
                backdrop-filter: blur(30px);
                -webkit-backdrop-filter: blur(30px);
                border-left: 1px solid rgba(255, 255, 255, 0.04);
            }

            .login-form-wrapper {
                width: 100%;
                max-width: 340px;
            }

            .login-header {
                margin-bottom: 3rem;
            }

            .login-header h1 {
                font-family: var(--font-display);
                font-size: 2.2rem;
                font-weight: 400;
                letter-spacing: -0.02em;
                margin-bottom: 0.6rem;
                color: var(--clr-text);
            }

            .login-header p {
                color: var(--clr-text-dim);
                font-size: 0.88rem;
                font-weight: 300;
            }

            /* Alerts */
            .alert-error {
                background: rgba(232, 93, 93, 0.1);
                color: var(--clr-error);
                padding: 0.85rem 1.1rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                font-size: 0.85rem;
                font-weight: 400;
                border: 1px solid rgba(232, 93, 93, 0.15);
                display: flex;
                align-items: center;
                gap: 0.6rem;
            }

            .alert-success {
                background: rgba(93, 190, 138, 0.1);
                color: var(--clr-success);
                padding: 0.85rem 1.1rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                font-size: 0.85rem;
                font-weight: 400;
                border: 1px solid rgba(93, 190, 138, 0.15);
                display: flex;
                align-items: center;
                gap: 0.6rem;
            }

            /* Form */
            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-group label {
                display: block;
                font-size: 0.7rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.15em;
                color: var(--clr-text-dim);
                margin-bottom: 0.6rem;
            }

            .form-group input {
                width: 100%;
                padding: 0.95rem 1.1rem;
                background: var(--clr-input-bg);
                border: 1px solid var(--clr-input-border);
                border-radius: 8px;
                color: var(--clr-text);
                font-family: var(--font-sans);
                font-size: 0.95rem;
                font-weight: 300;
                transition: border-color 0.4s var(--ease-cinematic), box-shadow 0.4s var(--ease-cinematic);
                outline: none;
            }

            .form-group input::placeholder {
                color: rgba(255, 255, 255, 0.15);
            }

            .form-group input:focus {
                border-color: var(--clr-accent);
                box-shadow: 0 0 0 3px rgba(203, 168, 106, 0.08);
            }

            .btn-login {
                width: 100%;
                padding: 1rem;
                background: transparent;
                color: var(--clr-text);
                border: 1px solid var(--clr-accent);
                border-radius: 8px;
                font-family: var(--font-sans);
                font-size: 0.8rem;
                font-weight: 400;
                text-transform: uppercase;
                letter-spacing: 0.2em;
                cursor: pointer;
                position: relative;
                overflow: hidden;
                transition: color 0.5s var(--ease-cinematic);
                margin-top: 0.5rem;
            }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: var(--clr-accent);
                transform: scaleX(0);
                transform-origin: left;
                transition: transform 0.6s var(--ease-cinematic);
                z-index: -1;
            }

            .btn-login:hover {
                color: var(--clr-bg);
            }

            .btn-login:hover::before {
                transform: scaleX(1);
            }

            /* Footer */
            .login-footer {
                margin-top: 3rem;
                text-align: center;
                color: var(--clr-text-dim);
                font-size: 0.7rem;
                letter-spacing: 0.05em;
                opacity: 0.6;
            }

            /* Animations */
            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .animate-in {
                animation: fadeUp 0.8s var(--ease-cinematic) forwards;
            }

            .animate-in-delay {
                animation: fadeUp 0.8s 0.15s var(--ease-cinematic) forwards;
                opacity: 0;
            }

            .animate-in-delay-2 {
                animation: fadeUp 0.8s 0.3s var(--ease-cinematic) forwards;
                opacity: 0;
            }

            /* Responsive */
            @media (max-width: 900px) {
                body {
                    flex-direction: column;
                    overflow-y: auto;
                }

                .brand-panel {
                    min-height: 40vh;
                    padding: 3rem;
                }

                .login-panel {
                    width: 100%;
                    min-width: unset;
                    backdrop-filter: none;
                    border-left: none;
                    border-top: 1px solid rgba(255, 255, 255, 0.04);
                }
            }
        </style>
    </head>

    <body>
        <div class="noise"></div>

        <div class="brand-panel">
            <div class="brand-inner animate-in">
                <span class="brand-label">Enterprise Portal</span>
                <h2 class="brand-title">OceanView<br><span class="italic">Resort</span></h2>
                <p class="brand-desc">Secure access to the enterprise management system. Reservation operations,
                    financial auditing, and executive oversight.</p>
            </div>
            <svg class="brand-svg" width="200" height="200" viewBox="0 0 200 200" fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <circle cx="100" cy="100" r="90" stroke="rgba(203,168,106,0.3)" stroke-width="0.5"
                    stroke-dasharray="3 8" />
                <circle cx="100" cy="100" r="60" stroke="rgba(203,168,106,0.2)" stroke-width="0.5" />
                <circle cx="100" cy="100" r="30" stroke="rgba(203,168,106,0.4)" stroke-width="0.5" />
                <line x1="100" y1="10" x2="100" y2="190" stroke="rgba(203,168,106,0.1)" stroke-width="0.5" />
                <line x1="10" y1="100" x2="190" y2="100" stroke="rgba(203,168,106,0.1)" stroke-width="0.5" />
            </svg>
        </div>

        <div class="login-panel">
            <div class="login-form-wrapper">
                <div class="login-header animate-in">
                    <h1>Authenticate</h1>
                    <p>Enter your credentials to proceed</p>
                </div>

                <%-- Pure JSP Scriptlet for alert messages (No ES6/EL literal conflicts) --%>
                    <% String errorMsg=request.getParameter("error"); String successMsg=request.getParameter("msg"); if
                        (errorMsg !=null && !errorMsg.trim().isEmpty()) { %>
                        <div class="alert-error animate-in">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="15" y1="9" x2="9" y2="15" />
                                <line x1="9" y1="9" x2="15" y2="15" />
                            </svg>
                            <%= errorMsg %>
                        </div>
                        <% } else if (successMsg !=null && !successMsg.trim().isEmpty()) { %>
                            <div class="alert-success animate-in">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                    <polyline points="22 4 12 14.01 9 11.01" />
                                </svg>
                                <%= successMsg %>
                            </div>
                            <% } %>

                                <form action="<%= request.getContextPath() %>/authenticate" method="POST">
                                    <div class="form-group animate-in-delay">
                                        <label for="username">System Username</label>
                                        <input type="text" id="username" name="username" required autocomplete="off"
                                            placeholder="Enter username">
                                    </div>

                                    <div class="form-group animate-in-delay-2">
                                        <label for="password">Secure Password</label>
                                        <input type="password" id="password" name="password" required
                                            placeholder="Enter password">
                                    </div>

                                    <button type="submit" class="btn-login animate-in-delay-2">Initiate Session</button>
                                </form>

                                <div class="login-footer animate-in-delay-2">
                                    <p>OceanView Enterprise System v3.0</p>
                                    <p style="margin-top: 0.3rem;">SHA-256 Encrypted · Session Managed</p>
                                </div>
            </div>
        </div>
    </body>

    </html>