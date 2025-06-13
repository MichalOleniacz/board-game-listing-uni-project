package org.michaloleniacz.project.persistance.domain;

import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.review.dto.ReviewDto;

import java.util.Optional;
import java.util.UUID;

public interface ReviewRepository {
    public Optional<ReviewDto> getReviewById(int reviewId);
    public void deleteUserReviewById(int reviewId, UUID userId);
    public PaginatedResult<ReviewDto> getAllReviewsForGame(UUID gameId, int limit, int offset);
    public PaginatedResult<ReviewDto> getUserReviewsForGame(UUID userId, UUID gameId, int limit, int offset);
    public PaginatedResult<ReviewDto> getReviewsForUser(UUID userId, int limit, int offset);
    public void save(ReviewDto reviewDto);
}
