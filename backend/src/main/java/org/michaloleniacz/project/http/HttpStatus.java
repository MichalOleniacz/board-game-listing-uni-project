package org.michaloleniacz.project.http;

public enum HttpStatus {
    // 1xx Informational
    CONTINUE(100, "Continue", Series.INFORMATIONAL),
    SWITCHING_PROTOCOLS(101, "Switching Protocols", Series.INFORMATIONAL),
    PROCESSING(102, "Processing", Series.INFORMATIONAL),
    EARLY_HINTS(103, "Early Hints", Series.INFORMATIONAL),

    // 2xx Success
    OK(200, "OK", Series.SUCCESSFUL),
    CREATED(201, "Created", Series.SUCCESSFUL),
    ACCEPTED(202, "Accepted", Series.SUCCESSFUL),
    NON_AUTHORITATIVE_INFORMATION(203, "Non-Authoritative Information", Series.SUCCESSFUL),
    NO_CONTENT(204, "No Content", Series.SUCCESSFUL),
    RESET_CONTENT(205, "Reset Content", Series.SUCCESSFUL),
    PARTIAL_CONTENT(206, "Partial Content", Series.SUCCESSFUL),
    MULTI_STATUS(207, "Multi-Status", Series.SUCCESSFUL),
    ALREADY_REPORTED(208, "Already Reported", Series.SUCCESSFUL),
    IM_USED(226, "I'm Used", Series.SUCCESSFUL),

    // 3xx Redirection
    MULTIPLE_CHOICES(300, "Multiple Choices", Series.REDIRECTION),
    MOVED_PERMANENTLY(301, "Moved Permanently", Series.REDIRECTION),
    FOUND(302, "Found", Series.REDIRECTION),
    SEE_OTHER(303, "See Other", Series.REDIRECTION),
    NOT_MODIFIED(304, "Not Modified", Series.REDIRECTION),
    USE_PROXY(305, "Use Proxy", Series.REDIRECTION),
    TEMPORARY_REDIRECT(307, "Temporary Redirect", Series.REDIRECTION),
    PERMANENT_REDIRECT(308, "Permanent Redirect", Series.REDIRECTION),

    // 4xx Client Error
    BAD_REQUEST(400, "Bad Request", Series.CLIENT_ERROR),
    UNAUTHORIZED(401, "Unauthorized", Series.CLIENT_ERROR),
    PAYMENT_REQUIRED(402, "Payment Required", Series.CLIENT_ERROR),
    FORBIDDEN(403, "Forbidden", Series.CLIENT_ERROR),
    NOT_FOUND(404, "Not Found", Series.CLIENT_ERROR),
    METHOD_NOT_ALLOWED(405, "Method Not Allowed", Series.CLIENT_ERROR),
    NOT_ACCEPTABLE(406, "Not Acceptable", Series.CLIENT_ERROR),
    PROXY_AUTHENTICATION_REQUIRED(407, "Proxy Authentication Required", Series.CLIENT_ERROR),
    REQUEST_TIMEOUT(408, "Request Timeout", Series.CLIENT_ERROR),
    CONFLICT(409, "Conflict", Series.CLIENT_ERROR),
    GONE(410, "Gone", Series.CLIENT_ERROR),
    LENGTH_REQUIRED(411, "Length Required", Series.CLIENT_ERROR),
    PRECONDITION_FAILED(412, "Precondition Failed", Series.CLIENT_ERROR),
    PAYLOAD_TOO_LARGE(413, "Payload Too Large", Series.CLIENT_ERROR),
    URI_TOO_LONG(414, "URI Too Long", Series.CLIENT_ERROR),
    UNSUPPORTED_MEDIA_TYPE(415, "Unsupported Media Type", Series.CLIENT_ERROR),
    RANGE_NOT_SATISFIABLE(416, "Range Not Satisfiable", Series.CLIENT_ERROR),
    EXPECTATION_FAILED(417, "Expectation Failed", Series.CLIENT_ERROR),
    IM_A_TEAPOT(418, "I'm a teapot", Series.CLIENT_ERROR),
    MISDIRECTED_REQUEST(421, "Misdirected Request", Series.CLIENT_ERROR),
    UNPROCESSABLE_ENTITY(422, "Unprocessable Entity", Series.CLIENT_ERROR),
    LOCKED(423, "Locked", Series.CLIENT_ERROR),
    FAILED_DEPENDENCY(424, "Failed Dependency", Series.CLIENT_ERROR),
    TOO_EARLY(425, "Too Early", Series.CLIENT_ERROR),
    UPGRADE_REQUIRED(426, "Upgrade Required", Series.CLIENT_ERROR),
    PRECONDITION_REQUIRED(428, "Precondition Required", Series.CLIENT_ERROR),
    TOO_MANY_REQUESTS(429, "Too Many Requests", Series.CLIENT_ERROR),
    REQUEST_HEADER_FIELDS_TOO_LARGE(431, "Request Header Fields Too Large", Series.CLIENT_ERROR),
    UNAVAILABLE_FOR_LEGAL_REASONS(451, "Unavailable For Legal Reasons", Series.CLIENT_ERROR),

    // 5xx Server Error
    INTERNAL_SERVER_ERROR(500, "Internal Server Error", Series.SERVER_ERROR),
    NOT_IMPLEMENTED(501, "Not Implemented", Series.SERVER_ERROR),
    BAD_GATEWAY(502, "Bad Gateway", Series.SERVER_ERROR),
    SERVICE_UNAVAILABLE(503, "Service Unavailable", Series.SERVER_ERROR),
    GATEWAY_TIMEOUT(504, "Gateway Timeout", Series.SERVER_ERROR),
    HTTP_VERSION_NOT_SUPPORTED(505, "HTTP Version Not Supported", Series.SERVER_ERROR),
    VARIANT_ALSO_NEGOTIATES(506, "Variant Also Negotiates", Series.SERVER_ERROR),
    INSUFFICIENT_STORAGE(507, "Insufficient Storage", Series.SERVER_ERROR),
    LOOP_DETECTED(508, "Loop Detected", Series.SERVER_ERROR),
    NOT_EXTENDED(510, "Not Extended", Series.SERVER_ERROR),
    NETWORK_AUTHENTICATION_REQUIRED(511, "Network Authentication Required", Series.SERVER_ERROR);

    public enum Series {
        INFORMATIONAL,
        SUCCESSFUL,
        REDIRECTION,
        CLIENT_ERROR,
        SERVER_ERROR
    }

    private final int code;
    private final String reason;
    private final Series series;

    HttpStatus(int code, String reason, Series series) {
        this.code = code;
        this.reason = reason;
        this.series = series;
    }

    public int getCode() {
        return code;
    }

    public String getReason() {
        return reason;
    }

    public Series getSeries() {
        return series;
    }

    public static HttpStatus valueOf(int statusCode) {
        for (HttpStatus status : values()) {
            if (status.code == statusCode) {
                return status;
            }
        }
        throw new IllegalArgumentException("No matching constant for [" + statusCode + "]");
    }
}

