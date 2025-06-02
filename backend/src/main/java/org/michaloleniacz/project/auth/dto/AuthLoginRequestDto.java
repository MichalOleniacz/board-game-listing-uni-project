package org.michaloleniacz.project.auth.dto;

public record AuthLoginRequestDto(
        String email,
        String password
) {}
