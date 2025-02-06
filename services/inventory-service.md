# Minimal Viable Implementation of Inventory Management

To get hands-on quickly, the first prototype should include:

## Product Management
- Add new products
- Update product details (name, category, etc.)
- List all products

## Stock Tracking
- Add stock (inbound operation)
- Deduct stock (outbound operation)
- Get current stock levels for a product

## Basic Location Tracking (Optional, but Useful)
- Store which aisle/bin a product is in
- Move a product between locations

## Basic API Endpoints (for MVP)
Using Java (Spring Boot) or Python (FastAPI):

### Products
- `POST /products` – Add a new product
- `GET /products` – List all products
- `GET /products/{id}` – Get details of a product
- `PUT /products/{id}` – Update product info

### Stock
- `POST /stock/inbound` – Add stock (receiving)
- `POST /stock/outbound` – Remove stock (order fulfillment)
- `GET /stock/{product_id}` – Get current stock level

### Locations (Optional)
- `POST /locations/{product_id}` – Assign product to a bin/location
- `PUT /locations/{product_id}` – Move product to another bin
- `GET /locations/{product_id}` – Get product location