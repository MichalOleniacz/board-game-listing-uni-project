import { HttpClient } from './HttpClient/HttpClient';

interface Category {
    id: number;
    name: string;
}

type Game = {
    id: string; // UUID as string
    title: string;
    description: string;
    minPlayers: number;
    maxPlayers: number;
    playtimeMinutes: number;
    publisher: string;
    yearPublished: number;
    imageUrl: string;
    createdAt: string; // or Date, if parsed
    avgScore: number;
    categories: string; // comma-separated or pipe-delimited list
};

interface GetGamesResponse {
    result: Game[],
    pageSize: number,
    pageNumber: number,
    totalItems: number
}

export default class RankingManager {
    private httpClient = new HttpClient();
    private filterContainer = document.querySelector<HTMLDivElement>('#categoryFilters');
    private gamesList = document.querySelector<HTMLDivElement>('#gamesList');
    private selectedCategories = new Set<number>();

    init(): void {
        this.fetchCategories();
        this.fetchGames(); // load default unfiltered games
    }

    private async fetchCategories(): Promise<void> {
        if (!this.filterContainer) return;

        const res = await this.httpClient.get<{ result: Category[] }>('/category/get-all-categories');
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
                } else {
                    this.selectedCategories.add(cat.id);
                    btn.classList.add('active');
                }

                this.fetchGames(); // reload game list
            });

            this.filterContainer!.appendChild(btn);
        });
    }

    private async fetchGames(): Promise<void> {
        if (!this.gamesList) return;

        // Clear current games
        this.gamesList.innerHTML = '';

        let res;

        if (this.selectedCategories.size === 0) {
            // No filters selected — call GET API
            res = await this.httpClient.get<GetGamesResponse>('/game/get-top-games?pageNumber=0&pageSize=50');
        } else {
            // Filters selected — call POST API with categoryIds
            const body = {
                categoryIds: Array.from(this.selectedCategories),
                pageNumber: 0,
                pageSize: 50
            };
            res = await this.httpClient.post<GetGamesResponse>('/game/get-top-games-in-category', body);
        }

        if (res.isErr()) {
            console.error('Failed to fetch games');
            return;
        }

        const games = res.unwrap();

        games.result.forEach((game, idx) => {
            const card = this.createGameCard(game, idx + 1);
            this.gamesList!.appendChild(card);
        });
    }

    private createGameCard(game: Game, idx: number): HTMLDivElement {
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
