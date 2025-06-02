package org.michaloleniacz.project.auth;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.ForbiddenException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;
import org.michaloleniacz.project.util.Logger;

import java.util.Optional;

public class AuthMiddleware {
    public Middleware requireRole(UserRole requiredRole) {
        return next -> ctx -> {
            Logger.info("[RBAC] Required role: " + requiredRole);

            if (!ctx.hasSession()) {
                Logger.debug("[RBAC] Missing session");
                throw new UnauthorizedException("Missing session, cannot infer role");
            }

            Optional<UserDto> maybeUser = ctx.getUser();
            if (maybeUser.isEmpty()) {
                Logger.debug("[RBAC] User not found");
                throw new UnauthorizedException("User not found");
            }

            UserDto user = maybeUser.get();
            if (user.role().ordinal() < requiredRole.ordinal()) {
                Logger.info("[RBAC] User does not have required role: " + requiredRole);
                throw new ForbiddenException("Missing required role " + requiredRole);
            }

            next.handle(ctx);
        };
    }

    public Middleware requireAuthenticated() {
        return next -> ctx -> {
            Logger.info("[RBAC] checker requires authenticated");
            if (!ctx.hasSession()) {
                Logger.debug("[RBAC] Missing session");
                throw new UnauthorizedException("Missing session");
            }
            next.handle(ctx);
        };
    }
}
