package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.http.HttpStatus;

public class InternalServerErrorException extends AppException {
    public InternalServerErrorException(String message) {
        super(message, HttpStatus.INTERNAL_SERVER_ERROR.getCode());
    }
}
