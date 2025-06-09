package org.michaloleniacz.project.game;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class GameController {
    private GameService gameService;
    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    public void getGameById(RequestContext ctx) {
        gameService.getGameById(ctx);
    }

    public void getGameByTitle(RequestContext ctx) {
        gameService.getGameByTitle(ctx);
    }

    public void getGamesInCategories(RequestContext ctx) {
        gameService.getGamesInCategories(ctx);
    }

    public void getAllGames(RequestContext ctx) {
        gameService.getAllGames(ctx);
    }

    public void createGame(RequestContext ctx) {
        gameService.createGame(ctx);
    }
}
