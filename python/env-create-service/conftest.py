import pytest
from flask import Flask
from main import create_app

@pytest.fixture
def app():
    yield create_app("test-create-env-var")

@pytest.fixture
def client(app):
    return app.test_client()
