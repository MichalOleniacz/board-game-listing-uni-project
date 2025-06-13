package org.michaloleniacz.project.game.dto;

import java.util.UUID;

public record UpdateGameRequestDto(
        UUID id,
        String title,
        String description,
        int minPlayers,
        int maxPlayers,
        int playtimeMinutes,
        String publisher,
        int yearPublished,
        String imageUrl
) { }
