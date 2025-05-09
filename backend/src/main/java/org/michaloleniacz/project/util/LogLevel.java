package org.michaloleniacz.project.util;

public enum LogLevel {
    DEBUG("DEBUG", "\u001B[34m"), // Blue
    INFO("INFO", "\u001B[32m"),  // Green
    WARN("WARN", "\u001B[33m"),  // Yellow
    ERROR("ERROR", "\u001B[31m"); // Red

    private final String label;
    private final String colorCode;

    // Constructor
    LogLevel(String label, String colorCode) {
        this.label = label;
        this.colorCode = colorCode;
    }

    public String getLabel() {
        return label;
    }

    public String getColorCode() {
        return colorCode;
    }
}
