import { HttpClient } from './HttpClient/HttpClient';

type Review = {
    id: number;
    gameTitle: string;
    rating: number;
    comment: string;
    createdAt: string;
};

export default class MyReviewsManager {
    private http = new HttpClient();
    private list = document.getElementById('reviewList')!;

    async init() {
        const res = await this.http.get<{ result: Review[] }>('/review/get-user-reviews');
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
    }

    private createReviewCard(review: Review): HTMLElement {
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

        const deleteBtn = div.querySelector('button')!;
        deleteBtn.addEventListener('click', async () => {
            const confirmDelete = confirm('Are you sure you want to delete this review?');
            if (!confirmDelete) return;

            const res = await this.http.post(`/review/delete-user-review?id=${encodeURIComponent(review.id)}`, {});
            if (res.isOk()) {
                div.remove();
            } else {
                alert('Failed to delete review');
            }
        });

        return div;
    }
}
