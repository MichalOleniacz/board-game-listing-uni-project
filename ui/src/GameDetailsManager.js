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
export default class GameDetailsManager {
    constructor() {
        this.httpClient = new HttpClient();
    }
    init() {
        return __awaiter(this, void 0, void 0, function* () {
            const id = this.getGameIdFromUrl();
            if (!id) {
                alert('No game ID provided.');
                return;
            }
            yield this.loadAndRenderReviews(id);
            this.setupAddReview(id);
            const res = yield this.httpClient.get(`/game/get-game?gameId=${encodeURIComponent(id)}`);
            if (res.isErr()) {
                alert('Failed to load game details.');
                return;
            }
            const game = res.unwrap();
            this.renderGame(game);
        });
    }
    getGameIdFromUrl() {
        const params = new URLSearchParams(window.location.search);
        return params.get('id');
    }
    renderGame(game) {
        const set = (id, value) => {
            const el = document.getElementById(id);
            if (el)
                el.textContent = value;
        };
        set('gameTitle', game.title);
        set('gameDescription', game.description);
        set('gamePlayers', `${game.minPlayers}–${game.maxPlayers}`);
        set('gameTime', `${game.playtimeMinutes} min`);
        set('gameScore', game.avgScore.toFixed(1));
        set('gamePublisher', `Publisher: ${game.publisher} (${game.yearPublished})`);
        set('gameCategories', `Categories: ${game.categories}`);
        const img = document.getElementById('gameImage');
        if (img) {
            img.src = game.imageUrl;
            img.alt = game.title;
        }
    }
    loadAndRenderReviews(gameId) {
        return __awaiter(this, void 0, void 0, function* () {
            const reviewContainer = document.querySelector('.reviewSection');
            if (!reviewContainer)
                return;
            const [userRes, allRes] = yield Promise.all([
                this.httpClient.get(`/review/get-user-reviews-for-game?gameId=${encodeURIComponent(gameId)}&pageSize=50&pageNumber=0`),
                this.httpClient.get(`/review/get-all-reviews-for-game?gameId=${encodeURIComponent(gameId)}&pageSize=50&pageNumber=0`)
            ]);
            if (userRes.isErr() || allRes.isErr()) {
                console.warn('Failed to fetch reviews');
                return;
            }
            const { result: userReviews } = userRes.unwrap();
            const { result: allReviews } = allRes.unwrap();
            const rendered = new Set();
            const combined = [];
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
        });
    }
    createReviewCard(review) {
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
    setupAddReview(gameId) {
        const btn = document.getElementById('addReviewBtn');
        const modal = document.getElementById('reviewModalOverlay');
        const cancel = document.getElementById('cancelReviewBtn');
        const submit = document.getElementById('submitReviewBtn');
        const stars = Array.from(document.querySelectorAll('#ratingStars span'));
        const comment = document.getElementById('reviewComment');
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
        submit.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            if (selectedRating === 0) {
                alert('Please select a rating.');
                return;
            }
            const res = yield this.httpClient.post('/review/add-user-review', {
                gameId,
                rating: selectedRating,
                comment: comment.value
            });
            if (res.isOk()) {
                alert('Review added!');
                window.location.reload();
            }
            else {
                alert('Failed to submit review');
            }
        }));
    }
}
