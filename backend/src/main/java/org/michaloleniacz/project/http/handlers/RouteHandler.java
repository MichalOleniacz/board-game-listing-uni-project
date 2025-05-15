package org.michaloleniacz.project.http.handlers;

import org.michaloleniacz.project.http.core.context.RequestContext;

import java.io.IOException;

@FunctionalInterface
public interface RouteHandler {
    void handle(RequestContext requestContext) throws IOException;
}
