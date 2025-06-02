package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.auth.AuthController;
import org.michaloleniacz.project.auth.AuthMiddleware;
import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.auth.dto.AuthLoginRequestDto;
import org.michaloleniacz.project.auth.dto.AuthRegisterRequestDto;
import org.michaloleniacz.project.health.HealthController;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.loader.ComponentRegistry;
import org.michaloleniacz.project.middleware.BodyParserMiddleware;
import org.michaloleniacz.project.middleware.LoggerMiddleware;
import org.michaloleniacz.project.session.SessionMiddleware;
import org.michaloleniacz.project.testEndpoint.TestEndpointController;
import org.michaloleniacz.project.testEndpoint.TestRequest;
import org.michaloleniacz.project.user.User;
import org.michaloleniacz.project.user.UserController;

public class Router {

    private final RouteRegistry routeRegistry;

    private final LoggerMiddleware loggerMiddleware = ComponentRegistry.get(LoggerMiddleware.class);
    private final BodyParserMiddleware bodyParserMiddleware = ComponentRegistry.get(BodyParserMiddleware.class);

    private final SessionMiddleware sessionMiddleware = ComponentRegistry.get(SessionMiddleware.class);
    private final AuthMiddleware authMiddleware = ComponentRegistry.get(AuthMiddleware.class);

    private final HealthController healthController = ComponentRegistry.get(HealthController.class);
    private final TestEndpointController testController = ComponentRegistry.get(TestEndpointController.class);
    private final UserController userController = ComponentRegistry.get(UserController.class);
    private final AuthController authController = ComponentRegistry.get(AuthController.class);

    public Router(final RouteRegistry routeRegistry) {
        this.routeRegistry = routeRegistry;
    }

    public void configure(HttpServer server) {
        routeRegistry.route(HttpMethod.GET, "/health")
                .handler(healthController::handle);

        routeRegistry.route(HttpMethod.GET, "/test")
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .handler(testController::handle);

        routeRegistry.route(HttpMethod.GET, "/test/:param")
                .handler(testController::handle);

        routeRegistry.route(HttpMethod.POST, "/test")
                .middleware(bodyParserMiddleware.parseToDTO(TestRequest.class))
                .handler(testController::handlePost);

        routeRegistry.route(HttpMethod.POST, "/auth/login")
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(bodyParserMiddleware.parseToDTO(AuthLoginRequestDto.class))
                .handler(authController::login);

        routeRegistry.route(HttpMethod.POST, "/auth/register")
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(bodyParserMiddleware.parseToDTO(AuthRegisterRequestDto.class))
                .handler(authController::register);

        for (String path : routeRegistry.getPaths()) {
            server.createContext(path.toString(), new RouteDispatcher(routeRegistry));
        }
    }
}
