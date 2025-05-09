package org.michaloleniacz.project.http.middleware;

import org.michaloleniacz.project.util.Logger;

public class LoggerMiddleware {
    public static Middleware logRequest() {
        return next -> (exchange, params) -> {
            Logger.info("" + exchange.getRequestMethod() + " " + exchange.getRequestURI());
            next.handle(exchange, params);
        };
    }
}

