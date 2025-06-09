package org.michaloleniacz.project.review.dto;

import java.sql.Date;
import java.util.UUID;

public record ReviewDto (
        int id,
        UUID userId,
        String username,
        UUID gameId,
        String gameTitle,
        int rating,
        String comment,
        Date createdAt

) { }
