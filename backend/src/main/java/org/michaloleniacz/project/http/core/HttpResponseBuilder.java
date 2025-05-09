package org.michaloleniacz.project.http.core;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

public class HttpResponseBuilder {
    private static final int DEFAULT_STATUS = 200;
    private static final String DEFAULT_BODY = "";
    private final Headers headers = new Headers();
    private int statusCode = HttpResponseBuilder.DEFAULT_STATUS;
    private String body = HttpResponseBuilder.DEFAULT_BODY;

    public HttpResponseBuilder() {};

    public HttpResponseBuilder status(int code) { this.statusCode = code; return this; }
    public HttpResponseBuilder body(String body) { this.body = body; return this; }
    public HttpResponseBuilder json(String json) {
        headers.add("Content-Type", "application/json");
        this.body = json;
        return this;
    }
    public HttpResponseBuilder header(String name, String value) {
        headers.add(name, value); return this;
    }

    public void send(HttpExchange exchange) throws IOException {
        exchange.getResponseHeaders().putAll(headers);
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        exchange.sendResponseHeaders(statusCode, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(bytes);
        }
    }
}
