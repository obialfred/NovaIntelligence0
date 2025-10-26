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
    <header class="toolbar">
        <div class="brand">
            <span class="logo">✦</span>
            <h1>Nova Intelligence (beta)</h1>
        </div>
        <button class="about-button" type="button" id="aboutButton">About</button>
    </header>

    <main class="layout">
        <section class="conversation" id="conversation" aria-live="polite">
            <article class="message assistant">
                <header>
                    <span class="avatar">NI</span>
                    <div>
                        <h2>Nova Intelligence</h2>
                        <time datetime="2024-06-12T09:00:00Z">9:00 AM</time>
                    </div>
                </header>
                <div class="content">
                    <p>Welcome to the offline Nova Intelligence (beta) preview. Ask a question to see how the branded chat experience feels even without a network connection.</p>
                </div>
            </article>
        </section>

        <aside class="sidebar" aria-label="Suggested prompts">
            <h2>Try asking…</h2>
            <ul id="suggestions" class="suggestions"></ul>
        </aside>
    </main>

    <footer class="composer" id="composer">
        <div class="model-picker">
            <label for="modelSelect">Model</label>
            <select id="modelSelect">
                <option>Nova Ultra</option>
                <option>Nova Pro</option>
                <option>Nova Lite</option>
            </select>
        </div>
        <textarea id="prompt" rows="3" placeholder="Send a message.">What are 5 creative things I could do with my kids' art?</textarea>
        <div class="actions">
            <button type="button" id="resetConversation">Reset</button>
            <button type="button" class="primary" id="sendPrompt">Send</button>
        </div>
    </footer>

    <dialog id="aboutDialog">
        <form method="dialog">
            <header>
                <h1>About Nova Intelligence (beta)</h1>
            </header>
            <p>Nova Intelligence (beta) is a native Swift recreation of the Open WebUI desktop experience. This Linux preview renders the same interface through a lightweight Swift NIO server so you can validate the layout without a browser wrapper or Python helpers.</p>
            <p class="meta">Version 0.6.34 • Offline preview</p>
            <menu>
                <button value="close">Close</button>
            </menu>
        </form>
    </dialog>

    <script src="app.js" type="module"></script>
</body>
</html>
"""#

    static let stylesCSS = #"""
:root {
    color-scheme: dark light;
    font-family: "SF Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    background-color: #0c0a1f;
    color: #f6f5ff;
}

body {
    margin: 0;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background: linear-gradient(145deg, #0f172a 0%, #0b1120 40%, #111827 100%);
}

.toolbar {
    height: 60px;
    padding: 0 32px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(15, 23, 42, 0.72);
    backdrop-filter: blur(18px);
}

.brand {
    display: flex;
    align-items: center;
    gap: 14px;
}

.brand .logo {
    width: 34px;
    height: 34px;
    border-radius: 12px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, rgba(241, 180, 76, 0.22), rgba(241, 180, 76, 0.05));
    color: #f1b44c;
    font-size: 18px;
    font-weight: 600;
}

.brand h1 {
    font-size: 18px;
    font-weight: 600;
    letter-spacing: 0.3px;
    margin: 0;
}

.about-button {
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 999px;
    padding: 8px 18px;
    font-size: 14px;
    font-weight: 500;
    color: inherit;
    background: rgba(15, 23, 42, 0.6);
    transition: background 120ms ease, border-color 120ms ease;
}

.about-button:hover {
    border-color: rgba(241, 180, 76, 0.6);
    background: rgba(241, 180, 76, 0.1);
}

.layout {
    flex: 1;
    display: grid;
    grid-template-columns: minmax(0, 3fr) 320px;
    gap: 32px;
    padding: 32px;
}

.conversation {
    display: flex;
    flex-direction: column;
    gap: 24px;
    padding: 32px;
    border-radius: 28px;
    background: rgba(15, 23, 42, 0.72);
    border: 1px solid rgba(255, 255, 255, 0.08);
    box-shadow: 0 24px 60px rgba(15, 23, 42, 0.45);
}

.message header {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 12px;
}

.avatar {
    width: 36px;
    height: 36px;
    border-radius: 12px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: rgba(241, 180, 76, 0.2);
    color: #f1b44c;
    font-weight: 600;
}

.message h2 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
}

.message time {
    display: block;
    margin-top: 4px;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.55);
}

.message .content {
    font-size: 15px;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.9);
}

.sidebar {
    padding: 24px;
    border-radius: 24px;
    background: rgba(15, 23, 42, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.08);
    box-shadow: 0 16px 40px rgba(15, 23, 42, 0.35);
}

.sidebar h2 {
    margin: 0 0 16px;
    font-size: 15px;
    letter-spacing: 0.4px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.72);
}

.suggestions {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    gap: 12px;
}

.suggestions button {
    width: 100%;
    text-align: left;
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 16px;
    padding: 14px 18px;
    background: rgba(15, 23, 42, 0.45);
    color: inherit;
    font-size: 14px;
    font-weight: 500;
    line-height: 1.45;
    transition: border-color 120ms ease, transform 120ms ease, background 120ms ease;
}

.suggestions button:hover {
    border-color: rgba(241, 180, 76, 0.7);
    background: rgba(241, 180, 76, 0.12);
    transform: translateY(-1px);
}

.composer {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr) auto;
    align-items: center;
    gap: 18px;
    padding: 18px 32px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    background: rgba(15, 23, 42, 0.78);
    backdrop-filter: blur(20px);
}

.model-picker {
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.72);
}

.model-picker select {
    border-radius: 14px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    background: rgba(15, 23, 42, 0.6);
    color: inherit;
    padding: 10px 14px;
    font-size: 14px;
}

.composer textarea {
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    background: rgba(15, 23, 42, 0.55);
    color: inherit;
    font-size: 15px;
    padding: 14px 16px;
    resize: vertical;
    min-height: 84px;
}

.actions {
    display: flex;
    gap: 12px;
}

.actions button {
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    background: rgba(15, 23, 42, 0.6);
    color: inherit;
    font-size: 14px;
    font-weight: 600;
    padding: 12px 20px;
    transition: border-color 120ms ease, background 120ms ease;
}

.actions button.primary {
    background: linear-gradient(135deg, rgba(241, 180, 76, 0.85), rgba(241, 180, 76, 0.72));
    border: none;
    color: #151822;
    box-shadow: 0 14px 40px rgba(241, 180, 76, 0.35);
}

.actions button:hover {
    border-color: rgba(241, 180, 76, 0.65);
    background: rgba(241, 180, 76, 0.18);
}

.actions button.primary:hover {
    filter: brightness(1.05);
}

@media (max-width: 1200px) {
    .layout {
        grid-template-columns: 1fr;
    }

    .sidebar {
        order: -1;
    }

    .composer {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .toolbar {
        padding: 0 20px;
    }

    .layout {
        padding: 20px;
        gap: 20px;
    }

    .conversation {
        padding: 24px;
        border-radius: 24px;
    }

    .sidebar {
        border-radius: 20px;
    }
}

#aboutDialog {
    border-radius: 24px;
    padding: 28px;
    background: rgba(15, 23, 42, 0.96);
    border: 1px solid rgba(241, 180, 76, 0.35);
    color: inherit;
    max-width: 440px;
}

#aboutDialog header h1 {
    margin-top: 0;
    margin-bottom: 12px;
    font-size: 20px;
}

#aboutDialog p {
    font-size: 14px;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.78);
}

#aboutDialog .meta {
    font-size: 13px;
    color: rgba(241, 180, 76, 0.75);
    margin-top: 12px;
}

#aboutDialog menu {
    display: flex;
    justify-content: flex-end;
    margin-top: 18px;
}

#aboutDialog button {
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    background: rgba(15, 23, 42, 0.6);
    color: inherit;
    font-size: 14px;
    padding: 10px 18px;
}
"""#

    static let appJS = #"""
const composer = document.getElementById("composer");
const promptField = document.getElementById("prompt");
const conversation = document.getElementById("conversation");
const resetButton = document.getElementById("resetConversation");
const aboutButton = document.getElementById("aboutButton");
const aboutDialog = document.getElementById("aboutDialog");

const cannedTopics = [
  {
    matcher: /roadmap|future|next/i,
    reply: "Here's what's coming soon: a collaborative workspace canvas, bring-your-own-model connectors, and fully offline voice support."
  },
  {
    matcher: /pricing|cost|subscription/i,
    reply: "Nova Intelligence (beta) is free while in preview. Paid tiers unlock workspace sharing and role-based administration."
  },
  {
    matcher: /help|support|contact/i,
    reply: "Need a hand? Reach us at support@novaring.tech and we'll help you get going."
  }
];

const suggestions = [
  "Summarize the latest Nova Intelligence release notes",
  "Draft a welcome email for new Nova Intelligence users",
  "Brainstorm 3 Nova Intelligence automations for my team",
  "How does Nova Intelligence keep data private?"
];

function createMessage(role, text) {
  const article = document.createElement("article");
  article.className = `message ${role}`;

  const header = document.createElement("header");
  const avatar = document.createElement("span");
  avatar.className = "avatar";
  avatar.textContent = role === "assistant" ? "NI" : "You";

  const details = document.createElement("div");
  const title = document.createElement("h2");
  title.textContent = role === "assistant" ? "Nova Intelligence" : "You";
  const timestamp = document.createElement("time");
  timestamp.dateTime = new Date().toISOString();
  timestamp.textContent = new Intl.DateTimeFormat([], { hour: "numeric", minute: "2-digit" }).format(new Date());

  details.appendChild(title);
  details.appendChild(timestamp);

  header.appendChild(avatar);
  header.appendChild(details);

  const body = document.createElement("div");
  body.className = "content";
  body.innerHTML = `<p>${text}</p>`;

  article.appendChild(header);
  article.appendChild(body);
  conversation.appendChild(article);

  conversation.scrollTop = conversation.scrollHeight;
}

function populateSuggestions() {
  const list = document.getElementById("suggestions");
  suggestions.forEach((item) => {
    const listItem = document.createElement("li");
    const button = document.createElement("button");
    button.type = "button";
    button.textContent = item;
    button.addEventListener("click", () => {
      promptField.value = item;
      sendPrompt();
    });
    listItem.appendChild(button);
    list.appendChild(listItem);
  });
}

function sendPrompt() {
  const text = promptField.value.trim();
  if (!text) return;

  createMessage("user", text);
  promptField.value = "";

  const canned = cannedTopics.find((topic) => topic.matcher.test(text));
  const reply = canned
    ? topicReply(text, canned.reply)
    : `Here's a Nova Intelligence (beta) take on that: ${text}`;

  setTimeout(() => createMessage("assistant", reply), 240);
}

function topicReply(question, baseReply) {
  return `${baseReply} (You asked: “${question}”)`;
}

promptField.addEventListener("keydown", (event) => {
  if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "enter") {
    event.preventDefault();
    sendPrompt();
  }
});

resetButton.addEventListener("click", () => {
  conversation.innerHTML = "";
  createMessage(
    "assistant",
    "Conversation cleared. Try one of the suggested prompts to keep exploring Nova Intelligence (beta)."
  );
});

aboutButton.addEventListener("click", () => {
  aboutDialog.showModal();
});

aboutDialog.addEventListener("close", () => {
  promptField.focus();
});

populateSuggestions();
createMessage(
  "assistant",
  "Ready when you are! Drop a prompt into the composer to experience Nova Intelligence (beta)."
);
"""#
}
#endif
