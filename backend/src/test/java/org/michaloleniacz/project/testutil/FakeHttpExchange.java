package org.michaloleniacz.project.testutil;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpPrincipal;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URI;

public class FakeHttpExchange extends HttpExchange {
    private final URI uri;
    private final String method;
    private final Headers requestHeaders = new Headers();
    private final Headers responseHeaders = new Headers();
    private final ByteArrayOutputStream responseBody = new ByteArrayOutputStream();
    private final InputStream requestBody;

    private int responseCode;

    public FakeHttpExchange(String method, String uriStr, String requestBodyContent) {
        this.method = method;
        this.uri = URI.create(uriStr);
        this.requestBody = new ByteArrayInputStream(requestBodyContent.getBytes());
    }

    @Override public Headers getRequestHeaders() { return requestHeaders; }
    @Override public Headers getResponseHeaders() { return responseHeaders; }
    @Override public URI getRequestURI() { return uri; }
    @Override public String getRequestMethod() { return method; }
    @Override public InputStream getRequestBody() { return requestBody; }
    @Override public OutputStream getResponseBody() { return responseBody; }
    @Override public void sendResponseHeaders(int code, long length) { this.responseCode = code; }

    public int getStatusCode() { return responseCode; }
    public String getResponseBodyAsString() { return responseBody.toString(); }

    // Stub unused methods
    @Override public void close() {}
    @Override public InetSocketAddress getRemoteAddress() { return null; }

    @Override
    public int getResponseCode() { return 0; }

    @Override public InetSocketAddress getLocalAddress() { return null; }
    @Override public String getProtocol() { return null; }
    @Override public Object getAttribute(String s) { return null; }
    @Override public void setAttribute(String s, Object o) {}
    @Override public void setStreams(InputStream i, OutputStream o) {}

    @Override
    public HttpPrincipal getPrincipal() { return null; }

    @Override public HttpContext getHttpContext() { return null; }
}

