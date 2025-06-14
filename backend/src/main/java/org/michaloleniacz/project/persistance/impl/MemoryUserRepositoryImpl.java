package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.user.User;
import org.michaloleniacz.project.user.dto.UserDetailsDto;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class MemoryUserRepositoryImpl implements UserRepository {
    public MemoryUserRepositoryImpl() {

    }

    @Override
    public Optional<User> findFullUserByEmail(String email) {
        return Optional.empty();
    }

    @Override
    public boolean addTransactional(User entity) {
        return false;
    }

    @Override
    public Optional<UserDto> findByEmail(String email) {
        return Optional.empty();
    }

    @Override
    public Optional<UserDto> findByUsername(String username) {
        return Optional.empty();
    }

    @Override
    public boolean updateUsername(UUID id, String newUsername) {
        return false;
    }

    @Override
    public boolean updateRole(UUID id, UserRole newRole) {
        return false;
    }

    @Override
    public Optional<UserDto> findById(UUID uuid) {
        return Optional.empty();
    }


    @Override
    public boolean add(User entity) {
        return false;
    }

    @Override
    public boolean deleteById(UUID uuid) {
        return false;
    }

    @Override
    public Optional<UserDetailsDto> getUserDetails(UUID uuid) {
        return Optional.empty();
    }

    public void updateUserDetails(UUID id, UserDetailsDto dto) {

    }
}
