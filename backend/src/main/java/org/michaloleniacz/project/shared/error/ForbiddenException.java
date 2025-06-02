package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.http.HttpStatus;

public class ForbiddenException extends AppException {
    public ForbiddenException(String message) {
        super(message, HttpStatus.FORBIDDEN.getCode());
    }
}
