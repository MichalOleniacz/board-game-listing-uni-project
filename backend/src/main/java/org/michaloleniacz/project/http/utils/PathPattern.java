package org.michaloleniacz.project.http.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

public class PathPattern {
    private final String rawPath;
    private final List<String> parts;
    private static final String PARAM_PREFIX = ":";

    private static List<String> splitPath(final String rawPath) {
        return Stream.of(rawPath.split("/"))
                .filter(part -> !part.isBlank())
                .toList();
    }

    public PathPattern(final String rawPath) {
        this.rawPath = rawPath;
        this.parts = PathPattern.splitPath(rawPath);
    }

    public boolean matches(final String actualPath) {
        final List<String> actualPathParts = PathPattern.splitPath(actualPath);

        if (parts.size() != actualPathParts.size())
            return false;

        for (int i = 0; i < parts.size(); i++) {
            if (!parts.get(i).startsWith(PARAM_PREFIX) && !parts.get(i).equals(actualPathParts.get(i))) {
                return false;
            }
        }

        return true;
    }

    public Map<String, String> extractPathParams(final String actualPath) {
        final List<String> actualPathParts = splitPath(actualPath);

        Map<String, String> pathParams = new HashMap<>();
        for (int i = 0; i < parts.size(); i++) {
            if (parts.get(i).startsWith(PARAM_PREFIX)) {
                pathParams.put(
                        parts.get(i).substring(PARAM_PREFIX.length()),
                        actualPathParts.get(i)
                );
            }
        }

        return pathParams;
    }

    public String getRawPath() {
        return rawPath;
    }
}
