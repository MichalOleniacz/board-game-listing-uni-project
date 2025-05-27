package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.session.Session;
import org.michaloleniacz.project.persistance.domain.SessionRepository;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

public class MemorySessionRepositoryImpl implements SessionRepository {
    private final Map<String, Session> store = new ConcurrentHashMap<>();

    @Override
    public Optional<Session> findByToken(String token) {
        return Optional.ofNullable(store.get(token));
    }

    @Override
    public void save(Session session) {
        store.put(session.token(), session);
    }

    @Override
    public void delete(String token) {
        store.remove(token);
    }

    @Override
    public void delete(Session session) {
        store.remove(session.token());
    }
}
