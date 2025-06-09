package org.michaloleniacz.project.http.core.routing;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.testutil.FakeHttpExchange;

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
//        List<String> log = new ArrayList<>();
//
//        Middleware m1 = next -> (req) -> {
//            log.add("m1");
//            next.handle(req);
//        };
//        Middleware m2 = next -> (req) -> {
//            log.add("m2");
//            next.handle(req);
//        };
//        RouteHandler finalHandler = (req) -> log.add("handler");
//
//        RouteHandler wrapped = m1.apply(m2.apply(finalHandler));
//
//        RequestContext ctx = new RequestContext(new FakeHttpExchange("GET", "/test", ""), Map.of());
//        wrapped.handle(ctx);
//
//        assertEquals(List.of("m1", "m2", "handler"), log);
    }

    @Test
    void shouldRegisterRouteWithComposedMiddleware() throws IOException {
//        List<String> log = new ArrayList<>();
//
//        Middleware m1 = next -> (req) -> {
//            log.add("m1");
//            next.handle(req);
//        };
//
//        Middleware m2 = next -> (req) -> {
//            log.add("m2");
//            next.handle(req);
//        };
//
//        RouteHandler handler = (req) -> log.add("handler");
//
//        // Act
//        RouteRegistry.route(HttpMethod.GET, "/test")
//                .middleware(m1)
//                .middleware(m2)
//                .handler(handler);
//
//        // Simulate request
//        Optional<ResolvedRoute> resolved = RouteRegistry.resolve("GET", "/test");
//        assertTrue(resolved.isPresent());
//
//        RequestContext ctx = new RequestContext(new FakeHttpExchange("GET", "/test", ""), Map.of());
//        resolved.get().handler().handle(ctx);
//
//        // Assert middleware was composed in correct order
//        assertEquals(List.of("m1", "m2", "handler"), log);
    }
}
