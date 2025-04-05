# Order Management System (OMS) - MVP -- FLOW TODO

## Overview
The Order Management System (OMS) handles order creation, fulfillment, and status tracking within the Warehouse Management System (WMS). This MVP provides core functionalities necessary for order processing.

## Tech Stack
- **Backend:** Java (Spring Boot) / Python (FastAPI)
- **API:** RESTful
- **Database:** PostgreSQL (primary), MongoDB (logs)
- **Messaging:** Apache Kafka (event-driven processing)
- **Security:** OAuth2 + JWT authentication

## Core Features
- **Create Order**
- **Retrieve Orders**
- **Update Order** 
- **Cancel Order**
- **Allocate Inventory** 
- **Update Order Status** 

## Integration with Inventory
- **Stock Reservation:** On order creation
- **Stock Deduction:** On shipment
- **Stock Release:** On cancellation

## Security
- OAuth2 authentication (JWT)
- Role-based access control (RBAC)

## Future Enhancements
- Payment processing integration
- Advanced order routing
- Customer notifications
