package org.michaloleniacz.project.http.core;

public interface IHttpServer {
    public void start();
    public void stop();
    public void configureRoutes();
}
