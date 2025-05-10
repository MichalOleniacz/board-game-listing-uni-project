# BoardGameHub Backend

A backend service for board game lovers to review, rate, and explore games — built from scratch with pure Java, no frameworks, and a modular, production-grade architecture.

---

## Project Overview

BoardGameHub is a platform that allows users to:
- Browse and review board games
- View and filter game rankings
- Search for rental locations (libraries, stores)
- Authenticate and manage user sessions
- Use an admin dashboard to view KPIs and moderate content

This project is built entirely **without frameworks or libraries** (e.g., no Spring, no Jackson, etc.) to demonstrate a strong grasp of core Java, clean architecture, and design patterns.

---

## Architecture Highlights

- **HTTP Server**: Built using `com.sun.net.httpserver.HttpServer`
- **Routing System**: Custom DSL with middleware and method-based routing
- **Design Patterns**: Strategy, Singleton, Decorator, Template Method
- **Modular Structure**: Layered architecture evolving into hexagonal (Ports & Adapters)
- **Config**: Properties-based config loading with optional Docker overrides
- **Persistence (upcoming)**: PostgreSQL via JDBC with pluggable repository interfaces
- **Testing**: JUnit 5 with full unit test coverage of core modules
- **Dockerized Services**: Compose-ready for PostgreSQL, Adminer, and the backend app

---

## System Requirements

- **Java 21** or newer
- **Maven 3.9+**
- **Docker & Docker Compose** (for database and full-stack runs)

---

## Local Development Setup

### 1. Clone the repository

```bash
git clone https://github.com/your-org/boardgamehub-backend.git
cd boardgamehub-backend
```

### 2. Run Postgres + Adminer via Docker

```bash
docker-compose up -d
```

> This starts:
> - PostgreSQL at `localhost:5432`
> - Adminer at `http://localhost:8081`

### 3. Run the backend app locally

- In IntelliJ or your IDE, run the `Main` class.
- Or from terminal:

```bash
mvn compile exec:java
```

---

## Full Stack via Docker

If you want to run **the app + services** fully in Docker:

```bash
docker-compose --profile full up --build
```

App is then available at `http://localhost:8080`

---

## Configuration

All configuration is loaded from `app.properties` or `/config/app.properties` (in Docker):

```properties
log.level=DEBUG
server.port=8080

db.url=jdbc:postgresql://localhost:5432/boardgamehub
db.user=postgres
db.pass=example
```

---

## Running Tests

```bash
mvn test
```

Tests cover:
- Route resolution
- Path param extraction
- Middleware execution
- Config loading

---

## Project Structure

```
src/
├── main/java/backend/
│   ├── http/               # HTTP server, router, dispatcher
│   ├── controller/         # Ping, Auth, Admin
│   ├── service/            # Business logic
│   ├── repository/         # Interfaces for persistence
│   ├── infra/postgres/     # JDBC implementations
│   ├── util/               # Logger, config, etc.
│   └── Main.java           # Entry point
└── test/java/backend/      # Unit tests
```

---

## 📚 Roadmap (Upcoming Features)

- [ ] User registration and login
- [ ] Session management (with Redis support)
- [ ] Game listings and reviews
- [ ] Admin dashboard with KPIs
- [ ] Role-based access control
- [ ] Full hexagonal refactor (ports/adapters)
- [ ] JSON body parsing
