package org.michaloleniacz.project.loader;

import org.michaloleniacz.project.auth.AuthMiddleware;
import org.michaloleniacz.project.health.HealthController;
import org.michaloleniacz.project.health.HealthService;
import org.michaloleniacz.project.middleware.LoggerMiddleware;
import org.michaloleniacz.project.session.SessionMiddleware;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.persistance.factory.RepositoryFactory;

public class AppLoader {
    public static void initializeComponents() {
        // Repositories
        ComponentRegistry.register(UserRepository.class, RepositoryFactory.createUserRepository());
        ComponentRegistry.register(SessionRepository.class, RepositoryFactory.createSessionRepository());

        // Middlewares
        ComponentRegistry.register(SessionMiddleware.class,
                new SessionMiddleware(
                        ComponentRegistry.get(SessionRepository.class),
                        ComponentRegistry.get(UserRepository.class)
                )
        );
        ComponentRegistry.register(AuthMiddleware.class, new AuthMiddleware());

        ComponentRegistry.register(LoggerMiddleware.class, new LoggerMiddleware());

        // Services
        ComponentRegistry.register(HealthService.class, new HealthService());

        // Controllers
        ComponentRegistry.register(HealthController.class, new HealthController(
                ComponentRegistry.get(HealthService.class)
        ));
    }
}
