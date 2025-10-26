#if os(Linux)
import Foundation

enum LinuxPreviewAssets {
    static let indexHTML = #"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Nova Intelligence (beta)</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="app" data-state="ready">
        <aside class="sidebar sidebar--primary">
            <div class="sidebar__brand">
                <span class="sidebar__logo">✦</span>
                <div>
                    <h1>Nova Intelligence</h1>
                    <span class="sidebar__badge">beta</span>
                </div>
            </div>

            <button class="sidebar__new" type="button">
                <span class="sidebar__new-icon">+</span>
                <span class="sidebar__new-label">New Chat</span>
            </button>

            <label class="sidebar__search" aria-label="Search chats">
                <span class="sidebar__search-icon">⌕</span>
                <input type="search" placeholder="Search" value="" />
            </label>

            <div class="sidebar__section">
                <span class="sidebar__section-title">Pinned</span>
                <ul class="chat-list">
                    <li class="chat-list__item chat-list__item--active">
                        <div class="chat-list__icon" data-accent="amber">✶</div>
                        <div class="chat-list__body">
                            <span class="chat-list__title">Classroom art showcase plan</span>
                            <span class="chat-list__subtitle">Outline ideas to display student artwork</span>
                        </div>
                        <span class="chat-list__meta">5m</span>
                    </li>
                </ul>
            </div>

            <div class="sidebar__section sidebar__section--scroll">
                <span class="sidebar__section-title">Recent</span>
                <ul class="chat-list" id="recentList">
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="blue">⬢</div>
                        <div class="chat-list__body">
                            <span class="chat-list__title">STEM night prompts</span>
                            <span class="chat-list__subtitle">Generate interactive booth ideas</span>
                        </div>
                        <span class="chat-list__meta">1d</span>
                    </li>
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="green">✎</div>
                        <div class="chat-list__body">
                            <span class="chat-list__title">Reading level summaries</span>
                            <span class="chat-list__subtitle">Summaries for parent updates</span>
                        </div>
                        <span class="chat-list__meta">2d</span>
                    </li>
                    <li class="chat-list__item">
                        <div class="chat-list__icon" data-accent="rose">🚌</div>
                        <div class="chat-list__body">
                            <span class="chat-list__title">Field trip logistics</span>
                            <span class="chat-list__subtitle">Draft permission slip copy</span>
                        </div>
                        <span class="chat-list__meta">1w</span>
                    </li>
                </ul>
            </div>

            <div class="sidebar__account">
                <div class="sidebar__account-avatar">OB</div>
                <div class="sidebar__account-body">
                    <span class="sidebar__account-name">Obi</span>
                    <span class="sidebar__account-role">Nova Intelligence Team</span>
                </div>
                <span class="sidebar__account-more">⋯</span>
            </div>
        </aside>

        <section class="conversation">
            <header class="conversation__toolbar">
                <div class="conversation__pills">
                    <button class="pill" type="button" data-menu-trigger="modelMenu">
                        <span>Nova Ultra</span>
                        <span class="pill__icon">⌄</span>
                    </button>
                    <button class="pill" type="button" data-menu-trigger="workspaceMenu">
                        <span>Default</span>
                        <span class="pill__icon">⌄</span>
                    </button>
                </div>

                <div class="conversation__actions">
                    <button class="icon-button" type="button" aria-label="Compose tools">✎</button>
                    <button class="icon-button" type="button" aria-label="Tuner">☰</button>
                    <button class="icon-button" type="button" aria-label="Notifications">🔔</button>
                    <button class="icon-button" type="button" aria-label="Open settings" data-open-settings>⚙︎</button>
                </div>
            </header>

            <div class="conversation__scroll" id="conversationScroll">
                <header class="conversation__header">
                    <div>
                        <h2>Classroom art showcase plan</h2>
                        <p>Last updated 5 minutes ago • Nova Ultra</p>
                    </div>
                    <div class="conversation__tags">
                        <span class="tag">Workspace</span>
                        <span class="tag">Nova Ultra</span>
                    </div>
                </header>

                <article class="message message--assistant">
                    <header>
                        <div class="message__avatar" data-role="assistant">NI</div>
                        <div>
                            <h3>Nova Intelligence</h3>
                            <time>Now</time>
                        </div>
                        <span class="message__meta">✦</span>
                    </header>
                    <div class="message__body">
                        <p>Here are five creative ways to transform your kids' art into keepsakes and displays:</p>
                        <ol>
                            <li><strong>Gallery Wall Rotation</strong> — Frame a grid of their favorite pieces using magnetic frames so you can swap new art each week.</li>
                            <li><strong>Storybook Compilation</strong> — Photograph each masterpiece and create a yearly photo book with captions they dictate.</li>
                            <li><strong>Gift Wrap Station</strong> — Turn drawings into custom wrapping paper or thank-you cards for family.</li>
                            <li><strong>Fabric Transfer Quilt</strong> — Scan the artwork, print on fabric sheets, and stitch a cozy quilt that keeps memories close.</li>
                            <li><strong>Shadow Box Exhibits</strong> — Combine 3D crafts with photos in labeled shadow boxes that rotate seasonally.</li>
                        </ol>
                        <section class="highlight">
                            <h4>Highlights</h4>
                            <ul>
                                <li>Magnetic gallery wall for easy rotation</li>
                                <li>Storybook photo album with artist captions</li>
                                <li>Fabric transfer quilt using scanned artwork</li>
                            </ul>
                        </section>
                    </div>
                </article>

                <article class="message message--user">
                    <header>
                        <div class="message__avatar" data-role="user">OB</div>
                        <div>
                            <h3>Obi</h3>
                            <time>1 min ago</time>
                        </div>
                    </header>
                    <div class="message__body">
                        <p>These are amazing! Can you draft an email to parents explaining the rotating gallery idea?</p>
                    </div>
                </article>

                <article class="message message--assistant">
                    <header>
                        <div class="message__avatar" data-role="assistant">NI</div>
                        <div>
                            <h3>Nova Intelligence</h3>
                            <time>moments ago</time>
                        </div>
                        <span class="message__meta">✦</span>
                    </header>
                    <div class="message__body">
                        <p>Absolutely! Here's a warm, professional draft you can adapt for your classroom.</p>
                        <pre class="message__pre">
Subject: Showcasing Our Young Artists

Hi families,

We're launching a rotating art gallery to celebrate the imagination blooming in our classroom. Each week, we'll feature a new set of student creations along our hallway display. Students will curate their pieces, add short artist statements, and learn how to present their work with pride.

If you'd like to help mount frames or photograph artwork, let me know—I'd love to coordinate a volunteer schedule. We'll also capture every display digitally so you can revisit the collection anytime.

Thank you for championing our artists!

Warmly,
Obi
                        </pre>
                    </div>
                </article>

                <section class="suggestions">
                    <h3>Try asking</h3>
                    <div class="suggestions__grid">
                        <button type="button" class="chip">Draft a parent newsletter</button>
                        <button type="button" class="chip">Create a budget for the gallery</button>
                        <button type="button" class="chip">Design student feedback prompts</button>
                        <button type="button" class="chip">Plan the unveiling event</button>
                    </div>
                </section>
            </div>

            <footer class="composer">
                <div class="composer__toolbar">
                    <button type="button" class="chip">📤 Upload Files</button>
                    <button type="button" class="chip">📸 Capture</button>
                    <button type="button" class="chip">📝 Attach Note</button>
                    <span class="composer__spacer"></span>
                    <button type="button" class="icon-button">🎤</button>
                    <button type="button" class="icon-button">⬚</button>
                </div>
                <div class="composer__editor">
                    <textarea rows="5">What are five creative things I could do with my kids' art?</textarea>
                    <div class="composer__footer">
                        <div class="composer__status">✦ Nova Suggest is enabled</div>
                        <button type="button" class="composer__submit">Generate</button>
                    </div>
                </div>
            </footer>
        </section>

        <aside class="sidebar sidebar--secondary">
            <section class="panel">
                <h3 class="panel__title">Session</h3>
                <dl class="panel__list">
                    <div>
                        <dt>Project</dt>
                        <dd>Nova Classroom Vision</dd>
                    </div>
                    <div>
                        <dt>Owner</dt>
                        <dd>Obi</dd>
                    </div>
                    <div>
                        <dt>Created</dt>
                        <dd>Mar 6, 2025</dd>
                    </div>
                </dl>
            </section>

            <section class="panel">
                <h3 class="panel__title">Quick Actions</h3>
                <ul class="panel__actions">
                    <li><span>📄</span> Summarize last 7 days</li>
                    <li><span>📅</span> Plan a class event</li>
                    <li><span>⚡</span> Generate teaching ideas</li>
                </ul>
            </section>

            <section class="panel">
                <h3 class="panel__title">Keyboard Shortcuts</h3>
                <ul class="panel__shortcuts">
                    <li><kbd>⌘</kbd><kbd>K</kbd><span>Command Palette</span></li>
                    <li><kbd>⌘</kbd><kbd>⇧</kbd><kbd>F</kbd><span>Search Messages</span></li>
                    <li><kbd>⌘</kbd><kbd>↵</kbd><span>Send Message</span></li>
                </ul>
            </section>
        </aside>
    </div>

    <div class="settings" id="settings" hidden>
        <div class="settings__backdrop" data-close-settings></div>
        <div class="settings__dialog" role="dialog" aria-modal="true" aria-labelledby="settingsTitle">
            <header class="settings__header">
                <div>
                    <h2 id="settingsTitle">Settings</h2>
                    <p>Nova Intelligence (beta)</p>
                </div>
                <button type="button" class="icon-button" data-close-settings aria-label="Close settings">✕</button>
            </header>
            <div class="settings__body">
                <nav class="settings__nav">
                    <button class="settings__nav-item is-active" data-settings-tab="general">
                        <span>⚙︎</span>
                        <div>
                            <strong>General</strong>
                            <small>Theme, language, defaults</small>
                        </div>
                    </button>
                    <button class="settings__nav-item" data-settings-tab="interface">
                        <span>▦</span>
                        <div>
                            <strong>Interface</strong>
                            <small>Layout preferences</small>
                        </div>
                    </button>
                    <button class="settings__nav-item" data-settings-tab="tools">
                        <span>🧩</span>
                        <div>
                            <strong>External Tools</strong>
                            <small>Linked integrations</small>
                        </div>
                    </button>
                    <button class="settings__nav-item" data-settings-tab="about">
                        <span>ℹ︎</span>
                        <div>
                            <strong>About</strong>
                            <small>Version &amp; credits</small>
                        </div>
                    </button>
                </nav>
                <section class="settings__content">
                    <div class="settings__panel" data-settings-panel="general">
                        <h3>Theme</h3>
                        <div class="settings__segment" role="group" aria-label="Theme">
                            <button class="settings__segment-button is-active">System</button>
                            <button class="settings__segment-button">Dark</button>
                            <button class="settings__segment-button">Light</button>
                        </div>
                        <h3>Language</h3>
                        <div class="settings__segment settings__segment--inline">
                            <button class="settings__segment-button is-active">English (US)</button>
                            <button class="settings__segment-button">English (UK)</button>
                            <button class="settings__segment-button">French</button>
                        </div>
                    </div>
                    <div class="settings__panel is-hidden" data-settings-panel="interface">
                        <h3>Interface</h3>
                        <label class="settings__toggle"><input type="checkbox" checked /> Auto-archive inactive chats</label>
                        <label class="settings__toggle"><input type="checkbox" checked /> Show message timestamps</label>
                    </div>
                    <div class="settings__panel is-hidden" data-settings-panel="tools">
                        <h3>Connected Tools</h3>
                        <ul class="settings__list">
                            <li><span>Google Drive</span><span class="status status--good">Connected</span></li>
                            <li><span>Slack</span><span class="status status--warn">Requires attention</span></li>
                            <li><span>Figma</span><span class="status">Not connected</span></li>
                        </ul>
                    </div>
                    <div class="settings__panel is-hidden" data-settings-panel="about">
                        <h3>About</h3>
                        <p>Nova Intelligence (beta) recreates the Open WebUI desktop interface with native SwiftUI components. This preview mirrors the layout, shortcuts, and styling without bundling upstream binaries.</p>
                    </div>
                </section>
            </div>
            <footer class="settings__footer">
                <span class="tag">Version 0.6.34</span>
                <span class="settings__spacer"></span>
                <button type="button" class="composer__submit" data-close-settings>Close</button>
            </footer>
        </div>
    </div>

    <script src="app.js" type="module"></script>
</body>
</html>
"""#

    static let stylesCSS = #"""
:root {
    color-scheme: dark;
    --bg-window: #101016;
    --bg-sidebar: #1a1b21;
    --bg-content: #18191f;
    --bg-panel: rgba(255, 255, 255, 0.04);
    --stroke: rgba(255, 255, 255, 0.08);
    --stroke-subtle: rgba(255, 255, 255, 0.05);
    --text-primary: #ffffff;
    --text-muted: rgba(255, 255, 255, 0.68);
    --accent: #f1b44c;
    --accent-strong: #f08a40;
    font-family: "SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    background-color: var(--bg-window);
    color: var(--text-primary);
}

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    min-height: 100vh;
    background: radial-gradient(circle at top left, rgba(241, 180, 76, 0.08), transparent 55%),
                linear-gradient(160deg, #101016 0%, #0d0e14 50%, #161820 100%);
    display: flex;
    align-items: stretch;
    justify-content: center;
    padding: 32px;
}

body::before {
    content: "";
    position: fixed;
    inset: 0;
    pointer-events: none;
    background: linear-gradient(130deg, rgba(241, 180, 76, 0.08) 0%, transparent 35%),
                linear-gradient(310deg, rgba(120, 143, 255, 0.06) 0%, transparent 40%);
}

.app {
    width: min(1440px, 100%);
    min-height: 860px;
    display: grid;
    grid-template-columns: 312px minmax(0, 1fr) 320px;
    border-radius: 32px;
    border: 1px solid var(--stroke);
    overflow: hidden;
    position: relative;
    backdrop-filter: blur(24px);
    box-shadow: 0 40px 120px rgba(7, 8, 11, 0.45);
}

.sidebar {
    background: var(--bg-sidebar);
    display: flex;
    flex-direction: column;
    gap: 18px;
    padding: 32px 26px 28px;
}

.sidebar--secondary {
    background: #16171d;
    overflow-y: auto;
}

.sidebar__brand {
    display: flex;
    gap: 14px;
    align-items: center;
}

.sidebar__logo {
    width: 38px;
    height: 38px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 14px;
    background: linear-gradient(135deg, rgba(241, 180, 76, 0.26), rgba(241, 180, 76, 0.05));
    color: var(--accent);
    font-size: 16px;
}

.sidebar__brand h1 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
}

.sidebar__badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 2px 8px;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 600;
    color: var(--accent);
    background: rgba(241, 180, 76, 0.16);
    margin-top: 2px;
}

.sidebar__new {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px 20px;
    font-size: 15px;
    font-weight: 600;
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    background: linear-gradient(140deg, #f1b44c, #f08a40);
    color: #161720;
    cursor: pointer;
}

.sidebar__new:hover {
    filter: brightness(1.05);
}

.sidebar__new-icon {
    font-size: 18px;
    font-weight: 700;
}

.sidebar__search {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    border-radius: 14px;
    border: 1px solid var(--stroke-subtle);
    background: rgba(255, 255, 255, 0.04);
    color: var(--text-muted);
}

.sidebar__search input {
    flex: 1;
    background: transparent;
    border: none;
    color: inherit;
    font-size: 13px;
}

.sidebar__search input:focus {
    outline: none;
}

.sidebar__section {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.sidebar__section--scroll {
    flex: 1;
    overflow-y: auto;
    padding-right: 4px;
}

.sidebar__section-title {
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.45);
    padding-left: 4px;
}

.chat-list {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.chat-list__item {
    display: grid;
    grid-template-columns: auto 1fr auto;
    gap: 12px;
    align-items: center;
    padding: 12px 16px;
    border-radius: 16px;
    cursor: pointer;
    border: 1px solid transparent;
    color: var(--text-primary);
}

.chat-list__item:hover {
    background: rgba(255, 255, 255, 0.04);
}

.chat-list__item--active {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.1);
}

.chat-list__icon {
    width: 32px;
    height: 32px;
    border-radius: 12px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 600;
}

.chat-list__icon[data-accent="amber"] {
    background: rgba(241, 180, 76, 0.2);
    color: #f1b44c;
}

.chat-list__icon[data-accent="blue"] {
    background: rgba(123, 156, 255, 0.2);
    color: #7b9cff;
}

.chat-list__icon[data-accent="green"] {
    background: rgba(122, 202, 158, 0.2);
    color: #7aca9e;
}

.chat-list__icon[data-accent="rose"] {
    background: rgba(228, 129, 140, 0.2);
    color: #e4818c;
}

.chat-list__title {
    display: block;
    font-size: 13.5px;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.chat-list__subtitle {
    display: block;
    font-size: 11.5px;
    color: var(--text-muted);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.chat-list__meta {
    font-size: 11px;
    color: var(--text-muted);
}

.sidebar__account {
    display: grid;
    grid-template-columns: auto 1fr auto;
    gap: 12px;
    align-items: center;
    margin-top: auto;
    padding-top: 18px;
    border-top: 1px solid var(--stroke-subtle);
}

.sidebar__account-avatar {
    width: 36px;
    height: 36px;
    border-radius: 999px;
    background: rgba(123, 156, 255, 0.25);
    color: #7b9cff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
}

.sidebar__account-name {
    font-size: 13px;
    font-weight: 600;
}

.sidebar__account-role {
    font-size: 11px;
    color: var(--text-muted);
}

.conversation {
    background: var(--bg-content);
    display: flex;
    flex-direction: column;
}

.conversation__toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24px 32px;
    gap: 16px;
}

.conversation__pills {
    display: flex;
    gap: 12px;
}

.pill {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 18px;
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.14);
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
}

.pill__icon {
    opacity: 0.72;
}

.icon-button {
    width: 44px;
    height: 44px;
    border-radius: 14px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
    font-size: 16px;
    cursor: pointer;
}

.icon-button:hover {
    background: rgba(255, 255, 255, 0.08);
}

.conversation__scroll {
    flex: 1;
    overflow-y: auto;
    padding: 0 40px 32px;
    display: flex;
    flex-direction: column;
    gap: 28px;
}

.conversation__header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 18px;
    padding-bottom: 8px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.conversation__header h2 {
    margin: 0;
    font-size: 24px;
    font-weight: 650;
    letter-spacing: -0.01em;
}

.conversation__header p {
    margin: 4px 0 0;
    color: var(--text-muted);
    font-size: 12.5px;
}

.conversation__tags {
    display: flex;
    gap: 10px;
}

.tag {
    padding: 6px 12px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.12);
    font-size: 10.5px;
    font-weight: 700;
    letter-spacing: 0.06em;
    color: rgba(255, 255, 255, 0.7);
}

.message {
    padding: 0;
    background: rgba(255, 255, 255, 0.04);
    border-radius: 24px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    padding: 24px 28px;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.message header {
    display: grid;
    grid-template-columns: auto 1fr auto;
    align-items: center;
    gap: 14px;
}

.message__avatar {
    width: 40px;
    height: 40px;
    border-radius: 999px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 14px;
}

.message__avatar[data-role="assistant"] {
    background: rgba(241, 180, 76, 0.25);
    color: var(--accent);
}

.message__avatar[data-role="user"] {
    background: rgba(123, 156, 255, 0.22);
    color: #7b9cff;
}

.message h3 {
    margin: 0;
    font-size: 13.5px;
    font-weight: 600;
}

.message time {
    display: block;
    font-size: 11.5px;
    color: var(--text-muted);
    margin-top: 2px;
}

.message__meta {
    color: var(--accent);
    font-size: 12px;
    font-weight: 600;
}

.message__body {
    font-size: 14.5px;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.94);
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.message__body ol {
    padding-left: 18px;
    margin: 0;
    display: grid;
    gap: 6px;
}

.message__body pre {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 18px;
    padding: 18px;
    white-space: pre-wrap;
    font-family: "SF Mono", "JetBrains Mono", monospace;
    font-size: 13px;
    color: rgba(255, 255, 255, 0.9);
}

.highlight {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 18px;
    padding: 18px;
}

.highlight h4 {
    margin: 0 0 10px;
    font-size: 12px;
    color: var(--text-muted);
    font-weight: 600;
}

.highlight ul {
    margin: 0;
    padding-left: 18px;
    display: grid;
    gap: 6px;
    font-size: 13px;
}

.suggestions {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.07);
    border-radius: 24px;
    padding: 24px 28px;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.suggestions h3 {
    margin: 0;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--text-muted);
}

.suggestions__grid {
    display: grid;
    gap: 12px;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
}

.chip {
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
    font-size: 12.5px;
    font-weight: 600;
    padding: 10px 16px;
    text-align: left;
    cursor: pointer;
}

.chip:hover {
    background: rgba(255, 255, 255, 0.08);
}

.composer {
    padding: 24px 32px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.composer__toolbar {
    display: flex;
    gap: 10px;
    align-items: center;
}

.composer__toolbar .chip {
    background: rgba(255, 255, 255, 0.04);
    border-radius: 16px;
}

.composer__spacer {
    flex: 1;
}

.composer__editor {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 26px;
    padding: 0;
    display: flex;
    flex-direction: column;
}

.composer__editor textarea {
    background: transparent;
    border: none;
    color: var(--text-primary);
    padding: 24px;
    font-size: 14.5px;
    line-height: 1.55;
    font-family: inherit;
    resize: none;
}

.composer__editor textarea:focus {
    outline: none;
}

.composer__footer {
    border-top: 1px solid rgba(255, 255, 255, 0.06);
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 16px 24px;
}

.composer__status {
    color: var(--text-muted);
    font-size: 12px;
}

.composer__submit {
    background: linear-gradient(135deg, var(--accent), var(--accent-strong));
    border: none;
    color: #141414;
    font-size: 14px;
    font-weight: 600;
    padding: 10px 24px;
    border-radius: 999px;
    cursor: pointer;
}

.panel {
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 24px;
    padding: 22px;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.panel__title {
    margin: 0;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--text-muted);
}

.panel__list, .panel__actions, .panel__shortcuts {
    margin: 0;
    padding: 0;
    list-style: none;
    display: grid;
    gap: 12px;
}

.panel__list div {
    display: flex;
    justify-content: space-between;
    font-size: 12.5px;
}

.panel__list dt {
    color: var(--text-muted);
}

.panel__actions li {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 12.5px;
}

.panel__actions span:first-child {
    width: 26px;
    height: 26px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.05);
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.panel__shortcuts li {
    display: grid;
    grid-template-columns: repeat(3, auto) 1fr;
    gap: 8px;
    align-items: center;
}

.panel__shortcuts kbd {
    min-width: 28px;
    padding: 6px 10px;
    border-radius: 10px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.06);
    font-size: 11px;
    font-weight: 600;
    text-align: center;
}

.panel__shortcuts span {
    color: var(--text-muted);
    font-size: 12px;
}

.settings {
    position: fixed;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
}

.settings[hidden] {
    display: none;
}

.settings__backdrop {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.55);
}

.settings__dialog {
    position: relative;
    width: min(860px, 90vw);
    height: 520px;
    background: #1d1e24;
    border-radius: 32px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.settings__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24px 28px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.settings__header h2 {
    margin: 0;
    font-size: 18px;
}

.settings__header p {
    margin: 4px 0 0;
    color: var(--text-muted);
    font-size: 12px;
}

.settings__body {
    display: grid;
    grid-template-columns: 260px 1fr;
    flex: 1;
}

.settings__nav {
    background: rgba(255, 255, 255, 0.02);
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.settings__nav-item {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 12px;
    align-items: center;
    padding: 14px 16px;
    border-radius: 18px;
    border: none;
    background: transparent;
    color: var(--text-primary);
    text-align: left;
    cursor: pointer;
}

.settings__nav-item span {
    font-size: 18px;
}

.settings__nav-item strong {
    display: block;
    font-size: 13.5px;
}

.settings__nav-item small {
    color: var(--text-muted);
    font-size: 11px;
}

.settings__nav-item.is-active {
    background: rgba(255, 255, 255, 0.08);
}

.settings__content {
    background: rgba(255, 255, 255, 0.02);
    padding: 32px;
    overflow-y: auto;
}

.settings__panel {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.settings__panel.is-hidden {
    display: none;
}

.settings__segment {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.settings__segment--inline {
    flex-wrap: wrap;
}

.settings__segment-button {
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    padding: 10px 18px;
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
    font-size: 12.5px;
    font-weight: 600;
    cursor: pointer;
}

.settings__segment-button.is-active {
    background: linear-gradient(135deg, var(--accent), var(--accent-strong));
    color: #151515;
}

.settings__toggle {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 13px;
    color: var(--text-primary);
}

.settings__toggle input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: var(--accent);
}

.settings__list {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    gap: 12px;
}

.settings__list li {
    display: flex;
    justify-content: space-between;
    padding: 14px 16px;
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.04);
    font-size: 13px;
}

.status {
    color: var(--text-muted);
}

.status--good {
    color: #7aca9e;
}

.status--warn {
    color: #f1b44c;
}

.settings__footer {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 18px 28px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.settings__spacer {
    flex: 1;
}

@media (max-width: 1280px) {
    body {
        padding: 16px;
    }

    .app {
        grid-template-columns: 280px minmax(0, 1fr) 280px;
    }
}
"""#

    static let appJS = #"""
const settings = document.querySelector('#settings');
const openSettingsButton = document.querySelector('[data-open-settings]');
const closeSettingsElements = document.querySelectorAll('[data-close-settings]');
const navButtons = Array.from(document.querySelectorAll('[data-settings-tab]'));
const panels = Array.from(document.querySelectorAll('[data-settings-panel]'));

openSettingsButton?.addEventListener('click', () => {
    settings?.removeAttribute('hidden');
});

closeSettingsElements.forEach((el) => {
    el.addEventListener('click', () => {
        settings?.setAttribute('hidden', '');
    });
});

navButtons.forEach((button) => {
    button.addEventListener('click', () => {
        const target = button.getAttribute('data-settings-tab');
        if (!target) return;

        navButtons.forEach((item) => item.classList.toggle('is-active', item === button));
        panels.forEach((panel) => {
            panel.classList.toggle('is-hidden', panel.getAttribute('data-settings-panel') !== target);
        });
    });
});
"""#
}
#endif
