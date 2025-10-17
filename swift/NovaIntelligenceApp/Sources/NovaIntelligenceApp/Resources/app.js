const composer = document.getElementById("composer");
const promptField = document.getElementById("prompt");
const conversation = document.getElementById("conversation");
const suggestions = document.getElementById("suggestions");
const modelButton = document.getElementById("modelButton");
const modelMenu = document.getElementById("modelMenu");
const activeModel = document.getElementById("activeModel");
const settingsDialog = document.getElementById("settingsDialog");
const openSettings = document.getElementById("openSettings");
const openSettingsTop = document.getElementById("openSettingsTop");
const applySettings = document.getElementById("applySettings");
const themeButtons = Array.from(document.querySelectorAll(".theme-picker button"));
const clearConversations = document.getElementById("clearConversations");
const userName = document.getElementById("userName");

const THEME_STORAGE_KEY = "nova.theme";
const MODEL_STORAGE_KEY = "nova.model";

const cannedReplies = {
  default:
    "I'm Nova Intelligence running in preview mode. Ask about workflows, research tactics, or request content drafts and I'll sketch how the full Open WebUI experience responds.",
  "Overcome procrastination":
    "Here’s a quick focus routine:\n• Define a 25-minute sprint\n• Identify the tiniest next action\n• Remove one distraction\n• Celebrate the finished sprint before planning the next",
  "Tell me a fun fact":
    "Koalas have unique fingerprints almost indistinguishable from humans—so detailed that even forensic teams have been fooled at crime scenes!",
  "Show me an ideas list":
    "Let’s brainstorm three ideas:\n1. An AI co-researcher that summarises daily industry briefings.\n2. A workspace that turns whiteboard scribbles into structured project plans.\n3. A narrative voice that rewrites technical specs into customer-friendly updates.",
  "Help me study":
    "Happy to help! Share a topic and I can generate flashcards, quick quizzes, or a reading roadmap tailored to how much time you have today.",
};

function appendMessage(role, text) {
  const wrapper = document.createElement("article");
  wrapper.className = `message ${role}`;

  const header = document.createElement("header");
  const avatar = document.createElement("div");
  avatar.className = "avatar";
  avatar.textContent = role === "user" ? userName.textContent.charAt(0) : "oi";

  const meta = document.createElement("div");
  const heading = document.createElement("h2");
  heading.textContent = role === "user" ? userName.textContent : "Nova Intelligence";
  const timestamp = document.createElement("span");
  timestamp.className = "timestamp";
  timestamp.textContent = new Date().toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });

  meta.append(heading, timestamp);
  header.append(avatar, meta);

  const body = document.createElement("div");
  body.className = "message-body";
  text.split(/\n+/).forEach((paragraph) => {
    const p = document.createElement("p");
    p.textContent = paragraph.trim();
    body.appendChild(p);
  });

  wrapper.append(header, body);
  conversation.appendChild(wrapper);
  conversation.scrollTo({ top: conversation.scrollHeight, behavior: "smooth" });
}

function novaReply(prompt) {
  const trimmed = prompt.trim();
  if (!trimmed) return;
  const matched = Object.keys(cannedReplies).find((key) =>
    key.toLowerCase() === trimmed.toLowerCase()
  );
  const response = matched ? cannedReplies[matched] : cannedReplies.default;
  appendMessage("assistant", response);
}

composer.addEventListener("submit", (event) => {
  event.preventDefault();
  const prompt = promptField.value.trim();
  if (!prompt) return;

  appendMessage("user", prompt);
  promptField.value = "";
  promptField.style.height = "auto";

  window.requestAnimationFrame(() => novaReply(prompt));
});

promptField.addEventListener("input", () => {
  promptField.style.height = "auto";
  promptField.style.height = `${Math.min(promptField.scrollHeight, 220)}px`;
});

if (suggestions) {
  suggestions.addEventListener("click", (event) => {
    if (event.target instanceof HTMLButtonElement) {
      const text = event.target.textContent.trim();
      appendMessage("user", text);
      window.requestAnimationFrame(() => novaReply(text));
    }
  });
}

function setActiveModel(model) {
  if (!modelMenu || !modelButton || !activeModel) return;
  modelMenu.querySelectorAll("li[data-model]").forEach((item) => {
    const isMatch = item.dataset.model === model;
    item.toggleAttribute("aria-selected", isMatch);
    item.tabIndex = isMatch ? 0 : -1;
  });
  modelButton.querySelector(".model-name").textContent = model;
  activeModel.textContent = model;
}

function persistModel(model) {
  try {
    localStorage.setItem(MODEL_STORAGE_KEY, model);
  } catch (error) {
    console.warn("Unable to persist model selection", error);
  }
}

function restoreModel() {
  if (!modelMenu || !modelButton || !activeModel) return;
  let stored = null;
  try {
    stored = localStorage.getItem(MODEL_STORAGE_KEY);
  } catch (error) {
    console.warn("Unable to restore model selection", error);
  }

  const defaultModel = modelButton.querySelector(".model-name").textContent.trim();
  const targetModel = stored || defaultModel;
  const option = modelMenu.querySelector(`[data-model="${targetModel}"]`);
  if (option) {
    setActiveModel(option.dataset.model);
  } else {
    setActiveModel(defaultModel);
  }
}

if (modelButton && modelMenu && activeModel) {
  modelMenu.querySelectorAll("li[data-model]").forEach((item) => {
    item.tabIndex = -1;
  });
  modelMenu.hidden = true;
  restoreModel();

  modelButton.addEventListener("click", () => {
    const expanded = modelButton.getAttribute("aria-expanded") === "true";
    modelButton.setAttribute("aria-expanded", String(!expanded));
    modelMenu.classList.toggle("open", !expanded);
    modelMenu.hidden = expanded;
    if (!expanded) {
      const selected = modelMenu.querySelector('[aria-selected="true"]');
      (selected ?? modelMenu.querySelector("li[data-model]"))?.focus();
    }
  });

  modelMenu.addEventListener("click", (event) => {
    const option = event.target.closest("li[data-model]");
    if (!option) return;

    const model = option.dataset.model;
    setActiveModel(model);
    persistModel(model);
    modelButton.setAttribute("aria-expanded", "false");
    modelMenu.classList.remove("open");
    modelMenu.hidden = true;
    modelButton.focus();
  });

  document.addEventListener("click", (event) => {
    if (!modelMenu.contains(event.target) && !modelButton.contains(event.target)) {
      modelButton.setAttribute("aria-expanded", "false");
      modelMenu.classList.remove("open");
      modelMenu.hidden = true;
    }
  });

  modelMenu.addEventListener("keydown", (event) => {
    const items = Array.from(modelMenu.querySelectorAll("li[data-model]"));
    if (!items.length) return;
    const currentIndex = items.indexOf(document.activeElement);

    if (event.key === "ArrowDown") {
      event.preventDefault();
      const nextIndex = currentIndex >= 0 ? (currentIndex + 1) % items.length : 0;
      const next = items[nextIndex];
      next?.focus();
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      const prevIndex = currentIndex >= 0
        ? (currentIndex - 1 + items.length) % items.length
        : items.length - 1;
      const prev = items[prevIndex];
      prev?.focus();
    } else if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      const model = document.activeElement?.dataset?.model;
      if (!model) return;
      setActiveModel(model);
      persistModel(model);
      modelButton.setAttribute("aria-expanded", "false");
      modelMenu.classList.remove("open");
      modelMenu.hidden = true;
      modelButton.focus();
    } else if (event.key === "Escape") {
      event.preventDefault();
      modelButton.setAttribute("aria-expanded", "false");
      modelMenu.classList.remove("open");
      modelMenu.hidden = true;
      modelButton.focus();
    }
  });
}

function openSettingsDialog() {
  if (!settingsDialog.open) {
    settingsDialog.showModal();
  }
}

openSettings?.addEventListener("click", openSettingsDialog);
openSettingsTop?.addEventListener("click", openSettingsDialog);

settingsDialog?.addEventListener("cancel", (event) => {
  event.preventDefault();
  settingsDialog.close();
});

function setTheme(theme, { persist = true } = {}) {
  if (!theme) return;
  document.body.dataset.theme = theme;
  themeButtons.forEach((item) => {
    item.classList.toggle("active", item.dataset.theme === theme);
  });

  if (persist) {
    try {
      localStorage.setItem(THEME_STORAGE_KEY, theme);
    } catch (error) {
      console.warn("Unable to persist theme", error);
    }
  }
}

function restoreTheme() {
  try {
    const storedTheme = localStorage.getItem(THEME_STORAGE_KEY);
    if (storedTheme) {
      setTheme(storedTheme, { persist: false });
      return;
    }
  } catch (error) {
    console.warn("Unable to restore theme", error);
  }
  const active = themeButtons.find((button) => button.classList.contains("active"));
  if (active) {
    setTheme(active.dataset.theme, { persist: false });
  } else {
    if (!document.body.dataset.theme) {
      document.body.dataset.theme = "system";
    }
  }
}

restoreTheme();

themeButtons.forEach((button) => {
  button.addEventListener("click", () => {
    setTheme(button.dataset.theme);
  });
});

applySettings?.addEventListener("click", () => {
  settingsDialog.close();
});

clearConversations?.addEventListener("click", () => {
  while (conversation.firstChild) {
    conversation.removeChild(conversation.firstChild);
  }
  appendMessage(
    "assistant",
    "Conversation cleared. Ask something new and Nova Intelligence will show how Open WebUI responds."
  );
});

composer.addEventListener("keydown", (event) => {
  if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
    composer.dispatchEvent(new Event("submit", { cancelable: true }));
  }
});

appendMessage(
  "assistant",
  "Welcome back! This Nova Intelligence preview mirrors the Open WebUI layout so you can explore navigation, settings, and the composer flow offline."
);
