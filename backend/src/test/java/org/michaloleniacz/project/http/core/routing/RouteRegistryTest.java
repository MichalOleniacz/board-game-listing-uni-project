package org.michaloleniacz.project.http.core.routing;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.http.middleware.Middleware;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class RouteRegistryTest {
    @Test
    void shouldResolveRegisteredGetRoute() {
        RouteRegistry.get("/test/:id", (exchange, params) -> {});
        Optional<ResolvedRoute> route = RouteRegistry.resolve("GET", "/test/abc");
        assertTrue(route.isPresent());
        assertEquals("abc", route.get().pathParams().get("id"));
    }

    @Test
    void shouldResolveRegisteredPostRoute() {
        RouteRegistry.post("/test/:id", (exchange, params) -> {});
        Optional<ResolvedRoute> route = RouteRegistry.resolve("POST", "/test/abc");
        assertTrue(route.isPresent());
        assertEquals("abc", route.get().pathParams().get("id"));
    }

    @Test
    void shouldResolveRegisteredPutRoute() {
        RouteRegistry.put("/test/:id", (exchange, params) -> {});
        Optional<ResolvedRoute> route = RouteRegistry.resolve("PUT", "/test/abc");
        assertTrue(route.isPresent());
        assertEquals("abc", route.get().pathParams().get("id"));
    }

    @Test
    void shouldResolveRegisteredDeleteRoute() {
        RouteRegistry.delete("/test/:id", (exchange, params) -> {});
        Optional<ResolvedRoute> route = RouteRegistry.resolve("DELETE", "/test/abc");
        assertTrue(route.isPresent());
        assertEquals("abc", route.get().pathParams().get("id"));
    }

    @Test
    void shouldReturnEmptyIfNoMatch() {
        Optional<ResolvedRoute> route = RouteRegistry.resolve("POST", "/unknown");
        assertTrue(route.isEmpty());
    }
}
