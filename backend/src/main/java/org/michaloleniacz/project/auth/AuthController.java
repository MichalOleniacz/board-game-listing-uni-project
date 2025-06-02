package org.michaloleniacz.project.auth;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class AuthController {
    private final AuthService authService;
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    public void login(RequestContext ctx) {
        authService.login(ctx);
    }

    public void register(RequestContext ctx) {
        authService.register(ctx);
    }
}
