package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;

import java.util.*;
import java.util.stream.Collectors;

public class RouteRegistry {
    private final List<Route> routes = new ArrayList<>();

    public RouteBuilder route(HttpMethod method, String path) {
        return new RouteBuilder(method, path, this);
    }

    public void register(Route route) {
        routes.add(route);
    }

    public List<Route> getRoutes() {
        return routes;
    }

    public Set<String> getPaths() {
        return routes.stream().map(route -> route.getPathPattern().getRawPath()).collect(Collectors.toSet());
    }

    public Optional<ResolvedRoute> resolve(String method, String path) {
        for (Route route : routes) {
            if (route.matches(method, path)) {
                Map<String, String> params = route.extractPathParams(path);
                return Optional.of(new ResolvedRoute(route.getHandler(), params));
            }
        }
        return Optional.empty();
    }
}

