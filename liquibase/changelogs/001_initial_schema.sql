-- Product table to store product information
CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    -- Storage Keeping Unit (SKU) - unique product identifier
    -- Format: alphanumeric, max 50 characters
    -- Examples: 'ABC123', 'T-SHIRT-L-RED', '12345-B'
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Location table to store warehouse locations
CREATE TABLE IF NOT EXISTS locations (
    id BIGSERIAL PRIMARY KEY,
    aisle VARCHAR(50) NOT NULL,
    bin VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(aisle, bin)
);

-- Stock table to track current inventory levels
CREATE TABLE IF NOT EXISTS stock (
    product_id BIGINT REFERENCES products(id),
    location_id BIGINT REFERENCES locations(id),
    quantity INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id, location_id)
);

-- Stock movement history for audit trail
CREATE TABLE IF NOT EXISTS stock_movements (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    location_id BIGINT REFERENCES locations(id),
    movement_type VARCHAR(20) CHECK (movement_type IN ('INBOUND', 'OUTBOUND')),
    quantity INTEGER NOT NULL,
    reference_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better query performance
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_stock_movements_product_id ON stock_movements(product_id);
CREATE INDEX idx_stock_movements_created_at ON stock_movements(created_at);

-- Trigger to update products.updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();