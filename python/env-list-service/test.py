import json
import pytest

def test_get_env_returns_ok(client):
    response = client.get("/conf/env")
    assert response.status_code == 200
    assert json.loads(response.data)["variables"]
