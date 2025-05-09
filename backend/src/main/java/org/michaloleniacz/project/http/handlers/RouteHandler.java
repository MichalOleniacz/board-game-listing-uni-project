package org.michaloleniacz.project.http.handlers;

import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.util.Map;

@FunctionalInterface
public interface RouteHandler {
    void handle(HttpExchange exchange, Map<String, String> pathParams) throws IOException;
}
