package org.michaloleniacz.project;
import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.http.core.HttpServerSingleton;
import org.michaloleniacz.project.util.LogLevel;
import org.michaloleniacz.project.util.Logger;

public class Main {
    public static void main(String[] args) {
        final LogLevel logLevel = AppConfig.getInstance().getLogLevel("util.logger.loglevel", LogLevel.INFO);
        Logger.setMinLogLevel(logLevel);
        HttpServerSingleton.getInstance().start();
    }
}
