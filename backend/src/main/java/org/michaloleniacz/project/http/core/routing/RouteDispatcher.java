package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.http.handlers.BaseHttpHandler;
import org.michaloleniacz.project.shared.error.AppException;
import org.michaloleniacz.project.util.Logger;

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

        if (maybeResolvedRoute.isEmpty()) {
            sendResponse(exchange, HttpStatus.NOT_FOUND.getCode(), HttpStatus.NOT_FOUND.getReason());
            return;
        }

        ResolvedRoute resolvedRoute = maybeResolvedRoute.get();
        RequestContext ctx = new RequestContext(exchange, resolvedRoute.pathParams());

        UUID reqId = UUID.randomUUID();
        ctx.setRequestId(reqId);

        try {
            resolvedRoute.handler().handle(ctx);
        } catch (AppException appException) {
            Logger.warn("Error boundary caught error: " + appException.getMessage());
//            sendResponse(exchange, appException.getStatusCode(), appException.getMessage());
            ctx.response()
                    .json(appException.toDto())
                    .status(HttpStatus.valueOf(appException.getStatusCode()))
                    .send();
        } catch (Exception e) {
            Logger.error("Unhandled exception: " + e);
            e.printStackTrace();
            sendResponse(exchange, HttpStatus.INTERNAL_SERVER_ERROR.getCode(), HttpStatus.INTERNAL_SERVER_ERROR.getReason());
        }
    }
}
