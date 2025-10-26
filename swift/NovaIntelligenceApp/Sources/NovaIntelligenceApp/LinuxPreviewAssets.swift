#if os(Linux)
import Foundation

enum LinuxPreviewAssets {
    static let indexHTML = #"""

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Nova Intelligence (beta)</title>
    <link rel="stylesheet" href="styles.css" />
</head>
<body class="theme-light">
    <div class="app">
        <nav class="rail">
            <div class="rail__brand">
                <div class="rail__logo">NI</div>
                <span class="rail__label">Nova Intelligence</span>
            </div>
            <div class="rail__group">
                <button class="rail__item rail__item--active" type="button">
                    <span class="rail__icon">+</span>
                    <span class="rail__text">New Chat</span>
                </button>
                <button class="rail__item" type="button">
                    <span class="rail__icon">🗂</span>
                    <span class="rail__text">Workspace</span>
                </button>
                <button class="rail__item" type="button">
                    <span class="rail__icon">⌕</span>
                    <span class="rail__text">Search</span>
                </button>
            </div>
            <div class="rail__grow"></div>
            <div class="rail__group rail__group--footer">
                <label class="rail__theme">
                    <span>Theme</span>
                    <select id="themeSelect">
                        <option value="system">System</option>
                        <option value="light" selected>Light</option>
                        <option value="dark">Dark</option>
                    </select>
                </label>
                <button class="rail__item" type="button" data-open-settings>
                    <span class="rail__icon">⚙︎</span>
                    <span class="rail__text">Settings</span>
                </button>
            </div>
        </nav>

        <aside class="sidebar">
            <header class="sidebar__header">
                <h1>Chats</h1>
                <label class="sidebar__search">
                    <span>⌕</span>
                    <input type="search" placeholder="Search" />
                </label>
            </header>

            <section class="sidebar__section">
                <h2>Pinned</h2>
                <ul class="chat-list">
                    <li class="chat-list__item chat-list__item--active">
                        <div class="chat-list__icon" data-accent="amber">✶</div>
                        <div class="chat-list__content">
                            <p class="chat-list__title">Classroom art showcase plan</p>
                            <p class="chat-list__subtitle">Outline ideas to display student artwork</p>
                        </div>
                        <span class="chat-list__meta">5m</span>
                    </li>
                </ul>
            </section>

            <section class="sidebar__section sidebar__section--grow">
                <h2>Recent</h2>
                <ul class="chat-list">
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="blue">⬢</div>
                        <div class="chat-list__content">
                            <p class="chat-list__title">STEM night prompts</p>
                            <p class="chat-list__subtitle">Generate interactive booth ideas</p>
                        </div>
                        <span class="chat-list__meta">1d</span>
                    </li>
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="green">✎</div>
                        <div class="chat-list__content">
                            <p class="chat-list__title">Reading level summaries</p>
                            <p class="chat-list__subtitle">Summaries for parent updates</p>
                        </div>
                        <span class="chat-list__meta">2d</span>
                    </li>
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="rose">🚌</div>
                        <div class="chat-list__content">
                            <p class="chat-list__title">Field trip logistics</p>
                            <p class="chat-list__subtitle">Draft permission slip copy</p>
                        </div>
                        <span class="chat-list__meta">1w</span>
                    </li>
                </ul>
            </section>

            <footer class="sidebar__footer">
                <div class="avatar">OB</div>
                <div>
                    <p>Obi</p>
                    <span>Nova Intelligence Team</span>
                </div>
                <span class="sidebar__more">⋯</span>
            </footer>
        </aside>

        <main class="workspace">
            <header class="toolbar">
                <div class="toolbar__selection">
                    <button class="pill" type="button">Nova Ultra<span>⌄</span></button>
                    <button class="pill" type="button">Default<span>⌄</span></button>
                </div>
                <div class="toolbar__icons">
                    <button class="icon" type="button">✎</button>
                    <button class="icon" type="button">☰</button>
                    <button class="icon" type="button">🔔</button>
                    <button class="icon" type="button" data-open-settings>⚙︎</button>
                </div>
            </header>

            <section class="workspace__scroll">
                <div class="banner">
                    <div class="banner__icon">✔</div>
                    <div class="banner__copy">
                        <span>Success</span>
                        <p>Nova Intelligence — On a mission to build the best open-source AI user interface.</p>
                    </div>
                </div>

                <section class="hero">
                    <div class="hero__avatars">
                        <button class="avatar avatar--active" type="button"><span>NU</span></button>
                        <button class="avatar" type="button"><span>NM</span></button>
                        <button class="avatar" type="button"><span>NV</span></button>
                    </div>
                    <div class="hero__copy">
                        <span class="hero__caption">Select a model</span>
                        <h2>Hello, Obi</h2>
                        <p>Balanced reasoning and speed for most tasks.</p>
                    </div>
                    <div class="hero__meta">
                        <div class="badge">
                            <span class="badge__dot"></span>
                            <div>
                                <strong>Nova Ultra</strong>
                                <span>Set as default</span>
                            </div>
                        </div>
                        <button class="hero__customize" type="button">
                            <span>Customize</span>
                            <span class="hero__icon">☰</span>
                        </button>
                    </div>
                    <div class="suggestions">
                        <header>
                            <span class="suggestions__icon">⚡</span>
                            <span>Suggested</span>
                        </header>
                        <div class="suggestions__grid">
                            <button class="suggestion" type="button">
                                <div>
                                    <strong>Give me ideas for what to do with my kids' art</strong>
                                    <span>Prompt</span>
                                </div>
                                <span>↗</span>
                            </button>
                            <button class="suggestion" type="button">
                                <div>
                                    <strong>Tell me a fun fact about the Roman Empire</strong>
                                    <span>Prompt</span>
                                </div>
                                <span>↗</span>
                            </button>
                            <button class="suggestion" type="button">
                                <div>
                                    <strong>Overcome procrastination: give me tips</strong>
                                    <span>Prompt</span>
                                </div>
                                <span>↗</span>
                            </button>
                            <button class="suggestion" type="button">
                                <div>
                                    <strong>Help me study vocabulary for a college exam</strong>
                                    <span>Prompt</span>
                                </div>
                                <span>↗</span>
                            </button>
                        </div>
                    </div>
                </section>

                <section class="thread">
                    <article class="message">
                        <header>
                            <div class="message__avatar message__avatar--assistant">✦</div>
                            <div>
                                <strong>Nova Intelligence (beta)</strong>
                                <span>Now</span>
                            </div>
                        </header>
                        <div class="message__body">
                            <p>Here are five creative ways to transform your kids' art into keepsakes and displays:</p>
                            <ul>
                                <li>Magnetic gallery wall for easy rotation.</li>
                                <li>Storybook photo album with artist captions.</li>
                                <li>Fabric transfer quilt using scanned artwork.</li>
                            </ul>
                        </div>
                    </article>
                    <article class="message message--user">
                        <header>
                            <div class="message__avatar">OB</div>
                            <div>
                                <strong>Obi</strong>
                                <span>1 min ago</span>
                            </div>
                        </header>
                        <div class="message__body">
                            <p>These are amazing! Can you draft an email to parents explaining the rotating gallery idea?</p>
                        </div>
                    </article>
                </section>
            </section>

            <footer class="composer">
                <div class="composer__actions">
                    <button type="button">📎</button>
                    <button type="button">📷</button>
                    <button type="button">✎</button>
                    <div class="composer__spacer"></div>
                    <button type="button">✨</button>
                    <button type="button">🎙</button>
                </div>
                <div class="composer__input">
                    <textarea placeholder="Send a message to Nova Intelligence…"></textarea>
                </div>
                <div class="composer__meta">
                    <span>✨ Nova Suggest is on</span>
                    <button class="composer__send" type="button">Send ↗</button>
                </div>
            </footer>
        </main>
    </div>

    <dialog class="settings" id="settingsDialog">
        <form method="dialog" class="settings__panel">
            <header class="settings__header">
                <div>
                    <h2>Nova Intelligence settings</h2>
                    <p>Preview controls for the desktop shell.</p>
                </div>
                <button class="settings__close" value="close">✕</button>
            </header>
            <div class="settings__body">
                <section>
                    <h3>Appearance</h3>
                    <label>
                        Theme
                        <select id="dialogThemeSelect">
                            <option value="system">System</option>
                            <option value="light">Light</option>
                            <option value="dark">Dark</option>
                        </select>
                    </label>
                    <label>
                        Default model
                        <select>
                            <option>Nova Ultra</option>
                            <option>Nova Mini</option>
                            <option>Nova Voice</option>
                        </select>
                    </label>
                </section>
                <section>
                    <h3>Data controls</h3>
                    <label><input type="checkbox" checked /> Allow product telemetry</label>
                    <label><input type="checkbox" checked /> Enable Nova Voice</label>
                </section>
                <section>
                    <h3>About</h3>
                    <p>Nova Intelligence (beta) mirrors the Open WebUI desktop experience with a fully native SwiftUI implementation.</p>
                </section>
            </div>
            <footer class="settings__footer">
                <span>Version 0.6.34</span>
                <button value="close">Close</button>
            </footer>
        </form>
    </dialog>

    <script src="app.js"></script>
</body>
</html>

"""#

    static let stylesCSS = #"""

:root {
    color-scheme: light;
    font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    --canvas: #f4f6fb;
    --rail-gradient-start: #111629;
    --rail-gradient-end: #192038;
    --rail-border: rgba(31, 41, 55, 0.08);
    --rail-accent: #101526;
    --rail-item: rgba(255, 255, 255, 0.14);
    --control-surface: #eef1ff;
    --surface: #ffffff;
    --composer-surface: #ffffff;
    --outline: #dbe2f4;
    --divider: #e2e8f0;
    --accent: #3b82f6;
    --accent-on: #ffffff;
    --text-primary: #111827;
    --text-muted: #4b5563;
    --text-section: #6b7280;
    --banner-bg: #ecfdf3;
    --banner-text: #15803d;
    --hero-gradient-start: #f6f7ff;
    --hero-gradient-end: #eef2ff;
    --hero-stroke: #dfe4f7;
    --shadow-soft: rgba(17, 21, 38, 0.12);
}

body.theme-dark {
    color-scheme: dark;
    --canvas: #06070a;
    --rail-gradient-start: #0b101a;
    --rail-gradient-end: #04060a;
    --rail-border: rgba(255, 255, 255, 0.08);
    --rail-accent: #f4b324;
    --rail-item: rgba(255, 255, 255, 0.07);
    --control-surface: #1f2330;
    --surface: #10121a;
    --composer-surface: #0b0d13;
    --outline: rgba(255, 255, 255, 0.08);
    --divider: rgba(255, 255, 255, 0.08);
    --accent: #3b82f6;
    --accent-on: #ffffff;
    --text-primary: #e5e7f6;
    --text-muted: #94a3c3;
    --text-section: #7c8aa8;
    --banner-bg: rgba(37, 86, 69, 0.6);
    --banner-text: #9bf6c7;
    --hero-gradient-start: #121726;
    --hero-gradient-end: #090b12;
    --hero-stroke: rgba(255, 255, 255, 0.06);
    --shadow-soft: rgba(0, 0, 0, 0.42);
}

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: var(--canvas);
    color: var(--text-primary);
}

.app {
    display: grid;
    grid-template-columns: 96px 300px 1fr;
    min-height: 100vh;
}

.rail {
    background: linear-gradient(180deg, var(--rail-gradient-start), var(--rail-gradient-end));
    border-right: 1px solid var(--rail-border);
    display: flex;
    flex-direction: column;
    padding: 28px 18px;
    gap: 24px;
}

.rail__brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

.rail__logo {
    width: 46px;
    height: 46px;
    border-radius: 16px;
    background: var(--rail-accent);
    color: #fff;
    display: grid;
    place-items: center;
    font-weight: 700;
}

.rail__label {
    font-size: 11px;
    text-align: center;
    color: var(--text-section);
    line-height: 1.2;
}

.rail__group {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.rail__group--footer {
    gap: 14px;
}

.rail__grow {
    flex: 1;
}

.rail__item {
    all: unset;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    width: 48px;
    padding: 12px 0;
    border-radius: 18px;
    position: relative;
    border: 1px solid var(--rail-border);
    background: var(--rail-item);
    font-size: 15px;
    color: var(--text-section);
    text-align: center;
    transition: transform 120ms ease, box-shadow 160ms ease;
}

.rail__item--active {
    background: linear-gradient(140deg, rgba(59, 130, 246, 0.38), rgba(59, 130, 246, 0.18));
    border-color: rgba(59, 130, 246, 0.7);
    color: var(--accent-on);
    box-shadow: 0 18px 28px rgba(15, 23, 42, 0.35);
    transform: translateY(-1px);
}

.rail__item--active::before {
    content: "";
    position: absolute;
    left: -18px;
    top: 18px;
    bottom: 18px;
    width: 4px;
    border-radius: 999px;
    background: var(--accent);
}

.rail__icon {
    font-size: 16px;
    line-height: 1;
}

.rail__text {
    font-size: 11px;
    font-weight: 600;
}

.rail__theme {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    font-size: 11px;
    color: var(--text-section);
}

.rail__theme select {
    width: 82px;
    padding: 6px 10px;
    border-radius: 10px;
    border: 1px solid var(--outline);
    background: var(--surface);
    color: var(--text-primary);
    font-size: 12px;
}

.sidebar {
    background: var(--surface);
    border-right: 1px solid var(--outline);
    display: flex;
    flex-direction: column;
    padding: 32px 24px;
    gap: 28px;
}

.sidebar__header {
    display: flex;
    flex-direction: column;
    gap: 18px;
}

.sidebar__header h1 {
    margin: 0;
    font-size: 22px;
}

.sidebar__search {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    border-radius: 16px;
    border: 1px solid var(--outline);
    background: var(--canvas);
    color: var(--text-muted);
}

.sidebar__search input {
    border: none;
    background: transparent;
    font-size: 13px;
    color: var(--text-primary);
    flex: 1;
}

.sidebar__section h2 {
    margin: 0 0 12px;
    font-size: 11px;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-section);
}

.chat-list {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    gap: 10px;
}

.chat-list__item {
    display: grid;
    grid-template-columns: auto 1fr auto;
    gap: 12px;
    align-items: center;
    padding: 12px 16px;
    border-radius: 18px;
    border: 1px solid var(--outline);
    background: transparent;
    color: var(--text-muted);
}

.chat-list__item--active {
    background: var(--surface);
    border-color: var(--accent);
    color: var(--text-primary);
}

.chat-list__icon {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: grid;
    place-items: center;
    font-size: 14px;
}

.chat-list__icon[data-accent="amber"] { background: rgba(250, 204, 21, 0.18); color: #b45309; }
.chat-list__icon[data-accent="blue"] { background: rgba(96, 165, 250, 0.18); color: #1d4ed8; }
.chat-list__icon[data-accent="green"] { background: rgba(74, 222, 128, 0.18); color: #047857; }
.chat-list__icon[data-accent="rose"] { background: rgba(244, 114, 182, 0.18); color: #be185d; }

.chat-list__title {
    margin: 0;
    font-size: 13px;
    font-weight: 600;
    color: inherit;
}

.chat-list__subtitle {
    margin: 2px 0 0;
    font-size: 12px;
    color: var(--text-muted);
}

.chat-list__meta {
    font-size: 11px;
    color: var(--text-muted);
}

.sidebar__footer {
    margin-top: auto;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 12px;
    color: var(--text-muted);
}

.sidebar__footer .avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: var(--canvas);
    display: grid;
    place-items: center;
    font-weight: 600;
    color: var(--text-primary);
}

.sidebar__footer p {
    margin: 0;
    font-weight: 600;
    color: var(--text-primary);
}

.sidebar__footer span {
    color: var(--text-muted);
}

.workspace {
    display: flex;
    flex-direction: column;
    background: var(--canvas);
}

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 24px 44px 20px;
    border-bottom: 1px solid var(--outline);
    background: var(--canvas);
}

.toolbar__selection {
    display: flex;
    gap: 12px;
}

.pill {
    all: unset;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 18px;
    border-radius: 18px;
    border: 1px solid var(--outline);
    background: var(--surface);
    color: var(--text-primary);
    font-weight: 600;
}

.toolbar__icons {
    display: flex;
    gap: 10px;
}

.icon {
    all: unset;
    cursor: pointer;
    width: 42px;
    height: 42px;
    border-radius: 14px;
    border: 1px solid var(--outline);
    background: var(--surface);
    display: grid;
    place-items: center;
    color: var(--text-muted);
    font-size: 16px;
}

.workspace__scroll {
    padding: 32px 48px 40px;
    display: grid;
    gap: 32px;
    overflow-y: auto;
}

.banner {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 18px 22px;
    border-radius: 18px;
    border: 1px solid var(--outline);
    background: var(--banner-bg);
    color: var(--banner-text);
}

.banner__icon {
    width: 36px;
    height: 36px;
    border-radius: 12px;
    background: var(--surface);
    display: grid;
    place-items: center;
    font-weight: 700;
}

.banner__copy span {
    font-size: 12px;
    font-weight: 600;
}

.banner__copy p {
    margin: 4px 0 0;
    font-size: 12.5px;
}

.hero {
    display: grid;
    gap: 20px;
    padding: 32px;
    border-radius: 32px;
    border: 1px solid var(--hero-stroke);
    background: linear-gradient(135deg, var(--hero-gradient-start), var(--hero-gradient-end));
    position: relative;
    overflow: hidden;
    box-shadow: 0 24px 40px rgba(15, 23, 42, 0.14);
}

.hero::after {
    content: "";
    position: absolute;
    inset: -20% 30% auto auto;
    width: 320px;
    height: 320px;
    background: radial-gradient(circle at top, rgba(59, 130, 246, 0.22), transparent 70%);
    pointer-events: none;
}

.hero__avatars {
    display: flex;
    gap: 12px;
}

.avatar {
    all: unset;
    cursor: pointer;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    border: 1px solid var(--hero-stroke);
    background: rgba(255, 255, 255, 0.22);
    display: grid;
    place-items: center;
    font-weight: 600;
    color: var(--accent);
    box-shadow: 0 12px 20px rgba(15, 23, 42, 0.18);
}

.avatar--active {
    background: rgba(59, 130, 246, 0.22);
    border-color: rgba(59, 130, 246, 0.65);
}

.hero__caption {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-section);
}

.hero__copy h2 {
    margin: 4px 0 0;
    font-size: 34px;
}

.hero__copy p {
    margin: 8px 0 0;
    font-size: 14.5px;
    color: var(--text-muted);
}

.hero__meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
}

.badge {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 18px;
    border-radius: 20px;
    border: 1px solid var(--hero-stroke);
    background: rgba(255, 255, 255, 0.34);
}

.badge__dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: var(--accent);
    display: inline-block;
}

.hero__customize {
    all: unset;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    border-radius: 18px;
    border: 1px solid var(--hero-stroke);
    background: rgba(255, 255, 255, 0.32);
    color: var(--text-primary);
    font-weight: 600;
}

.suggestions header {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 11px;
    font-weight: 600;
    color: var(--text-muted);
}

.suggestions__grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
}

.suggestion {
    all: unset;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 14px 16px;
    border-radius: 18px;
    border: 1px solid var(--hero-stroke);
    background: linear-gradient(140deg, rgba(246, 247, 255, 0.88), rgba(238, 242, 255, 0.95));
    color: var(--text-primary);
    box-shadow: 0 16px 24px rgba(15, 23, 42, 0.12);
}

.suggestion strong {
    display: block;
    font-size: 14px;
}

.suggestion span:last-child {
    color: var(--text-muted);
}

.thread {
    display: grid;
    gap: 20px;
}

.message {
    padding: 24px;
    border-radius: 26px;
    border: 1px solid var(--outline);
    background: var(--surface);
    box-shadow: 0 24px 36px rgba(15, 23, 42, 0.12);
    display: grid;
    gap: 18px;
}

.message header {
    display: flex;
    align-items: center;
    gap: 14px;
}

.message__avatar {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    background: var(--control-surface);
    display: grid;
    place-items: center;
    font-weight: 600;
    color: var(--text-primary);
}

.message__avatar--assistant {
    background: rgba(59, 130, 246, 0.18);
    color: var(--accent);
}

.message header strong {
    display: block;
    font-size: 14px;
}

.message header span {
    font-size: 11px;
    color: var(--text-muted);
}

.message__body {
    display: grid;
    gap: 12px;
    font-size: 13.5px;
    line-height: 1.6;
}

.message__body ul {
    padding-left: 18px;
    margin: 0;
    color: var(--text-muted);
}

.message--user {
    border-color: var(--outline);
}

.composer {
    margin-top: auto;
    padding: 24px 44px 32px;
    display: grid;
    gap: 14px;
    border-top: 1px solid var(--outline);
    background: var(--canvas);
}

.composer__actions {
    display: flex;
    gap: 10px;
}

.composer__actions button {
    all: unset;
    cursor: pointer;
    width: 34px;
    height: 34px;
    border-radius: 12px;
    border: 1px solid var(--outline);
    background: var(--control-surface);
    display: grid;
    place-items: center;
    font-size: 13px;
    color: var(--text-muted);
}

.composer__spacer {
    flex: 1;
}

.composer__input textarea {
    width: 100%;
    min-height: 110px;
    max-height: 180px;
    border: 1px solid var(--outline);
    border-radius: 24px;
    padding: 16px;
    font-family: inherit;
    font-size: 14px;
    color: var(--text-primary);
    resize: vertical;
    background: var(--composer-surface);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}

.composer__meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 12px;
    color: var(--text-muted);
}

.composer__send {
    all: unset;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 10px 18px;
    border-radius: 999px;
    background: var(--accent);
    color: var(--accent-on);
    font-weight: 600;
}

.settings {
    border: none;
    border-radius: 32px;
    padding: 0;
}

.settings::backdrop {
    background: rgba(17, 21, 38, 0.45);
}

.settings__panel {
    display: grid;
    grid-template-rows: auto 1fr auto;
    background: var(--surface);
    border-radius: 32px;
    border: 1px solid var(--outline);
    width: min(760px, calc(100vw - 48px));
    max-height: 80vh;
}

.settings__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24px 30px;
    border-bottom: 1px solid var(--divider);
}

.settings__header h2 {
    margin: 0;
    font-size: 18px;
}

.settings__header p {
    margin: 4px 0 0;
    font-size: 12px;
    color: var(--text-muted);
}

.settings__close {
    all: unset;
    cursor: pointer;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid var(--outline);
    background: var(--surface);
    display: grid;
    place-items: center;
}

.settings__body {
    padding: 0 30px;
    overflow-y: auto;
}

.settings__body section {
    padding: 24px 0;
    border-bottom: 1px solid var(--divider);
    display: grid;
    gap: 16px;
}

.settings__body section:last-of-type {
    border-bottom: none;
}

.settings__body h3 {
    margin: 0;
    font-size: 11px;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-section);
}

.settings__body label {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 13px;
}

.settings__body select {
    margin-left: 8px;
    padding: 8px 12px;
    border-radius: 12px;
    border: 1px solid var(--outline);
    background: var(--surface);
    color: var(--text-primary);
}

.settings__footer {
    padding: 18px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid var(--divider);
    font-size: 11px;
    color: var(--text-muted);
}

.settings__footer button {
    all: unset;
    cursor: pointer;
    padding: 12px 24px;
    border-radius: 999px;
    background: var(--accent);
    color: var(--accent-on);
    font-weight: 600;
}

"""#

    static let appJS = #"""
(() => {
    const THEME_KEY = "nova-theme-preference";
    const themeSelect = document.getElementById("themeSelect");
    const dialogThemeSelect = document.getElementById("dialogThemeSelect");
    const settingsDialog = document.getElementById("settingsDialog");

    const systemMedia = window.matchMedia("(prefers-color-scheme: dark)");
    const storedPreference = localStorage.getItem(THEME_KEY) || "light";
    applyTheme(storedPreference);

    function applyTheme(preference) {
        const resolved = preference === "system"
            ? (systemMedia.matches ? "dark" : "light")
            : preference;

        document.body.classList.remove("theme-light", "theme-dark");
        document.body.classList.add(`theme-${resolved}`);

        localStorage.setItem(THEME_KEY, preference);
        themeSelect.value = preference;
        dialogThemeSelect.value = preference;
    }

    themeSelect.addEventListener("change", (event) => {
        applyTheme(event.target.value);
    });

    dialogThemeSelect.addEventListener("change", (event) => {
        applyTheme(event.target.value);
    });

    systemMedia.addEventListener("change", () => {
        const pref = localStorage.getItem(THEME_KEY) || "light";
        if (pref === "system") {
            applyTheme("system");
        }
    });

    document.querySelectorAll("[data-open-settings]").forEach((button) => {
        button.addEventListener("click", () => {
            if (typeof settingsDialog.showModal === "function") {
                settingsDialog.showModal();
            }
        });
    });

    settingsDialog?.addEventListener("cancel", (event) => {
        event.preventDefault();
        settingsDialog.close("close");
    });
})();
"""#
}
#endif
