package org.michaloleniacz.project.auth.dto;

public record AuthAttemptResponseDto(
        Boolean success,
        String redirectUrl
) {
}
