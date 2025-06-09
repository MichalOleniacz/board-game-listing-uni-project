import { HttpClient } from './HttpClient/HttpClient';

type GameDto = {
    id: string;
    title: string;
    description: string;
    minPlayers: number;
    maxPlayers: number;
    playtimeMinutes: number;
    publisher: string;
    yearPublished: number;
    imageUrl: string;
    createdAt: string;
    avgScore: number;
    categories: string;
};

type Review = {
    id: number;
    userId: string;
    username: string;
    gameId: string;
    gameTitle: string;
    rating: number;
    comment: string;
    createdAt: string;
};

export default class GameDetailsManager {
    private httpClient = new HttpClient();

    async init(): Promise<void> {
        const id = this.getGameIdFromUrl();
        if (!id) {
            alert('No game ID provided.');
            return;
        }

        await this.loadAndRenderReviews(id);
        this.setupAddReview(id);

        const res = await this.httpClient.get<GameDto>(`/game/get-game?gameId=${encodeURIComponent(id)}`);
        if (res.isErr()) {
            alert('Failed to load game details.');
            return;
        }

        const game = res.unwrap();
        this.renderGame(game);
    }

    private getGameIdFromUrl(): string | null {
        const params = new URLSearchParams(window.location.search);
        return params.get('id');
    }

    private renderGame(game: GameDto): void {
        const set = (id: string, value: string) => {
            const el = document.getElementById(id);
            if (el) el.textContent = value;
        };

        set('gameTitle', game.title);
        set('gameDescription', game.description);
        set('gamePlayers', `${game.minPlayers}–${game.maxPlayers}`);
        set('gameTime', `${game.playtimeMinutes} min`);
        set('gameScore', game.avgScore.toFixed(1));
        set('gamePublisher', `Publisher: ${game.publisher} (${game.yearPublished})`);
        set('gameCategories', `Categories: ${game.categories}`);

        const img = document.getElementById('gameImage') as HTMLImageElement | null;
        if (img) {
            img.src = game.imageUrl;
            img.alt = game.title;
        }
    }

    private async loadAndRenderReviews(gameId: string): Promise<void> {
        const reviewContainer = document.querySelector<HTMLElement>('.reviewSection');
        if (!reviewContainer) return;

        const [userRes, allRes] = await Promise.all([
            this.httpClient.get<{ result: Review[] }>(
                `/review/get-user-reviews-for-game?gameId=${encodeURIComponent(gameId)}&pageSize=50&pageNumber=0`
            ),
            this.httpClient.get<{ result: Review[] }>(
                `/review/get-all-reviews-for-game?gameId=${encodeURIComponent(gameId)}&pageSize=50&pageNumber=0`
            )
        ]);

        if (userRes.isErr() || allRes.isErr()) {
            console.warn('Failed to fetch reviews');
            return;
        }

        const { result: userReviews } = userRes.unwrap();
        const { result: allReviews } = allRes.unwrap();

        const rendered = new Set<number>();
        const combined: Review[] = [];

        userReviews.forEach(r => {
            rendered.add(r.id);
            combined.push(r);
        });

        allReviews.forEach(r => {
            if (!rendered.has(r.id)) {
                combined.push(r);
            }
        });

        combined.forEach(review => {
            const card = this.createReviewCard(review);
            reviewContainer.appendChild(card);
        });
    }

    private createReviewCard(review: Review): HTMLElement {
        const div = document.createElement('div');
        div.className = 'reviewCard';

        div.innerHTML = `
            <div class="reviewStars">${'⭐'.repeat(review.rating)}</div>
            <div class="reviewText">
              <strong>${review.gameTitle}</strong>
              <p>${review.comment}</p>
              <small>by ${review.username} • ${new Date(review.createdAt).toLocaleDateString()}</small>
            </div>
        `;

        return div;
    }

    private setupAddReview(gameId: string): void {
        const btn = document.getElementById('addReviewBtn')!;
        const modal = document.getElementById('reviewModalOverlay')!;
        const cancel = document.getElementById('cancelReviewBtn')!;
        const submit = document.getElementById('submitReviewBtn')!;
        const stars = Array.from(document.querySelectorAll<HTMLSpanElement>('#ratingStars span'));
        const comment = document.getElementById('reviewComment') as HTMLTextAreaElement;
        let selectedRating = 0;

        btn.addEventListener('click', () => {
            modal.classList.remove('hidden');
        });

        cancel.addEventListener('click', () => {
            modal.classList.add('hidden');
            stars.forEach(s => s.classList.remove('active'));
            comment.value = '';
            selectedRating = 0;
        });

        stars.forEach(star => {
            star.addEventListener('click', () => {
                selectedRating = parseInt(star.dataset.rating || '0');
                stars.forEach(s => {
                    const r = parseInt(s.dataset.rating || '0');
                    s.classList.toggle('active', r <= selectedRating);
                });
            });
        });

        submit.addEventListener('click', async () => {
            if (selectedRating === 0) {
                alert('Please select a rating.');
                return;
            }

            const res = await this.httpClient.post('/review/add-user-review', {
                gameId,
                rating: selectedRating,
                comment: comment.value
            });

            if (res.isOk()) {
                alert('Review added!');
                window.location.reload();
            } else {
                alert('Failed to submit review');
            }
        });
    }
}
