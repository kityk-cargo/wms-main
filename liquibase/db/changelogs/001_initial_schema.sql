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
    quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
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

-- Customers Table
CREATE TABLE IF NOT EXISTS wms_schema.customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE IF NOT EXISTS wms_schema.orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES wms_schema.customers(id),
    order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL, -- e.g., 'Pending', 'Processing', 'Shipped', 'Delivered'
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS wms_schema.order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES wms_schema.orders(id),
    product_id BIGINT REFERENCES wms_schema.products(id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- Price at the time of order
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Inventory Table
CREATE TABLE IF NOT EXISTS wms_schema.inventory (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES wms_schema.products(id),
    location_id BIGINT REFERENCES wms_schema.locations(id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Shipments Table
CREATE TABLE IF NOT EXISTS wms_schema.shipments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES wms_schema.orders(id),
    shipment_date TIMESTAMPTZ,
    carrier VARCHAR(100),
    tracking_number VARCHAR(100),
    status VARCHAR(50) NOT NULL, -- e.g., 'Awaiting Pickup', 'In Transit', 'Delivered'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE IF NOT EXISTS wms_schema.payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES wms_schema.orders(id),
    payment_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50), -- e.g., 'Credit Card', 'PayPal', 'Bank Transfer'
    transaction_id VARCHAR(100),
    status VARCHAR(50) NOT NULL, -- e.g., 'Pending', 'Completed', 'Failed'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

