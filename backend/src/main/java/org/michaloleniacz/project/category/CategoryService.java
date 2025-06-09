package org.michaloleniacz.project.category;

import org.michaloleniacz.project.category.dto.CategoryDto;
import org.michaloleniacz.project.category.dto.GetAllCategoriesResponseDto;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.CategoryRepository;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;

import java.util.ArrayList;

public class CategoryService {
    private CategoryRepository categoryRepository;
    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }
    public void getAllCategories(RequestContext ctx) {
        if (!ctx.hasSession()) {
            throw new UnauthorizedException("You are not logged in");
        }

        try {
            ArrayList<CategoryDto> result = categoryRepository.findAll();
            ctx.response()
                    .json(new GetAllCategoriesResponseDto(result))
                    .status(HttpStatus.OK)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException("Failed to get all categories");
        }
    }
}
