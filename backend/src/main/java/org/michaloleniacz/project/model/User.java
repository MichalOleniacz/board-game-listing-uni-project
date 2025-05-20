package org.michaloleniacz.project.model;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.dto.UserDto;

import java.util.UUID;

public record User(
        UUID id,
        String username,
        String email,
        String passwordHash,
        UserRole role
) {
    public UserDto toDto() {
        return new UserDto(id, username, email, role);
    }
}
