-- V2__create_devices_table.sql
-- Stores electronic devices owned by customers

CREATE TABLE devices (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id     UUID            NOT NULL,
    brand           VARCHAR(80)     NOT NULL,
    model           VARCHAR(80)     NOT NULL,
    serial_number   VARCHAR(100),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,

    CONSTRAINT fk_devices_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT uq_devices_serial_number
        UNIQUE (serial_number)
);

CREATE INDEX idx_devices_customer_id ON devices(customer_id);
