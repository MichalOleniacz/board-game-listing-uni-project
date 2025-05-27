package org.michaloleniacz.project.http.core;

import com.sun.net.httpserver.HttpServer;

public interface IHttpServer {
    void start();
    void stop();
    HttpServer getServer();
}
