package org.michaloleniacz.project.http.core.routing;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.auth.AuthController;
import org.michaloleniacz.project.auth.AuthMiddleware;
import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.auth.dto.AuthLoginRequestDto;
import org.michaloleniacz.project.auth.dto.AuthRegisterRequestDto;
import org.michaloleniacz.project.category.CategoryController;
import org.michaloleniacz.project.cors.CorsMiddleware;
import org.michaloleniacz.project.game.GameController;
import org.michaloleniacz.project.game.dto.AddNewGameRequestDto;
import org.michaloleniacz.project.game.dto.GetGamesInCategoryRequestDto;
import org.michaloleniacz.project.game.dto.SearchGameRequestDto;
import org.michaloleniacz.project.game.dto.UpdateGameRequestDto;
import org.michaloleniacz.project.health.HealthController;
import org.michaloleniacz.project.http.core.HttpMethod;
import org.michaloleniacz.project.loader.ComponentRegistry;
import org.michaloleniacz.project.middleware.BodyParserMiddleware;
import org.michaloleniacz.project.middleware.LoggerMiddleware;
import org.michaloleniacz.project.persistance.domain.CategoryRepository;
import org.michaloleniacz.project.preference.dto.AddPreferenceRequestDto;
import org.michaloleniacz.project.preference.PreferenceController;
import org.michaloleniacz.project.preference.dto.RemovePreferenceRequestDto;
import org.michaloleniacz.project.review.ReviewController;
import org.michaloleniacz.project.review.dto.CreateNewReviewRequestDto;
import org.michaloleniacz.project.session.SessionMiddleware;
import org.michaloleniacz.project.testEndpoint.TestEndpointController;
import org.michaloleniacz.project.testEndpoint.TestRequest;
import org.michaloleniacz.project.user.UserController;
import org.michaloleniacz.project.user.dto.PromoteUserToAdminRequestDto;
import org.michaloleniacz.project.user.dto.UserDetailsDto;

public class Router {

    private final RouteRegistry routeRegistry;

    private final LoggerMiddleware loggerMiddleware = ComponentRegistry.get(LoggerMiddleware.class);
    private final BodyParserMiddleware bodyParserMiddleware = ComponentRegistry.get(BodyParserMiddleware.class);

    private final SessionMiddleware sessionMiddleware = ComponentRegistry.get(SessionMiddleware.class);
    private final AuthMiddleware authMiddleware = ComponentRegistry.get(AuthMiddleware.class);
    private final CorsMiddleware corsMiddleware = ComponentRegistry.get(CorsMiddleware.class);
    private final HealthController healthController = ComponentRegistry.get(HealthController.class);
    private final TestEndpointController testController = ComponentRegistry.get(TestEndpointController.class);
    private final UserController userController = ComponentRegistry.get(UserController.class);
    private final AuthController authController = ComponentRegistry.get(AuthController.class);
    private final PreferenceController preferenceController = ComponentRegistry.get(PreferenceController.class);
    private final ReviewController reviewController = ComponentRegistry.get(ReviewController.class);
    private final CategoryController categoryController = ComponentRegistry.get(CategoryController.class);
    private final GameController gameController = ComponentRegistry.get(GameController.class);

    public Router(final RouteRegistry routeRegistry) {
        this.routeRegistry = routeRegistry;
    }

    public void configure(HttpServer server) {
        routeRegistry.route(HttpMethod.GET, "/health")
                .middleware(corsMiddleware.allowOrigin("*"))
                .handler(healthController::handle);

        routeRegistry.route(HttpMethod.GET, "/test")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .handler(testController::handle);

        routeRegistry.route(HttpMethod.GET, "/test/:param")
                .middleware(corsMiddleware.allowOrigin("*"))
                .handler(testController::handle);

        routeRegistry.route(HttpMethod.POST, "/test")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(bodyParserMiddleware.parseToDTO(TestRequest.class))
                .handler(testController::handlePost);

        routeRegistry.route(HttpMethod.POST, "/auth/login")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(bodyParserMiddleware.parseToDTO(AuthLoginRequestDto.class))
                .handler(authController::login);

        routeRegistry.route(HttpMethod.POST, "/auth/register")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(bodyParserMiddleware.parseToDTO(AuthRegisterRequestDto.class))
                .handler(authController::register);

        routeRegistry.route(HttpMethod.POST, "/auth/logout")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(authController::logout);

        routeRegistry.route(HttpMethod.GET, "/user/get-user-details")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(userController::getUserDetails);

        routeRegistry.route(HttpMethod.POST, "/user/update-user-details")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(bodyParserMiddleware.parseToDTO(UserDetailsDto.class))
                .handler(userController::updateUserDetails);

        routeRegistry.route(HttpMethod.GET, "/preference/get-all")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(preferenceController::getAllPreferences);

        routeRegistry.route(HttpMethod.GET, "/preference/get-user-preferences")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(preferenceController::getPreferencesForUser);

        routeRegistry.route(HttpMethod.POST, "/preference/add-user-preference")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(preferenceController::addPreference);

        routeRegistry.route(HttpMethod.POST, "/preference/delete-user-preference")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(bodyParserMiddleware.parseToDTO(RemovePreferenceRequestDto.class))
                .handler(preferenceController::removePreference);

        routeRegistry.route(HttpMethod.GET, "/review/get-user-reviews")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(reviewController::getUserReviews);

        routeRegistry.route(HttpMethod.POST, "/review/add-user-review")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(bodyParserMiddleware.parseToDTO(CreateNewReviewRequestDto.class))
                .handler(reviewController::addNewReview);

        routeRegistry.route(HttpMethod.POST, "/review/delete-user-review")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(reviewController::removeReview);

        routeRegistry.route(HttpMethod.GET, "/review/get-user-reviews-for-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(reviewController::getUserReviewsForGame);

        routeRegistry.route(HttpMethod.GET, "/review/get-all-reviews-for-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(reviewController::getReviewsForGame);

        routeRegistry.route(HttpMethod.GET, "/category/get-all-categories")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(categoryController::getAllCategories);

        routeRegistry.route(HttpMethod.GET, "/game/get-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(gameController::getGameById);

        routeRegistry.route(HttpMethod.POST, "/game/search-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(bodyParserMiddleware.parseToDTO(SearchGameRequestDto.class))
                .handler(gameController::searchGame);

        routeRegistry.route(HttpMethod.GET, "/game/get-top-games")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .handler(gameController::getAllGames);

        routeRegistry.route(HttpMethod.POST, "/game/get-top-games-in-category")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(bodyParserMiddleware.parseToDTO(GetGamesInCategoryRequestDto.class))
                .handler(gameController::getGamesInCategories);

        routeRegistry.route(HttpMethod.GET, "/admin/user/get-user-by-email")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .handler(userController::getUserByEmail);

        routeRegistry.route(HttpMethod.POST, "/admin/user/make-user-admin")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .middleware(bodyParserMiddleware.parseToDTO(PromoteUserToAdminRequestDto.class))
                .handler(userController::promoteUserToAdmin);

        routeRegistry.route(HttpMethod.GET, "/admin/game/get-game-by-title")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .handler(gameController::getGameByTitle);

        routeRegistry.route(HttpMethod.POST, "/admin/game/create-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .middleware(bodyParserMiddleware.parseToDTO(AddNewGameRequestDto.class))
                .handler(gameController::createGame);

        routeRegistry.route(HttpMethod.POST, "/admin/game/update-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .middleware(bodyParserMiddleware.parseToDTO(UpdateGameRequestDto.class))
                .handler(gameController::updateGame);

        routeRegistry.route(HttpMethod.POST, "/admin/game/delete-game")
                .middleware(corsMiddleware.allowOrigin("*"))
                .middleware(loggerMiddleware.logRequest())
                .middleware(sessionMiddleware.hydrateSession())
                .middleware(authMiddleware.requireAuthenticated())
                .middleware(authMiddleware.requireRole(UserRole.ADMIN))
                .handler(gameController::deleteGame);


        for (String path : routeRegistry.getPaths()) {
            server.createContext(path.toString(), new RouteDispatcher(routeRegistry));
        }
    }
}
