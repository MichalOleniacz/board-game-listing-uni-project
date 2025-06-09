package org.michaloleniacz.project.session;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class SessionController {
    private SessionService sessionService;
    public SessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    public void hasValidSession(RequestContext ctx) {
        sessionService.hasValidSession(ctx);
    }
}
