package org.michaloleniacz.project.http.middleware;

import org.michaloleniacz.project.util.Logger;

public class LoggerMiddleware {
    public static Middleware logRequest() {
        return next -> (ctx) -> {
            Logger.info("" + ctx.getMethod() + " " + ctx.getPath());
            next.handle(ctx);
        };
    }
}

