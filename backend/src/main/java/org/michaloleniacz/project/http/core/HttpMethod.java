package org.michaloleniacz.project.http.core;

public enum HttpMethod {
    GET("GET"),
    POST("POST"),
    PUT("PUT"),
    DELETE("DELETE")
    ;

    private final String methodName;

    HttpMethod(final String name) {
        this.methodName = name;
    }

    @Override
    public String toString() {
        return methodName;
    }
}
