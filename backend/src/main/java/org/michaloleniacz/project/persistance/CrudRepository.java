package org.michaloleniacz.project.persistance;

import org.michaloleniacz.project.persistance.core.PaginatedResult;

import java.io.Serializable;
import java.util.Optional;

public interface CrudRepository<DTO, MDL, ID extends Serializable> {
    Optional<DTO> findById(ID id);

    boolean add(MDL entity);

    boolean deleteById(ID id);
}
