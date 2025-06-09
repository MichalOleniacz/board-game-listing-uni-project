package org.michaloleniacz.project.game.dto;

public record AddNewGameRequestDto (
        String title,
        String description,
        int minPlayers,
        int maxPlayers,
        int playtimeMinutes,
        String publisher,
        int yearPublished,
        String imageUrl
) { }
