package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.persistance.domain.UserRepository;

import java.util.List;
import java.util.Optional;

public class MemoryUserRepositoryImpl implements UserRepository {
    public MemoryUserRepositoryImpl() {

    }

    @Override
    public Optional findById(Object o) {
        return Optional.empty();
    }

    @Override
    public List findAll() {
        return List.of();
    }

    @Override
    public boolean save(Object entity) {
        return false;
    }

    @Override
    public boolean deleteById(Object o) {
        return false;
    }
}
