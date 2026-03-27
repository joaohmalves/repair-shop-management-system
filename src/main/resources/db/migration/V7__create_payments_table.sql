-- V7__create_payments_table.sql
-- Stores payments made for service orders (partial or full)

CREATE TYPE payment_method AS ENUM (
    'CASH',
    'CARD',
    'PIX',
    'TRANSFER'
);

CREATE TABLE payments (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id    UUID            NOT NULL,
    amount              NUMERIC(10,2)   NOT NULL,
    payment_method      payment_method  NOT NULL,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,

    CONSTRAINT fk_payments_service_order
        FOREIGN KEY (service_order_id)
        REFERENCES service_orders(id),

    CONSTRAINT chk_payments_amount
        CHECK (amount > 0)
);

CREATE INDEX idx_payments_service_order_id ON payments(service_order_id);
