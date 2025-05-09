package org.michaloleniacz.project.config;

import org.michaloleniacz.project.util.LogLevel;
import org.michaloleniacz.project.util.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    private static final AppConfig configInstance = new AppConfig();
    private final Properties properties = new Properties();

    private AppConfig() {
        try (InputStream ioStream = AppConfig.class.getClassLoader().getResourceAsStream("app.properties")) {
            if (ioStream == null) {
                Logger.error("Unable to find app.properties...");
                throw new RuntimeException("Unable to find properties file...");
            }
            properties.load(ioStream);
        } catch (IOException ex) {
            Logger.error("Failed to load app.properties...");
        }
    }

    public static AppConfig getInstance() {
        return configInstance;
    }

    public String get(String key) {
        return properties.getProperty(key);
    }

    public Object getOrDefault(String key, Object defaultValue) {
        return properties.getOrDefault(key, defaultValue);
    }

    public int getInt(String key, int defaultValue) {
        final String value = get(key);
        if (value == null) return defaultValue;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            Logger.warn("Invalid int for config key: " + key + " → using default " + defaultValue);
            return defaultValue;
        }
    }

    public boolean getBoolean(String key, boolean defaultValue) {
        String value = get(key);
        return value != null ? Boolean.parseBoolean(value) : defaultValue;
    }

    public LogLevel getLogLevel(String key, LogLevel defaultLevel) {
        String value = get(key);
        try {
            return value != null ? LogLevel.valueOf(value.toUpperCase()) : defaultLevel;
        } catch (IllegalArgumentException e) {
            Logger.warn("Invalid log level: " + value + " → using default " + defaultLevel);
            return defaultLevel;
        }
    }
}
