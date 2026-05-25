import subprocess

from fastapi.testclient import TestClient

from app.main import app


def setup_module():
    subprocess.run(["./scripts/init-db.sh"], check=True)


client = TestClient(app)


def test_root_endpoint():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_clients_endpoint_returns_clients():
    response = client.get("/clients")

    assert response.status_code == 200
    data = response.json()

    assert isinstance(data, list)
    assert len(data) >= 1
    assert data[0]["first_name"]


def test_single_client_exists():
    response = client.get("/clients/1")

    assert response.status_code == 200
    assert response.json()["id"] == 1


def test_single_client_not_found():
    response = client.get("/clients/9999")

    assert response.status_code == 404


def test_photographers_endpoint():
    response = client.get("/photographers")

    assert response.status_code == 200
    assert len(response.json()) >= 1


def test_shoots_endpoint_contains_joined_data():
    response = client.get("/shoots")

    assert response.status_code == 200
    data = response.json()

    assert len(data) >= 1
    assert "client" in data[0]
    assert "photographer" in data[0]
    assert "location" in data[0]


def test_services_endpoint():
    response = client.get("/services")

    assert response.status_code == 200
    data = response.json()

    assert len(data) >= 1
    assert "category" in data[0]


def test_shoot_details_endpoint():
    response = client.get("/shoots/1/details")

    assert response.status_code == 200
    data = response.json()

    assert "services" in data
    assert "equipment" in data
    assert len(data["services"]) >= 1
    assert len(data["equipment"]) >= 1
