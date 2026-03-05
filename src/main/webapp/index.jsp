<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView Resort — Enterprise Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Outfit:wght@200;300;400;500&display=swap"
        rel="stylesheet">
    <style>
        /* ─── DESIGN TOKENS ─── */
        :root {
            --ease-out: cubic-bezier(0.215, 0.61, 0.355, 1);
            --ease-cin: cubic-bezier(0.19, 1, 0.22, 1);
            --font-d: 'Cormorant Garamond', serif;
            --font-s: 'Outfit', sans-serif;
            --radius: 2px;
            --transition-theme: background-color 0.5s var(--ease-out), color 0.5s var(--ease-out), border-color 0.5s var(--ease-out);
        }

        /* ─── DARK THEME ─── */
        [data-theme="dark"] {
            --bg: #080a0d;
            --bg-2: #0e1115;
            --bg-3: #13171c;
            --surface: rgba(255, 255, 255, 0.03);
            --surface-h: rgba(255, 255, 255, 0.06);
            --text: #f0ece2;
            --text-2: #8a9199;
            --text-3: #5a6068;
            --accent: #c9a55a;
            --accent-dim: rgba(201, 165, 90, 0.12);
            --accent-glow: rgba(201, 165, 90, 0.08);
            --border: rgba(255, 255, 255, 0.07);
            --border-acc: rgba(201, 165, 90, 0.25);
            --hero-overlay: linear-gradient(180deg, rgba(8, 10, 13, 0.3) 0%, rgba(8, 10, 13, 0.55) 55%, #080a0d 100%);
            --card-shadow: 0 40px 80px rgba(0, 0, 0, 0.6);
            --nav-bg: rgba(8, 10, 13, 0.75);
        }

        /* ─── LIGHT THEME ─── */
        [data-theme="light"] {
            --bg: #f7f4ee;
            --bg-2: #eeebe3;
            --bg-3: #e5e1d8;
            --surface: rgba(0, 0, 0, 0.03);
            --surface-h: rgba(0, 0, 0, 0.06);
            --text: #1a1714;
            --text-2: #5a5047;
            --text-3: #9a8f83;
            --accent: #9a6f28;
            --accent-dim: rgba(154, 111, 40, 0.10);
            --accent-glow: rgba(154, 111, 40, 0.06);
            --border: rgba(0, 0, 0, 0.09);
            --border-acc: rgba(154, 111, 40, 0.30);
            --hero-overlay: linear-gradient(180deg, rgba(247, 244, 238, 0.15) 0%, rgba(247, 244, 238, 0.5) 55%, #f7f4ee 100%);
            --card-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
            --nav-bg: rgba(247, 244, 238, 0.82);
        }

        /* ─── BASE ─── */
        *,
        *::before,
        *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            background-color: var(--bg);
            color: var(--text);
            font-family: var(--font-s);
            font-weight: 300;
            line-height: 1.65;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            transition: var(--transition-theme);
        }

        ::selection {
            background: var(--accent-dim);
            color: var(--accent);
        }

        ::-webkit-scrollbar {
            width: 5px;
        }

        ::-webkit-scrollbar-track {
            background: var(--bg);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 99px;
        }

        h1,
        h2,
        h3,
        h4 {
            font-family: var(--font-d);
            font-weight: 400;
            line-height: 1.05;
        }

        /* ─── CURSOR ─── */
        * {
            cursor: none;
        }

        #c-dot,
        #c-ring {
            position: fixed;
            top: 0;
            left: 0;
            pointer-events: none;
            z-index: 99999;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            will-change: transform;
        }

        #c-dot {
            width: 5px;
            height: 5px;
            background: var(--accent);
            transition: width .25s, height .25s, opacity .25s;
        }

        #c-ring {
            width: 34px;
            height: 34px;
            border: 1px solid var(--border-acc);
            transition: width .4s var(--ease-out), height .4s var(--ease-out), border-color .4s;
        }

        /* ─── THEME TOGGLE ─── */
        #theme-btn {
            position: fixed;
            top: 50%;
            right: 1.5rem;
            transform: translateY(-50%);
            z-index: 500;
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--surface-h);
            border: 1px solid var(--border);
            backdrop-filter: blur(12px);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background .3s, border-color .3s, transform .4s var(--ease-out);
            cursor: none;
        }

        #theme-btn:hover {
            background: var(--accent-dim);
            border-color: var(--border-acc);
            transform: translateY(-50%) scale(1.08);
        }

        #theme-btn svg {
            width: 18px;
            height: 18px;
            fill: none;
            stroke: var(--accent);
            stroke-width: 1.5;
            transition: opacity .3s;
        }

        #theme-btn .icon-sun {
            display: none;
        }

        #theme-btn .icon-moon {
            display: block;
        }

        [data-theme="light"] #theme-btn .icon-sun {
            display: block;
        }

        [data-theme="light"] #theme-btn .icon-moon {
            display: none;
        }

        /* ─── NAV ─── */
        nav {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            padding: 1.8rem 4vw;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 400;
            transition: padding .5s var(--ease-cin), background .5s, backdrop-filter .5s, border-color .5s;
        }

        nav.scrolled {
            padding: 1.1rem 4vw;
            background: var(--nav-bg);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: .75rem;
            text-decoration: none;
        }

        .nav-logo svg {
            width: 38px;
            height: 38px;
            flex-shrink: 0;
            transition: transform .6s var(--ease-cin);
        }

        .nav-logo:hover svg {
            transform: rotate(72deg);
        }

        .nav-wordmark {
            font-family: var(--font-d);
            font-size: 1.25rem;
            color: var(--text);
            letter-spacing: .05em;
            transition: color .3s;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 3vw;
        }

        .nav-links {
            display: flex;
            gap: 2.5vw;
            list-style: none;
        }

        .nav-links a {
            color: var(--text-2);
            text-decoration: none;
            font-size: .72rem;
            text-transform: uppercase;
            letter-spacing: .18em;
            position: relative;
            padding-bottom: .4rem;
            transition: color .3s;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background: var(--accent);
            transform: scaleX(0);
            transform-origin: right;
            transition: transform .5s var(--ease-cin);
        }

        .nav-links a:hover {
            color: var(--text);
        }

        .nav-links a:hover::after {
            transform: scaleX(1);
            transform-origin: left;
        }

        .btn-nav {
            padding: .6rem 1.6rem;
            border: 1px solid var(--border-acc);
            background: var(--accent-dim);
            color: var(--accent);
            text-decoration: none;
            font-size: .7rem;
            text-transform: uppercase;
            letter-spacing: .2em;
            transition: background .4s, color .4s, border-color .4s;
        }

        .btn-nav:hover {
            background: var(--accent);
            color: var(--bg);
        }

        /* ─── HERO ─── */
        .hero {
            position: relative;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            align-items: flex-start;
            padding: 0 5vw 8vw;
            overflow: hidden;
        }

        .hero-img {
            position: absolute;
            inset: 0;
            background-image: url('${pageContext.request.contextPath}/images/cinematic_resort_hero.png');
            background-size: cover;
            background-position: center;
            transform: scale(1.06);
            will-change: transform;
            z-index: 0;
            transition: background-image .3s;
        }

        /* fallback gradient when image missing */
        .hero-img-fallback {
            position: absolute;
            inset: 0;
            z-index: 0;
            background: linear-gradient(135deg, #0d1520 0%, #1a2535 40%, #0f1a10 70%, #1a1008 100%);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            z-index: 1;
            background: var(--hero-overlay);
        }

        .hero-grain {
            position: absolute;
            inset: 0;
            z-index: 2;
            pointer-events: none;
            opacity: .04;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
        }

        .hero-content {
            position: relative;
            z-index: 3;
            max-width: 900px;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: .75rem;
            font-size: .65rem;
            text-transform: uppercase;
            letter-spacing: .35em;
            color: var(--accent);
            margin-bottom: 2rem;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeUp .9s var(--ease-out) .2s forwards;
        }

        .hero-eyebrow::before {
            content: '';
            width: 32px;
            height: 1px;
            background: var(--accent);
            flex-shrink: 0;
        }

        .hero-title {
            font-size: clamp(4.5rem, 10vw, 11rem);
            line-height: .9;
            letter-spacing: -.03em;
            margin-bottom: 2rem;
            opacity: 0;
            transform: translateY(40px);
            animation: fadeUp 1.2s var(--ease-cin) .35s forwards;
        }

        .hero-title em {
            font-style: italic;
            color: var(--accent);
            font-weight: 300;
        }

        .hero-sub {
            font-size: 1rem;
            color: var(--text-2);
            max-width: 420px;
            line-height: 1.7;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeUp .9s var(--ease-out) .6s forwards;
            margin-bottom: 3rem;
        }

        .hero-actions {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeUp .9s var(--ease-out) .8s forwards;
        }

        .btn-primary {
            display: inline-block;
            padding: 1.1rem 3rem;
            background: var(--accent);
            color: var(--bg);
            text-decoration: none;
            font-size: .72rem;
            text-transform: uppercase;
            letter-spacing: .22em;
            font-weight: 400;
            transition: opacity .3s, transform .4s var(--ease-out);
        }

        .btn-primary:hover {
            opacity: .88;
            transform: translateY(-2px);
        }

        .btn-ghost {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            padding: 1.1rem 0;
            color: var(--text-2);
            text-decoration: none;
            font-size: .72rem;
            text-transform: uppercase;
            letter-spacing: .22em;
            border-bottom: 1px solid var(--border);
            transition: color .3s, border-color .3s;
        }

        .btn-ghost:hover {
            color: var(--text);
            border-color: var(--accent);
        }

        .btn-ghost svg {
            width: 28px;
            height: 10px;
            stroke: var(--accent);
            fill: none;
            transition: transform .4s var(--ease-cin);
        }

        .btn-ghost:hover svg {
            transform: translateX(8px);
        }

        .hero-scroll {
            position: absolute;
            bottom: 3rem;
            right: 5vw;
            z-index: 3;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
            opacity: .5;
            animation: fadeUp 1s var(--ease-out) 1.2s both;
        }

        .hero-scroll span {
            font-size: .6rem;
            text-transform: uppercase;
            letter-spacing: .3em;
            color: var(--text-2);
            writing-mode: vertical-rl;
        }

        .scroll-bar {
            width: 1px;
            height: 60px;
            background: var(--border);
            overflow: hidden;
            position: relative;
        }

        .scroll-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--accent);
            animation: scrollDrop 2s var(--ease-cin) infinite;
        }

        /* ─── STATS BAR ─── */
        .stats-bar {
            background: var(--bg-2);
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            padding: 2.5rem 5vw;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1px;
            background-color: var(--border);
        }

        .stat-item {
            background: var(--bg-2);
            padding: 2rem 3rem;
            display: flex;
            flex-direction: column;
            gap: .5rem;
            transition: background .3s;
        }

        .stat-item:hover {
            background: var(--bg-3);
        }

        .stat-num {
            font-family: var(--font-d);
            font-size: 3rem;
            color: var(--accent);
            line-height: 1;
        }

        .stat-label {
            font-size: .65rem;
            text-transform: uppercase;
            letter-spacing: .2em;
            color: var(--text-3);
        }

        /* ─── SECTION BASE ─── */
        .section {
            padding: 10vw 5vw;
        }

        .section-tag {
            display: inline-flex;
            align-items: center;
            gap: .6rem;
            font-size: .62rem;
            text-transform: uppercase;
            letter-spacing: .3em;
            color: var(--accent);
            margin-bottom: 1.5rem;
        }

        .section-tag::before {
            content: '';
            width: 24px;
            height: 1px;
            background: var(--accent);
        }

        /* ─── ABOUT / STORY ─── */
        .about {
            background: var(--bg);
        }

        .about-inner {
            display: grid;
            grid-template-columns: 5fr 5fr;
            gap: 8vw;
            align-items: center;
        }

        .about-visual {
            position: relative;
            aspect-ratio: 3/4;
            max-height: 600px;
            overflow: hidden;
            border: 1px solid var(--border);
        }

        .about-visual-img {
            width: 100%;
            height: 100%;
            background: linear-gradient(160deg, var(--bg-3) 0%, var(--bg-2) 100%);
            position: relative;
            overflow: hidden;
        }

        /* SVG architectural diagram as visual art */
        .about-visual-img svg {
            width: 100%;
            height: 100%;
        }

        .about-badge {
            position: absolute;
            bottom: 1.5rem;
            left: 1.5rem;
            background: var(--bg);
            border: 1px solid var(--border);
            padding: 1.2rem 1.8rem;
            display: flex;
            flex-direction: column;
            gap: .3rem;
        }

        .about-badge-num {
            font-family: var(--font-d);
            font-size: 2.5rem;
            color: var(--accent);
            line-height: 1;
        }

        .about-badge-txt {
            font-size: .6rem;
            text-transform: uppercase;
            letter-spacing: .2em;
            color: var(--text-3);
        }

        .about-text h2 {
            font-size: clamp(2.8rem, 5vw, 5.5rem);
            margin-bottom: 2rem;
        }

        .about-desc {
            color: var(--text-2);
            line-height: 1.8;
            margin-bottom: 1.5rem;
            font-size: .95rem;
        }

        .about-features {
            display: flex;
            flex-direction: column;
            gap: 0;
            margin-top: 2.5rem;
        }

        .feature-row {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            padding: 1rem 0;
            border-top: 1px solid var(--border);
            transition: padding .3s;
        }

        .feature-row:last-child {
            border-bottom: 1px solid var(--border);
        }

        .feature-row:hover {
            padding-left: .5rem;
        }

        .feature-icon {
            flex-shrink: 0;
            width: 32px;
            height: 32px;
        }

        .feature-icon svg {
            width: 100%;
            height: 100%;
            fill: none;
            stroke: var(--accent);
            stroke-width: 1.2;
        }

        .feature-label {
            font-size: .8rem;
            color: var(--text-2);
        }

        /* ─── ROOMS ─── */
        .rooms {
            background: var(--bg-2);
        }

        .rooms-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 5rem;
            gap: 2rem;
        }

        .rooms-header h2 {
            font-size: clamp(3rem, 7vw, 8rem);
        }

        .rooms-header p {
            max-width: 280px;
            color: var(--text-3);
            font-size: .85rem;
            text-align: right;
            padding-bottom: .5rem;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            background: var(--border);
        }

        .room-card {
            background: var(--bg-2);
            padding: 3.5rem 3rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 500px;
            position: relative;
            overflow: hidden;
            transition: background .4s, transform .5s var(--ease-out);
            border-bottom: 3px solid transparent;
        }

        .room-card:hover {
            background: var(--bg-3);
            transform: translateY(-6px);
            border-bottom-color: var(--accent);
            box-shadow: var(--card-shadow);
            z-index: 2;
        }

        .room-number {
            position: absolute;
            top: 2rem;
            right: 2.5rem;
            font-family: var(--font-d);
            font-size: 5rem;
            color: var(--border);
            line-height: 1;
            pointer-events: none;
            user-select: none;
            transition: color .4s;
        }

        .room-card:hover .room-number {
            color: var(--accent-dim);
        }

        .room-top {
            position: relative;
            z-index: 2;
        }

        .room-price-tag {
            display: inline-block;
            font-size: .65rem;
            text-transform: uppercase;
            letter-spacing: .18em;
            color: var(--accent);
            border: 1px solid var(--border-acc);
            padding: .4rem 1rem;
            margin-bottom: 2rem;
            background: var(--accent-dim);
        }

        .room-name {
            font-size: 2.4rem;
            margin-bottom: 1rem;
        }

        .room-desc {
            font-size: .88rem;
            color: var(--text-2);
            line-height: 1.75;
        }

        .room-bottom {
            position: relative;
            z-index: 2;
        }

        .room-features-list {
            display: flex;
            flex-wrap: wrap;
            gap: .5rem;
            margin-bottom: 2.5rem;
            margin-top: 1.5rem;
        }

        .room-feature-pill {
            font-size: .6rem;
            text-transform: uppercase;
            letter-spacing: .15em;
            color: var(--text-3);
            border: 1px solid var(--border);
            padding: .35rem .9rem;
        }

        .room-cta {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            color: var(--text-2);
            text-decoration: none;
            font-size: .68rem;
            text-transform: uppercase;
            letter-spacing: .2em;
            border-bottom: 1px solid var(--border);
            padding-bottom: .5rem;
            transition: color .3s, border-color .3s;
        }

        .room-cta svg {
            width: 24px;
            height: 8px;
            stroke: var(--accent);
            fill: none;
            transition: transform .4s var(--ease-cin);
        }

        .room-cta:hover {
            color: var(--accent);
            border-color: var(--accent);
        }

        .room-cta:hover svg {
            transform: translateX(8px);
        }

        /* ─── AVAILABILITY CHECKER ─── */
        .availability {
            background: var(--bg);
        }

        .avail-inner {
            display: grid;
            grid-template-columns: 5fr 5fr;
            gap: 6vw;
            align-items: start;
        }

        .avail-left h2 {
            font-size: clamp(2.5rem, 4.5vw, 5rem);
            margin-bottom: 1.5rem;
        }

        .avail-left p {
            color: var(--text-2);
            font-size: .9rem;
            line-height: 1.8;
            max-width: 400px;
        }

        .avail-form {
            background: var(--bg-2);
            border: 1px solid var(--border);
            padding: 3rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: .5rem;
        }

        .form-group label {
            font-size: .62rem;
            text-transform: uppercase;
            letter-spacing: .2em;
            color: var(--text-3);
        }

        .form-group select,
        .form-group input[type="date"] {
            background: var(--bg-3);
            border: 1px solid var(--border);
            color: var(--text);
            padding: .85rem 1rem;
            font-family: var(--font-s);
            font-size: .85rem;
            font-weight: 300;
            outline: none;
            width: 100%;
            transition: border-color .3s;
            -webkit-appearance: none;
            appearance: none;
        }

        .form-group select:focus,
        .form-group input[type="date"]:focus {
            border-color: var(--accent);
        }

        .form-group select option {
            background: var(--bg-3);
        }

        .btn-check {
            background: var(--accent);
            color: var(--bg);
            border: none;
            padding: 1.1rem 2rem;
            font-family: var(--font-s);
            font-size: .72rem;
            text-transform: uppercase;
            letter-spacing: .22em;
            font-weight: 400;
            width: 100%;
            cursor: none;
            transition: opacity .3s;
        }

        .btn-check:hover {
            opacity: .85;
        }

        #avail-results {
            margin-top: 1.5rem;
            min-height: 60px;
        }

        .avail-room-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.2rem;
            border: 1px solid var(--border);
            margin-bottom: .5rem;
            background: var(--bg-3);
            transition: border-color .3s;
        }

        .avail-room-item:hover {
            border-color: var(--border-acc);
        }

        .avail-room-num {
            font-family: var(--font-d);
            font-size: 1.4rem;
            color: var(--text);
        }

        .avail-room-rate {
            font-size: .75rem;
            color: var(--accent);
        }

        .avail-status-badge {
            font-size: .58rem;
            text-transform: uppercase;
            letter-spacing: .15em;
            padding: .3rem .8rem;
            border: 1px solid;
        }

        .badge-available {
            color: #4caf82;
            border-color: rgba(76, 175, 130, .3);
            background: rgba(76, 175, 130, .08);
        }

        .badge-occupied {
            color: #e06060;
            border-color: rgba(224, 96, 96, .3);
            background: rgba(224, 96, 96, .08);
        }

        .avail-msg {
            font-size: .8rem;
            color: var(--text-3);
            padding: 1rem;
            text-align: center;
        }

        /* ─── HOW IT WORKS ─── */
        .how {
            background: var(--bg-2);
        }

        .how-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1px;
            background: var(--border);
            margin-top: 4rem;
        }

        .how-step {
            background: var(--bg-2);
            padding: 3rem 2.5rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            transition: background .3s;
        }

        .how-step:hover {
            background: var(--bg-3);
        }

        .how-step-num {
            font-family: var(--font-d);
            font-size: 3.5rem;
            color: var(--border);
            line-height: 1;
            transition: color .3s;
        }

        .how-step:hover .how-step-num {
            color: var(--accent);
        }

        .how-step-icon {
            width: 40px;
            height: 40px;
            flex-shrink: 0;
        }

        .how-step-icon svg {
            width: 100%;
            height: 100%;
            fill: none;
            stroke: var(--accent);
            stroke-width: 1.2;
        }

        .how-step h3 {
            font-family: var(--font-d);
            font-size: 1.6rem;
        }

        .how-step p {
            font-size: .83rem;
            color: var(--text-2);
            line-height: 1.7;
        }

        /* ─── SYSTEM / TECH STRIP ─── */
        .tech-strip {
            background: var(--bg-3);
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            padding: 3rem 5vw;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 2rem;
        }

        .tech-label {
            font-size: .62rem;
            text-transform: uppercase;
            letter-spacing: .25em;
            color: var(--text-3);
        }

        .tech-items {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            align-items: center;
        }

        .tech-pill {
            display: flex;
            align-items: center;
            gap: .6rem;
            font-size: .7rem;
            text-transform: uppercase;
            letter-spacing: .15em;
            color: var(--text-2);
        }

        .tech-pill svg {
            width: 16px;
            height: 16px;
            fill: none;
            stroke: var(--accent);
            stroke-width: 1.5;
            flex-shrink: 0;
        }

        /* ─── PORTAL / CTA ─── */
        .portal {
            background: var(--bg);
            text-align: center;
            padding: 12vw 5vw;
            position: relative;
            overflow: hidden;
        }

        .portal-bg {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-family: var(--font-d);
            font-size: 25vw;
            color: var(--surface);
            white-space: nowrap;
            pointer-events: none;
            letter-spacing: -.05em;
            line-height: 1;
            user-select: none;
        }

        .portal-inner {
            position: relative;
            z-index: 2;
            max-width: 700px;
            margin: 0 auto;
        }

        .portal-inner h2 {
            font-size: clamp(3rem, 6vw, 7rem);
            margin-bottom: 1.5rem;
        }

        .portal-inner p {
            color: var(--text-2);
            font-size: 1rem;
            max-width: 460px;
            margin: 0 auto 3.5rem;
            line-height: 1.8;
        }

        .portal-actions {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        /* ─── FOOTER ─── */
        footer {
            background: var(--bg-2);
            border-top: 1px solid var(--border);
            padding: 5vw 5vw 3vw;
        }

        .footer-top {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 4vw;
            margin-bottom: 4rem;
            padding-bottom: 3rem;
            border-bottom: 1px solid var(--border);
        }

        .footer-brand h3 {
            font-family: var(--font-d);
            font-size: 2.5rem;
            color: var(--accent);
            margin-bottom: .5rem;
        }

        .footer-brand p {
            font-size: .78rem;
            color: var(--text-3);
            max-width: 260px;
            line-height: 1.7;
        }

        .footer-col h4 {
            font-size: .62rem;
            text-transform: uppercase;
            letter-spacing: .25em;
            color: var(--text-3);
            margin-bottom: 1.5rem;
        }

        .footer-col ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: .75rem;
        }

        .footer-col ul a {
            color: var(--text-2);
            text-decoration: none;
            font-size: .8rem;
            transition: color .3s;
        }

        .footer-col ul a:hover {
            color: var(--accent);
        }

        .footer-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .footer-copy {
            font-size: .68rem;
            color: var(--text-3);
            letter-spacing: .1em;
        }

        .footer-sys {
            font-size: .68rem;
            color: var(--text-3);
        }

        .footer-sys span {
            color: var(--accent);
        }

        /* ─── ANIMATIONS ─── */
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes scrollDrop {
            0% {
                transform: translateY(-100%);
            }

            50% {
                transform: translateY(0);
            }

            100% {
                transform: translateY(100%);
            }
        }

        .reveal {
            opacity: 0;
            transform: translateY(40px);
            transition: opacity 1s var(--ease-cin), transform 1s var(--ease-cin);
        }

        .reveal.in {
            opacity: 1;
            transform: translateY(0);
        }

        .reveal-delay-1 {
            transition-delay: .1s;
        }

        .reveal-delay-2 {
            transition-delay: .2s;
        }

        .reveal-delay-3 {
            transition-delay: .35s;
        }

        .reveal-delay-4 {
            transition-delay: .5s;
        }

        /* ─── RESPONSIVE ─── */
        @media(max-width:1024px) {
            .about-inner,
            .avail-inner {
                grid-template-columns: 1fr;
            }

            .about-visual {
                max-height: 320px;
            }

            .rooms-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .rooms-header p {
                text-align: left;
            }

            .footer-top {
                grid-template-columns: 1fr 1fr;
            }

            .how-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width:768px) {
            .stats-bar {
                grid-template-columns: repeat(2, 1fr);
            }

            .room-grid {
                grid-template-columns: 1fr;
            }

            .how-grid {
                grid-template-columns: 1fr;
            }

            .footer-top {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .portal-actions {
                flex-direction: column;
                align-items: center;
            }

            .nav-links {
                display: none;
            }

            #theme-btn {
                top: auto;
                bottom: 2rem;
                transform: none;
            }

            #theme-btn:hover {
                transform: scale(1.08);
            }

            .hero {
                padding: 0 6vw 14vw;
            }

            .tech-strip {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>

<body>

    <!-- ═══ CURSOR ═══ -->
    <div id="c-dot"></div>
    <div id="c-ring"></div>

    <!-- ═══ THEME TOGGLE ═══ -->
    <button id="theme-btn" aria-label="Toggle theme">
        <!-- moon icon -->
        <svg class="icon-moon" viewBox="0 0 24 24">
            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
        <!-- sun icon -->
        <svg class="icon-sun" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="5" stroke-linecap="round" />
            <line x1="12" y1="1" x2="12" y2="3" stroke-linecap="round" />
            <line x1="12" y1="21" x2="12" y2="23" stroke-linecap="round" />
            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" stroke-linecap="round" />
            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" stroke-linecap="round" />
            <line x1="1" y1="12" x2="3" y2="12" stroke-linecap="round" />
            <line x1="21" y1="12" x2="23" y2="12" stroke-linecap="round" />
            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" stroke-linecap="round" />
            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" stroke-linecap="round" />
        </svg>
    </button>

    <!-- ═══ NAV ═══ -->
    <nav id="main-nav" role="navigation" aria-label="Main navigation">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            <svg viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="30" cy="30" r="28" stroke="var(--accent)" stroke-width=".8" stroke-dasharray="4 3" />
                <path d="M12 30 Q21 14 30 30 T48 30" stroke="var(--text)" stroke-width="1.4" fill="none" />
                <circle cx="30" cy="30" r="2.5" fill="var(--accent)" />
                <path d="M30 30 Q33 42 30 48" stroke="var(--accent)" stroke-width=".9" stroke-dasharray="2 2" />
            </svg>
            <span class="nav-wordmark">OceanView</span>
        </a>
        <div class="nav-right">
            <ul class="nav-links">
                <li><a href="#about">About</a></li>
                <li><a href="#residences">Residences</a></li>
                <li><a href="#availability">Availability</a></li>
                <li><a href="#portal">Staff Portal</a></li>
            </ul>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-nav">Login</a>
        </div>
    </nav>

    <!-- ═══ HERO ═══ -->
    <header class="hero" id="home">
        <div class="hero-img-fallback"></div>
        <div class="hero-img" id="hero-img-bg"></div>
        <div class="hero-overlay"></div>
        <div class="hero-grain"></div>

        <div class="hero-content">
            <div class="hero-eyebrow">Enterprise Resort Management System</div>
            <h1 class="hero-title">
                OceanView<br><em>Resort &amp; Sanctuary</em>
            </h1>
            <p class="hero-sub">A fully managed coastal retreat — powered by a secure enterprise backend for seamless reservations, billing, and staff operations.</p>
            <div class="hero-actions">
                <a href="#residences" class="btn-primary">View Residences</a>
                <a href="#availability" class="btn-ghost">
                    Check Availability
                    <svg viewBox="0 0 28 10">
                        <path d="M0 5 L28 5 M23 1 L28 5 L23 9" stroke-width="1.5" />
                    </svg>
                </a>
            </div>
        </div>

        <div class="hero-scroll" aria-hidden="true">
            <span>Scroll</span>
            <div class="scroll-bar"></div>
        </div>
    </header>

    <!-- ═══ STATS BAR ═══ -->
    <section class="stats-bar" aria-label="Key statistics">
        <div class="stat-item reveal">
            <span class="stat-num">3</span>
            <span class="stat-label">Room Categories</span>
        </div>
        <div class="stat-item reveal reveal-delay-1">
            <span class="stat-num">7</span>
            <span class="stat-label">Total Rooms</span>
        </div>
        <div class="stat-item reveal reveal-delay-2">
            <span class="stat-num">2</span>
            <span class="stat-label">Access Roles</span>
        </div>
        <div class="stat-item reveal reveal-delay-3">
            <span class="stat-num">LKR</span>
            <span class="stat-label">Billing in Sri Lankan Rupees</span>
        </div>
    </section>

    <!-- ═══ ABOUT ═══ -->
    <section class="section about" id="about" aria-labelledby="about-heading">
        <div class="about-inner">
            <div class="about-visual reveal">
                <div class="about-visual-img">
                    <!-- Custom SVG architectural blueprint art -->
                    <svg viewBox="0 0 400 530" xmlns="http://www.w3.org/2000/svg" fill="none">
                        <rect width="400" height="530" fill="var(--bg-3)" />
                        <!-- Floor plan grid -->
                        <line x1="40" y1="40" x2="360" y2="40" stroke="var(--border)" stroke-width=".5" />
                        <line x1="40" y1="490" x2="360" y2="490" stroke="var(--border)" stroke-width=".5" />
                        <line x1="40" y1="40" x2="40" y2="490" stroke="var(--border)" stroke-width=".5" />
                        <line x1="360" y1="40" x2="360" y2="490" stroke="var(--border)" stroke-width=".5" />
                        <!-- Room outlines -->
                        <rect x="60" y="60" width="120" height="150" stroke="var(--accent)" stroke-width=".8" opacity=".6" />
                        <rect x="220" y="60" width="120" height="150" stroke="var(--border)" stroke-width=".8" opacity=".8" />
                        <rect x="60" y="250" width="280" height="200" stroke="var(--border)" stroke-width=".8" opacity=".8" />
                        <!-- Room labels -->
                        <text x="120" y="142" fill="var(--accent)" font-size="8" font-family="var(--font-s)" text-anchor="middle" opacity=".7">PRESIDENTIAL
                            </text>
                        <text x="120" y="154" fill="var(--accent)" font-size="8" font-family="var(--font-s)" text-anchor="middle" opacity=".7">SUITE</text>
                        <text x="280" y="142" fill="var(--text-3)" font-size="8" font-family="var(--font-s)" text-anchor="middle" opacity=".7">OCEAN DELUXE
                        </text>
                        <text x="200" y="356" fill="var(--text-3)" font-size="8" font-family="var(--font-s)" text-anchor="middle" opacity=".7">STANDARD SINGLE
                        </text>
                        <!-- Measurement lines -->
                        <line x1="60" y1="230" x2="180" y2="230" stroke="var(--accent)" stroke-width=".4" stroke-dasharray="3 2" opacity=".4" />
                        <line x1="60" y1="470" x2="340" y2="470" stroke="var(--border)" stroke-width=".4" stroke-dasharray="3 2" opacity=".4" />
                        <!-- Compass rose -->
                        <circle cx="340" cy="470" r="18" stroke="var(--border)" stroke-width=".5" opacity=".5" />
                        <line x1="340" y1="455" x2="340" y2="485" stroke="var(--text-3)" stroke-width=".8" opacity=".5" />
                        <line x1="325" y1="470" x2="355" y2="470" stroke="var(--text-3)" stroke-width=".8" opacity=".5" />
                        <text x="340" y="451" fill="var(--accent)" font-size="7" text-anchor="middle" opacity=".7">N</text>
                        <!-- Dotted ocean horizon -->
                        <path d="M40 510 Q100 505 160 510 T280 508 T360 510" stroke="var(--accent)" stroke-width=".6" stroke-dasharray="2 3" opacity=".3" />
                        <text x="200" y="522" fill="var(--accent)" font-size="7" font-family="var(--font-s)" text-anchor="middle" opacity=".4" letter-spacing="3">OCEAN FRONTAGE
                        </text>
                    </svg>
                </div>
                <div class="about-badge">
                    <span class="about-badge-num">v3.0</span>
                    <span class="about-badge-txt">Distinction Build</span>
                </div>
            </div>

            <div class="about-text">
                <div class="section-tag reveal">The Property</div>
                <h2 id="about-heading" class="reveal reveal-delay-1">Where the ocean<br><em>meets precision.</em></h2>
                <p class="about-desc reveal reveal-delay-2">OceanView Resort is a premium coastal property managed entirely through this enterprise system. From the moment a guest arrives to the final invoice, every workflow is handled with database-backed accuracy and role-based access control.</p>
                <p class="about-desc reveal reveal-delay-2">Built on Java Servlets, MySQL, and JSP — the system handles reservations, billing with automatic 5% service tax, room availability, and full audit logging of every booking action.</p>

                <div class="about-features">
                    <div class="feature-row reveal reveal-delay-2">
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24">
                                <rect x="3" y="4" width="18" height="18" rx="1" ry="1" />
                                <line x1="16" y1="2" x2="16" y2="6" />
                                <line x1="8" y1="2" x2="8" y2="6" />
                                <line x1="3" y1="10" x2="21" y2="10" />
                            </svg>
                        </div>
                        <span class="feature-label">Booking ref auto-generated (e.g. OVR-A012)</span>
                    </div>
                    <div class="feature-row reveal reveal-delay-3">
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                            </svg>
                        </div>
                        <span class="feature-label">SHA-256 salted password hashing for all accounts</span>
                    </div>
                    <div class="feature-row reveal reveal-delay-4">
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24">
                                <line x1="12" y1="1" x2="12" y2="23" />
                                <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                            </svg>
                        </div>
                        <span class="feature-label">Auto-calculated billing with 5% service tax</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ ROOMS ═══ -->
    <section class="section rooms" id="residences" aria-labelledby="rooms-heading">
        <div class="rooms-header reveal">
            <div>
                <div class="section-tag">Residences</div>
                <h2 id="rooms-heading">Our<br><em>Rooms</em></h2>
            </div>
            <p>Three distinct categories — each managed live from the <code>ov_room_category</code> table in the database.</p>
        </div>

        <div class="room-grid">
            <!-- Standard Single – category_id 1, base_rate 15,000 LKR, rooms 101-103 -->
            <article class="room-card reveal">
                <div class="room-number" aria-hidden="true">01</div>
                <div class="room-top">
                    <span class="room-price-tag">LKR 15,000 / Night</span>
                    <h3 class="room-name">Standard<br>Single</h3>
                    <p class="room-desc">A focused, well-appointed room for solo travelers. Clean lines, optimised layout, and direct access to resort facilities. Rooms 101, 102 &amp; 103 fall under this category.</p>
                </div>
                <div class="room-bottom">
                    <div class="room-features-list">
                        <span class="room-feature-pill">Solo Occupancy</span>
                        <span class="room-feature-pill">Resort Access</span>
                        <span class="room-feature-pill">3 Rooms</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="room-cta">
                        Book via Staff Portal
                        <svg viewBox="0 0 24 8">
                            <path d="M0 4 L24 4 M20 1 L24 4 L20 7" stroke-width="1.4" />
                        </svg>
                    </a>
                </div>
            </article>

            <!-- Ocean Deluxe – category_id 2, base_rate 25,000 LKR, rooms 201-203 -->
            <article class="room-card reveal reveal-delay-1">
                <div class="room-number" aria-hidden="true">02</div>
                <div class="room-top">
                    <span class="room-price-tag">LKR 25,000 / Night</span>
                    <h3 class="room-name">Ocean<br>Deluxe</h3>
                    <p class="room-desc">Double occupancy room with a direct sea-facing view. Floor-to-ceiling framing of the coastline. Rooms 201, 202 &amp; 203 — available status confirmed live from the database.</p>
                </div>
                <div class="room-bottom">
                    <div class="room-features-list">
                        <span class="room-feature-pill">Sea View</span>
                        <span class="room-feature-pill">Double Occupancy</span>
                        <span class="room-feature-pill">3 Rooms</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="room-cta">
                        Book via Staff Portal
                        <svg viewBox="0 0 24 8">
                            <path d="M0 4 L24 4 M20 1 L24 4 L20 7" stroke-width="1.4" />
                        </svg>
                    </a>
                </div>
            </article>

            <!-- Presidential Suite – category_id 3, base_rate 55,000 LKR, room 301 -->
            <article class="room-card reveal reveal-delay-2">
                <div class="room-number" aria-hidden="true">03</div>
                <div class="room-top">
                    <span class="room-price-tag">LKR 55,000 / Night</span>
                    <h3 class="room-name">Presidential<br>Suite</h3>
                    <p class="room-desc">The resort's flagship suite — Room 301. Full amenity package, panoramic ocean exposure, and priority service. A single, exclusive property with unmediated horizon views.</p>
                </div>
                <div class="room-bottom">
                    <div class="room-features-list">
                        <span class="room-feature-pill">Exclusive — 1 Room</span>
                        <span class="room-feature-pill">Full Amenities</span>
                        <span class="room-feature-pill">Priority Service</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="room-cta">
                        Book via Staff Portal
                        <svg viewBox="0 0 24 8">
                            <path d="M0 4 L24 4 M20 1 L24 4 L20 7" stroke-width="1.4" />
                        </svg>
                    </a>
                </div>
            </article>
        </div>
    </section>

    <!-- ═══ AVAILABILITY CHECKER ═══ -->
    <section class="section availability" id="availability" aria-labelledby="avail-heading">
        <div class="avail-inner">
            <div class="avail-left">
                <div class="section-tag reveal">Live Check</div>
                <h2 id="avail-heading" class="reveal reveal-delay-1">Check Room<br><em>Availability</em></h2>
                <p class="reveal reveal-delay-2">Select a room category and your stay dates. The system queries the <code>ov_reservation</code> and <code>ov_accommodation</code> tables in real time via the <code>/api/availability</code> endpoint to show live room status.</p>
            </div>
            <div class="avail-form reveal reveal-delay-2">
                <div class="form-group">
                    <label for="avail-category">Room Category</label>
                    <select id="avail-category" aria-label="Select room category">
                        <option value="">— Select Category —</option>
                        <option value="1">Standard Single — LKR 15,000/night</option>
                        <option value="2">Ocean Deluxe — LKR 25,000/night</option>
                        <option value="3">Presidential Suite — LKR 55,000/night</option>
                    </select>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="avail-arrival">Arrival Date</label>
                        <input type="date" id="avail-arrival" aria-label="Arrival date">
                    </div>
                    <div class="form-group">
                        <label for="avail-departure">Departure Date</label>
                        <input type="date" id="avail-departure" aria-label="Departure date">
                    </div>
                </div>
                <button class="btn-check" id="avail-btn" type="button">Check Availability</button>
                <div id="avail-results" role="region" aria-live="polite"></div>
            </div>
        </div>
    </section>

    <!-- ═══ HOW IT WORKS ═══ -->
    <section class="section how" id="how" aria-labelledby="how-heading">
        <div class="section-tag reveal">System Flow</div>
        <h2 id="how-heading" class="reveal reveal-delay-1" style="font-size:clamp(2.5rem,5vw,5rem);margin-bottom:.5rem;">How a Booking<br><em>Works</em></h2>

        <div class="how-grid">
            <div class="how-step reveal">
                <span class="how-step-num">01</span>
                <div class="how-step-icon">
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="8" r="4" />
                        <path d="M4 20c0-4 3.58-7 8-7s8 3 8 7" />
                    </svg>
                </div>
                <h3>Staff Login</h3>
                <p>Authorised staff log in via the secure portal. Credentials are checked against SHA-256 salted hashes in <code>ov_sys_account</code>. ADMIN and STAFF roles route to different dashboards.</p>
            </div>
            <div class="how-step reveal reveal-delay-1">
                <span class="how-step-num">02</span>
                <div class="how-step-icon">
                    <svg viewBox="0 0 24 24">
                        <rect x="3" y="4" width="18" height="18" rx="1" />
                        <line x1="16" y1="2" x2="16" y2="6" />
                        <line x1="8" y1="2" x2="8" y2="6" />
                        <line x1="3" y1="10" x2="21" y2="10" />
                    </svg>
                </div>
                <h3>Check Availability</h3>
                <p>Staff query rooms by category and dates. The <code>AvailabilityAPI</code> returns live JSON — each room's status calculated against existing confirmed bookings in <code>ov_reservation</code>.</p>
            </div>
            <div class="how-step reveal reveal-delay-2">
                <span class="how-step-num">03</span>
                <div class="how-step-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                        <polyline points="14 2 14 8 20 8" />
                        <line x1="9" y1="13" x2="15" y2="13" />
                        <line x1="9" y1="17" x2="15" y2="17" />
                    </svg>
                </div>
                <h3>Create Reservation</h3>
                <p>A booking reference like <code>OVR-A012</code> is auto-generated using UUID. Guest details, room, and dates are saved to <code>ov_reservation</code>. A DB trigger logs the action to <code>ov_audit_log</code>.</p>
            </div>
            <div class="how-step reveal reveal-delay-3">
                <span class="how-step-num">04</span>
                <div class="how-step-icon">
                    <svg viewBox="0 0 24 24">
                        <line x1="12" y1="1" x2="12" y2="23" />
                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                    </svg>
                </div>
                <h3>Auto Invoice</h3>
                <p>The <code>BillingService</code> immediately calculates room charges × nights + 5% service tax. The invoice is written to <code>ov_billing_invoice</code> and is viewable as a printable PDF-style page.</p>
            </div>
        </div>
    </section>

    <!-- ═══ TECH STRIP ═══ -->
    <div class="tech-strip reveal" aria-label="Technology stack">
        <span class="tech-label">Powered by</span>
        <div class="tech-items">
            <div class="tech-pill">
                <svg viewBox="0 0 24 24">
                    <ellipse cx="12" cy="5" rx="9" ry="3" />
                    <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3" />
                    <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5" />
                </svg>
                MySQL / MariaDB
            </div>
            <div class="tech-pill">
                <svg viewBox="0 0 24 24">
                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
                </svg>
                Java Servlets
            </div>
            <div class="tech-pill">
                <svg viewBox="0 0 24 24">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                    <polyline points="9 22 9 12 15 12 15 22" />
                </svg>
                JSP / Tomcat 9
            </div>
            <div class="tech-pill">
                <svg viewBox="0 0 24 24">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                </svg>
                SHA-256 Auth
            </div>
            <div class="tech-pill">
                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" />
                    <line x1="2" y1="12" x2="22" y2="12" />
                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                </svg>
                REST JSON API
            </div>
        </div>
    </div>

    <!-- ═══ PORTAL / CTA ═══ -->
    <section class="portal" id="portal" aria-labelledby="portal-heading">
        <div class="portal-bg" aria-hidden="true">System</div>
        <div class="portal-inner">
            <div class="section-tag reveal" style="justify-content:center;">Staff Access</div>
            <h2 id="portal-heading" class="reveal reveal-delay-1">Enter the<br><em>Management Portal</em></h2>
            <p class="reveal reveal-delay-2">Authorised staff and administrators can log in to manage reservations, view the financial ledger, check room availability, and generate invoices.</p>
            <div class="portal-actions reveal reveal-delay-3">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-primary">Staff Login</a>
                <a href="#residences" class="btn-ghost">
                    View Rooms
                    <svg viewBox="0 0 28 10">
                        <path d="M0 5 L28 5 M23 1 L28 5 L23 9" stroke-width="1.5" />
                    </svg>
                </a>
            </div>
        </div>
    </section>

    <!-- ═══ FOOTER ═══ -->
    <footer>
        <div class="footer-top">
            <div class="footer-brand">
                <h3>OceanView</h3>
                <p>Enterprise Resort Management System — a full-stack Java EE application managing reservations, billing, and room operations for a coastal resort property.</p>
            </div>
            <div class="footer-col">
                <h4>Residences</h4>
                <ul>
                    <li><a href="#residences">Standard Single</a></li>
                    <li><a href="#residences">Ocean Deluxe</a></li>
                    <li><a href="#residences">Presidential Suite</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>System</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/login.jsp">Staff Login</a></li>
                    <li><a href="#availability">Check Availability</a></li>
                    <li><a href="#how">How it Works</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Information</h4>
                <ul>
                    <li><a href="#about">About</a></li>
                    <li><a href="#portal">Admin Portal</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p class="footer-copy">© 2026 OceanView Resort &amp; Sanctuary. All rights reserved.</p>
            <p class="footer-sys">Build <span>v3.0-DISTINCTION</span> · Java EE · Tomcat 9 · MariaDB</p>
        </div>
    </footer>

    <script>
        (function () {
            'use strict';

            /* ─── CURSOR ─── */
            const dot = document.getElementById('c-dot');
            const ring = document.getElementById('c-ring');
            let mx = window.innerWidth / 2,
                my = window.innerHeight / 2;
            let rx = mx,
                ry = my;

            document.addEventListener('mousemove', e => {
                mx = e.clientX;
                my = e.clientY;
                dot.style.transform = `translate(${mx}px,${my}px) translate(-50%,-50%)`;
            });

            (function lerp() {
                rx += (mx - rx) * .12;
                ry += (my - ry) * .12;
                ring.style.transform = `translate(${rx}px,${ry}px) translate(-50%,-50%)`;
                requestAnimationFrame(lerp);
            })();

            document.querySelectorAll('a,button,[data-hover]').forEach(el => {
                el.addEventListener('mouseenter', () => {
                    ring.style.width = ring.style.height = '64px';
                    ring.style.borderColor = 'var(--accent)';
                    dot.style.opacity = '0';
                });
                el.addEventListener('mouseleave', () => {
                    ring.style.width = ring.style.height = '34px';
                    ring.style.borderColor = 'var(--border-acc)';
                    dot.style.opacity = '1';
                });
            });

            /* ─── THEME TOGGLE ─── */
            const root = document.documentElement;
            const themeBtn = document.getElementById('theme-btn');
            const savedTheme = localStorage.getItem('ov-theme') || 'dark';
            root.setAttribute('data-theme', savedTheme);

            themeBtn.addEventListener('click', () => {
                const current = root.getAttribute('data-theme');
                const next = current === 'dark' ? 'light' : 'dark';
                root.setAttribute('data-theme', next);
                localStorage.setItem('ov-theme', next);
            });

            /* ─── NAV SCROLL ─── */
            const nav = document.getElementById('main-nav');
            window.addEventListener('scroll', () => {
                nav.classList.toggle('scrolled', window.scrollY > 60);
            }, {
                passive: true
            });

            /* ─── HERO IMAGE FALLBACK ─── */
            const heroBg = document.getElementById('hero-img-bg');
            const img = new Image();
            img.onload = () => {
                heroBg.style.backgroundImage = "url('${pageContext.request.contextPath}/images/cinematic_resort_hero.png')";
                heroBg.style.opacity = '1';
            };
            img.onerror = () => {
                heroBg.style.opacity = '0';
            };
            img.src = '${pageContext.request.contextPath}/images/cinematic_resort_hero.png';

            /* ─── PARALLAX HERO ─── */
            window.addEventListener('scroll', () => {
                const y = window.scrollY;
                heroBg.style.transform = `scale(1.06) translate3d(0,${y * 0.25}px,0)`;
            }, {
                passive: true
            });

            /* ─── REVEAL ON SCROLL ─── */
            const revealObserver = new IntersectionObserver((entries) => {
                entries.forEach(e => {
                    if (e.isIntersecting) {
                        e.target.classList.add('in');
                    }
                });
            }, {
                threshold: 0.12,
                rootMargin: '0px 0px -40px 0px'
            });

            document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));

            /* ─── DATE DEFAULTS ─── */
            const today = new Date();
            const fmt = d => d.toISOString().split('T')[0];
            const tomorrow = new Date(today);
            tomorrow.setDate(today.getDate() + 1);
            const dayAfter = new Date(today);
            dayAfter.setDate(today.getDate() + 3);
            const arrIn = document.getElementById('avail-arrival');
            const depIn = document.getElementById('avail-departure');
            arrIn.min = fmt(tomorrow);
            depIn.min = fmt(dayAfter);
            arrIn.value = fmt(tomorrow);
            depIn.value = fmt(dayAfter);

            /* ─── AVAILABILITY CHECK ─── */
            document.getElementById('avail-btn').addEventListener('click', async () => {
                const cat = document.getElementById('avail-category').value;
                const arr = arrIn.value;
                const dep = depIn.value;
                const out = document.getElementById('avail-results');

                if (!cat || !arr || !dep) {
                    out.innerHTML = '<p class="avail-msg">Please select a category and both dates.</p>';
                    return;
                }
                if (arr >= dep) {
                    out.innerHTML = '<p class="avail-msg">Departure must be after arrival.</p>';
                    return;
                }

                out.innerHTML = '<p class="avail-msg">Checking live availability…</p>';

                try {
                    const url = `${pageContext.request.contextPath}/api/availability?categoryId=${encodeURIComponent(cat)}&arrival=${encodeURIComponent(arr)}&departure=${encodeURIComponent(dep)}`;
                    const res = await fetch(url);
                    if (!res.ok) throw new Error('API error');
                    const rooms = await res.json();

                    if (!rooms.length) {
                        out.innerHTML = '<p class="avail-msg">No rooms found for this category.</p>';
                        return;
                    }

                    out.innerHTML = rooms.map(r => `
                <div class="avail-room-item">
                    <div>
                        <div class="avail-room-num">Room ${r.roomNumber}</div>
                        <div class="avail-room-rate">LKR ${Number(r.baseRateLkr).toLocaleString()} / night</div>
                    </div>
                    <span class="avail-status-badge ${r.status == 'AVAILABLE' ? 'badge-available' : 'badge-occupied'}">
                        ${r.status}
                    </span>
                </div>
            `).join('');
                } catch (err) {
                    out.innerHTML = '<p class="avail-msg">Could not reach the availability service. Please log in to check.</p>';
                }
            });

        })();
    </script>
</body>

</html>


