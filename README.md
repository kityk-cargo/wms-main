# Warehouse Management System (WMS) - Tech Decisions

## 📌 Project Overview

This Warehouse Management System (WMS) is designed for a **medium-sized, general-purpose warehouse**. It focuses on **real-time inventory tracking, order management, warehouse automation, and scalability**.

## 🏗️ Architecture & Tech Stack

### **Backend**

- **Language:** Java (**Spring Boot**) AND Python (**FastAPI**)
- **API:** REST (primary) + GraphQL (optional for analytics)
- **Security:** OAuth2, Keycloak, JWT-based authentication
- **Real-time Processing:** WebSockets for UI updates

### **Frontend**

- **Framework:** React.js (**Next.js**) (Server-Side Rendering for performance)
- **UI Framework:** Tailwind CSS or Material UI
- **State Management:** RTK Query / Redux Toolkit

### **Databases**

- **Primary DB:** PostgreSQL (Transactional Data)
- **Secondary DB:** MongoDB (Event Logs & Semi-structured Data)
- **ORM:** Hibernate (Java) / SQLAlchemy (Python)

### **Messaging System**

- **Primary Choice:** Apache Kafka (Event-driven Processing)
- **Alternative:** RabbitMQ (Simpler Message Queue)

### **IoT & Automation**

- **Devices:** AGVs, barcode/RFID scanners, warehouse sensors
- **Communication Protocol:** MQTT (for RFID & IoT Integration)
- **Cloud IoT Service:** AWS IoT Core (or Azure IoT Hub)

### **Cloud & Deployment**

- **Cloud Providers:** AWS / GCP / Azure (Based on Infra)
- **Containerization:** Docker & Kubernetes (K8s)
- **CI/CD:** GitHub Actions
## 🔥 Microservices Breakdown

| **Service**                       | **Repository**                                                                      | **Responsibilities**                                               | **Main Thing**                                             | **Tech Stack**                                                                         |
| --------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **API Gateway**                   | [wms-gateway](https://github.com/kityk-cargo/wms-gateway)                           | Manages routing, security, and rate limiting                       | "What do we serve? How often?"                              | Kong or Apache APISIX, OAuth2, Keycloak, JWT-based authentication                        |
| **User & Auth Service**           | [wms-auth-access-control](https://github.com/kityk-cargo/wms-auth-access-control)   | Handles authentication, RBAC (Role-Based Access Control)           | "Who is accessing the system and what can they do?"         | Java (Spring Boot), PostgreSQL, Hibernate, OAuth2, Keycloak                            |
| **Inventory Management Service**  | [wms-inventory-management](https://github.com/kityk-cargo/wms-inventory-management) | Tracks stock levels, updates warehouse locations, low-stock alerts | "What do we have in stock?"                                 | Python (FastAPI), PostgreSQL, SQLAlchemy, Apache Kafka                                 |
| **Order Management Service**      | [wms-order-management](https://github.com/kityk-cargo/wms-order-management)         | Manages order lifecycle, fulfillment, and e-commerce integration   | "What do we need to deliver and how and where?"             | Java (Spring Boot), PostgreSQL, Hibernate, Apache Kafka                                |
| **Warehouse Automation Service**  | [wms-warehouse-automation](https://github.com/kityk-cargo/wms-warehouse-automation) | Controls AGVs, barcode scanners, IoT devices integration           | "How do we automate warehouse operations?"                  | Python (FastAPI), MQTT, AWS IoT Core, MongoDB, SQLAlchemy                              |
| **Notification & Alerts Service** | [wms-notification](https://github.com/kityk-cargo/wms-notification)                 | Sends alerts for stock shortages, order delays, machine failures   | "What needs immediate attention and how make everyone REACT?" | Python (FastAPI), Apache Kafka, WebSockets                                           |
| **Reports & Analytics Service**   | [wms-reports](https://github.com/kityk-cargo/wms-reports)                           | Provides dashboards, efficiency tracking, real-time insights       | "What are the key metrics and insights?"                    | Python (FastAPI), GraphQL, PostgreSQL, SQLAlchemy, Apache Kafka                        |
| **UI Service**                    | [wms-ui](https://github.com/kityk-cargo/wms-ui)                                     | Manages frontend interfaces, dashboards, and user interactions     | "How do users interact with the system?"                    | React.js (Next.js), Tailwind CSS or Material UI, RTK Query / Redux Toolkit, WebSockets |
| **GitOps**                        | [wms-gitops](https://github.com/kityk-cargo/wms-gitops)                             | Manages deployments                                                | "Where and how we are deployed?"                             | Docker, Kubernetes (K8s), GitHub Actions                                               |
| **Contracts**                     | [wms-contracts](https://github.com/kityk-cargo/wms-contracts)                      | Holds inter-service communication contracts | "Who is talking with who about what? And how" | Pact |


# Order Processing Flow (MVP)

This document outlines the minimal viable process for handling an order in the Warehouse Management System (WMS).

Not all of the services here exist. Probably some of them wil end up not existing in the end.

## 1. Order Creation

- **Customer** places an order through an online platform or a sales representative.
- **Sales Representative** may manually enter orders for customers.
- **Service:** `order-service` - Handles the creation and management of customer orders.
- **External Integrations:**
  - E-commerce platforms: `Shopify`, `Magento`
  - CRM systems for customer data synchronization

## 2. Order Processing

- **Order Management System (OMS)** validates the order and checks inventory.
- **Inventory Manager** ensures stock is allocated for fulfillment.
- **Services:**
  - `inventory-service` - Manages inventory levels and allocates stock for orders.
  - `scheduling-service` - Schedules orders for fulfillment based on inventory and capacity.
- **External Integrations:**
  - ERP systems for inventory updates
  - Supplier systems for stock replenishment

## 3. Picking

- **Warehouse Operatives** retrieve products from storage.
- **Automated Systems (AGVs, barcode/RFID scanners)** assist in locating and transporting items.
- **Services:**
  - `order-service` - Generates pick lists and coordinates the picking process.
  - `automation-service` - Integrates with AGVs and automation tools for efficient picking.
- **External Integrations:**
  - IoT devices: `RFID scanners`, `barcode systems` for real-time tracking
  - Warehouse robotics API

## 4. Packing

- **Packing Staff** inspect, package, and label items for shipping.
- **Service:** `order-service` - Manages the packing process, ensuring items are correctly packaged and labeled.
- **External Integrations:**
  - Label printing systems
  - Packaging automation solutions

## 5. Shipping

- **Shipping Coordinators** organize shipments and assign carriers.
- **Logistics Partners/Carriers** transport packages to the customer.
- **Service:** `order-service` - Organizes shipments, assigns carriers, and tracks deliveries.
- **External Integrations:**
  - Courier services: `FedEx`, `UPS`, `DHL`
  - Transportation management systems (TMS)

## 6. Delivery Confirmation

- **Customer Service Representatives** provide updates on order status.
- **Accounting Department** finalizes financial transactions post-delivery.
- **Services:**
  - `notification-service` - Sends updates to customers regarding order status and delivery confirmations.
  - `order-service` - Handles financial transactions, invoicing, and payment processing post-delivery.
- **External Integrations:**
  - Payment gateways: `Stripe`, `PayPal`
  - Customer support platforms: `Zendesk`, `Salesforce Service Cloud`

This flow ensures efficient order fulfillment, leveraging automation, external integrations, and human roles to optimize warehouse operations.


## 🚀 Next Steps

- **Optimize Deployment Strategies:** Kubernetes scaling, serverless options
- **Deep-dive into Microservices:** API contracts, inter-service communication
- **Performance Improvements:** Caching strategies, database indexing, event processing optimizations
- **AI/ML Enhancements:** Demand forecasting, route optimization for AGVs
- ArgoCD, Terraform (Infrastructure as Code) -- maybe, especially ArgoCD

---

📌 **This document provides a snapshot of the WMS architecture and tech stack. Future discussions will refine individual services, deployment, and optimization strategies.**

