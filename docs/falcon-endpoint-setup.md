# Falcon Endpoint Setup for Nova I-Go 0.1.0-alpha.1

This guide walks through provisioning a **local Falcon language model** (either
[Falcon 7B Instruct](https://huggingface.co/tiiuae/falcon-7b-instruct) or
[Falcon 2 11B](https://huggingface.co/tiiuae/falcon-2-11b)) and connecting it to
the Nova Intelligence web UI so it becomes the first Nova I-Go
(`0.1.0-alpha.1`) assistant.

The instructions assume you are working on a Linux or macOS workstation that can
run Docker containers and Python tooling. Adapt the paths to your environment as
needed.

## 1. Choose and download a Falcon checkpoint

1. Ensure you have enough GPU memory for the chosen model:
   * **Falcon 7B Instruct** – runs comfortably on a single 12 GB GPU (or larger).
   * **Falcon 2 11B** – expect ~22 GB of VRAM for full-speed FP16 inference.
2. Install the [Hugging Face CLI](https://huggingface.co/docs/huggingface_hub/quick-start#login) and authenticate (`huggingface-cli login`).
3. Pull the model weights to a persistent cache directory (this avoids
   re-downloading when the inference server restarts):

   ```bash
   mkdir -p ~/hf-cache
   HF_HOME=~/hf-cache huggingface-cli download \
     tiiuae/falcon-7b-instruct --local-dir ~/hf-cache/falcon-7b-instruct
   # For Falcon 2 11B, swap in tiiuae/falcon-2-11b
   ```

   > **Tip:** If you have the VRAM budget, Falcon 2 11B offers noticeably better
   > quality. The rest of the guide works for either checkpoint.

## 2. Launch a Falcon inference server with vLLM

Nova Intelligence expects an OpenAI-compatible REST API. The
[`vLLM`](https://github.com/vllm-project/vllm) runtime exposes such an API for
Falcon models when `trust_remote_code` is enabled.

1. Install Python 3.9+ and create a virtual environment dedicated to the
   endpoint:

   ```bash
   python3 -m venv ~/envs/falcon-vllm
   source ~/envs/falcon-vllm/bin/activate
   pip install --upgrade pip
   pip install "vllm[serve]"==0.4.2
   ```

2. Start the server, pointing it at the local model weights. Stream the logs to
   the `artifacts/` directory for later review:

   ```bash
   mkdir -p artifacts
   HF_HOME=~/hf-cache \
   python -m vllm.entrypoints.openai.api_server \
     --model tiiuae/falcon-7b-instruct \
     --tensor-parallel-size 1 \
     --dtype half \
     --trust-remote-code \
     --host 0.0.0.0 \
     --port 8000 \
     --max-model-len 4096 \
     | tee artifacts/falcon-vllm.log
   ```

   *Swap `tiiuae/falcon-2-11b` for the model argument if you prefer the 11B
   checkpoint and have the VRAM to support it.*

3. In a second terminal, run a health check to confirm the server responds:

   ```bash
   curl -s http://127.0.0.1:8000/v1/models | jq
   ```

   You should see the Falcon model listed under `data[0].id`. Save the response
   in `artifacts/falcon-health.json` for the run record:

   ```bash
   curl -s http://127.0.0.1:8000/v1/models | tee artifacts/falcon-health.json
   ```

## 3. Start the Nova Intelligence container

Build (or pull) the Nova Intelligence Docker image from this repository and run
it side-by-side with the Falcon server.

```bash
git clone https://github.com/<your-org>/NovaIntelligence0.git
cd NovaIntelligence0

docker build -t nova-intel-ui .

# Expose the web UI on http://127.0.0.1:4173 and mount artifacts/
mkdir -p artifacts

docker run --rm \
  -p 4173:4173 \
  -p 8080:8080 \
  -e OPENAI_API_BASE="http://host.docker.internal:8000/v1" \
  -e OPENAI_API_KEY="falcon-local" \
  -e ENABLE_OPENAI_API=True \
  -v "$PWD/artifacts:/workspace/artifacts" \
  --name nova-intel-ui \
  nova-intel-ui
```

*If you are on Linux, replace `host.docker.internal` with the Docker host IP
(e.g., `172.17.0.1`).*

The container prints "Nova Intelligence is ready" once the UI and API proxy are
running. Capture the logs with `docker logs nova-intel-ui | tee artifacts/nova-intel.log` for
traceability.

## 4. Link Nova Intelligence to the Falcon endpoint

Once the UI is live (http://127.0.0.1:4173), verify that the built-in OpenAI
provider is pointing at the Falcon API:

1. Click the settings gear (top-right) → **Settings** → **Providers**.
2. Confirm **OpenAI** is toggled on and the base URL shows `http://host.docker.internal:8000/v1` (or the Linux host IP).
3. Set the display name to **Nova I-Go 0.1.0-alpha.1 (Falcon)** so the chat
   header reflects the first Nova I-Go assistant.
4. Create a new conversation and select the Falcon-backed provider if prompted.

## 5. Run verification chats and capture evidence

Use the following prompts to confirm the end-to-end flow. Run each in a fresh
chat to keep transcripts short.

1. **Connectivity check** – `Say exactly NOVA I-GO 0.1.0-alpha.1 OK`
2. **Math sanity check** – `What is 17 * 23?`
3. **Identity query** – `Who are you?`

For each conversation:

1. Ensure Falcon responds within expected latency and the answer is reasonable.
2. Click the **⋮** menu → **Download conversation** to save the JSON transcript
   into `artifacts/`, naming them `chat-connectivity.json`, `chat-math.json`, and
   `chat-identity.json`.

### Screenshot capture

Collect three screenshots to document the setup:

1. **Home screen after startup** – full-page capture once the UI loads.
2. **Settings panel** – showing the OpenAI provider configured for Falcon.
3. **Conversation results** – one capture per test chat, or a combined view if
   your browser supports scrolling screenshots.

Suggested tools:

```bash
# macOS (Safari Technology Preview)
safaridriver --enable
/Applications/Safari\ Technology\ Preview.app/Contents/MacOS/safaridriver \
  --url http://127.0.0.1:4173 --screenshot artifacts/nova-home.png

# Or use Chrome headless on Linux/macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --headless --disable-gpu \
  --screenshot=artifacts/nova-settings.png \
  "http://127.0.0.1:4173/settings"
```

Adjust the URLs to navigate the UI before taking a capture. Store the output
images under `artifacts/` and attach them in your report.

## 6. Optional: systemd service wrappers

To make the Falcon endpoint persistent across reboots, create systemd service
units:

*`~/.config/systemd/user/falcon-vllm.service`*

```ini
[Unit]
Description=Falcon vLLM OpenAI-compatible server
After=network.target

[Service]
Type=simple
Environment=HF_HOME=%h/hf-cache
ExecStart=%h/envs/falcon-vllm/bin/python -m vllm.entrypoints.openai.api_server \
  --model tiiuae/falcon-7b-instruct \
  --tensor-parallel-size 1 \
  --dtype half \
  --trust-remote-code \
  --host 0.0.0.0 \
  --port 8000 \
  --max-model-len 4096
WorkingDirectory=%h
Restart=on-failure

[Install]
WantedBy=default.target
```

Enable with `systemctl --user enable --now falcon-vllm.service`.

Create a similar unit for the Nova Intelligence container (using
[podman](https://podman.io/) or Docker) if you want the UI to auto-start.

---

Following the steps above yields a locally hosted Falcon model powering Nova
Intelligence. The saved artifacts (logs, health checks, chat transcripts, and
screenshots) provide the compliance evidence requested by stakeholders.
