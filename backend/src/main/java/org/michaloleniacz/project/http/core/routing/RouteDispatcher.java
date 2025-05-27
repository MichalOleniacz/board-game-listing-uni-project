package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.http.handlers.BaseHttpHandler;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

public class RouteDispatcher extends BaseHttpHandler {
    private final RouteRegistry routeRegistry;

    public RouteDispatcher(RouteRegistry registry) {
        routeRegistry = registry;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        String method = exchange.getRequestMethod();
        String path = exchange.getRequestURI().getPath();

        Optional<ResolvedRoute> maybeResolvedRoute = routeRegistry.resolve(method, path);

        if (maybeResolvedRoute.isPresent()) {
            ResolvedRoute resolvedRoute = maybeResolvedRoute.get();
            RequestContext ctx = new RequestContext(exchange, resolvedRoute.pathParams());

            UUID reqId = UUID.randomUUID();
            ctx.setRequestId(reqId);
            resolvedRoute.handler().handle(ctx);
        } else {
            sendResponse(exchange, HttpStatus.NOT_FOUND.getCode(), HttpStatus.NOT_FOUND.getReason());
        }
    }
}
