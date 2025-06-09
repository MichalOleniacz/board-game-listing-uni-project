package org.michaloleniacz.project.category.dto;

import java.util.ArrayList;

public record GetAllCategoriesResponseDto(
        ArrayList<CategoryDto> result
) { }
