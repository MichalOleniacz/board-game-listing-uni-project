package org.michaloleniacz.project.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Logger {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static int minLogLevel = LogLevel.DEBUG.ordinal();

    public static void info(String message) {
        log(LogLevel.INFO, message);
    }

    public static void warn(String message) {
        log(LogLevel.WARN, message);
    }

    public static void error(String message) {
        log(LogLevel.ERROR, message);
    }

    public static void debug(String message) {
        log(LogLevel.DEBUG, message);
    }

    public static void setMinLogLevel(LogLevel logLevel) {
        Logger.minLogLevel = logLevel.ordinal();
    }

    private static String prettify(LogLevel level, String time, String threadName, String callerClassName, String message) {
        return String.format("[%s] [%s] [%s] [%s] %s %s", time, threadName, level.getLabel(), callerClassName, message, level.getColorCode());
    }

    private static void log(LogLevel level, String message) {
        if (level.ordinal() < minLogLevel) {
            System.out.println("" + minLogLevel + " " + level.ordinal());
            return;
        }

        String time = LocalDateTime.now().format(formatter);
        String threadName = Thread.currentThread().getName();

        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        String callerClassName = "Unknown";
        if (stackTrace.length > 3) {
            callerClassName = stackTrace[3].getClassName();
        }

        System.out.println(prettify(
                level,
                time,
                threadName,
                callerClassName,
                message
        ));
    }
}
