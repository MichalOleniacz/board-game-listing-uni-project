package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.persistance.core.RedisClient;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.session.Session;
import org.michaloleniacz.project.util.json.JsonMapper;
import org.michaloleniacz.project.util.json.JsonUtil;

import java.util.Map;
import java.util.Optional;

public class RedisSessionRepositoryImpl implements SessionRepository {
    private final RedisClient redis;

    public RedisSessionRepositoryImpl(RedisClient redis) {
        this.redis = redis;
    }

    @Override
    public Optional<Session> findByToken(String token) {
        String json = redis.get("session:" + token);
        if (json == null) return Optional.empty();

        Map<String, Object> data = JsonUtil.parseJsonToMap(json);
        return Optional.of(JsonMapper.mapToRecord(data, Session.class));
    }

    @Override
    public void save(Session session) {
        String json = JsonUtil.toJson(session);
        redis.set("session:" + session.token(), json);
    }

    @Override
    public void delete(String token) {
        redis.delete(token);
    }

    @Override
    public void delete(Session session) {
        redis.delete(session.token());
    }
}
