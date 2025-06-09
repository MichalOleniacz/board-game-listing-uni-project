package org.michaloleniacz.project.persistance.factory;

import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.persistance.core.RedisClient;
import org.michaloleniacz.project.persistance.domain.*;
import org.michaloleniacz.project.persistance.impl.*;

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

    public static PreferenceRepository createPreferenceRepository() {
        final AppConfig config = AppConfig.getInstance();
        final String preferenceStrategy = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.preference", "postgres");

        return switch (preferenceStrategy) {
            case "postgres" -> new PostgresPreferenceRepositoryImpl();
            default -> throw new IllegalStateException("Unexpected persistence strategy: " + preferenceStrategy);
        };
    }

    public static ReviewRepository createReviewRepository() {
        final AppConfig config = AppConfig.getInstance();
        final String preferenceStrategy = (String) AppConfig.getInstance().getOrDefault("persistence.strategy.review", "postgres");

        return switch (preferenceStrategy) {
            case "postgres" -> new PostgresReviewRepositoryImpl();
            default -> throw new IllegalStateException("Unexpected persistence strategy: " + preferenceStrategy);
        };
    }

    public static CategoryRepository createCategoryRepository() {
        final AppConfig config = AppConfig.getInstance();
        final String categoryStrategy = (String) AppConfig.getInstance().getOrDefault("persistence.category.category", "postgres");

        return switch (categoryStrategy) {
            case "postgres" -> new PostgresCategoryRepositoryImpl();
            default -> throw new IllegalStateException("Unexpected persistence strategy: " + categoryStrategy);
        };
    }

    public static GameRepository createGameRepository() {
        final AppConfig config = AppConfig.getInstance();
        final String gameStrategy = (String) AppConfig.getInstance().getOrDefault("persistence.game.category", "postgres");

        return switch (gameStrategy) {
            case "postgres" -> new PostgresGameRepositoryImpl();
            default -> throw new IllegalStateException("Unexpected persistence strategy: " + gameStrategy);
        };
    }
}
