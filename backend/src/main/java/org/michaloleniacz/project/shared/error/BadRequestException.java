package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.http.HttpStatus;

public class BadRequestException extends AppException {
    public BadRequestException(String message) {
        super(message, HttpStatus.BAD_REQUEST.getCode());
    }
}
