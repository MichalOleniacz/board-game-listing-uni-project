package org.michaloleniacz.project.http.core.routing;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.http.middleware.Middleware;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class RouteBuilderTest {
    @Test
    void shouldCallAllMiddlewareInOrder() throws IOException {
        List<String> log = new ArrayList<>();

        Middleware m1 = next -> (exchange, params) -> {
            log.add("m1");
            next.handle(exchange, params);
        };
        Middleware m2 = next -> (exchange, params) -> {
            log.add("m2");
            next.handle(exchange, params);
        };
        RouteHandler finalHandler = (exchange, params) -> log.add("handler");

        RouteHandler wrapped = m1.apply(m2.apply(finalHandler));
        wrapped.handle(null, Map.of());

        assertEquals(List.of("m1", "m2", "handler"), log);
    }

    @Test
    void shouldRegisterRouteWithComposedMiddleware() throws IOException {
        List<String> log = new ArrayList<>();

        Middleware m1 = next -> (exchange, params) -> {
            log.add("m1");
            next.handle(exchange, params);
        };

        Middleware m2 = next -> (exchange, params) -> {
            log.add("m2");
            next.handle(exchange, params);
        };

        RouteHandler handler = (exchange, params) -> log.add("handler");

        // Act
        RouteRegistry.route(HttpMethod.GET, "/test")
                .middleware(m1)
                .middleware(m2)
                .handler(handler);

        // Simulate request
        Optional<ResolvedRoute> resolved = RouteRegistry.resolve("GET", "/test");
        assertTrue(resolved.isPresent());
        resolved.get().handler().handle(null, Map.of());

        // Assert middleware was composed in correct order
        assertEquals(List.of("m1", "m2", "handler"), log);
    }
}
