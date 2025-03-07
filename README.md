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

- **Role:** Stock Logistics Coordinator (places an order for our own business)
- **Service:** `order-service` - Handles the creation and management of customer orders.
- **External Integrations:**
  - CRM systems for customer data synchronization - validate if the customer is valid and has authorization to draw on a warehouse.
- **Status:** Created

## 2. Order Processing

- **Role:** Order Management System (OMS) validates the order and checks inventory. Inventory Supervisor oversees stock allocation (no actions required).
- **Services:**
  - `inventory-service` - Manages inventory levels.
  - `order-service` - Allocates stock for orders.
  - `scheduling-service` - Schedules orders for fulfillment based on inventory and capacity. (Not needed now)
- **External Integrations:**
  - ERP systems for inventory updates - Not needed.
  - Supplier systems for stock replenishment - Not needed.
- **Status:**
  - processing -> error (on inventory check failure)
  - processing -> ready for picking (stock reserved for picking)

## 3. Picking

- **Role:** Warehouse Operator or Forklift / AGV Operator retrieve products from storage.
- **Services:**
  - `order-service` - Generates pick lists and coordinates the picking process.
  - `inventory-service` - Coordinates the picking process.
  - `automation-service` - Integrates with AGVs and automation tools for efficient picking.
- **External Integrations:**
  - IoT devices: `RFID scanners`, `barcode systems` for real-time tracking
  - Warehouse robotics API -- emulate on automation service by pausing time between progressing the picking
- **Status:**
  - Ready for picking -> error (if any error in picking service)
  - Ready for picking -> picking
  - Picking -> error (on any automation error)
  - Picking -> ready for packing (items are on the packing spot)

## 4. Packing

- **Role:** Packing Staff inspect, package, and label items for shipping. (To implement in later releases)
- **Service:** `automation-service`, `order-service` - Manages the packing process, ensuring items are correctly packaged and labeled.
- **External Integrations:**
  - Label printing systems - stub
  - Packaging automation solutions - not in the MVP
- **Status:**
  - ready for packing -> packing
  - packing -> packed
  - packed -> ready for order validation
  - ready for order validation -> validation
  - validation -> ready for shipping
  - With error flows at every step

## 5. Shipping

- **Role:** Outbound Coordinator organize shipments and assign carriers. Logistics Partners/Carriers transport packages to the customer. (External role in the Carrier company, doesn't use WMS)
- **Alternate flow:** **Outbound Coordinator** is checking the shipping site and assigning 'shipped' status on the UI.
- **Service:** `order-service` - Organizes shipments, assigns carriers, and tracks deliveries.
- **External Integrations:**
  - Courier services: `FedEx`, `UPS`, `DHL`, `Kityk Cargo Logistics System (KCLS)` - MVP only KCLS and manual if not KCLS
  - Transportation management systems (TMS) - Ignore for now
- **Status:**
  - ready for shipping -> shipping
  - shipping -> error (if shipping went bad)
  - shipping -> shipped

## 🚀 Next Steps

- **Optimize Deployment Strategies:** Kubernetes scaling, serverless options
- **Deep-dive into Microservices:** API contracts, inter-service communication
- **Performance Improvements:** Caching strategies, database indexing, event processing optimizations
- **AI/ML Enhancements:** Demand forecasting, route optimization for AGVs
- ArgoCD, Terraform (Infrastructure as Code) -- maybe, especially ArgoCD

---

📌 **This document provides a snapshot of the WMS architecture and tech stack. Future discussions will refine individual services, deployment, and optimization strategies.**

