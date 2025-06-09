package org.michaloleniacz.project.shared.dto;

import java.util.ArrayList;

public record PaginatedResponseDto<T> (
    ArrayList<T> result,
    int pageSize,
    int pageNumber,
    int totalItems
) { }
