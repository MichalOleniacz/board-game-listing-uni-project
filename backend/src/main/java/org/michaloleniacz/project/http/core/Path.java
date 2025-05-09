package org.michaloleniacz.project.http.core;

public enum Path {
    Ping("/ping"),
    KochamCieBardzo("/k");

    private String path;

    Path(String urlPath) {
        path = urlPath;
    }

    @Override
    public String toString() {
        return path;
    }
}
