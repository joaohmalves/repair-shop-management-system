-- V1__create_customers_table.sql
-- Stores repair shop clients

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE customers (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100)    NOT NULL,
    phone       VARCHAR(20),
    email       VARCHAR(150)    NOT NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    deleted_at  TIMESTAMPTZ,

    CONSTRAINT uq_customers_email UNIQUE (email)
);

CREATE INDEX idx_customers_email ON customers(email);
