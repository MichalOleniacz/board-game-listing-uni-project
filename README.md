# BoardGameHub Backend

A backend service for board game lovers to review, rate, and explore games — built from scratch in **pure Java**, with no frameworks or third-party libraries. The goal is to demonstrate deep understanding of architecture, design patterns, and production-quality backend design.

---

## Project Overview

BoardGameHub enables users to:

- Browse and filter board game listings
- Submit and read reviews
- View ranking pages (filterable by category and location)
- Register, log in, and manage user sessions
- Moderate users and content through an admin dashboard

Built to enforce modularity, testability, and real-world scalability.

---

## Architectural Patterns

- **Layered architecture** (HTTP, middleware, controller, service, persistence)
- **MVC** structure with RESTful routes
- **Domain-Driven Design-inspired structure**
- **ComponentRegistry-based dependency injection**
- **Configurable persistence layer using strategy + factory patterns**
- **Stateless, pluggable middleware pipeline**

---

## GoF Design Patterns Used

| Pattern         | Where                                                   |
|----------------|---------------------------------------------------------|
| Singleton       | `AppConfig`, `ComponentRegistry`, `HttpServerSingleton` |
| Builder         | `ResponseContext`, `RouteBuilder`                       |
| Strategy        | `PasswordHasherStrategy`, `Repositories`                |
| Factory Method  | `RepositoryFactory`, `JsonMapper.mapToRecord(...)`      |
| Adapter         | `JdbcPostgresAdapter`, `RedisClient`                    |
| Decorator       | Middleware chaining                                     |
| Template Method | Middleware design structure                             |

---

## System Requirements

- **Java 21**
- **Maven 3.9+**
- **Docker** and **Docker Compose**

---

## Local Development Setup

### 1. Clone and Navigate

```bash
git clone https://github.com/your-org/boardgamehub-backend.git
cd boardgamehub-backend
```

### 2. Start Database + Adminer

```bash
docker-compose up -d
```

- PostgreSQL → `localhost:5432`
- Adminer UI → `http://localhost:8081`

### 3. Run Backend in IDE or CLI

```bash
mvn clean compile exec:java
```

Or use Docker:

```bash
docker-compose --profile dev up --build
```

---

## Running Tests

```bash
mvn test
```

Includes unit tests for:
- JSON parsing and serialization
- Request routing
- Middleware behavior
- Repository logic (with JDBC)
- Config loader and logger

---

## Database Support

- **PostgreSQL**: used via `DriverManager` + `PreparedStatement` with custom `JdbcPostgresAdapter`
- **Redis**: optional for storing session tokens
- **Transactions**: supported via `JdbcPostgresAdapter.transaction(...)`

Example:

```java
adapter.transaction(conn -> {
    UUID id = userRepo.add(conn, ...);
    sessionRepo.save(conn, new Session(...));
    return id;
});
```

---

## Project Structure

```
project
├── middleware                 Reusable middlewares
├── category                   Category domain package
│   └── dto
├── util                       Shared utilities
│   ├── json
│   └── passwordHasher         Hasher strategies, impl and factory
│       └── impl
├── config                     Application configuration
├── auth                       Auth domain package
│   └── dto
├── health                     Health domain package (healthcheck)
├── user                       User domain package
│   └── dto
├── shared                     Shared functionalities, DTOs
│   ├── dto
│   └── error
├── game                       Game domain package
│   └── dto
├── testEndpoint               Test functionality
├── preference                 Preference domain package
│   └── dto
├── loader                     Application loader and component registry
├── http                       HTTP integration layer
│   ├── core
│   │   ├── context
│   │   └── routing
│   ├── utils
│   └── handlers
├── review                     Review domain package
│   └── dto
├── cors
├── persistance                Persistance layer integration
│   ├── impl                   Strategy implementations
│   ├── core                   Adapters
│   ├── domain                 Strategy definitions
│   └── factory                Database Factories
└── session                    Session domain package
```

---

## Configuration

Your `application.properties` file defines all config:

```properties
log.level=DEBUG
server.port=8080

db.url=jdbc:postgresql://localhost:5432/boardgamehub
db.user=postgres
db.password=example

session.backend=redis
redis.host=localhost
redis.port=6379

cors.origin=http://localhost:5173
```

---

## Authentication & Sessions

- Session-based login
- Cookie stored securely via `Set-Cookie`
- Pluggable session repo: `InMemory` or `Redis`
- RBAC with role-checking middleware (`requireAuthenticated()`, `requireRole(...)`)
- Login/registration includes hashing (e.g., `SHA256PasswordHasher`)

---

## JSON Support

Custom reflection-based system:

- `JsonUtil.toJson(...)` → handles records, lists, maps, primitives
- Supports: `String`, `int`, `UUID`, `Instant`, `Date`, `AuthRole`, `ArrayList<Integer>`, etc.
- `JsonMapper.mapToRecord(...)` → converts `Map<String, Object>` to a record
- Handles nested DTOs, `PaginatedResult<T>`, and validation errors

Example:

```java
ctx.response().json(new PaginatedResult<>(list, 10, 0, 1)).send();
```

---

## CORS

Via `CorsMiddleware`, which:

- Responds to preflight `OPTIONS` requests
- Injects `Access-Control-Allow-Origin`, etc.
- Honors the origin configured in properties

---

## Dependency Injection

Use the `ComponentRegistry` for wiring:

```java
ComponentRegistry.register(UserService.class, new UserService(...));
var service = ComponentRegistry.get(UserService.class);
```

No framework — just clean, explicit control.

---

## Admin & Dashboard

Supports:

- Moderate users, reviews, games
- Role-based access for `/admin/*` routes

---

## Roadmap

- [x] Pluggable password hashing
- [x] Repository strategy pattern
- [x] Paginated DTOs
- [x] Session middleware
- [x] Global error handling
- [x] CORS + cookies
- [x] Redis integration
- [x] Transactional flow
- [ ] OpenAPI spec or HTML route index

---

## 📜 License

MIT — for educational and demonstration use.
