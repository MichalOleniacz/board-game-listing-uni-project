package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.user.User;
import org.michaloleniacz.project.persistance.CrudRepository;
import org.michaloleniacz.project.user.dto.UserDetailsDto;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends CrudRepository<UserDto, User, UUID> {
    Optional<User> findFullUserByEmail(String email);
    boolean addTransactional(User entity);
    Optional<UserDto> findByEmail(String email);
    Optional<UserDto> findByUsername(String username);
    boolean updateUsername(UUID id, String newUsername);
    boolean updateRole(UUID id, UserRole newRole);
    Optional<UserDetailsDto> getUserDetails(UUID id);

    void updateUserDetails(UUID id, UserDetailsDto dto);
}
