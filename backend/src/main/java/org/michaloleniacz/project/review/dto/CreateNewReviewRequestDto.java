package org.michaloleniacz.project.review.dto;

import java.sql.Date;
import java.util.UUID;

public record CreateNewReviewRequestDto (
    UUID gameId,
    int rating,
    String comment
) {}
