# Architecture Overview — BoardGameHub Backend

This document provides a high-level technical overview of the architecture for the BoardGameHub backend project.

---

## Overview

BoardGameHub is a backend system designed with production-level structure and extensibility in mind. It avoids external frameworks to demonstrate full control over the request lifecycle, system composition, and core design patterns.

---

## Core Architectural Principles

- **Frameworkless by design** — no Spring, Jakarta EE, or third-party libraries
- **Clean layering**:
    - HTTP layer (routing, dispatching)
    - Controller layer
    - Service layer
    - Repository layer
- **Evolving toward hexagonal architecture** (Ports and Adapters)
- **Custom routing system** using method + path + middleware chaining
- **Composable middleware** using functional-style decorators
- **Configurable via `.properties` files or Docker volume**

---

## Layered Structure

```
backend/
├── Main.java                # Entry point
├── http/                   # HttpServer, Router, Dispatcher, ResponseBuilder
├── controller/             # Request handlers (Ping, User, Admin)
├── service/                # Business logic (auth, reviews, game logic)
├── repository/             # Interfaces for data persistence
├── util/                   # Logger, Config, etc.
└── config/                 # AppConfig singleton, properties loader
```

---

## HTTP Layer

- **Server**: Java’s built-in `HttpServer`
- **Router**: Custom DSL-like route registration via `RouteRegistry`
- **Dispatcher**: Central `RouteDispatcher` resolves path + method
- **Path Params**: Supported via `:param` syntax (e.g. `/games/:id`)
- **Middleware**: Defined as `Middleware -> RouteHandler`, composed in reverse
- **ResponseBuilder**: Builder abstraction for HTTP responses

Example route:

```java
RouteRegistry.route("GET", "/ping/:id")
    .middleware(LoggerMiddleware.logRequest())
    .handler(PingController::handleById);
```

---

## Auth & Sessions (Planned)

- Role-based access control
- Session-based cookie management
- Optional Redis integration for distributed session storage

---

## Testing Strategy

- **JUnit 5** based unit tests
- Test modules:
    - Path matching
    - Middleware chaining
    - Route resolution
    - Config loading
- Planned: fake `HttpExchange` for end-to-end handler testing

---

## Deployment & DevOps

- Dockerized app, Postgres, and Adminer
- Dev runs locally with `docker-compose` DB, live reload in IntelliJ
- Full stack runs with:  
  `docker-compose -f docker-compose.yml -f docker-compose.full.yml up --build`

---

## Roadmap for Hexagonal Refactor

- Extract ports (interfaces) for service and repository layers
- Move adapters to `infra/{adapter}`
- Isolate use cases into `application/` layer
- Add controller → use case → port → adapter flow

---

## Observability (Planned)

- Unified `Logger` with log levels and caller class
- Request logging middleware
- Metrics endpoint (`/admin/stats`) planned for future

---

## Design Patterns in Use

| Pattern | Usage |
|--------|-------|
| Singleton | `AppConfig`, `SessionManager` |
| Strategy | `UserRepository`, `SessionRepository` |
| Decorator | Middleware composition |
| Template Method | Shared base handler class |
| Builder | `HttpResponseBuilder` |
| Command (planned) | Use-case encapsulation |

---

## Summary

BoardGameHub backend is a modular, production-grade, frameworkless Java application with a strong foundation in clean design, testability, and containerization. It is well-suited for growth into a fully hexagonal, maintainable system.

