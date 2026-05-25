from fastapi import FastAPI, HTTPException

from app.db import fetch_all, fetch_one

app = FastAPI(
    title="Photostudio API",
    description="REST API for SQLite photostudio database",
    version="1.0.0",
)


@app.get("/")
def root():
    return {
        "status": "ok",
        "message": "Photostudio API is running",
    }


@app.get("/clients")
def get_clients():
    return fetch_all("""
        SELECT id, first_name, last_name, phone, email, registration_date, notes
        FROM clients
        ORDER BY id;
    """)


@app.get("/clients/{client_id}")
def get_client(client_id: int):
    client = fetch_one("""
        SELECT id, first_name, last_name, phone, email, registration_date, notes
        FROM clients
        WHERE id = ?;
    """, (client_id,))

    if client is None:
        raise HTTPException(status_code=404, detail="Client not found")

    return client


@app.get("/photographers")
def get_photographers():
    return fetch_all("""
        SELECT id, first_name, last_name, phone, email, experience_years, status
        FROM photographers
        ORDER BY id;
    """)


@app.get("/shoots")
def get_shoots():
    return fetch_all("""
        SELECT
            shoots.id,
            shoots.start_datetime,
            shoots.end_datetime,
            shoots.status,
            shoots.total_price,
            clients.first_name || ' ' || clients.last_name AS client,
            photographers.first_name || ' ' || photographers.last_name AS photographer,
            locations.city || ', ' || locations.street AS location
        FROM shoots
        JOIN clients ON clients.id = shoots.client_id
        JOIN photographers ON photographers.id = shoots.photographer_id
        JOIN locations ON locations.id = shoots.location_id
        ORDER BY shoots.id;
    """)


@app.get("/services")
def get_services():
    return fetch_all("""
        SELECT
            services.id,
            services.name,
            services.price,
            services.duration_minutes,
            services.status,
            service_categories.name AS category
        FROM services
        JOIN service_categories ON service_categories.id = services.category_id
        ORDER BY services.id;
    """)


@app.get("/equipment")
def get_equipment():
    return fetch_all("""
        SELECT id, name, category, brand, serial_number, purchase_date, status
        FROM equipment
        ORDER BY id;
    """)


@app.get("/shoots/{shoot_id}/details")
def get_shoot_details(shoot_id: int):
    shoot = fetch_one("""
        SELECT
            shoots.id,
            shoots.start_datetime,
            shoots.end_datetime,
            shoots.status,
            shoots.total_price,
            clients.first_name || ' ' || clients.last_name AS client,
            photographers.first_name || ' ' || photographers.last_name AS photographer,
            locations.city || ', ' || locations.street AS location
        FROM shoots
        JOIN clients ON clients.id = shoots.client_id
        JOIN photographers ON photographers.id = shoots.photographer_id
        JOIN locations ON locations.id = shoots.location_id
        WHERE shoots.id = ?;
    """, (shoot_id,))

    if shoot is None:
        raise HTTPException(status_code=404, detail="Shoot not found")

    services = fetch_all("""
        SELECT
            services.name,
            shoot_services.quantity,
            shoot_services.price_at_time
        FROM shoot_services
        JOIN services ON services.id = shoot_services.service_id
        WHERE shoot_services.shoot_id = ?;
    """, (shoot_id,))

    equipment = fetch_all("""
        SELECT
            equipment.name,
            equipment.brand,
            shoot_equipment.hours_used,
            shoot_equipment.usage_notes
        FROM shoot_equipment
        JOIN equipment ON equipment.id = shoot_equipment.equipment_id
        WHERE shoot_equipment.shoot_id = ?;
    """, (shoot_id,))

    shoot["services"] = services
    shoot["equipment"] = equipment

    return shoot
