package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.util.Logger;

import java.util.ArrayList;
import java.util.List;

public class RouteBuilder {
    private final HttpMethod method;
    private final String path;
    private final List<Middleware> middlewareList = new ArrayList<>();
    private final RouteRegistry registry;

    public RouteBuilder(HttpMethod method, String path, RouteRegistry registry) {
        this.method = method;
        this.path = path;
        this.registry = registry;
    }

    public RouteBuilder middleware(final Middleware middleware) {
        middlewareList.add(middleware);
        return this;
    }

    public void handler(RouteHandler finalHandler) {
        RouteHandler composed = finalHandler;
        for (int i = 0; i < middlewareList.size(); i++) {
            composed = middlewareList.get(i).apply(composed);
        }
        Logger.debug("Registering route: " + method + " " + path);
        registry.register(new Route(method, path, composed));
    }
}
