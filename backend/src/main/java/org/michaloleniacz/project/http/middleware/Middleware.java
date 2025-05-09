package org.michaloleniacz.project.http.middleware;

import org.michaloleniacz.project.http.handlers.RouteHandler;

@FunctionalInterface
public interface Middleware {
    RouteHandler apply(RouteHandler next);
}
