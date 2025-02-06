--comment: Initial schema setup for WMS

-- Create custom schema
CREATE SCHEMA IF NOT EXISTS wms_schema;

-- Product table to store product information
CREATE TABLE IF NOT EXISTS wms_schema.products (
    id BIGSERIAL PRIMARY KEY,
    -- Storage Keeping Unit (SKU) - unique product identifier
    -- Format: alphanumeric, max 50 characters
    -- Examples: 'ABC123', 'T-SHIRT-L-RED', '12345-B'
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Location table to store warehouse locations
CREATE TABLE IF NOT EXISTS wms_schema.locations (
    id BIGSERIAL PRIMARY KEY,
    aisle VARCHAR(50) NOT NULL,
    bin VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (aisle, bin)
);

-- Stock table to track current inventory levels
CREATE TABLE IF NOT EXISTS wms_schema.stock (
    product_id BIGINT REFERENCES wms_schema.products(id),
    location_id BIGINT REFERENCES wms_schema.locations(id),
    quantity INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id, location_id)
);

-- Stock movement history for audit trail
CREATE TABLE IF NOT EXISTS wms_schema.stock_movements (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES wms_schema.products(id),
    location_id BIGINT REFERENCES wms_schema.locations(id),
    movement_type VARCHAR(20) CHECK (movement_type IN ('INBOUND', 'OUTBOUND')),
    quantity INTEGER NOT NULL,
    reference_number VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better query performance
CREATE INDEX idx_products_sku ON wms_schema.products(sku);
CREATE INDEX idx_stock_movements_product_id ON wms_schema.stock_movements(product_id);
CREATE INDEX idx_stock_movements_created_at ON wms_schema.stock_movements(created_at);

-- Trigger function to update products.updated_at
CREATE OR REPLACE FUNCTION wms_schema.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update products.updated_at on update
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON wms_schema.products
    FOR EACH ROW
    EXECUTE FUNCTION wms_schema.update_updated_at_column();

--rollback DROP TRIGGER IF EXISTS update_products_updated_at ON wms_schema.products;
--rollback DROP FUNCTION IF EXISTS wms_schema.update_updated_at_column();
--rollback DROP INDEX IF EXISTS idx_stock_movements_created_at;
--rollback DROP INDEX IF EXISTS idx_stock_movements_product_id;
--rollback DROP INDEX IF EXISTS idx_products_sku;
--rollback DROP TABLE IF EXISTS wms_schema.stock_movements;
--rollback DROP TABLE IF EXISTS wms_schema.stock;
--rollback DROP TABLE IF EXISTS wms_schema.locations;
--rollback DROP TABLE IF EXISTS wms_schema.products;
--rollback DROP SCHEMA IF EXISTS wms_schema;