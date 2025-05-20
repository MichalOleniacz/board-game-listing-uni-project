package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.dto.UserDto;
import org.michaloleniacz.project.model.User;
import org.michaloleniacz.project.persistance.CrudRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends CrudRepository<UserDto, User, UUID> {
    Optional<UserDto> findByEmail(String email);
    Optional<UserDto> findByUsername(String username);
    boolean updateUsername(UUID id, String newUsername);
    boolean updateRole(UUID id, UserRole newRole);
}
