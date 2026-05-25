PRAGMA foreign_keys = ON;

CREATE TABLE photographers (
    id integer PRIMARY KEY ,
    first_name text NOT NULL CHECK (LENGTH(first_name) <= 50),
    last_name text NOT NULL CHECK (LENGTH(last_name) <= 50),
    phone text UNIQUE 
    CHECK (phone IS NULL OR phone GLOB '+[0-9]*' OR phone GLOB '[0-9]*'),
    email text UNIQUE
    CHECK (email IS NULL OR (LENGTH(email) <= 75 AND email glob '*@*.*')), 
    experience_years integer NOT NULL CHECK (experience_years BETWEEN 0 AND 99),
    status text NOT NULL 
    CHECK (status IN ('active', 'vacation', 'fired')),
    CHECK (phone IS NOT NULL OR email IS NOT NULL) 
);

CREATE TABLE clients (
    id integer PRIMARY KEY ,
    first_name text NOT NULL CHECK (LENGTH(first_name) <= 50),
    last_name text NOT NULL CHECK (LENGTH(last_name) <= 50),
    phone text UNIQUE 
    CHECK (phone IS NULL or phone GLOB '+[0-9]*' OR phone GLOB '[0-9]*'),
    email text UNIQUE 
    CHECK (email IS NULL OR (LENGTH(email) <= 75 AND email glob '*@*.*')), 
    registration_date text NOT NULL
    DEFAULT (datetime('now'))
    CHECK (registration_date = strftime('%Y-%m-%d %H:%M:%S', registration_date)),  
    notes text CHECK (LENGTH(notes) <= 512),
    CHECK (phone IS NOT NULL OR email IS NOT NULL)
);

CREATE TABLE locations (
    id integer PRIMARY KEY,
    country text NOT NULL CHECK (LENGTH(country) <= 50),
    city text NOT NULL CHECK (LENGTH(city) <= 50),
    street text CHECK (LENGTH(street) <= 100),
    building text CHECK (LENGTH(building) <= 20),
    location_category text NOT NULL
    CHECK (location_category IN ('studio', 'outdoor', 'clients_home', 'other')),
    unit text CHECK (LENGTH(unit) <= 20),
    description text CHECK (LENGTH(description) <= 500)
);

CREATE TABLE shoots(
    id integer PRIMARY KEY,
    start_datetime text NOT NULL
    DEFAULT (datetime('now'))
    CHECK (start_datetime = strftime('%Y-%m-%d %H:%M:%S', start_datetime)), 
    end_datetime text NOT NULL
    CHECK (end_datetime = strftime('%Y-%m-%d %H:%M:%S', end_datetime)),
    location_id integer NOT NULL,
    photographer_id integer NOT NULL,
    client_id integer NOT NULL,
    status text NOT NULL 
    CHECK (status IN ('planned', 'done', 'cancelled')), 
    total_price REAL NOT NULL 
    CHECK (total_price >= 0),
    FOREIGN KEY (location_id) REFERENCES locations (id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (photographer_id) REFERENCES photographers (id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients (id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (end_datetime > start_datetime)
);


CREATE TABLE service_categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE CHECK (LENGTH(name) <= 50),
    description TEXT CHECK (LENGTH(description) <= 500)
);

CREATE TABLE services (  
    id integer PRIMARY KEY,  
    name text NOT NULL CHECK (LENGTH(name) <= 100),  
    description text CHECK (LENGTH(description) <= 500),
    price REAL NOT NULL CHECK(price >= 0),  
    duration_minutes integer NOT NULL CHECK( duration_minutes > 0),  
    status text NOT NULL CHECK (status IN ('active', 'inactive', 'deprecated', 'maintenance')),  
    category_id INTEGER NOT NULL,  
    FOREIGN KEY (category_id) REFERENCES service_categories(id)  
);  
  

CREATE TABLE equipment (
    id integer PRIMARY KEY,
    name text NOT NULL
    CHECK (LENGTH(name) <= 150),
    category text CHECK (LENGTH(category) <= 50),
    brand text CHECK (LENGTH(brand) <= 50),
    serial_number text NOT NULL,
    purchase_date text
        CHECK (
            purchase_date IS NULL OR
            purchase_date = strftime('%Y-%m-%d %H:%M:%S', purchase_date)
        ),
    status text NOT NULL
    CHECK (status IN ('available', 'broken', 'rented')),
    UNIQUE (brand, serial_number)
);

CREATE TABLE shoot_services (
    shoot_id integer NOT NULL,
    service_id integer NOT NULL,
    quantity integer NOT NULL CHECK (quantity > 0),
    price_at_time REAL NOT NULL CHECK (price_at_time >= 0),
    PRIMARY KEY (shoot_id, service_id),
    FOREIGN KEY (shoot_id) REFERENCES shoots(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
) WITHOUT ROWID;

CREATE TABLE shoot_equipment (
    shoot_id integer NOT NULL,
    equipment_id integer NOT NULL,
    usage_notes text CHECK (LENGTH(usage_notes) <= 500),
    hours_used integer NOT NULL CHECK (hours_used >= 0), 
    PRIMARY KEY (shoot_id, equipment_id),
    FOREIGN KEY (shoot_id) REFERENCES shoots(id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(id)

) WITHOUT ROWID;
