package org.michaloleniacz.project.persistance.core;

import org.michaloleniacz.project.config.AppConfig;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnector {

    private static final String url;
    private static final String user;
    private static final String pass;

    static {
        AppConfig config = AppConfig.getInstance();
        url = config.get("db.url");
        user = config.get("db.user");
        pass = config.get("db.pass");

        if (url == null || user == null || pass == null) {
            throw new RuntimeException("Database configuration missing in app.properties");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }
}
