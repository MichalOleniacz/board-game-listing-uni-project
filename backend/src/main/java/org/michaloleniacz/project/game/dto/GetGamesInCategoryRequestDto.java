package org.michaloleniacz.project.game.dto;

import java.util.ArrayList;

public record GetGamesInCategoryRequestDto(
        ArrayList<Integer> categoryIds,
        int pageNumber,
        int pageSize
) { }
