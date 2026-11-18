import io
import json
from unittest.mock import patch

from app.client import build_models_url, fetch_models


def test_build_models_url():
    assert build_models_url("192.168.56.101") == "http://192.168.56.101:30080/v1/models"


def test_fetch_models():
    sample_payload = {"object": "list", "data": [{"id": "TinyLlama"}]}
    fake_response = io.BytesIO(json.dumps(sample_payload).encode("utf-8"))
    fake_response.__enter__ = lambda self: self
    fake_response.__exit__ = lambda self, *args: None

    with patch("urllib.request.urlopen", return_value=fake_response):
        result = fetch_models("192.168.56.101")

    assert result["object"] == "list"
    assert result["data"][0]["id"] == "TinyLlama"
