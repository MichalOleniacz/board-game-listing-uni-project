package org.michaloleniacz.project.auth;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.util.Logger;

import java.util.Optional;

public class AuthMiddleware {
    public Middleware requireRole(UserRole requiredRole) {
        return next -> ctx -> {
            Logger.info("[RBAC] Required role: " + requiredRole);

            if (!ctx.hasSession()) {
                Logger.debug("[RBAC] Missing session");
                ctx.response()
                        .status(HttpStatus.UNAUTHORIZED)
                        .body(HttpStatus.UNAUTHORIZED.getReason())
                        .send();
                return;
            }

            Optional<UserDto> maybeUser = ctx.getUser();
            if (maybeUser.isEmpty()) {
                Logger.debug("[RBAC] User not found");
                ctx.response()
                        .status(HttpStatus.UNAUTHORIZED)
                        .body(HttpStatus.UNAUTHORIZED.getReason())
                        .send();
                return;
            }

            UserDto user = maybeUser.get();
            if (user.role().ordinal() < requiredRole.ordinal()) {
                Logger.info("[RBAC] User does not have required role: " + requiredRole);
                ctx.response()
                        .status(HttpStatus.FORBIDDEN)
                        .body(HttpStatus.FORBIDDEN.getReason())
                        .send();
                return;
            }

            next.handle(ctx);
        };
    }

    public Middleware requireAuthenticated() {
        return next -> ctx -> {
            Logger.info("[RBAC] checker requires authenticated");
            if (!ctx.hasSession()) {
                Logger.debug("[RBAC] Missing session");
                ctx.response()
                        .status(HttpStatus.UNAUTHORIZED)
                        .body(HttpStatus.UNAUTHORIZED.getReason())
                        .send();
                return;
            }
            next.handle(ctx);
        };
    }
}
