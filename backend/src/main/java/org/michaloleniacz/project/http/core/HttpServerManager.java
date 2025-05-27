package org.michaloleniacz.project.http.core;

import com.sun.net.httpserver.HttpServer;
import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.util.Logger;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

public final class HttpServerManager implements IHttpServer {
    private static final int PORT = AppConfig.getInstance().getInt("http.server.port", 8080);
    private static volatile HttpServerManager instance = null;
    private final HttpServer serverInstance;

    private HttpServerManager() {
        try {
            serverInstance = HttpServer.create(new InetSocketAddress(PORT), 0);
            final int threadCount = AppConfig.getInstance().getInt("http.server.threadCount", 10);
            serverInstance.setExecutor(Executors.newFixedThreadPool(threadCount));
        } catch (IOException e) {
            Logger.error("Fatal error - failed to create HTTP server...\n" + e.toString());
            throw new RuntimeException("Failed to initialize HTTP server", e);
        }
    }

    public static HttpServerManager getInstance() {
        if (instance == null) {
            synchronized (HttpServerManager.class) {
                if (instance == null) {
                    instance = new HttpServerManager();
                }
            }
        }
        return instance;
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
    public HttpServer getServer() {
        return serverInstance;
    }
}
