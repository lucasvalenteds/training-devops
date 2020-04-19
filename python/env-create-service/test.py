import os
import json
import pytest

def test_post_create_env_returns_ok(client):
    os.environ.unsetenv("VAR_NAME")
    assert os.environ.get("VAR_NAME") == None

    response = client.post("/env/VAR_NAME/VAR_VALUE")
    assert response.status_code == 200
    assert json.loads(response.data)["VAR_NAME"] == "VAR_VALUE"

    assert os.environ["VAR_NAME"] == "VAR_VALUE"
