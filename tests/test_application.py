from fastapi.testclient import TestClient

from application import app

client = TestClient(app)


def test_health_check():
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["version"] == "1.0.0"


def test_read_item():
    response = client.get("/items/42?q=test")
    assert response.status_code == 200
    data = response.json()
    assert data["item_id"] == 42
    assert data["query"] == "test"


def test_read_item_no_query():
    response = client.get("/items/1")
    assert response.status_code == 200
    data = response.json()
    assert data["item_id"] == 1
    assert data["query"] is None


def test_app_info():
    response = client.get("/info")
    assert response.status_code == 200
    data = response.json()
    assert data["app_name"] == "FastAPI CI/CD Demo"
    assert "/" in data["endpoints"]