package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;

import java.util.*;
import java.util.stream.Collectors;

public class RouteRegistry {
    private static final List<Route> routes = new ArrayList<>();

    public static void get(String path, RouteHandler handler) {
        routes.add(new Route(HttpMethod.GET, path, handler));
    }

    public static void post(String path, RouteHandler handler) {
        routes.add(new Route(HttpMethod.POST, path, handler));
    }

    public static void put(String path, RouteHandler handler) {
        routes.add(new Route(HttpMethod.PUT, path, handler));
    }

    public static void delete(String path, RouteHandler handler) {
        routes.add(new Route(HttpMethod.DELETE, path, handler));
    }

    public static RouteBuilder route(HttpMethod method, String path) {
        return new RouteBuilder(method, path);
    }

    public static void register(Route route) {
        routes.add(route);
    }

    public static Optional<ResolvedRoute> resolve(String method, String path) {
        for (Route route : routes) {
            if (route.matches(method, path)) {
                Map<String, String> params = route.extractPathParams(path);
                return Optional.of(new ResolvedRoute(route.getHandler(), params));
            }
        }
        return Optional.empty();
    }

    public static Set<String> getPaths() {
        return routes.stream().map(route -> route.getPathPattern().getRawPath()).collect(Collectors.toSet());
    }
}
