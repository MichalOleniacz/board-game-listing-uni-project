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
export default class GameSearchManager {
    constructor() {
        this.http = new HttpClient();
        this.input = document.getElementById('searchInput');
        this.results = document.getElementById('searchResults');
    }
    init() {
        this.input.addEventListener('input', () => {
            clearTimeout(this.debounceTimer);
            this.debounceTimer = window.setTimeout(() => {
                const query = this.input.value.trim();
                if (query.length > 0) {
                    this.search(query);
                }
                else {
                    this.results.innerHTML = '';
                }
            }, 300);
        });
    }
    search(query) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield this.http.post('/game/search-game', { query });
            if (res.isErr()) {
                console.error('Search failed');
                return;
            }
            const { result } = res.unwrap();
            this.results.innerHTML = '';
            if (result.length === 0) {
                this.results.innerHTML = '<p>No results found.</p>';
                return;
            }
            result.forEach(game => {
                const card = document.createElement('div');
                card.className = 'gameCard';
                card.innerHTML = `
  <div class="gameHeader">
    <h2 class="gameTitle">${game.title}</h2>
    <span class="gameScore">⭐ ${game.avgScore.toFixed(1)}</span>
  </div>
  <p class="gameDescription">${game.description}</p>
  <div class="gameMeta">
    <div><strong>Players:</strong> ${game.minPlayers}–${game.maxPlayers}</div>
    <div><strong>Playtime:</strong> ${game.playtimeMinutes} min</div>
    <div><strong>Publisher:</strong> ${game.publisher} (${game.yearPublished})</div>
    <div><strong>Categories:</strong> ${game.categories}</div>
  </div>
`;
                card.addEventListener('click', () => {
                    window.location.assign(`/game-details.html?id=${game.id}`);
                });
                this.results.appendChild(card);
            });
        });
    }
}
