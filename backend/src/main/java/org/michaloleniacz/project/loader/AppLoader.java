package org.michaloleniacz.project.loader;

import org.michaloleniacz.project.auth.AuthController;
import org.michaloleniacz.project.auth.AuthMiddleware;
import org.michaloleniacz.project.auth.AuthService;
import org.michaloleniacz.project.health.HealthController;
import org.michaloleniacz.project.health.HealthService;
import org.michaloleniacz.project.middleware.BodyParserMiddleware;
import org.michaloleniacz.project.middleware.LoggerMiddleware;
import org.michaloleniacz.project.session.SessionMiddleware;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.persistance.factory.RepositoryFactory;
import org.michaloleniacz.project.testEndpoint.TestEndpointController;
import org.michaloleniacz.project.testEndpoint.TestEndpointService;
import org.michaloleniacz.project.user.UserController;
import org.michaloleniacz.project.user.UserService;
import org.michaloleniacz.project.util.passwordHasher.PasswordHasherFactory;
import org.michaloleniacz.project.util.passwordHasher.PasswordHasherStrategy;

public class AppLoader {
    public static void initializeComponents() {
        // Utils
        ComponentRegistry.register(PasswordHasherStrategy.class, PasswordHasherFactory.createPasswordHasher());

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
        ComponentRegistry.register(BodyParserMiddleware.class, new BodyParserMiddleware());
        ComponentRegistry.register(AuthMiddleware.class, new AuthMiddleware());

        ComponentRegistry.register(LoggerMiddleware.class, new LoggerMiddleware());

        // Services
        ComponentRegistry.register(HealthService.class, new HealthService());
        ComponentRegistry.register(TestEndpointService.class, new TestEndpointService());
        ComponentRegistry.register(UserService.class, new UserService(
                ComponentRegistry.get(UserRepository.class)
        ));
        ComponentRegistry.register(AuthService.class, new AuthService(
                ComponentRegistry.get(UserRepository.class),
                ComponentRegistry.get(SessionRepository.class),
                ComponentRegistry.get(PasswordHasherStrategy.class)
        ));

        // Controllers
        ComponentRegistry.register(HealthController.class, new HealthController(
                ComponentRegistry.get(HealthService.class)
        ));
        ComponentRegistry.register(TestEndpointController.class, new TestEndpointController(
                ComponentRegistry.get(TestEndpointService.class)
        ));
        ComponentRegistry.register(UserController.class, new UserController(
                ComponentRegistry.get(UserService.class)
        ));
        ComponentRegistry.register(AuthController.class, new AuthController(
                ComponentRegistry.get(AuthService.class)
        ));
    }
}
