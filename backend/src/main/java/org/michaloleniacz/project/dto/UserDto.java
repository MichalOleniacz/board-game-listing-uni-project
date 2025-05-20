package org.michaloleniacz.project.dto;

import org.michaloleniacz.project.auth.UserRole;

import java.util.UUID;

public record UserDto(
        UUID id,
        String username,
        String email,
        UserRole role
) {
}
