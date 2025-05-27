package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.http.HttpStatus;

public class UnauthorizedException extends AppException {
    public UnauthorizedException(String message) {
        super(message, HttpStatus.UNAUTHORIZED.getCode());
    }
}
