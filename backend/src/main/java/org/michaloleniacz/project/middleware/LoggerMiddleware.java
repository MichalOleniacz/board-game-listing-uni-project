package org.michaloleniacz.project.middleware;

import org.michaloleniacz.project.util.Logger;

public class LoggerMiddleware {
    public Middleware logRequest() {
        return next -> (ctx) -> {
            Logger.info("" + ctx.getMethod() + " " + ctx.getPath());
            next.handle(ctx);
        };
    }
}

