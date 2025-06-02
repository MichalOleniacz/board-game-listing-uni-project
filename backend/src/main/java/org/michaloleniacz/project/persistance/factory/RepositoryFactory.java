package org.michaloleniacz.project.persistance.factory;

import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.persistance.core.RedisClient;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.persistance.impl.MemorySessionRepositoryImpl;
import org.michaloleniacz.project.persistance.impl.PostgresUserRepositoryImpl;
import org.michaloleniacz.project.persistance.impl.RedisSessionRepositoryImpl;

public class RepositoryFactory {
    public static UserRepository createUserRepository() {
        String userStrategyConfig = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.user", "postgres");

        return switch (userStrategyConfig) {
            case "postgres" -> new PostgresUserRepositoryImpl();

            default -> throw new IllegalStateException("Unexpected persistence strategy: " + userStrategyConfig);
        };
    }

    public static SessionRepository createSessionRepository() {
        AppConfig config = (AppConfig) AppConfig.getInstance();
        String userStrategyConfig = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.session", "memory");

        return switch (userStrategyConfig) {
            case "redis" -> {
                String host = config.getOrDefault("persistance.redis.host", "127.0.0.1").toString();
                int port = Integer.parseInt(config.getOrDefault("persistance.redis.port", "6379").toString());
                RedisClient client = new RedisClient(host, port);
                yield new RedisSessionRepositoryImpl(client);
            }
            case "memory" -> new MemorySessionRepositoryImpl();

            default -> throw new IllegalStateException("Unexpected persistence strategy: " + userStrategyConfig);
        };
    }
}
