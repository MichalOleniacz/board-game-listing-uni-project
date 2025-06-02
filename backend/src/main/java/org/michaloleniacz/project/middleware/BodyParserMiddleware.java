package org.michaloleniacz.project.middleware;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.util.json.JsonParsingException;

public class BodyParserMiddleware {
    public <T> Middleware parseToDTO(Class<T> clazz) {
        return next -> (RequestContext ctx) -> {
            try {
                T instance = ctx.bodyAsJson(clazz);
                ctx.setParsedBody(instance);
                next.handle(ctx);
            } catch (JsonParsingException e) {
                throw new BadRequestException(HttpStatus.BAD_REQUEST.getReason());
            }
        };
    }
}
