# Repair Shop Management System

A production-grade microservices backend for managing repair shop operations — built to demonstrate real-world software engineering skills including distributed systems design, domain-driven development, cloud deployment, and security best practices.

> **Status:** 🚧 In active development — Phase 1 (customer-service) in progress

---

## Table of Contents

1. [Architecture](#1-architecture)
2. [Services](#2-services)
3. [Technology Stack](#3-technology-stack)
4. [Security](#4-security)
5. [Getting Started](#5-getting-started)
6. [API Documentation](#6-api-documentation)
7. [Running Tests](#7-running-tests)
8. [Deployment](#8-deployment)
9. [Roadmap](#9-roadmap)

---

## 1. Architecture

### 1.1 Design Choices

This system is built as **independent microservices**, each owning its domain, its database, and its deployment lifecycle. Services communicate through two patterns:

- **Synchronous (HTTP)** — via API Gateway using Spring Cloud Gateway, for real-time requests (e.g. fetching a customer record)
- **Asynchronous (Event-Driven)** — via Apache Kafka, for operations that should not block the caller (e.g. sending notifications when an order is completed)

**Domain-Driven Design (DDD)** was chosen because the repair shop domain has meaningful bounded contexts — a customer is not the same concept in the order context as it is in the notification context. Each service models its own version of shared entities independently.

```
                        ┌─────────────────────────────────────────────────────┐
                        │                    API Gateway :8080                │
                        │            (routing · auth · rate limiting)         │
                        └──────┬──────────┬──────────┬──────────┬────────────┘
                               │          │          │          │
                    ┌──────────▼──┐ ┌─────▼──────┐ ┌▼──────────┐ ┌▼────────────┐
                    │  customer   │ │   order    │ │technician │ │  payment    │
                    │  service   │ │  service   │ │  service  │ │  service    │
                    │  :8081     │ │  :8082     │ │  :8083    │ │  :8084      │
                    └──────┬─────┘ └─────┬──────┘ └───────────┘ └─────────────┘
                           │             │
                           │        ┌────▼──────────────────────┐
                           │        │        Apache Kafka        │
                           │        │  (OrderCreated · Payment   │
                           │        │   Processed · StatusChange)│
                           │        └────────────┬──────────────┘
                           │                     │
                           │             ┌───────▼──────────┐
                           │             │  notification    │
                           │             │  service :8085   │
                           │             └──────────────────┘
                           │
                    ┌──────▼──────────────────────────────────────┐
                    │                  Redis Cache                 │
                    └─────────────────────────────────────────────┘
```

### 1.2 Package Structure (per service)

Every service follows the same internal structure based on Clean Architecture principles, enforcing the **Dependency Rule** — outer layers depend on inner layers, never the reverse:

```
com.repairshop.<service>/
├── domain/           # Entities, value objects, repository interfaces — no framework dependencies
├── application/      # Use cases, DTOs, mappers — orchestrates domain logic
├── infrastructure/   # JPA repositories, Kafka producers/consumers, external adapters
├── web/              # REST controllers, exception handlers — entry points only
└── config/           # Spring beans, Swagger, security config
```

---

## 2. Services

| Service | Port | Responsibility | Database |
|---|---|---|---|
| `api-gateway` | 8080 | Single entry point — routing, JWT validation, rate limiting | — |
| `customer-service` | 8081 | Customer registration and management | PostgreSQL (customers_db) |
| `order-service` | 8082 | Service order lifecycle and status management | PostgreSQL (orders_db) |
| `technician-service` | 8083 | Technician profiles and assignments | PostgreSQL (technicians_db) |
| `payment-service` | 8084 | Payment recording and processing | PostgreSQL (payments_db) |
| `notification-service` | 8085 | Email/push notifications via Kafka events | — |

Each service has its **own isolated database**. Services never share a database or call each other's data layer directly — this is a hard architectural constraint.

---

## 3. Technology Stack

### Backend
| Technology | Version | Purpose |
|---|---|---|
| Java | 21 | Language — Virtual Threads (Project Loom) for efficient concurrency |
| Spring Boot | 3.3.x | Application framework |
| Spring Cloud Gateway | 4.x | API Gateway and routing |
| Spring Data JPA + Hibernate | 6.x | ORM and database access |
| Spring Security | 6.x | Authentication and authorization |
| Apache Kafka | 3.x | Asynchronous event streaming between services |
| Redis | 7.x | Distributed cache for frequent reads |
| Flyway | 10.x | Database schema versioning and migrations |
| Springdoc OpenAPI | 2.x | Swagger UI and API documentation at `/api/v1/docs` |

### Infrastructure
| Technology | Purpose |
|---|---|
| Docker + Docker Compose | Containerization and local development environment |
| Kubernetes (EKS) | Container orchestration and horizontal scaling |
| GitHub Actions | CI/CD pipelines — build, test, push image, deploy |
| Prometheus + Grafana | Metrics collection and dashboards |
| OpenTelemetry + Jaeger | Distributed tracing across services |
| Loki | Centralized log aggregation |

### Cloud (AWS)
| Service | Purpose |
|---|---|
| ECS Fargate / EKS | Container hosting |
| RDS PostgreSQL | Managed database per service |
| ElastiCache (Redis) | Managed cache |
| MSK (Kafka) | Managed Kafka cluster |
| ALB | Application Load Balancer |
| ECR | Docker image registry |
| Secrets Manager | Credentials and environment secrets |
| IAM | Identity and access management — least privilege per service |

### Frontend
| Technology | Purpose |
|---|---|
| React + Vite | UI framework and build tool |
| TypeScript | Type safety |
| Tailwind CSS | Styling |
| React Query | Server state management and caching |

---

## 4. Security

Security is applied at multiple layers — no single point of trust.

### 4.1 Authentication and Authorization
- **JWT (JSON Web Tokens)** — stateless authentication validated at the API Gateway level; services receive pre-validated claims
- **Role-based access control (RBAC)** — roles: `ADMIN`, `TECHNICIAN`, `CUSTOMER`; enforced at both gateway and service level
- **Short-lived access tokens** (15 min) with **refresh token rotation** — stolen tokens expire quickly
- Passwords hashed with **BCrypt** (cost factor ≥ 12)

### 4.2 API Security
- **Rate limiting** at the gateway — per IP and per authenticated user, preventing brute force and DoS
- **CORS** configured explicitly — no wildcard origins in production
- **HTTPS only** in production — HTTP redirected to HTTPS at load balancer level
- **Input validation** on every request with Jakarta Bean Validation — `@NotBlank`, `@Email`, `@Size`, `@Positive`
- **SQL injection prevention** — all queries go through JPA/Hibernate with parameterized statements; no raw string concatenation in queries

### 4.3 Data Security
- **Soft delete** on sensitive entities (`deleted_at` column) — data is never permanently destroyed without explicit action, preserving audit history
- **Audit fields** on all entities (`created_at`, `updated_at`) — full record of when data changed
- **No sensitive data in logs** — customer PII (email, phone) is masked in log output
- **No secrets in source code** — all credentials loaded from environment variables or AWS Secrets Manager; `.env` files are gitignored

### 4.4 Infrastructure Security
- **IAM least privilege** — each AWS service has its own role with only the permissions it needs; no shared root credentials
- **VPC isolation** — databases and internal services are not publicly accessible; only the load balancer is internet-facing
- **Security groups** — each service communicates only with the services it needs
- **Secrets rotation** — database credentials rotated automatically via AWS Secrets Manager

### 4.5 Kafka Security
- **Authentication** between producers and consumers via SASL
- **Topic-level authorization** — each service can only publish/consume from its own topics
- Messages do not contain raw PII — only IDs and event types; services fetch full data from their own source if needed

---

## 5. Getting Started

### Prerequisites
- Docker and Docker Compose installed
- Java 21+
- Maven 3.9+

### Running locally

Clone the repository and copy the environment file:

```bash
git clone https://github.com/yourusername/repair-shop-management-system.git
cd repair-shop-management-system
cp .env.example .env
```

Start all infrastructure (PostgreSQL per service, Redis, Kafka, pgAdmin):

```bash
docker compose up -d
```

Run a specific service:

```bash
cd customer-service
./mvnw spring-boot:run
```

The customer-service will be available at `http://localhost:8081` and its Swagger UI at `http://localhost:8081/api/v1/docs`.

### Environment variables

Copy `.env.example` to `.env` and fill in the values. Never commit the `.env` file.

```env
# Customer Service DB
CUSTOMER_DB_HOST=localhost
CUSTOMER_DB_PORT=5432
CUSTOMER_DB_NAME=customers_db
CUSTOMER_DB_USER=
CUSTOMER_DB_PASSWORD=

# JWT
JWT_SECRET=
JWT_EXPIRATION_MS=900000

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
```

---

## 6. API Documentation

Each service exposes its own Swagger UI when running:

| Service | Swagger UI |
|---|---|
| customer-service | `http://localhost:8081/api/v1/docs` |
| order-service | `http://localhost:8082/api/v1/docs` |
| technician-service | `http://localhost:8083/api/v1/docs` |
| payment-service | `http://localhost:8084/api/v1/docs` |

All endpoints follow the pattern `/api/v1/<resource>` and return consistent response envelopes.

---

## 7. Running Tests

Each service has unit tests (Mockito) and integration tests (Testcontainers with real PostgreSQL):

```bash
cd customer-service

# All tests
./mvnw test

# Only unit tests
./mvnw test -Dgroups=unit

# Only integration tests
./mvnw test -Dgroups=integration
```

Integration tests spin up a real PostgreSQL container automatically — no manual setup needed.

---

## 8. Deployment

CI/CD pipelines run automatically on push via GitHub Actions:

1. Build and run all tests
2. Build Docker image (multi-stage build)
3. Push image to AWS ECR
4. Deploy to ECS Fargate / EKS

Each service has its own pipeline and deploys independently — a change in `payment-service` does not trigger a deployment of `customer-service`.

---

## 9. Roadmap

- [x] Project structure and architecture definition
- [ ] **Phase 1** — `customer-service` with full CRUD, Swagger, tests
- [ ] **Phase 2** — remaining services + Kafka event flow + API Gateway
- [ ] **Phase 3** — Docker multi-stage builds + GitHub Actions CI/CD + AWS deploy
- [ ] **Phase 4** — Kubernetes manifests + Grafana/Prometheus observability
- [ ] **Phase 5** — React frontend + S3/CloudFront deploy

---

## Author

**João Henrique**  
[LinkedIn](https://www.linkedin.com/in/joao-henrique-monteiro-alves/) · [GitHub](https://github.com/joaohmalves)