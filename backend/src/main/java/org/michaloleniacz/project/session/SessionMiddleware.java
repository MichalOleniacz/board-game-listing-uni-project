package org.michaloleniacz.project.session;

import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.middleware.Middleware;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.util.Logger;

public class SessionMiddleware {
    private final String SESSION_COOKIE = AppConfig.getInstance().get("session.cookie.name");
    private final SessionRepository sessionRepo;
    private final UserRepository userRepo;

    public SessionMiddleware(SessionRepository sessionRepo, UserRepository userRepo) {
        this.sessionRepo = sessionRepo;
        this.userRepo = userRepo;
    }

    public Middleware hydrateSession() {
        return next -> ctx -> {
            final String sessionToken = ctx.getCookie(SESSION_COOKIE);
            if (sessionToken == null) {
                Logger.debug("No session cookie found");
                next.handle(ctx); // not logged in — let other middleware handle it
                return;
            }

            sessionRepo.findByToken(sessionToken).ifPresent(session -> {
                ctx.setSession(session);

                userRepo.findById(session.userId()).ifPresent(ctx::setUser);
            });

            next.handle(ctx);
        };
    }
}
