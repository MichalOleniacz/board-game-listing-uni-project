package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.game.dto.AddNewGameRequestDto;
import org.michaloleniacz.project.game.dto.GameDto;
import org.michaloleniacz.project.persistance.core.PaginatedResult;

import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;

public interface GameRepository {
    public PaginatedResult<GameDto> findAll(int page, int pageSize);
    public PaginatedResult<GameDto> findAllInCategories(int page, int pageSize, ArrayList<Integer> categoryIds);

    public Optional<GameDto> findById(UUID id);
    public Optional<GameDto> findByTitle(String title);

    public void save(AddNewGameRequestDto gameDto);
}
