package org.michaloleniacz.project.cors;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.util.Logger;


// TODO: apply middleware globally
public class CorsMiddleware {
    public Middleware allowOrigin(String allowedOrigin) {
        return next -> ctx -> {
            ctx.response()
                    .header("Access-Control-Allow-Origin", allowedOrigin)
                    .header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS")
                    .header("Access-Control-Allow-Headers", "Content-Type, Authorization")
                    .header("Access-Control-Allow-Credentials", "true");

            if (ctx.getMethod().equalsIgnoreCase("OPTIONS")) {
                Logger.info("Handling preflight request");
                ctx.response()
                        .status(HttpStatus.NO_CONTENT)
                        .header("Content-Length", "0")
                        .send(); // preflight response
                return;
            }

            next.handle(ctx);
        };
    }
}
