package org.michaloleniacz.project.health;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;

import java.io.IOException;

public class HealthService {
    public void handle(RequestContext ctx) {
        ctx.response()
                .status(HttpStatus.OK)
                .body(HttpStatus.OK.getReason())
                .send();
        return;
    }
}
