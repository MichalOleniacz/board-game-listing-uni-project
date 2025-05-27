package org.michaloleniacz.project.middleware;

import org.michaloleniacz.project.http.handlers.RouteHandler;

@FunctionalInterface
public interface Middleware {
    RouteHandler apply(RouteHandler next);
}
