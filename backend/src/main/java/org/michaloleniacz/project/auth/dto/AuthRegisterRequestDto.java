package org.michaloleniacz.project.auth.dto;

public record AuthRegisterRequestDto(
        String email,
        String password,
        String username
) {};
