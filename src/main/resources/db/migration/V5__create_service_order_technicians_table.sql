-- V5__create_service_order_technicians_table.sql
-- Junction table between service orders and technicians
-- Contains role attribute to define technician responsibility per order

CREATE TYPE technician_role AS ENUM (
    'LEAD',
    'SUPPORT'
);

CREATE TABLE service_order_technicians (
    id                  UUID                PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id    UUID                NOT NULL,
    technician_id       UUID                NOT NULL,
    role                technician_role     NOT NULL DEFAULT 'SUPPORT',
    assigned_at         TIMESTAMPTZ         NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_sot_service_order
        FOREIGN KEY (service_order_id)
        REFERENCES service_orders(id),

    CONSTRAINT fk_sot_technician
        FOREIGN KEY (technician_id)
        REFERENCES technicians(id),

    CONSTRAINT uq_sot_order_technician
        UNIQUE (service_order_id, technician_id)
);

CREATE INDEX idx_sot_service_order_id ON service_order_technicians(service_order_id);
CREATE INDEX idx_sot_technician_id    ON service_order_technicians(technician_id);
