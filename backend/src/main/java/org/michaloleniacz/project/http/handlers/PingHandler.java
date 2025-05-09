package org.michaloleniacz.project.http.handlers;
import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.util.Logger;

import java.io.IOException;

public class PingHandler extends BaseHttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        Logger.debug("Handling ping request");
        String response = "pong!";
        sendResponse(exchange, 200, response);
    }
}
