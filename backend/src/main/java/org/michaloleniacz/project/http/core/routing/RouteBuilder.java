package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.http.middleware.Middleware;
import org.michaloleniacz.project.util.Logger;

import java.util.ArrayList;
import java.util.List;

public class RouteBuilder {
    private final HttpMethod method;
    private final String path;
    private final List<Middleware> middlewareList = new ArrayList<>();

    public RouteBuilder(HttpMethod method, String path) {
        this.method = method;
        this.path = path;
    }

    public RouteBuilder middleware(Middleware middleware) {
        middlewareList.add(middleware);
        return this;
    }

    public void handler(RouteHandler finalHandler) {
        RouteHandler composed = finalHandler;
        // Compose a middleware callstack chain and final handler call
        for (int i = middlewareList.size() - 1; i >= 0; i--) {
            composed = middlewareList.get(i).apply(composed);
        }

        Logger.debug("Registering route: " + method + " " + path);
        RouteRegistry.register(new Route(method, path, composed));
    }

}
