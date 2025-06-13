package org.michaloleniacz.project.game;

import org.michaloleniacz.project.game.dto.*;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.core.PaginatedResult;
import org.michaloleniacz.project.persistance.domain.GameRepository;
import org.michaloleniacz.project.shared.dto.PaginatedResponseDto;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;

import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;

public class GameService {
    private GameRepository gameRepository;
    public GameService(GameRepository gameRepository) {
        this.gameRepository = gameRepository;
    }

    public void getGameById(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        String gameIdStr = ctx.getQueryParam("gameId");
        if (gameIdStr == null) {
            throw new BadRequestException("Missing required parameter 'gameId'");
        }

        UUID gameId;
        try {
            gameId = UUID.fromString(gameIdStr);
        } catch (IllegalArgumentException e) {
            throw new BadRequestException("Invalid parameter 'gameId'");
        }

        Optional<GameDto> maybeGame = gameRepository.findById(gameId);
        maybeGame.ifPresentOrElse(gameDto -> {
            ctx.response()
                    .json(gameDto)
                    .status(HttpStatus.OK)
                    .send();
        }, () -> { throw new BadRequestException("Game not found");});
    }

    public void getGameByTitle(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        String titleStr = ctx.getQueryParam("title");
        if (titleStr == null) {
            throw new BadRequestException("Missing required parameter 'gameId'");
        }

        Optional<GameDto> maybeGame = gameRepository.findByTitle(titleStr);
        maybeGame.ifPresentOrElse(gameDto -> {
            ctx.response()
                    .json(gameDto)
                    .status(HttpStatus.OK)
                    .send();
        }, () -> { throw new BadRequestException("Game not found");});
    }

    public void getAllGames(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        final String pageSizeStr = ctx.getQueryParam("pageSize");
        final String pageNumberStr = ctx.getQueryParam("pageNumber");
        if (pageSizeStr == null || pageNumberStr == null) {
            throw new BadRequestException("Missing required parameters");
        }

        int pageSize;
        int pageNumber;
        try {
            pageSize = Integer.parseInt(pageSizeStr);
            pageNumber = Integer.parseInt(pageNumberStr);
        } catch (NumberFormatException e) {
            throw new BadRequestException("Invalid parameter.");
        }

        PaginatedResult<GameDto> paginatedResult = gameRepository.findAll(pageNumber, pageSize);
        PaginatedResponseDto res = new PaginatedResponseDto<>(paginatedResult.result(), paginatedResult.pageNumber(), paginatedResult.pageNumber(), paginatedResult.result().size());

        ctx.response()
                .json(res)
                .status(HttpStatus.OK)
                .send();
    }

    public void getGamesInCategories(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        final GetGamesInCategoryRequestDto req = ctx.getParsedBody();

        PaginatedResult<GameDto> paginatedResult = gameRepository.findAllInCategories(req.pageNumber(), req.pageSize(), req.categoryIds());
        PaginatedResponseDto res = new PaginatedResponseDto(paginatedResult.result(), paginatedResult.pageNumber(), paginatedResult.pageNumber(), paginatedResult.result().size());
        ctx.response()
                .json(res)
                .status(HttpStatus.OK)
                .send();
    }

    public void createGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        AddNewGameRequestDto req = ctx.getParsedBody();

        if (Stream.of(req.description(), req.title()).anyMatch(String::isEmpty)) {
            throw new BadRequestException("Missing required parameters");
        }

        try {
            gameRepository.save(req);
            ctx.response()
                    .status(HttpStatus.CREATED)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(e.getMessage());
        }
    }

    public void updateGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        UpdateGameRequestDto req = ctx.getParsedBody();

        if (Stream.of(req.description(), req.title()).anyMatch(String::isEmpty)) {
            throw new BadRequestException("Missing required parameters");
        }

        try {
            gameRepository.update(req);
            ctx.response()
                    .status(HttpStatus.CREATED)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(e.getMessage());
        }
    }

    public void deleteGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        String gameIdStr = ctx.getQueryParam("id");
        UUID gameId = UUID.fromString(gameIdStr);

        try {
            gameRepository.deleteById(gameId);
            ctx.response()
                    .status(HttpStatus.NO_CONTENT)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(e.getMessage());
        }
    }

    public void searchGame(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in");
        }

        SearchGameRequestDto req = ctx.getParsedBody();

        if (req.query() == null || req.query().isEmpty()) {
            throw new BadRequestException("Missing required parameters");
        }

        ArrayList<GameDto> games = gameRepository.search(req);
        ctx.response()
                .json(new PaginatedResponseDto(games, games.size(), 0, games.size()))
                .status(HttpStatus.OK)
                .send();
    }
}
