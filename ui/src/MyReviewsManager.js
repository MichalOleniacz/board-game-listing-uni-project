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
export default class MyReviewsManager {
    constructor() {
        this.http = new HttpClient();
        this.list = document.getElementById('reviewList');
    }
    init() {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield this.http.get('/review/get-user-reviews');
            if (res.isErr()) {
                console.error('Failed to fetch reviews');
                this.list.innerHTML = '<p>Failed to load reviews.</p>';
                return;
            }
            const { result } = res.unwrap();
            this.list.innerHTML = '';
            if (result.length === 0) {
                this.list.innerHTML = '<p>You haven’t submitted any reviews yet.</p>';
            }
            result.forEach(review => {
                this.list.appendChild(this.createReviewCard(review));
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
        <small>${new Date(review.createdAt).toLocaleDateString()}</small>
      </div>
      <div class="reviewActions">
        <button>Delete</button>
      </div>
    `;
        const deleteBtn = div.querySelector('button');
        deleteBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const confirmDelete = confirm('Are you sure you want to delete this review?');
            if (!confirmDelete)
                return;
            const res = yield this.http.post(`/review/delete-user-review?id=${encodeURIComponent(review.id)}`, {});
            if (res.isOk()) {
                div.remove();
            }
            else {
                alert('Failed to delete review');
            }
        }));
        return div;
    }
}
