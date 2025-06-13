import { HttpClient } from './HttpClient/HttpClient';

export type GameDto = {
    id: string;                // UUID as string
    title: string;
    description: string;
    minPlayers: number;
    maxPlayers: number;
    playtimeMinutes: number;
    publisher: string;
    yearPublished: number;
    imageUrl: string;
    createdAt: string;         // ISO 8601 date string
    avgScore: number;
    categories: string;        // comma-separated list
};

export default class GameSearchManager {
    private http = new HttpClient();
    private input = document.getElementById('searchInput') as HTMLInputElement;
    private results = document.getElementById('searchResults')!;
    private debounceTimer: number | undefined;

    init() {
        this.input.addEventListener('input', () => {
            clearTimeout(this.debounceTimer);
            this.debounceTimer = window.setTimeout(() => {
                const query = this.input.value.trim();
                if (query.length > 0) {
                    this.search(query);
                } else {
                    this.results.innerHTML = '';
                }
            }, 300);
        });
    }

    private async search(query: string): Promise<void> {
        const res = await this.http.post<{ result: GameDto[] }>('/game/search-game', { query });

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
    }
}
