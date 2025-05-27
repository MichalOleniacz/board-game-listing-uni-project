package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.session.Session;

import java.util.Optional;

public interface SessionRepository {
    Optional<Session> findByToken(String token);
    void save(Session session);
    void delete(String token);
    void delete(Session session);
}
