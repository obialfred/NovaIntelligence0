const composer = document.getElementById("composer");
const promptField = document.getElementById("prompt");
const conversation = document.getElementById("conversation");
const resetButton = document.getElementById("resetConversation");
const aboutButton = document.getElementById("aboutButton");
const aboutDialog = document.getElementById("aboutDialog");

const cannedTopics = [
  {
    matcher: /roadmap|future|next/i,
    reply:
      "Nova Intelligence is focused on ethical autonomy, private deployment, and fast iteration. This offline build highlights the UI while we prepare the multi-model backend for preview."
  },
  {
    matcher: /hello|hi|hey/i,
    reply:
      "Hello! I'm Nova, your guide to the platform. Even offline, I can walk you through how the experience flows."
  },
  {
    matcher: /dark|theme/i,
    reply:
      "Themes adapt automatically based on your system appearance. The offline demo ships with the Nova gradient to keep things on brand."
  },
  {
    matcher: /how|what can/i,
    reply:
      "Ask about the platform roadmap, integration points, or how to connect to a real deployment. Once you're online, switch the address bar in the toolbar to your Nova cluster URL."
  }
];

function appendMessage(role, text) {
  const wrapper = document.createElement("article");
  wrapper.className = `message ${role}`;

  const header = document.createElement("header");
  header.textContent = role === "user" ? "You" : "Nova";
  wrapper.appendChild(header);

  text.split(/\n+/).forEach((paragraph) => {
    const p = document.createElement("p");
    p.textContent = paragraph.trim();
    wrapper.appendChild(p);
  });

  conversation.appendChild(wrapper);
  conversation.scrollTo({ top: conversation.scrollHeight, behavior: "smooth" });
}

function generateReply(prompt) {
  const topic = cannedTopics.find(({ matcher }) => matcher.test(prompt));
  if (topic) {
    return topic.reply;
  }

  const fallback = [
    "I'm running locally, so I can't reach the cloud just yet, but I can outline how Nova orchestrates research workflows.",
    "Offline mode keeps everything on-device. Connect to the internet and paste a deployment URL into the toolbar to collaborate with the full Nova Intelligence stack.",
    "Think of this as a design sandbox: structure, theming, and interactions are ready for your ideas while the backend spins up."
  ];
  return fallback[Math.floor(Math.random() * fallback.length)];
}

composer.addEventListener("submit", (event) => {
  event.preventDefault();
  const prompt = promptField.value.trim();
  if (!prompt) {
    return;
  }

  appendMessage("user", prompt);
  promptField.value = "";
  promptField.focus();

  window.requestAnimationFrame(() => {
    appendMessage("assistant", generateReply(prompt));
  });
});

resetButton.addEventListener("click", () => {
  while (conversation.firstChild) {
    conversation.removeChild(conversation.firstChild);
  }
  appendMessage(
    "assistant",
    "Conversation cleared. Ask another question to continue exploring the offline interface."
  );
});

aboutButton.addEventListener("click", () => {
  aboutDialog.showModal();
});

aboutDialog.addEventListener("cancel", (event) => {
  event.preventDefault();
  aboutDialog.close();
});

composer.addEventListener("keydown", (event) => {
  if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
    composer.dispatchEvent(new Event("submit", { cancelable: true }));
  }
});
