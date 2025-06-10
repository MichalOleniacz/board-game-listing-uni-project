package org.michaloleniacz.project.http.core.routing;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.handlers.RouteHandler;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.util.Logger;

import static org.mockito.Mockito.*;

class RouteBuilderTest {

    private RouteRegistry registry;
    private RouteHandler finalHandler;

    @BeforeEach
    void setUp() {
        registry = mock(RouteRegistry.class);
        finalHandler = mock(RouteHandler.class);
    }

    @Test
    void shouldApplyMiddlewareInReverseOrder() {
        RouteHandler inner = mock(RouteHandler.class);
        Middleware mw1 = mock(Middleware.class);
        Middleware mw2 = mock(Middleware.class);

        // Compose mocks to track call order
        when(mw1.apply(any())).thenAnswer(invocation -> {
            RouteHandler next = invocation.getArgument(0);
            return mock(RouteHandler.class); // wrap
        });

        when(mw2.apply(any())).thenAnswer(invocation -> {
            RouteHandler next = invocation.getArgument(0);
            return inner; // inner-most
        });

        RouteBuilder builder = new RouteBuilder(HttpMethod.POST, "/secure", registry);
        builder.middleware(mw1).middleware(mw2).handler(finalHandler);

        verify(mw2).apply(finalHandler);
        verify(mw1).apply(any()); // Applied after mw2
        verify(registry).register(any(Route.class));
    }

}
