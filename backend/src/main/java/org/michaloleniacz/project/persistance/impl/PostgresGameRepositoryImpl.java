package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.category.dto.CategoryDto;
import org.michaloleniacz.project.game.dto.AddNewGameRequestDto;
import org.michaloleniacz.project.game.dto.GameDto;
import org.michaloleniacz.project.game.dto.SearchGameRequestDto;
import org.michaloleniacz.project.game.dto.UpdateGameRequestDto;
import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.persistance.domain.GameRepository;

import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

public class PostgresGameRepositoryImpl implements GameRepository {
    private JdbcPostgresAdapter jdbcAdapter;
    public PostgresGameRepositoryImpl() {
        this.jdbcAdapter = new JdbcPostgresAdapter();
    }

    private String buildCategoryIds(ArrayList<Integer> categories) {
        return categories.stream().map(Objects::toString).collect(Collectors.joining(","));
    }

    private GameDto mapToDto(ResultSet rs) {
        try {
            final UUID id = UUID.fromString(rs.getString("id"));
            final String title = rs.getString("title");
            final String description = rs.getString("description");
            final int minPlayers = rs.getInt("min_players");
            final int maxPlayers = rs.getInt("max_players");
            final int playtimeMinutes = rs.getInt("playtime_minutes");
            final String publisher = rs.getString("publisher");
            final int yearPublished = rs.getInt("year_published");
            final String imageUrl = rs.getString("image_url");
            final Date createdAt = rs.getDate("created_at");
            final float avgRating = rs.getFloat("avg_rating");
            final String categories = rs.getString("categories");

            return new GameDto(
                    id,
                    title,
                    description,
                    minPlayers,
                    maxPlayers,
                    playtimeMinutes,
                    publisher,
                    yearPublished,
                    imageUrl,
                    createdAt,
                    avgRating,
                    categories
            );
        } catch (Exception e) {
            throw new IllegalStateException("Failed to map game to DTO.\n " + e.getMessage());
        }
    }
    @Override
    public PaginatedResult<GameDto> findAll(int page, int pageSize) {
        ArrayList<GameDto> result = jdbcAdapter.queryMany(
                "SELECT\n" +
                        "    gr.id,\n" +
                        "    title,\n" +
                        "    description,\n" +
                        "    min_players,\n" +
                        "    max_players,\n" +
                        "    playtime_minutes,\n" +
                        "    publisher,\n" +
                        "    year_published,\n" +
                        "    image_url,\n" +
                        "    created_at,\n" +
                        "    avg_rating,\n" +
                        "    string_agg(c.category_name, ', ') AS categories\n" +
                        "FROM game_ranking gr\n" +
                        "         JOIN game_category gc ON gc.game_id = gr.id\n" +
                        "         JOIN categories c ON c.id = gc.category_id\n" +
                        "GROUP BY\n" +
                        "    gr.id,\n" +
                        "    description,\n" +
                        "    title,\n" +
                        "    avg_rating,\n" +
                        "    year_published,\n" +
                        "    publisher,\n" +
                        "    playtime_minutes,\n" +
                        "    max_players,\n" +
                        "    min_players,\n" +
                        "    image_url,\n" +
                        "    created_at\n" +
                        "ORDER BY avg_rating DESC\n" +
                        "LIMIT ? OFFSET ?;\n",
                stmt -> {
                    stmt.setInt(1, pageSize);
                    stmt.setInt(2, page * pageSize);
                },
                this::mapToDto
        );
        return new PaginatedResult<GameDto>(result, pageSize, page * pageSize, page);
    }

    @Override
    public PaginatedResult<GameDto> findAllInCategories(int page, int pageSize, ArrayList<Integer> categoryIds) {
        String placeholders = categoryIds.stream()
                .map(id -> "?")
                .collect(Collectors.joining(", "));

        String sql = "SELECT\n" +
                "    gr.id,\n" +
                "    title,\n" +
                "    description,\n" +
                "    min_players,\n" +
                "    max_players,\n" +
                "    playtime_minutes,\n" +
                "    publisher,\n" +
                "    year_published,\n" +
                "    image_url,\n" +
                "    created_at,\n" +
                "    avg_rating,\n" +
                "    string_agg(c.category_name, ', ') AS categories\n" +
                "FROM game_ranking gr\n" +
                "         JOIN game_category gc ON gc.game_id = gr.id\n" +
                "         JOIN categories c ON c.id = gc.category_id\n" +
                "WHERE category_id IN (" + placeholders + ")\n" +
                "GROUP BY\n" +
                "    gr.id,\n" +
                "    description,\n" +
                "    title,\n" +
                "    avg_rating,\n" +
                "    year_published,\n" +
                "    publisher,\n" +
                "    playtime_minutes,\n" +
                "    max_players,\n" +
                "    min_players,\n" +
                "    image_url,\n" +
                "    created_at\n" +
                "ORDER BY avg_rating DESC\n" +
                "LIMIT ? OFFSET ?";

        ArrayList<GameDto> result = jdbcAdapter.queryMany(
                sql,
                stmt -> {
                    int i = 1;
                    for (int categoryId : categoryIds) {
                        stmt.setInt(i++, categoryId);
                    }
                    stmt.setInt(i++, pageSize);
                    stmt.setInt(i, page * pageSize);
                },
                this::mapToDto
        );

        return new PaginatedResult<>(result, pageSize, page * pageSize, page);
    }


    @Override
    public Optional<GameDto> findById(UUID id) {
        return jdbcAdapter.queryOne(
                "SELECT\n" +
                        "    gr.id,\n" +
                        "    title,\n" +
                        "    description,\n" +
                        "    min_players,\n" +
                        "    max_players,\n" +
                        "    playtime_minutes,\n" +
                        "    publisher,\n" +
                        "    year_published,\n" +
                        "    image_url,\n" +
                        "    created_at,\n" +
                        "    avg_rating,\n" +
                        "    string_agg(c.category_name, ', ') AS categories\n" +
                        "FROM game_ranking gr\n" +
                        "         JOIN game_category gc ON gc.game_id = gr.id\n" +
                        "         JOIN categories c ON c.id = gc.category_id\n" +
                        "WHERE gr.id = CAST(? AS UUID)\n" +
                        "GROUP BY\n" +
                        "    gr.id,\n" +
                        "    description,\n" +
                        "    title,\n" +
                        "    avg_rating,\n" +
                        "    year_published,\n" +
                        "    publisher,\n" +
                        "    playtime_minutes,\n" +
                        "    max_players,\n" +
                        "    min_players,\n" +
                        "    image_url,\n" +
                        "    created_at\n",
                stmt -> {
                    stmt.setString(1, id.toString());
                },
                this::mapToDto
        );
    }

    @Override
    public Optional<GameDto> findByTitle(String title) {
        return jdbcAdapter.queryOne(
                "SELECT\n" +
                        "    gr.id,\n" +
                        "    title,\n" +
                        "    description,\n" +
                        "    min_players,\n" +
                        "    max_players,\n" +
                        "    playtime_minutes,\n" +
                        "    publisher,\n" +
                        "    year_published,\n" +
                        "    image_url,\n" +
                        "    created_at,\n" +
                        "    avg_rating,\n" +
                        "    string_agg(c.category_name, ', ') AS categories\n" +
                        "FROM game_ranking gr\n" +
                        "         JOIN game_category gc ON gc.game_id = gr.id\n" +
                        "         JOIN categories c ON c.id = gc.category_id\n" +
                        "WHERE title = ?\n" +
                        "GROUP BY\n" +
                        "    gr.id,\n" +
                        "    description,\n" +
                        "    title,\n" +
                        "    avg_rating,\n" +
                        "    year_published,\n" +
                        "    publisher,\n" +
                        "    playtime_minutes,\n" +
                        "    max_players,\n" +
                        "    min_players,\n" +
                        "    image_url,\n" +
                        "    created_at\n",
                stmt -> stmt.setString(1, title),
                this::mapToDto
        );
    }

    @Override
    public void save(AddNewGameRequestDto gameDto) {
        jdbcAdapter.update(
                "INSERT INTO games (" +
                        "id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url" +
                        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                stmt -> {
                    stmt.setObject(1, UUID.randomUUID());
                    stmt.setString(2, gameDto.title());
                    stmt.setString(3, gameDto.description());
                    stmt.setInt(4, gameDto.minPlayers());
                    stmt.setInt(5, gameDto.maxPlayers());
                    stmt.setInt(6, gameDto.playtimeMinutes());
                    stmt.setString(7, gameDto.publisher());
                    stmt.setInt(8, gameDto.yearPublished());
                    stmt.setString(9, gameDto.imageUrl());
                }
        );
    }

    @Override
    public void update(UpdateGameRequestDto gameDto) {
        jdbcAdapter.update(
                "UPDATE games SET " +
                        "title = ?, " +
                        "description = ?, " +
                        "min_players = ?, " +
                        "max_players = ?, " +
                        "playtime_minutes = ?, " +
                        "publisher = ?, " +
                        "year_published = ?, " +
                        "image_url = ? " +
                        "WHERE id = ?",
                stmt -> {
                    stmt.setString(1, gameDto.title());
                    stmt.setString(2, gameDto.description());
                    stmt.setInt(3, gameDto.minPlayers());
                    stmt.setInt(4, gameDto.maxPlayers());
                    stmt.setInt(5, gameDto.playtimeMinutes());
                    stmt.setString(6, gameDto.publisher());
                    stmt.setInt(7, gameDto.yearPublished());
                    stmt.setString(8, gameDto.imageUrl());
                    stmt.setObject(9, gameDto.id());
                }
        );
    }

    @Override
    public void deleteById(UUID id) {
        jdbcAdapter.update(
                "DELETE FROM games WHERE id = ?",
                stmt -> stmt.setObject(1, id)
        );
    }

    @Override
    public ArrayList<GameDto> search(SearchGameRequestDto dto) {
        return jdbcAdapter.queryMany(
                "SELECT\n" +
                        "    g.*,\n" +
                        "    AVG(r.rating) AS avg_rating,\n" +
                        "    string_agg(DISTINCT c.category_name, ', ') AS categories\n" +
                        "FROM search_game(?) g\n" +
                        "    LEFT JOIN game_category gc ON g.id = gc.game_id\n" +
                        "    LEFT JOIN categories c on gc.category_id = c.id\n" +
                        "    LEFT JOIN reviews r on gc.game_id = r.game_id\n" +
                        "GROUP BY g.id, g.title, g.description, g.min_players, g.max_players, g.playtime_minutes, g.publisher, g.year_published, g.image_url, g.created_at;",
                stmt -> stmt.setString(1, dto.query()),
                this::mapToDto
        );
    }
}
