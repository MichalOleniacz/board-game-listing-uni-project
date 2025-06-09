package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.http.utils.PathPattern;
import org.michaloleniacz.project.util.Logger;

import java.util.Map;
import java.util.Objects;

public class Route {
    private final HttpMethod method;
    private final PathPattern pathPattern;
    private final RouteHandler handler;

    public Route(HttpMethod httpMethod, String rawPathTemplate, RouteHandler routeHandler) {
        method = httpMethod;
        pathPattern = new PathPattern(rawPathTemplate);
        handler = routeHandler;
    }

    public boolean matches(HttpMethod httpMethod, String rawPath) {
        if (httpMethod == HttpMethod.OPTIONS) {
            return pathPattern.matches(rawPath);
        }
        return Objects.equals(method.toString(), httpMethod.toString()) && pathPattern.matches(rawPath);
    }

    public boolean matches(String httpMethod, String rawPath) {
        if (Objects.equals(httpMethod, HttpMethod.OPTIONS.name())) {
            Logger.debug("Matched http method: " + httpMethod + " path: " + rawPath);
            return pathPattern.matches(rawPath);
        }
        return Objects.equals(method.toString(), httpMethod.toString()) && pathPattern.matches(rawPath);
    }

    public Map<String, String> extractPathParams(String actualPath) {
        return pathPattern.extractPathParams(actualPath);
    }

    public RouteHandler getHandler() {
        return handler;
    }

    public PathPattern getPathPattern() {
        return pathPattern;
    }
}
