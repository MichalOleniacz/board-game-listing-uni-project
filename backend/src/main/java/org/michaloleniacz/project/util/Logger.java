package org.michaloleniacz.project.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class Logger {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static int minLogLevel = LogLevel.DEBUG.ordinal();
    private static ThreadLocal<UUID> requestId = new ThreadLocal<>();

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

    public static void setRequestId(UUID rId) { requestId.set(rId); }

    public static void clearRequestId() {
        requestId.remove();
    }

    private static String prettify(LogLevel level, String time, String threadName, String rId, String callerClassName, String message) {
        return String.format("[%s] [%s] [%s] [rid:%s] [%s] %s %s", time, threadName, level.getLabel(), rId, callerClassName, message, level.getColorCode());
    }

    private static void log(LogLevel level, String message) {
        if (level.ordinal() < minLogLevel) {
            return;
        }

        String time = LocalDateTime.now().format(formatter);
        String threadName = Thread.currentThread().getName();
        String rId = requestId.get() != null ? requestId.get().toString() : "-";

        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        String callerClassName = "Unknown";
        if (stackTrace.length > 3) {
            callerClassName = stackTrace[3].getClassName();
        }

        System.out.println(prettify(
                level,
                time,
                threadName,
                rId,
                callerClassName,
                message
        ));
    }
}
