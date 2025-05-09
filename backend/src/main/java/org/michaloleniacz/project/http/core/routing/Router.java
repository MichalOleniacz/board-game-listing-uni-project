package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.controller.PingController;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.middleware.LoggerMiddleware;

public class Router {
    public static void configure(HttpServer server) {
        RouteRegistry.route(HttpMethod.GET, "/ping")
                .middleware(LoggerMiddleware.logRequest())
                .handler(PingController::handle);
        RouteRegistry.route(HttpMethod.GET, "/ping/:id")
                .middleware(LoggerMiddleware.logRequest())
                .handler(PingController::handleWithId);

        for (String path : RouteRegistry.getPaths()) {
            server.createContext(path.toString(), new RouteDispatcher());
        }
    }
}
