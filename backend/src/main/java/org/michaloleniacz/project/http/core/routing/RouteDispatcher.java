package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.core.context.RequestContext;
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
            RequestContext ctx = new RequestContext(exchange, resolvedRoute.pathParams());
            resolvedRoute.handler().handle(ctx);
        } else {
            sendResponse(exchange, 404, "Not Found");
        }
    }
}
