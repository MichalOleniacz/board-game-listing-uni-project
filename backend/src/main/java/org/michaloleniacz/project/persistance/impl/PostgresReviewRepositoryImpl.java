package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.persistance.domain.ReviewRepository;
import org.michaloleniacz.project.review.dto.ReviewDto;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;

public class PostgresReviewRepositoryImpl implements ReviewRepository {

    private JdbcPostgresAdapter jdbcAdapter;

    public PostgresReviewRepositoryImpl() {
        jdbcAdapter = new JdbcPostgresAdapter();
    }

    private ReviewDto mapToReviewDto(ResultSet rs) {
        try {
            int id = rs.getInt("id");
            UUID userId = UUID.fromString(rs.getString("user_id"));
            String username = rs.getString("username");
            UUID gameId = UUID.fromString(rs.getString("game_id"));
            String gameTitle = rs.getString("game_title");
            int rating = rs.getInt("rating");
            String comment = rs.getString("comment");
            Date created = rs.getDate("created_at");
            return new ReviewDto(id, userId, username, gameId, gameTitle, rating, comment, created);
        } catch (Exception e) {
            throw new InternalServerErrorException("Failed to map to ReviewDto\n " + e.getMessage());
        }
    }

    @Override
    public final Optional<ReviewDto> getReviewById(int reviewId) {
        return jdbcAdapter.queryOne(
                "SELECT r.*, g.title AS game_title, u.username AS username FROM reviews r LEFT JOIN games g on r.game_id = g.id LEFT JOIN users u on r.user_id = u.id WHERE id = ?",
                stmt -> stmt.setInt(1, reviewId),
                this::mapToReviewDto
        );
    }

    @Override
    public void deleteUserReviewById(int reviewId) {
        jdbcAdapter.update(
                "DELETE FROM reviews WHERE id = ?",
                stmt -> stmt.setInt(1, reviewId)
        );
    }

    @Override
    public final PaginatedResult<ReviewDto> getAllReviewsForGame(UUID gameId, int limit, int offset) {
        ArrayList<ReviewDto> results = jdbcAdapter.queryMany(
                "SELECT r.*, g.title AS game_title, u.username AS username FROM reviews r LEFT JOIN games g on r.game_id = g.id LEFT JOIN users u on r.user_id = u.id WHERE game_id = CAST(? AS UUID) LIMIT ? OFFSET ?",
                stmt -> {
                    stmt.setString(1, gameId.toString());
                    stmt.setInt(2, limit);
                    stmt.setInt(3, offset);
                },
                this::mapToReviewDto
        );
        return new PaginatedResult<>(results, limit, offset + limit, offset / limit);
    }

    @Override
    public PaginatedResult<ReviewDto> getUserReviewsForGame(UUID userId, UUID gameId, int limit, int offset) {
        ArrayList<ReviewDto> results = jdbcAdapter.queryMany(
                "SELECT r.*, g.title AS game_title, u.username AS username FROM reviews r LEFT JOIN games g on r.game_id = g.id LEFT JOIN users u on r.user_id = u.id WHERE user_id = CAST(? AS UUID) AND game_id = CAST(? AS UUID) LIMIT ? OFFSET ?",
                stmt -> {
                    stmt.setString(1, userId.toString());
                    stmt.setString(2, gameId.toString());
                    stmt.setInt(3, limit);
                    stmt.setInt(4, offset);
                },
                this::mapToReviewDto
        );
        return new PaginatedResult<>(results, limit, offset + limit, offset / limit);
    }

    @Override
    public PaginatedResult<ReviewDto> getReviewsForUser(UUID userId, int limit, int offset) {
        ArrayList<ReviewDto> results = jdbcAdapter.queryMany(
                "SELECT r.*, g.title AS game_title, u.username AS username FROM reviews r LEFT JOIN games g on r.game_id = g.id LEFT JOIN users u on r.user_id = u.id WHERE user_id = CAST(? AS UUID) LIMIT ? OFFSET ?",
                stmt -> {
                    stmt.setString(1, userId.toString());
                    stmt.setInt(2, limit);
                    stmt.setInt(3, offset);
                },
                this::mapToReviewDto
        );
        return new PaginatedResult<>(results, limit, offset + limit, offset / limit);
    }

    @Override
    public void save(ReviewDto reviewDto) {
        jdbcAdapter.update(
                "INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)",
                stmt -> {
                    stmt.setObject(1, reviewDto.userId());
                    stmt.setObject(2, reviewDto.gameId());
                    stmt.setInt(3, reviewDto.rating());
                    stmt.setString(4, reviewDto.comment());
                    stmt.setDate(5, reviewDto.createdAt());
                }
        );
    }
}
