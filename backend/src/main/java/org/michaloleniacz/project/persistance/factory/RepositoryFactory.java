package org.michaloleniacz.project.persistance.factory;

import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.persistance.impl.MemorySessionRepositoryImpl;
import org.michaloleniacz.project.persistance.impl.PostgresUserRepositoryImpl;

public class RepositoryFactory {
    public static UserRepository createUserRepository() {
        String userStrategyConfig = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.user", "postgres");

        return switch (userStrategyConfig) {
            case "postgres" -> new PostgresUserRepositoryImpl();

            default -> throw new IllegalStateException("Unexpected persistence strategy: " + userStrategyConfig);
        };
    }

    public static SessionRepository createSessionRepository() {
        String userStrategyConfig = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.session", "memory");

        return switch (userStrategyConfig) {
            case "memory" -> new MemorySessionRepositoryImpl();

            default -> throw new IllegalStateException("Unexpected persistence strategy: " + userStrategyConfig);
        };
    }
}
