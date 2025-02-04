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

| **Service**                       | **Repository**                                                                      | **Responsibilities**                                               | **Tech Stack**                                                                         |
| --------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| **API Gateway**                   | [wms-gateway](https://github.com/kityk-cargo/wms-gateway)                           | Manages routing, security, and rate limiting                       | Kong or Apache APISIX, OAuth2, Keycloak, JWT-based authentication               |
| **User & Auth Service**           | [wms-auth-access-control](https://github.com/kityk-cargo/wms-auth-access-control)   | Handles authentication, RBAC (Role-Based Access Control)           | Java (Spring Boot), PostgreSQL, Hibernate, OAuth2, Keycloak                            |
| **Inventory Management Service**  | [wms-inventory-management](https://github.com/kityk-cargo/wms-inventory-management) | Tracks stock levels, updates warehouse locations, low-stock alerts | Python (FastAPI), PostgreSQL, SQLAlchemy, Apache Kafka                                 |
| **Order Management Service**      | [wms-order-management](https://github.com/kityk-cargo/wms-order-management)         | Manages order lifecycle, fulfillment, and e-commerce integration   | Java (Spring Boot), PostgreSQL, Hibernate, Apache Kafka                                |
| **Warehouse Automation Service**  | [wms-warehouse-automation](https://github.com/kityk-cargo/wms-warehouse-automation) | Controls AGVs, barcode scanners, IoT devices integration           | Python (FastAPI), MQTT, AWS IoT Core, MongoDB, SQLAlchemy                              |
| **Notification & Alerts Service** | [wms-notification](https://github.com/kityk-cargo/wms-notification)                 | Sends alerts for stock shortages, order delays, machine failures   | Python (FastAPI), Apache Kafka, WebSockets                                           |
| **Reports & Analytics Service**   | [wms-reports](https://github.com/kityk-cargo/wms-reports)                           | Provides dashboards, efficiency tracking, real-time insights       | Python (FastAPI), GraphQL, PostgreSQL, SQLAlchemy, Apache Kafka                        |
| **UI Service**                    | [wms-ui](https://github.com/kityk-cargo/wms-ui)                                     | Manages frontend interfaces, dashboards, and user interactions     | React.js (Next.js), Tailwind CSS or Material UI, RTK Query / Redux Toolkit, WebSockets |
| **GitOps**                        | [wms-gitops](https://github.com/kityk-cargo/wms-gitops)                             | Manages deployments                                                | Docker, Kubernetes (K8s), GitHub Actions                                               |

## 🚀 Next Steps

- **Optimize Deployment Strategies:** Kubernetes scaling, serverless options
- **Deep-dive into Microservices:** API contracts, inter-service communication
- **Performance Improvements:** Caching strategies, database indexing, event processing optimizations
- **AI/ML Enhancements:** Demand forecasting, route optimization for AGVs
- ArgoCD, Terraform (Infrastructure as Code) -- maybe, especially ArgoCD

---

📌 **This document provides a snapshot of the WMS architecture and tech stack. Future discussions will refine individual services, deployment, and optimization strategies.**

