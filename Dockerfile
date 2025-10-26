FROM ghcr.io/open-webui/open-webui:main

# --- Brand visible strings ---
RUN find /app -type f \
    \( -name "*.html" -o -name "*.js" -o -name "*.css" -o -name "*.json" -o -name "*.md" -o -name "*.py" \) \
    -print0 \
  | xargs -0 sed -i \
    -e 's/Open WebUI/Nova Intelligence (beta)/g' \
    -e 's/>WebUI</>Nova Intelligence (beta)</g' \
    -e 's/"WebUI"/"Nova Intelligence (beta)"/g' \
    -e 's/ WebUI / Nova Intelligence (beta) /g'

# --- Stop auto-appending the upstream suffix (comment the logic; no newlines in sed) ---
RUN sed -i 's/WEBUI_NAME = os\.environ\.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Nova Intelligence (beta)")/' /app/backend/open_webui/env.py && \
    sed -i 's/^ *if WEBUI_NAME != .*/# branding suffix check disabled/' /app/backend/open_webui/env.py && \
    sed -i 's/^ *WEBUI_NAME \+= .*/# suffix append disabled/' /app/backend/open_webui/env.py

# --- Rename custom headers on the wire ---
RUN sed -i 's/X-OpenWebUI-User-Name/X-Nova-User-Name/g' /app/backend/open_webui/retrieval/utils.py && \
    sed -i 's/X-OpenWebUI-User-Id/X-Nova-User-Id/g'     /app/backend/open_webui/retrieval/utils.py

# --- Hard remove the extra themes from the compiled bundle (keep System/Dark/Light only) ---
RUN set -e; JS="$(ls /app/build/_app/immutable/nodes/2.*.js | head -n1)"; \
    perl -0777 -i -pe 's/A=g\("option"\).*?u\(p,A\),\s*//s' "$JS"; \
    perl -0777 -i -pe 's/R=g\("option"\).*?u\(p,R\),\s*//s' "$JS"; \
    sed -i -E 's/\["dark","light","oled-dark"\]/["dark","light"]/g' "$JS" || true; \
    sed -i -E '/OLED Dark|oled-dark|🌷 Her|"her"/d' "$JS" || true

# --- Remove literal upstream suffix remnants in static assets ---
RUN find /app -type f -print0 | xargs -0 sed -i -E 's/[[:space:]]*\(Open WebUI\)//g'

# --- Default env overrides for Nova Intelligence (beta) ---
ENV WEBUI_NAME="Nova Intelligence (beta)" \
    BRAND_COLOR_PRIMARY="#3B2FF3" \
    BRAND_COLOR_ACCENT="#7C5CFF"

# --- Place custom Nova Intelligence (beta) assets / overrides here (optional build arg) ---
ARG NOVA_ASSETS_TARBALL=none
COPY --chmod=755 <<'NOVA_SCRIPT' /tmp/apply_nova_assets.sh
#!/bin/bash
set -euo pipefail
if [[ "${NOVA_ASSETS_TARBALL}" != "none" && -f "${NOVA_ASSETS_TARBALL}" ]]; then
  tar -xzf "${NOVA_ASSETS_TARBALL}" -C /app
fi
NOVA_SCRIPT
RUN /tmp/apply_nova_assets.sh && rm -f /tmp/apply_nova_assets.sh
