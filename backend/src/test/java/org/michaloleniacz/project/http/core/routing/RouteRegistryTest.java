package org.michaloleniacz.project.http.core.routing;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class RouteRegistryTest {

    private RouteRegistry registry;
    private RouteHandler handler;

    @BeforeEach
    void setUp() {
        registry = new RouteRegistry();
        handler = mock(RouteHandler.class);
    }

    @Test
    void shouldRegisterAndRetrieveRoute() {
        Route route = mock(Route.class);
        when(route.getHandler()).thenReturn(handler);

        registry.register(route);

        List<Route> routes = registry.getRoutes();
        assertEquals(1, routes.size());
        assertEquals(handler, routes.get(0).getHandler());
    }

    @Test
    void shouldResolveMatchingRouteAndExtractParams() {
        Route matchingRoute = mock(Route.class);
        Map<String, String> params = Map.of("id", "42");

        when(matchingRoute.matches("GET", "/user/42")).thenReturn(true);
        when(matchingRoute.extractPathParams("/user/42")).thenReturn(params);
        when(matchingRoute.getHandler()).thenReturn(handler);

        registry.register(matchingRoute);

        Optional<ResolvedRoute> result = registry.resolve("GET", "/user/42");

        assertTrue(result.isPresent());
        assertEquals(handler, result.get().handler());
        assertEquals("42", result.get().pathParams().get("id"));
    }

    @Test
    void shouldReturnEmptyOptionalIfNoMatch() {
        Route route = mock(Route.class);
        when(route.matches("GET", "/not-this")).thenReturn(false);

        registry.register(route);

        Optional<ResolvedRoute> result = registry.resolve("GET", "/not-this");

        assertTrue(result.isEmpty());
    }
}
