package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.category.dto.CategoryDto;

import java.util.ArrayList;

public interface CategoryRepository {
    public ArrayList<CategoryDto> findAll();
}
