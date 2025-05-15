package org.michaloleniacz.project.controller;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;

import java.io.IOException;

public class PingController {
    public static void handle(RequestContext ctx) throws IOException {
        ctx.response()
                .body("Pong!")
                .status(HttpStatus.OK)
                .send();
    }

    public static void handleWithId(RequestContext ctx) throws IOException {
        final String id = ctx.getPathParam("id");
        ctx.response()
                .json("{\"id\": \"" + id + "\", \"message\": \"pong\"}")
                .status(HttpStatus.OK)
                .send();
    }

}
