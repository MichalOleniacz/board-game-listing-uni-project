package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.shared.dto.ErrorResponseDto;

public class AppException extends RuntimeException {
    private final int statusCode;

    public AppException(String message, int statusCode) {
        super(message);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public ErrorResponseDto toDto() {
        return new ErrorResponseDto(this.getClass().getSimpleName(), getMessage());
    }
}
