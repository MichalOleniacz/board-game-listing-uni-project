package org.michaloleniacz.project.user;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.shared.dto.UserDto;

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
