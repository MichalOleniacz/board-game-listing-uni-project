package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.auth.AuthMiddleware;
import org.michaloleniacz.project.health.HealthController;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.loader.ComponentRegistry;
import org.michaloleniacz.project.middleware.LoggerMiddleware;
import org.michaloleniacz.project.session.SessionMiddleware;

public class Router {

    private final RouteRegistry routeRegistry;

    private final LoggerMiddleware loggerMiddleware = ComponentRegistry.get(LoggerMiddleware.class);

    private final SessionMiddleware sessionMiddleware = ComponentRegistry.get(SessionMiddleware.class);
    private final AuthMiddleware authMiddleware = ComponentRegistry.get(AuthMiddleware.class);

    private final HealthController healthController = ComponentRegistry.get(HealthController.class);


    public Router(final RouteRegistry routeRegistry) {
        this.routeRegistry = routeRegistry;
    }

    public void configure(HttpServer server) {
        routeRegistry.route(HttpMethod.GET, "/health")
                .handler(healthController::handle);

        for (String path : routeRegistry.getPaths()) {
            server.createContext(path.toString(), new RouteDispatcher(routeRegistry));
        }
    }
}
