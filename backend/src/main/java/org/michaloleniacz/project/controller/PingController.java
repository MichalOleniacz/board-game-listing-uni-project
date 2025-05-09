package org.michaloleniacz.project.controller;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.core.HttpResponseBuilder;

import java.io.IOException;
import java.util.Map;

public class PingController {
    public static void handle(HttpExchange exchange, Map<String, String> pathParams) throws IOException {
        new HttpResponseBuilder()
                .body("Pong!")
                .status(200)
                .send(exchange);
    }

    public static void handleWithId(HttpExchange exchange, Map<String, String> pathParams) throws IOException {
        final String id = pathParams.get("id");
        new HttpResponseBuilder()
                .json("{\"id\": \"" + id + "\", \"message\": \"pong\"}")
                .status(200)
                .send(exchange);
    }
}
