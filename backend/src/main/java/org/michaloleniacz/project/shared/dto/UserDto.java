package org.michaloleniacz.project.shared.dto;

import org.michaloleniacz.project.auth.UserRole;

import java.util.UUID;

public record UserDto(
        UUID id,
        String username,
        String email,
        UserRole role
) {
}
