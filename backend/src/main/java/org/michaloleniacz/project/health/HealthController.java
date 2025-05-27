package org.michaloleniacz.project.health;

import org.michaloleniacz.project.http.core.context.RequestContext;

import java.io.IOException;

public class HealthController {
    private final HealthService healthService;
    public HealthController(HealthService healthService) {
        this.healthService = healthService;
    }

    public void handle(RequestContext context) throws IOException {
        healthService.handle(context);
    }
}
