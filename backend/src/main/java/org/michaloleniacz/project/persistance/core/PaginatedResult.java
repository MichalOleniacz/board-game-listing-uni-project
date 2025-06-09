package org.michaloleniacz.project.persistance.core;

import java.util.ArrayList;

public record PaginatedResult<T>(
        ArrayList<T> result,
        int pageSize,
        int currentOffset,
        int pageNumber
) {};
