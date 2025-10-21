# Llama 4 Endpoint Integration Guide

This guide describes how to expose a local or remote Llama 4 inference endpoint and
connect it to the Nova Intelligence (Open WebUI) deployment. The commands assume
a macOS or Linux host with Docker and Python 3.10+ installed.

## 1. Provision a Llama 4 inference endpoint

### Option A: Ollama

1. Install [Ollama](https://ollama.com/download).
2. Pull the Llama 4 model bundle (replace the tag with the exact release you have access to):
   ```bash
   ollama pull llama4:latest
   ```
3. Start a detached Ollama instance that exposes an OpenAI-compatible HTTP API:
   ```bash
   OLLAMA_HOST=0.0.0.0 OLLAMA_PORT=11434 ollama serve
   ```
4. (Optional) Create a thin wrapper that maps the Ollama API to the OpenAI schema expected by Nova Intelligence. The [open-webui community proxy](https://github.com/open-webui/ollama-openai-proxy) works out of the box.

### Option B: vLLM or text-generation-inference

1. Download the Llama 4 weights from your licensed provider.
2. Launch a vLLM server that enables the OpenAI-compatible server:
   ```bash
   python -m vllm.entrypoints.openai.api_server \
     --model /path/to/llama4 \
     --port 8000 \
     --host 0.0.0.0 \
     --max-num-batched-tokens 4096
   ```
3. Confirm the server is reachable via cURL:
   ```bash
   curl http://localhost:8000/v1/models
   ```

## 2. Run the Nova Intelligence container

1. Build the branded Open WebUI image:
   ```bash
   docker build -t nova-intelligence .
   ```
2. Start the container and forward port 4173:
   ```bash
   docker run --rm -p 4173:8080 \
     -e OPENAI_API_BASE_URL="http://host.docker.internal:8000/v1" \
     -e OPENAI_API_KEY="test-key" \
     nova-intelligence
   ```
   Adjust `OPENAI_API_BASE_URL` and the API key for your Llama 4 endpoint.
3. Wait for the UI to report "Nova Intelligence is ready" in the logs.

## 3. Link Nova Intelligence to Llama 4

1. Open <http://localhost:4173> in your browser.
2. Go to **Settings → Models**.
3. Choose **OpenAI-Compatible** and supply the endpoint base URL and API key used above.
4. Add a new provider entry, then select the Llama 4 model (for example `llama4` or `llama4-chat`).
5. Set Llama 4 as the default assistant model.

## 4. Run conversational smoke tests

Use the built-in chat interface to validate inference:

1. Start a new chat session.
2. Ask a greeting prompt, e.g., "Hello Llama 4, how do you describe Nova Intelligence?"
3. Follow up with a domain-specific question, for example "Summarize the key steps for deploying Nova Intelligence on Kubernetes."
4. Confirm that responses stream without errors in the console logs.

If you need to automate regression checks, the following Python snippet exercises the OpenAI-compatible API directly:

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url=os.environ["OPENAI_API_BASE_URL"],
    api_key=os.environ["OPENAI_API_KEY"],
)

chat = client.chat.completions.create(
    model="llama4",
    messages=[
        {"role": "system", "content": "You are Nova Intelligence's assistant."},
        {"role": "user", "content": "List three product pillars."},
    ],
)

print(chat.choices[0].message.content)
```

## 5. Capture screenshots

1. Open the Nova Intelligence chat window that shows a successful Llama 4 response.
2. Use your operating system shortcut to capture the window (macOS: `Shift + Cmd + 4`, Windows: `Win + Shift + S`).
3. Save the images under `artifacts/` inside this repository if you want them tracked with version control.
4. Attach the screenshots to your pull request or share them directly with the requester.

## Troubleshooting

- **Timeout errors:** Ensure the inference server allows cross-origin requests and that the Nova container can reach the host interface (`host.docker.internal` on macOS/Windows, the LAN IP on Linux).
- **Model not appearing:** The OpenAI-compatible endpoint must expose the `/v1/models` route. Check the proxy logs for schema mismatches.
- **Large responses truncated:** Increase `OPENAI_MAX_OUTPUT_TOKENS` in the Nova container or bump `--max-model-len` for vLLM.

```
docker run --rm -p 4173:8080 \
  -e OPENAI_API_BASE_URL="http://host.docker.internal:8000/v1" \
  -e OPENAI_API_KEY="test-key" \
  -e OPENAI_MAX_OUTPUT_TOKENS=4096 \
  nova-intelligence
```

With the endpoint reachable and the Nova UI configured, you can perform exploratory testing and capture the requested evidence.
