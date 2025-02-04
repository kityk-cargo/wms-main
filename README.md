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
| **Service** | **Repository** | **Responsibilities** | **Main Thing** |
|------------|----------------------------------------------|----------------------|-------------------|
| **API Gateway** | [wms-gateway](https://github.com/kityk-cargo/wms-gateway) | Manages routing, security, and rate limiting | "What do we serve? How often?" |
| **User & Auth Service** | [wms-auth-access-control](https://github.com/kityk-cargo/wms-auth-access-control) | Handles authentication, RBAC (Role-Based Access Control) | "Who is accessing the system and what can they do?" |
| **Inventory Management Service** | [wms-inventory-management](https://github.com/kityk-cargo/wms-inventory-management) | Tracks stock levels, updates warehouse locations, low-stock alerts | "What do we have in stock?" |
| **Order Management Service** | [wms-order-management](https://github.com/kityk-cargo/wms-order-management) | Manages order lifecycle, fulfillment, and e-commerce integration | "What do we need to deliver and how and where?" |
| **Warehouse Automation Service** | [wms-warehouse-automation](https://github.com/kityk-cargo/wms-warehouse-automation) | Controls AGVs, barcode scanners, IoT devices integration | "How do we automate warehouse operations?" |
| **Notification & Alerts Service** | [wms-notification](https://github.com/kityk-cargo/wms-notification) | Sends alerts for stock shortages, order delays, machine failures | "What needs immediate attention and how make everyone REACT?" |
| **Reports & Analytics Service** | [wms-reports](https://github.com/kityk-cargo/wms-reports) | Provides dashboards, efficiency tracking, real-time insights | "What are the key metrics and insights?" |
| **UI Service** | [wms-ui](https://github.com/kityk-cargo/wms-ui) | Manages frontend interfaces, dashboards, and user interactions | "How do users interact with the system?" |
| **GitOps** | [wms-gitops](https://github.com/kityk-cargo/wms-gitops) | Manages deployments | "Where and how we are deployed?" |

## 🚀 Next Steps
- **Optimize Deployment Strategies:** Kubernetes scaling, serverless options
- **Deep-dive into Microservices:** API contracts, inter-service communication
- **Performance Improvements:** Caching strategies, database indexing, event processing optimizations
- **AI/ML Enhancements:** Demand forecasting, route optimization for AGVs
- ArgoCD, Terraform (Infrastructure as Code) -- maybe, especially ArgoCD 

---
📌 **This document provides a snapshot of the WMS architecture and tech stack. Future discussions will refine individual services, deployment, and optimization strategies.**
