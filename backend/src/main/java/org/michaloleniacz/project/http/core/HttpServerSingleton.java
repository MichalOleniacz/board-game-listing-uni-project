package org.michaloleniacz.project.http.core;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.http.core.routing.Router;
import org.michaloleniacz.project.util.Logger;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

public final class HttpServerSingleton implements IHttpServer {
    private static final int PORT = AppConfig.getInstance().getInt("http.server.port", 8080);
    private static HttpServerSingleton instance = null;
    private HttpServer serverInstance = null;

    private HttpServerSingleton() {
        try {
            serverInstance = HttpServer.create(new InetSocketAddress(PORT), 0);
            final int threadCount = AppConfig.getInstance().getInt("http.server.threadCount", 10);
            serverInstance.setExecutor(Executors.newFixedThreadPool(threadCount));
            configureRoutes();
        } catch (IOException e) {
            Logger.error("Fatal error - failed to create HTTP server...");
            e.printStackTrace();
        }
    }

    @Override
    public void start() {
        Logger.info(String.format("Server starting on port %d...", PORT));
        serverInstance.start();
    }

    @Override
    public void stop() {
        Logger.info("Server stopping...");
        serverInstance.stop(0);
    }

    @Override
    public void configureRoutes() {
        Logger.info("Configuring routes...");
        Router.configure(serverInstance);
    }

    public static HttpServerSingleton getInstance() {
        if (HttpServerSingleton.instance != null) {
            return HttpServerSingleton.instance;
        }
        HttpServerSingleton.instance = new HttpServerSingleton();
        return HttpServerSingleton.instance;
    }
}
