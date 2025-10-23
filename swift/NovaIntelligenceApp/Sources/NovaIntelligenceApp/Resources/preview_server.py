import argparse
import json
import os
import posixpath
from http import HTTPStatus
from http.server import SimpleHTTPRequestHandler
from socketserver import ThreadingTCPServer
from urllib.parse import urlparse


DEFAULT_CONFIG = {
    "status": True,
    "name": "Nova Intelligence (beta)",
    "version": "v0.6.34",
    "default_locale": "en",
    "onboarding": False,
    "oauth": {"providers": {}},
    "features": {
        "auth": False,
        "auth_trusted_header": False,
        "enable_signup_password_confirmation": False,
        "enable_ldap": False,
        "enable_api_key": False,
        "enable_signup": False,
        "enable_login_form": True,
        "enable_websocket": False,
        "enable_version_update_check": False,
        "enable_direct_connections": False,
        "enable_channels": False,
        "enable_notes": False,
        "enable_web_search": False,
        "enable_code_execution": False,
        "enable_code_interpreter": False,
        "enable_image_generation": False,
        "enable_autocomplete_generation": False,
        "enable_community_sharing": False,
        "enable_message_rating": False,
        "enable_user_webhooks": False,
        "enable_admin_export": False,
        "enable_admin_chat_access": False,
        "enable_google_drive_integration": False,
        "enable_onedrive_integration": False,
        "enable_onedrive_personal": False,
        "enable_onedrive_business": False,
    },
    "default_models": [],
    "default_prompt_suggestions": [],
    "user_count": 1,
    "code": {"engine": ""},
    "audio": {
        "tts": {"engine": "", "voice": "", "split_on": ""},
        "stt": {"engine": ""},
    },
    "file": {
        "max_size": 10485760,
        "max_count": 10,
        "image_compression": {"width": 1024, "height": 1024},
    },
    "permissions": {},
    "google_drive": {
        "client_id": "stub-google-client",
        "api_key": "stub-google-key",
    },
    "onedrive": {
        "client_id_personal": "",
        "client_id_business": "",
        "sharepoint_url": "",
        "sharepoint_tenant_id": "",
    },
    "ui": {
        "pending_user_overlay_title": "",
        "pending_user_overlay_content": "",
        "response_watermark": "",
    },
    "license_metadata": {},
    "metadata": {"login_footer": "", "auth_logo_position": ""},
}

DEFAULT_CHANGELOG = {}

DEFAULT_VERSION = {"version": "v0.6.34"}
DEFAULT_VERSION_UPDATES = {"current": "v0.6.34", "latest": "v0.6.34"}

DEFAULT_SESSION = {
    "token": "offline-token",
    "token_type": "Bearer",
    "expires_at": None,
    "id": "offline-user",
    "email": "user@offline.local",
    "name": "Offline User",
    "role": "admin",
    "profile_image_url": None,
    "permissions": {},
}

DEFAULT_USER = {
    "id": "offline-user",
    "email": "user@offline.local",
    "name": "Offline User",
    "role": "admin",
    "profile_image_url": None,
    "bio": "",
    "gender": None,
    "date_of_birth": None,
    "permissions": {},
    "metadata": {},
    "settings": {},
}

DEFAULT_MODELS = [
    {
        "id": "openai/gpt-4o-mini",
        "name": "GPT-4o mini (Preview)",
        "provider": "openai",
        "type": "chat",
        "meta": {
            "description": "Demo model bundled with the offline preview.",
            "capabilities": ["chat", "vision"],
        },
        "params": {
            "temperature": 0.7,
            "top_p": 0.9,
        },
        "context_length": 128000,
        "preset": True,
    }
]

DEFAULT_WORKSPACES = [
    {
        "id": "offline",
        "name": "Offline Sandbox",
        "description": "Workspace populated with local demo data for the bundled Nova Intelligence (beta) preview.",
        "is_default": True,
        "default_model": DEFAULT_MODELS[0]["id"],
    }
]

DEFAULT_RESPONSES = {
    "GET": {
        "/api/config": DEFAULT_CONFIG,
        "/api/version": DEFAULT_VERSION,
        "/api/version/": DEFAULT_VERSION,
        "/api/version/updates": DEFAULT_VERSION_UPDATES,
        "/api/changelog": DEFAULT_CHANGELOG,
        "/api/v1/auths": DEFAULT_SESSION,
        "/api/v1/auths/": DEFAULT_SESSION,
        "/api/v1/auths/session": DEFAULT_SESSION,
        "/api/v1/users/self": DEFAULT_USER,
        "/api/v1/models": DEFAULT_MODELS,
        "/api/models": DEFAULT_MODELS,
        "/api/v1/workspaces": DEFAULT_WORKSPACES,
        "/api/v1/collections": [],
        "/api/v1/prompts": [],
        "/api/v1/assistants": [],
        "/api/v1/chats": [],
        "/api/v1/chats/": [],
        "/api/v1/tags": [],
        "/api/v1/configs/banners": [],
        "/api/v1/tools/": [],
        "/api/v1/users/user/settings": {},
        "/api/v1/channels/": [],
        "/api/v1/folders/": [],
        "/api/v1/chats/all/tags": [],
        "/api/v1/chats/pinned": [],
    },
    "POST": {
        "/api/v1/auths/signin": DEFAULT_SESSION,
        "/api/v1/auths/signout": {"status": True},
        "/api/v1/users/user/settings/update": {"status": True},
    },
}


def _normalized_path(path: str) -> str:
    parsed = urlparse(path)
    return parsed.path


class PreviewHandler(SimpleHTTPRequestHandler):
    server_version = "NovaPreview/1.0"

    def __init__(self, *args, directory=None, **kwargs):
        super().__init__(*args, directory=directory, **kwargs)

    def do_OPTIONS(self):
        path = _normalized_path(self.path)
        if path.startswith("/api/"):
            self.send_response(HTTPStatus.NO_CONTENT)
            self._send_common_headers()
            self.send_header("Access-Control-Allow-Methods", "GET,POST,OPTIONS")
            self.send_header(
                "Access-Control-Allow-Headers", "Content-Type, Authorization"
            )
            self.end_headers()
        else:
            super().do_OPTIONS()

    def do_GET(self):
        path = _normalized_path(self.path)
        if path in DEFAULT_RESPONSES["GET"]:
            payload = DEFAULT_RESPONSES["GET"][path]
            self._send_json(payload)
            return
        if path == "/ws/socket.io/":
            self._send_json({"detail": "Socket connections are disabled in the offline preview."}, status=HTTPStatus.NOT_FOUND)
            return
        super().do_GET()

    def do_POST(self):
        path = _normalized_path(self.path)
        if path in DEFAULT_RESPONSES["POST"]:
            payload = DEFAULT_RESPONSES["POST"][path]
            cookies = []
            if path == "/api/v1/auths/signin":
                cookies.append("token=offline-token; Path=/; HttpOnly")
            elif path == "/api/v1/auths/signout":
                cookies.append("token=; Path=/; Max-Age=0")
            self._send_json(payload, cookies=cookies)
            return
        if path.startswith("/api/"):
            self._send_json({"detail": f"Endpoint '{path}' is not available in the offline preview."}, status=HTTPStatus.NOT_FOUND)
            return
        self.send_error(HTTPStatus.NOT_IMPLEMENTED)

    def end_headers(self):
        origin = self.headers.get("Origin")
        if origin:
            self.send_header("Access-Control-Allow-Origin", origin)
        else:
            self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Credentials", "true")
        super().end_headers()

    def translate_path(self, path):
        # Use SimpleHTTPRequestHandler's translation but ensure directory is respected
        path = _normalized_path(path)
        if path.startswith("/api/"):
            # Map API requests to root directory for potential static fallbacks
            path = path[1:]
        return super().translate_path(path)

    def _send_common_headers(self):
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Type", "application/json")

    def _send_json(self, payload, status=HTTPStatus.OK, cookies=None):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self._send_common_headers()
        self.send_header("Content-Length", str(len(body)))
        if cookies:
            for cookie in cookies:
                self.send_header("Set-Cookie", cookie)
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        # Prefix logs to differentiate API vs static requests
        super().log_message(format, *args)


def run_server(root: str, port: int) -> None:
    handler = lambda *args, **kwargs: PreviewHandler(*args, directory=root, **kwargs)
    with ThreadingTCPServer(("0.0.0.0", port), handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass


def main():
    parser = argparse.ArgumentParser(description="Nova Intelligence (beta) preview server")
    parser.add_argument("--root", required=True, help="Directory containing the extracted Nova Intelligence (beta) build")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind the preview server to")
    args = parser.parse_args()

    root = os.path.abspath(args.root)
    if not os.path.isdir(root):
        raise SystemExit(f"error: preview root '{root}' does not exist or is not a directory")

    run_server(root, args.port)


if __name__ == "__main__":
    main()
