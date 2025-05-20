package org.michaloleniacz.project.persistance.core;

import java.sql.SQLException;

@FunctionalInterface
public interface SQLCollector<T, R> {
    R collect(T t) throws SQLException;
}
