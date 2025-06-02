package org.michaloleniacz.project.testEndpoint;

import org.michaloleniacz.project.health.HealthService;
import org.michaloleniacz.project.http.core.context.RequestContext;

import java.io.IOException;

public class TestEndpointController {
    private final TestEndpointService testEndpointService;
    public TestEndpointController(TestEndpointService testEndpointService) {
        this.testEndpointService = testEndpointService;
    }

    public void handle(RequestContext context) throws IOException {
        testEndpointService.handle(context);
    }

    public void handlePost(RequestContext context) throws IOException {
        testEndpointService.handlePost(context);
    }
}
