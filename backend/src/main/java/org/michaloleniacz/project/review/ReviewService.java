package org.michaloleniacz.project.review;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.persistance.domain.ReviewRepository;
import org.michaloleniacz.project.review.dto.CreateNewReviewRequestDto;
import org.michaloleniacz.project.review.dto.ReviewDto;
import org.michaloleniacz.project.shared.dto.PaginatedResponseDto;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.shared.error.ForbiddenException;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

public class ReviewService {
    private ReviewRepository reviewRepository;
    private final int PAGE_SIZE = 10;
    private final int START_OFFSET = 0;
    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public void getUserReviews(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        UserDto user = ctx.getUser().get();

        try {
            int pageNumber = ctx.getQueryParam("pageNumber") == null ? 1 : Integer.parseInt(ctx.getQueryParam("pageNumber"));
            PaginatedResult<ReviewDto> pagedResult = reviewRepository.getReviewsForUser(user.id(), PAGE_SIZE, START_OFFSET + ((pageNumber - 1) * PAGE_SIZE));

            ctx.response()
                    .json(pagedResult)
                    .status(HttpStatus.OK)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException("Failed to get reviews.\n " + e.getMessage());
        }
    }

    public void getUserReviewsForGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        UserDto user = ctx.getUser().get();
        String gameIdStr = ctx.getQueryParam("gameId");
        final String pageSizeStr = ctx.getQueryParam("pageSize");
        final String pageNumberStr = ctx.getQueryParam("pageNumber");
        if (gameIdStr == null || pageSizeStr == null || pageNumberStr == null) {
            throw new BadRequestException("Missing required parameters");
        }

        UUID gameId;
        int pageSize;
        int pageNumber;
        try {
            gameId = UUID.fromString(gameIdStr);
            pageSize = Integer.parseInt(pageSizeStr);
            pageNumber = Integer.parseInt(pageNumberStr);
        } catch (IllegalArgumentException e) {
            throw new BadRequestException("Invalid parameter.");
        }

        PaginatedResult<ReviewDto> userReviews = reviewRepository.getUserReviewsForGame(user.id(), gameId, pageSize, pageSize * pageNumber );
        PaginatedResponseDto<ReviewDto> res = new PaginatedResponseDto<>(userReviews.result(), pageSize, pageNumber + 1, userReviews.result().size());
        ctx.response()
                .json(res)
                .status(HttpStatus.OK)
                .send();
    }

    public void getReviewsForGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        String gameIdStr = ctx.getQueryParam("gameId");
        final String pageSizeStr = ctx.getQueryParam("pageSize");
        final String pageNumberStr = ctx.getQueryParam("pageNumber");
        if (gameIdStr == null || pageSizeStr == null || pageNumberStr == null) {
            throw new BadRequestException("Missing required parameters");
        }

        UUID gameId;
        int pageSize;
        int pageNumber;
        try {
            gameId = UUID.fromString(gameIdStr);
            pageSize = Integer.parseInt(pageSizeStr);
            pageNumber = Integer.parseInt(pageNumberStr);
        } catch (IllegalArgumentException e) {
            throw new BadRequestException("Invalid parameter.");
        }

        PaginatedResult<ReviewDto> userReviews = reviewRepository.getAllReviewsForGame(gameId, pageSize, pageSize * pageNumber );
        PaginatedResponseDto<ReviewDto> res = new PaginatedResponseDto<>(userReviews.result(), pageSize, pageNumber + 1, userReviews.result().size());
        ctx.response()
                .json(res)
                .status(HttpStatus.OK)
                .send();
    }

    public void addNewReview(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<UserDto> userOpt = ctx.getUser();
        if (userOpt.isEmpty()) {
            throw new UnauthorizedException("You are not logged in.");
        }

        UserDto user = userOpt.get();
        CreateNewReviewRequestDto req = ctx.getParsedBody();

        reviewRepository.save(new ReviewDto(
                1,
                user.id(),
                "",
                req.gameId(),
                "",
                req.rating(),
                req.comment(),
                new java.sql.Date(System.currentTimeMillis())
        ));

        ctx.response()
                .status(HttpStatus.CREATED)
                .send();
    }

    public void removeReview(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<UserDto> userOpt = ctx.getUser();
        if (userOpt.isEmpty()) {
            throw new UnauthorizedException("You are not logged in.");
        }
        UserDto user = userOpt.get();
        String reviewIdStr = ctx.getQueryParam("id");

        try {
            int id = Integer.parseInt(reviewIdStr);
            reviewRepository.deleteUserReviewById(id, user.id());
            ctx.response()
                    .status(HttpStatus.NO_CONTENT)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException("Failed to process request.\n " + e.getMessage());
        }

    }
}
