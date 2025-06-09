package org.michaloleniacz.project.session;

import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.SessionRepository;

public class SessionService {
    private SessionRepository sessionRepository;
    public SessionService(SessionRepository sessionRepository) {
        this.sessionRepository = sessionRepository;
    }

    public void hasValidSession(RequestContext ctx) {

    }
}
