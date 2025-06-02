package org.michaloleniacz.project.http.core.context;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.util.Logger;
import org.michaloleniacz.project.util.json.JsonUtil;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

public class ResponseContext {
    private final HttpExchange exchange;
    private final Headers headers;
    private HttpStatus status;
    private byte[] body = new byte[0];

    public ResponseContext(HttpExchange exchange) {
        this.exchange = exchange;
        this.headers = exchange.getResponseHeaders();
    }

    public ResponseContext status(HttpStatus status) {
        this.status = status;
        return this;
    }

    public ResponseContext body(String bodyText) {
        this.body = bodyText.getBytes(StandardCharsets.UTF_8);
        return this;
    }

    public ResponseContext json(Object body) {
        headers.add("Content-Type", "application/json");
        this.body = JsonUtil.toJson(body).getBytes(StandardCharsets.UTF_8);
        return this;
    }

    public ResponseContext header(String key, String value) {
        headers.add(key, value);
        return this;
    }

    public ResponseContext redirect(String location) {
        status(HttpStatus.MOVED_PERMANENTLY);
        header("Location", location);
        return this;
    }

    public void send() {
        try {
            exchange.sendResponseHeaders(status.getCode(), body.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(body);
            } catch (IOException e) {
                Logger.error("Failed to send response...\n" + e.getMessage());
            }
        }
        catch (IOException e) {
            Logger.error("Failed to send response...\n" + e.getMessage());
        }
    }
}
