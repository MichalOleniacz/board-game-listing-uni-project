package org.michaloleniacz.project.shared.error;

import org.michaloleniacz.project.http.HttpStatus;

public class ForbiddenExcpetion extends AppException {
    public ForbiddenExcpetion(String message) {
        super(message, HttpStatus.FORBIDDEN.getCode());
    }
}
