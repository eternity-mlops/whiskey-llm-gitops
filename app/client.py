import json
import urllib.request


def build_models_url(host: str, port: int = 30080) -> str:
    return f"http://{host}:{port}/v1/models"


def fetch_models(host: str, port: int = 30080, timeout: float = 5.0) -> dict:
    url = build_models_url(host, port)
    with urllib.request.urlopen(url, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))
