package org.michaloleniacz.project.http.core.routing;

import org.michaloleniacz.project.http.handlers.RouteHandler;

import java.util.Map;

public record ResolvedRoute(RouteHandler handler, Map<String, String> pathParams) { }
