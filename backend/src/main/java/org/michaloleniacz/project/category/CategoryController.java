package org.michaloleniacz.project.category;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class CategoryController {
    private CategoryService categoryService;
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    public void getAllCategories(RequestContext ctx) {
        categoryService.getAllCategories(ctx);
    }
}
