# Nova Intelligence (beta) Platform

This repository contains the building blocks required to rebrand the upstream project ([source](https://github.com/open-webui/open-webui)) as **Nova Intelligence (beta)** and to provide a multiplatform SwiftUI shell that can host the branded experience on Apple devices.

## Contents

| Path | Description |
| --- | --- |
| `Dockerfile` | Builds a Nova Intelligence (beta)-branded variant of the official upstream container image. |
| `swift/NovaIntelligenceApp` | SwiftUI application package capable of running on macOS, iOS, and tvOS. |

## Zero-dependency offline preview

If you simply want to explore the Nova Intelligence (beta) interface on macOS without Docker, localhost ports, or any backend setup, run the bundled SwiftUI shell. On first launch the app downloads the official Open WebUI 0.6.34 frontend from PyPI, rebrands it in place, and caches the result under `~/\.nova-intelligence/web-bundle` (macOS stores the cache inside *~/Library/Application Support/NovaIntelligence/WebBundle*). Subsequent launches reuse that cache so the experience opens instantly without hitting the network again.

```bash
cd NovaIntelligence0
./scripts/launch-mac.sh
```

The script compiles the Swift package if needed and launches the "Nova Intelligence (beta)" app window. From there you can:

* Interact with the offline chat sandbox to feel the navigation and styling.
* Open the toolbar address bar and paste a real Nova Intelligence (beta) deployment URL when you're ready to connect to a live backend.

> **Note:** The script requires the macOS Swift toolchain (installed automatically with Xcode 15+ or the standalone Swift installer). No additional dependencies are needed.

## Nova Intelligence (beta)-branded container image

The `Dockerfile` extends the upstream image and performs the following Nova Intelligence (beta) rebranding steps:

* Replaces human-visible strings so the upstream branding becomes "Nova Intelligence (beta)" everywhere in the bundle.
* Updates backend defaults to prevent the original brand suffix from reappearing at runtime.
* Renames custom HTTP headers to `X-Nova-*` variants for network consistency.
* Removes unused OLED/Her themes from the compiled frontend and limits the theme picker to System/Dark/Light.
* Scrubs any residual upstream suffixes left in static assets.
* Sets brand-focused default environment variables and allows optional asset injection at build time via the `NOVA_ASSETS_TARBALL` build argument.

Build the image locally (from the repository root so Docker can find the bundled `Dockerfile`):

```bash
cd NovaIntelligence0            # skip if you are already inside the repo folder
docker build -t nova-intelligence .
```

Run it on a fresh localhost port (4173 in this example):

```bash
docker run --rm -p 4173:8080 nova-intelligence
```

Then open <http://localhost:4173> in your browser to confirm the Nova Intelligence (beta) UI loads without errors.

Configure upstream model backends (for example, Llama 4) through the generated Nova Intelligence (beta) UI as you would with the upstream deployment.

> **Troubleshooting tip:** Seeing `failed to read dockerfile: open Dockerfile: no such file or directory` means the command was run from a directory that does not contain the project `Dockerfile`. Change into the cloned repository directory and rerun the command with the trailing `.` build context as shown above.

## Public web deployment on novaring.tech

The repository now ships with a production-ready Docker Compose stack that reverse-proxies Nova Intelligence (beta) behind [Caddy](https://caddyserver.com) and terminates HTTPS automatically. Use it to serve the application at **https://novaring.tech** on any Linux VPS or bare-metal host.

1. Provision an Ubuntu 22.04 (or similar) host with ports **80** and **443** exposed to the internet. Install Docker Engine and Docker Compose v2.
2. Clone this repository onto the server and enter the project directory.
3. Copy the environment template and adjust the values so they match your domain:

   ```bash
   cp .env.example .env
   ${EDITOR:-nano} .env
   ```

   Update `DOMAIN` and `NOVA_PUBLIC_URL` only if you plan to host the site on a different hostname. Leave both values as-is when deploying to **novaring.tech**.

4. Build and launch the stack:

   ```bash
   docker compose up -d
   ```

   The `nova-intelligence` service rebuilds the branded Open WebUI container, while the companion `proxy` service requests and renews TLS certificates via Let’s Encrypt.

5. Configure DNS at your registrar (GoDaddy in the provided screenshots):

   * Replace the default parked `A` record for `@` with the public IP address of your server.
   * Add a second `A` record for `www` pointing to the same IP (or configure `www` as a CNAME that targets `@`).
   * Remove the default `_domainconnect` CNAME entries so GoDaddy no longer overrides your custom configuration.

   DNS propagation typically completes within a few minutes, but it can take up to an hour worldwide.

6. Watch the proxy logs until you see the automatic certificate issuance succeed:

   ```bash
   docker compose logs -f proxy
   ```

7. Visit <https://novaring.tech> in your browser. You should see the Nova Intelligence (beta) interface, including login, workspace, and settings flows, all served from your domain with a valid TLS certificate.

Whenever you need to upgrade to a newer build, pull the latest repository changes and run `docker compose up -d --build` again. To stop the services, use `docker compose down`.

### Automating novaring.tech DNS updates

To push DNS changes to GoDaddy whenever you deploy, add the following repository secrets in GitHub (`Settings → Secrets and variables → Actions`):

| Secret | Purpose |
| --- | --- |
| `GODADDY_KEY` / `GODADDY_SECRET` | API credentials for your GoDaddy account. |
| `APEX_IP` | IPv4 address that should back the `@` A record for `novaring.tech`. Leave empty if you only need CNAMEs. |
| `EXTRA_CNAME_JSON` (optional) | JSON array describing any extra subdomains to CNAME (e.g. `[{"name":"app","target":"host.example.com"}]`). |

Once the secrets are in place, the [`Update GoDaddy DNS` workflow](.github/workflows/update-dns.yml) can be triggered manually or runs automatically on pushes to `main`. It updates the apex A record when `APEX_IP` is provided, ensures `www` points to the apex, and applies any additional CNAMEs you define.

## SwiftUI host application

The Swift package `swift/NovaIntelligenceApp` exposes a minimal executable product that wraps the Nova Intelligence (beta) web experience inside a `WKWebView` while providing room for native controls such as a toolbar, address bar, and settings sheet.

### Features

* **Unified codebase:** The same SwiftUI code runs across macOS, iOS, and tvOS with adaptive navigation chrome.
* **Brand-forward UI:** Toolbar colors and icons align with the Nova Intelligence (beta) palette and naming.
* **Configurable endpoint:** Users can adjust the backend URL via the in-app address bar, with validation helpers to normalize user input.
* **Extensible settings:** `@AppStorage` toggles illustrate how to persist Nova-specific preferences.

### Running in Xcode

1. Open the folder `swift/NovaIntelligenceApp` in Xcode 15 or newer (`File → Open…`).
2. Select the `NovaIntelligenceApp` scheme.
3. Choose the desired destination (iOS Simulator, My Mac, Apple TV, etc.).
4. Press **Run** to launch the hosted Nova Intelligence (beta) experience.

To point the shell at a production deployment, update the default URL in `NovaIntelligenceApp.swift` or adjust it at runtime through the address bar.

### Next steps

* Integrate secure authentication flows shared with the Docker deployment (e.g., OAuth, API tokens).
* Package the SwiftUI app as a signed `.app` bundle and submit to TestFlight for limited testing (<50 users) while securing the necessary enterprise license.
* When the Nova Intelligence (beta) LLM is ready, update the backend configuration to use the new inference endpoints without altering the Swift client.

## Syncing your local work to GitHub

All artifacts in this repository start on your machine. To publish updates to your private GitHub fork or origin repository:

```bash
git status                     # review pending changes
git add <files>                # stage the updates you want to share
git commit -m "Describe change"
git push origin <branch-name>  # replace with your working branch
```

If `git push` reports authentication issues, ensure your GitHub CLI session or personal access token has permission to update the target repository.
