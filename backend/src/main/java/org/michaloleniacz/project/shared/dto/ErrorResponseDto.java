package org.michaloleniacz.project.shared.dto;

public record ErrorResponseDto(
        String error,
        String message
) {};
