PRAGMA foreign_keys = ON;

INSERT INTO photographers
(id, first_name, last_name, phone, email, experience_years, status)
VALUES
(1, 'Ivan', 'Petrenko', '+380991111111', 'ivan.petrenko@test.com', 5, 'active'),
(2, 'Olena', 'Koval', '+380672222222', 'olena.koval@test.com', 3, 'active');

INSERT INTO clients
(id, first_name, last_name, phone, email, registration_date, notes)
VALUES
(1, 'Andrii', 'Melnyk', '+380933333333', 'andrii.melnyk@test.com', '2026-05-01 10:00:00', 'portrait client'),
(2, 'Maria', 'Shevchenko', '+380634444444', 'maria.shevchenko@test.com', '2026-05-02 11:00:00', 'family photoshoot');

INSERT INTO locations
(id, country, city, street, building, location_category, unit, description)
VALUES
(1, 'Ukraine', 'Lviv', 'Bandery', '12', 'studio', '4A', 'Main studio'),
(2, 'Ukraine', 'Lviv', 'Svobody', '1', 'outdoor', NULL, 'Outdoor city center location');

INSERT INTO service_categories
(id, name, description)
VALUES
(1, 'Portrait', 'Portrait photography services'),
(2, 'Family', 'Family photography services');

INSERT INTO services
(id, name, description, price, duration_minutes, status, category_id)
VALUES
(1, 'CV portrait', 'Professional CV photo session', 800, 60, 'active', 1),
(2, 'Family session', 'Family photo session', 1500, 120, 'active', 2);

INSERT INTO equipment
(id, name, category, brand, serial_number, purchase_date, status)
VALUES
(1, 'Camera EOS R', 'camera', 'Canon', 'CANON-001', '2024-01-10 10:00:00', 'available'),
(2, 'Softbox 90cm', 'light', 'Godox', 'GODOX-001', '2024-02-15 12:00:00', 'available');

INSERT INTO shoots
(id, start_datetime, end_datetime, location_id, photographer_id, client_id, status, total_price)
VALUES
(1, '2026-05-10 12:00:00', '2026-05-10 14:00:00', 1, 1, 1, 'done', 800),
(2, '2026-05-11 15:00:00', '2026-05-11 17:00:00', 2, 2, 2, 'planned', 1500);

INSERT INTO shoot_services
(shoot_id, service_id, quantity, price_at_time)
VALUES
(1, 1, 1, 800),
(2, 2, 1, 1500);

INSERT INTO shoot_equipment
(shoot_id, equipment_id, usage_notes, hours_used)
VALUES
(1, 1, 'Main camera', 2),
(1, 2, 'Lighting setup', 2),
(2, 1, 'Outdoor camera usage', 2);
