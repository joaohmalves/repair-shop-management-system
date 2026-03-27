-- V4__create_service_orders_table.sql
-- Stores repair requests created for devices

CREATE TYPE service_order_status AS ENUM (
    'OPEN',
    'IN_PROGRESS',
    'WAITING_PART',
    'COMPLETED',
    'CANCELLED'
);

CREATE TABLE service_orders (
    id          UUID                    PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id   UUID                    NOT NULL,
    status      service_order_status    NOT NULL DEFAULT 'OPEN',
    description TEXT,
    created_at  TIMESTAMPTZ             NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ             NOT NULL DEFAULT NOW(),
    deleted_at  TIMESTAMPTZ,

    CONSTRAINT fk_service_orders_device
        FOREIGN KEY (device_id)
        REFERENCES devices(id)
);

CREATE INDEX idx_service_orders_device_id ON service_orders(device_id);
CREATE INDEX idx_service_orders_status    ON service_orders(status);
