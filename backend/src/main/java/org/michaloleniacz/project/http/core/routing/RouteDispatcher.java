package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.handlers.BaseHttpHandler;

import java.io.IOException;
import java.util.Optional;

public class RouteDispatcher extends BaseHttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        String method = exchange.getRequestMethod();
        String path = exchange.getRequestURI().getPath();

        Optional<ResolvedRoute> maybeResolvedRoute = RouteRegistry.resolve(method, path);

        if (maybeResolvedRoute.isPresent()) {
            ResolvedRoute resolvedRoute = maybeResolvedRoute.get();
            resolvedRoute.handler().handle(exchange, resolvedRoute.pathParams());
        } else {
            sendResponse(exchange, 404, "Not Found");
        }
    }
}
