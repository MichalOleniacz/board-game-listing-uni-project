var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { HttpClient } from './HttpClient/HttpClient';
export default class RankingManager {
    constructor() {
        this.httpClient = new HttpClient();
        this.filterContainer = document.querySelector('#categoryFilters');
        this.gamesList = document.querySelector('#gamesList');
        this.selectedCategories = new Set();
    }
    init() {
        this.fetchCategories();
        this.fetchGames(); // load default unfiltered games
    }
    fetchCategories() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.filterContainer)
                return;
            const res = yield this.httpClient.get('/category/get-all-categories');
            if (res.isErr()) {
                console.error('Failed to load categories');
                return;
            }
            const categories = res.unwrap().result;
            categories.forEach(cat => {
                const btn = document.createElement('button');
                btn.textContent = cat.name;
                btn.className = 'filterBtn';
                btn.dataset.categoryId = cat.id.toString();
                btn.addEventListener('click', () => {
                    const selected = this.selectedCategories.has(cat.id);
                    if (selected) {
                        this.selectedCategories.delete(cat.id);
                        btn.classList.remove('active');
                    }
                    else {
                        this.selectedCategories.add(cat.id);
                        btn.classList.add('active');
                    }
                    this.fetchGames(); // reload game list
                });
                this.filterContainer.appendChild(btn);
            });
        });
    }
    fetchGames() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.gamesList)
                return;
            // Clear current games
            this.gamesList.innerHTML = '';
            let res;
            if (this.selectedCategories.size === 0) {
                // No filters selected — call GET API
                res = yield this.httpClient.get('/game/get-top-games?pageNumber=0&pageSize=50');
            }
            else {
                // Filters selected — call POST API with categoryIds
                const body = {
                    categoryIds: Array.from(this.selectedCategories),
                    pageNumber: 0,
                    pageSize: 50
                };
                res = yield this.httpClient.post('/game/get-top-games-in-category', body);
            }
            if (res.isErr()) {
                console.error('Failed to fetch games');
                return;
            }
            const games = res.unwrap();
            games.result.forEach((game, idx) => {
                const card = this.createGameCard(game, idx + 1);
                this.gamesList.appendChild(card);
            });
        });
    }
    createGameCard(game, idx) {
        const card = document.createElement('div');
        card.className = 'gameCard';
        card.style.cursor = 'pointer';
        card.innerHTML = `
      <div class="gameInfo">
        <span class="rank">#${idx}</span>
        <div class="gameText">
          <h2>${game.title}</h2>
          <p>${game.description}</p>
        </div>
      </div>
      <div class="stats">
        <div class="scoreBlock">
          <label>Avg. score</label>
          <div class="scoreValue">${game.avgScore}</div>
        </div>
      </div>
    `;
        card.addEventListener('click', () => {
            window.location.assign(`/game-details.html?id=${encodeURIComponent(game.id)}`);
        });
        return card;
    }
}
