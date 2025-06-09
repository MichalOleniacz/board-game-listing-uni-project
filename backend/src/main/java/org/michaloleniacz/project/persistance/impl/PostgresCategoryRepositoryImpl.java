package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.category.dto.CategoryDto;
import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.domain.CategoryRepository;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;

import java.sql.ResultSet;
import java.util.ArrayList;

public class PostgresCategoryRepositoryImpl implements CategoryRepository {
    private JdbcPostgresAdapter jdbcAdapter;
    public PostgresCategoryRepositoryImpl() {
        this.jdbcAdapter = new JdbcPostgresAdapter();
    }

    private CategoryDto mapToDto(ResultSet rs) {
        try {
            int id = rs.getInt("id");
            String name = rs.getString("category_name");
            return new CategoryDto(id, name);
        } catch (Exception e) {
            throw new InternalServerErrorException("Failed to convert ResultSet to CategoryDto.\n " + e.getMessage());
        }
    }
    @Override
    public ArrayList<CategoryDto> findAll() {
        return jdbcAdapter.queryMany(
                "SELECT * FROM categories",
                stmt -> {},
                this::mapToDto
        );
    }
}
