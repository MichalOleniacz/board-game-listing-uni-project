package org.michaloleniacz.project;
import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.http.core.HttpServerManager;
import org.michaloleniacz.project.http.core.routing.RouteRegistry;
import org.michaloleniacz.project.http.core.routing.Router;
import org.michaloleniacz.project.loader.AppLoader;
import org.michaloleniacz.project.util.LogLevel;
import org.michaloleniacz.project.util.Logger;

public class Main {
    public static void main(String[] args) {
        final LogLevel logLevel = AppConfig.getInstance().getLogLevel("util.logger.loglevel", LogLevel.INFO);
        Logger.setMinLogLevel(logLevel);

        AppLoader.initializeComponents();

        RouteRegistry routeRegistry = new RouteRegistry();
        Router router = new Router(routeRegistry);

        HttpServerManager serverManager = HttpServerManager.getInstance();
        router.configure(serverManager.getServer());
        serverManager.start();
    }
}
