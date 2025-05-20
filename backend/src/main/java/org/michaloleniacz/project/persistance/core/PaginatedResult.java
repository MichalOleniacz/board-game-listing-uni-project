package org.michaloleniacz.project.persistance.core;

import java.util.List;
import java.util.OptionalLong;

public class PaginatedResult<T> {
    private final List<T> items;
    private final int pageNumber;
    private final int pageSize;
    private final boolean hasNext;
    private final OptionalLong totalCount;

    public PaginatedResult(List<T> items, int pageNumber, int pageSize, boolean hasNext) {
        this(items, pageNumber, pageSize, hasNext, OptionalLong.empty());
    }

    public PaginatedResult(List<T> items, int pageNumber, int pageSize, boolean hasNext, OptionalLong totalCount) {
        this.items = items;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.hasNext = hasNext;
        this.totalCount = totalCount;
    }

    public List<T> items() { return items; }
    public int pageNumber() { return pageNumber; }
    public int pageSize() { return pageSize; }
    public boolean hasNext() { return hasNext; }
    public OptionalLong totalCount() { return totalCount; }
}
