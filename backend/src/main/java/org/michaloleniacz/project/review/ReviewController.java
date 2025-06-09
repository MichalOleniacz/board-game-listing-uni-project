package org.michaloleniacz.project.review;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class ReviewController {
    private ReviewService reviewService;
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    public void getUserReviews(RequestContext ctx) {
        reviewService.getUserReviews(ctx);
    }

    public void getUserReviewsForGame(RequestContext ctx) {
        reviewService.getUserReviewsForGame(ctx);
    }

    public void getReviewsForGame(RequestContext ctx) {
        reviewService.getReviewsForGame(ctx);
    }

    public void addNewReview(RequestContext ctx) {
        reviewService.addNewReview(ctx);
    }
}
