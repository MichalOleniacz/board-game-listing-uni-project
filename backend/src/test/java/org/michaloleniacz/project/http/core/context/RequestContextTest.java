package org.michaloleniacz.project.http.core.context;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.testutil.FakeHttpExchange;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class RequestContextTest {

    @Test
    void shouldExtractHeader() {
        FakeHttpExchange exchange = new FakeHttpExchange("GET", "/ping", "");
        exchange.getRequestHeaders().add("X-Test-Header", "12345");

        RequestContext ctx = new RequestContext(exchange, Map.of());
        assertEquals("12345", ctx.getHeader("X-Test-Header"));
    }

    @Test
    void shouldExtractPathParam() {
        FakeHttpExchange exchange = new FakeHttpExchange("GET", "/ping/123", "");
        RequestContext ctx = new RequestContext(exchange, Map.of("id", "123"));
        assertEquals("123", ctx.getPathParam("id"));
    }

    @Test
    void shouldExtractQueryParam() {
        FakeHttpExchange exchange = new FakeHttpExchange("GET", "/ping?id=42", "");
        RequestContext ctx = new RequestContext(exchange, Map.of());
        assertEquals("42", ctx.getQueryParam("id"));
    }

    @Test
    void shouldReadBodyAsString() throws Exception {
        String json = "{\"message\":\"pong\"}";
        FakeHttpExchange exchange = new FakeHttpExchange("POST", "/ping", json);
        RequestContext ctx = new RequestContext(exchange, Map.of());
        assertEquals(json, ctx.getBodyAsString());
    }

    @Test
    void shouldBuildJsonResponse() throws Exception {
        FakeHttpExchange exchange = new FakeHttpExchange("GET", "/ping", "");
        ResponseContext response = new ResponseContext(exchange);
        response.status(HttpStatus.OK).json("{\"ok\":true}").send();

        assertEquals("{\"ok\":true}", exchange.getResponseBodyAsString());
        assertTrue(exchange.getResponseHeaders().getFirst("Content-Type").contains("application/json"));
        assertEquals(200, exchange.getStatusCode());
    }
}
