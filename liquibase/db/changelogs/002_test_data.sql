-- Insert test data for products, customers, orders, order items, locations, and stock with fixed IDs

-- Products
INSERT INTO wms_schema.products (id, sku, name, category, description, created_at, updated_at) VALUES
    (1, 'SKU001', 'Product A', 'Category Alpha', 'Description for Product A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'SKU002', 'Product B', 'Category Beta', 'Description for Product B', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Customers
INSERT INTO wms_schema.customers (id, name, email, phone, address, created_at, updated_at) VALUES
    (1, 'Customer One', 'one@example.com', '111-222-3333', '123 Main St', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Customer Two', 'two@example.com', '444-555-6666', '456 Elm St', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Orders
INSERT INTO wms_schema.orders (id, customer_id, order_date, status, total_amount, created_at, updated_at) VALUES
    (1, 1, CURRENT_TIMESTAMP, 'Pending', 100.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 2, CURRENT_TIMESTAMP, 'Processing', 250.50, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Order Items
INSERT INTO wms_schema.order_items (id, order_id, product_id, quantity, price, created_at, updated_at) VALUES
    (1, 1, 1, 2, 50.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 2, 2, 1, 250.50, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 10 Test Locations
INSERT INTO wms_schema.locations (id, aisle, bin, created_at) VALUES
    (1, 'Aisle 1', 'Bin 1', CURRENT_TIMESTAMP),
    (2, 'Aisle 1', 'Bin 2', CURRENT_TIMESTAMP),
    (3, 'Aisle 2', 'Bin 1', CURRENT_TIMESTAMP),
    (4, 'Aisle 2', 'Bin 2', CURRENT_TIMESTAMP),
    (5, 'Aisle 3', 'Bin 1', CURRENT_TIMESTAMP),
    (6, 'Aisle 3', 'Bin 2', CURRENT_TIMESTAMP),
    (7, 'Aisle 4', 'Bin 1', CURRENT_TIMESTAMP),
    (8, 'Aisle 4', 'Bin 2', CURRENT_TIMESTAMP),
    (9, 'Aisle 5', 'Bin 1', CURRENT_TIMESTAMP),
    (10, 'Aisle 5', 'Bin 2', CURRENT_TIMESTAMP);

-- Stock for some locations (using fixed product and location references)
INSERT INTO wms_schema.stock (product_id, location_id, quantity, updated_at) VALUES
    (1, 1, 100, CURRENT_TIMESTAMP),
    (2, 2, 50, CURRENT_TIMESTAMP),
    (1, 3, 20, CURRENT_TIMESTAMP);
