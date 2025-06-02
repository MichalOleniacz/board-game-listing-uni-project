package org.michaloleniacz.project.testEndpoint;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.http.handlers.BaseHttpHandler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

;

public class TestEndpointService {
    public void handle(RequestContext ctx) {

        Map<String, String> map = new HashMap<>();
        map.put("test", ctx.getPathParam("param"));

        ctx.response()
                .status(HttpStatus.OK)
                .json(map)
                .send();
    }

    public void handlePost(RequestContext ctx) {

        TestRequest reqBody = ctx.<TestRequest>getParsedBody();


        Map<String, Object> map = new HashMap<>();
        map.put("test", reqBody.test());
        map.put("testNumber", reqBody.testNumber());

        ctx.response()
                .status(HttpStatus.OK)
                .json(map)
                .send();
        return;
    }
}
