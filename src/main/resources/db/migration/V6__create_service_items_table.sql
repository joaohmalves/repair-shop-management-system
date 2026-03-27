-- V6__create_service_items_table.sql
-- Stores individual service items (labor + parts) within a service order

CREATE TABLE service_items (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id    UUID            NOT NULL,
    description         TEXT            NOT NULL,
    unit_price          NUMERIC(10,2)   NOT NULL,
    quantity            SMALLINT        NOT NULL DEFAULT 1,
    part_name           VARCHAR(120),
    part_used           BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_service_items_order
        FOREIGN KEY (service_order_id)
        REFERENCES service_orders(id),

    CONSTRAINT chk_service_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_service_items_quantity
        CHECK (quantity > 0)
);

CREATE INDEX idx_service_items_order_id ON service_items(service_order_id);
