package org.michaloleniacz.project.game.dto;

import java.sql.Date;
import java.util.UUID;

public record GameDto (
    UUID id,
    String title,
    String description,
    int minPlayers,
    int maxPlayers,
    int playtimeMinutes,
    String publisher,
    int yearPublished,
    String imageUrl,
    Date createdAt,
    float avgScore,
    String categories
) { }
