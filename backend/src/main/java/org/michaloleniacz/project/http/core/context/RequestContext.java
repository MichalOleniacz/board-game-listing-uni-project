package org.michaloleniacz.project.http.core.context;

import com.sun.net.httpserver.HttpExchange;
import org.michaloleniacz.project.session.Session;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.util.json.JsonMapper;
import org.michaloleniacz.project.util.json.JsonUtil;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

public class RequestContext {
    private final HttpExchange exchange;
    private final Map<String, String> pathParams;
    private final Map<String, String> queryParams;
    private final Map<String, String> cookies;
    private final ResponseContext response;
    private Object parsedBody;
    private UUID requestId;
    private Session session;
    private UserDto user;

    public RequestContext(HttpExchange ex, Map<String, String> pathParams) {
        this.exchange = ex;
        this.pathParams = pathParams;
        this.queryParams = this.parseQueryParams(ex);
        this.cookies = this.parseCookies(ex);
        this.response = new ResponseContext(ex);
    }

    public String getMethod() {
        return exchange.getRequestMethod();
    }

    public String getPath() {
        return exchange.getRequestURI().getPath();
    }

    public String getQueryParam(String key) {
        if (queryParams == null) {
            return null;
        }

        return queryParams.get(key);
    }

    public <T> void setParsedBody(T parsedBody) {
        this.parsedBody = parsedBody;
    }

    public <T> T getParsedBody() {
        if (parsedBody == null) {
            throw new IllegalStateException("RequestContext has not been parsed");
        }
        return (T) parsedBody;
    }

    public <T> T bodyAsJson(Class<T> type) {
        try {
            String body = getBodyAsString();
            Map<String, Object> rawMap = JsonUtil.parseJsonToMap(body);
            return JsonMapper.mapToRecord(rawMap, type);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public String getHeader(String name) {
        List<String> values = exchange.getRequestHeaders().get(name);
        return (values != null && !values.isEmpty()) ? values.get(0) : null;
    }

    public String getCookie(String key) {
        return cookies.get(key);
    }

    public String getPathParam(String key) {
        return pathParams.get(key);
    }

    public String getBodyAsString() throws IOException {
        return new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
    }

    public ResponseContext response() {
        return response;
    }

    public HttpExchange getRawHttpExchange() {
        return exchange;
    }

    public void setRequestId(UUID rId) {
        requestId = rId;
    }

    public void setSession(Session s) {
        session = s;
    }

    public void setUser(UserDto u) { user = u;}

    public Optional<UserDto> getUser() { return Optional.ofNullable(user); }

    public Optional<Session> getSession() {
        return Optional.ofNullable(session);
    }

    public boolean hasSession() { return session != null && user != null; }

    private Map<String, String> parseQueryParams(HttpExchange exchange) {
        final String rawQuery = exchange.getRequestURI().getRawQuery();
        if (rawQuery == null) {
            return null;
        }

        Map<String, String> queryParams = Arrays.stream(rawQuery.split("&"))
                .map(kvp -> kvp.split("=", 2))
                .filter(kvp -> kvp.length == 2)
                .collect(Collectors.toMap(
                        kvp -> URLDecoder.decode(kvp[0], StandardCharsets.UTF_8),
                        kvp -> URLDecoder.decode(kvp[1], StandardCharsets.UTF_8),
                        (e, r) -> r
                ));

        return queryParams;
    }

    private Map<String, String> parseCookies(HttpExchange ex) {
        final List<String> cookieHeaders = exchange.getRequestHeaders().get("Cookie");
        if (cookieHeaders == null) {
            return Map.of();
        }

        Map<String, String> cookies = cookieHeaders.stream()
                .flatMap(cookieHeader -> Arrays.stream(cookieHeader.split(";")))
                .map(String::trim)
                .map(cookieKVP -> cookieKVP.split("=", 2))
                .filter(cookieKVP -> cookieKVP.length == 2)
                .collect(Collectors.toMap(
                        cookieKVP -> cookieKVP[0],
                        cookieKVP -> cookieKVP[1],
                        (existing, replacement) -> replacement
                ));

        return cookies;
    }
}
