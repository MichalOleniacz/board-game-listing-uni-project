import { HttpClient } from './HttpClient/HttpClient';

type Preference = {
    id: number;
    name: string;
}

type PreferenceResponse = {
    preferences: Preference[]
}

type Review = {
    id: number,
    userId: string,
    gameId: string,
    gameTitle: string,
    rating: number,
    comment: string,
    createdAt: Date|string
}

type ReviewResponse = {
    result: Review[],
    pageSize: number,
    currentOffstet: number,
    pageNumber: number
}

export default class HomeManager {
    private httpClient: HttpClient;
    private preferenceList = document.querySelector<HTMLUListElement>('#userPreferenceList');

    constructor() {
        this.httpClient = new HttpClient();
    }

    private async fetchPreferences(): Promise<void> {
        if (!this.preferenceList) throw new Error('Preference list container not found');

        const res = await this.httpClient.get<PreferenceResponse>('/preference/get-user-preferences');

        if (res.isErr()) {
            console.error('Failed to fetch preferences.');
            return;
        }

        const body = res.unwrap();
        this.preferenceList.innerHTML = ''; // clear any existing content

        body.preferences.forEach(pref => {
            const li = this.createPreferenceItem(pref);
            this.preferenceList!.appendChild(li);
        });
    }

    private createPreferenceItem(pref: Preference): HTMLLIElement {
        const li = document.createElement('li');
        li.className = 'preferenceItem';
        li.textContent = pref.name;

        const deleteBtn = document.createElement('img');
        deleteBtn.src = 'assets/delete.svg';
        deleteBtn.alt = 'Delete';
        deleteBtn.className = 'deleteIcon';
        deleteBtn.style.cursor = 'pointer';
        deleteBtn.style.marginLeft = '8px';

        deleteBtn.addEventListener('click', async () => {
            const delRes = await this.httpClient.post('/preference/delete-user-preference', { preferenceId: pref.id });

            if (delRes.isOk()) {
                li.remove();
            } else {
                alert('Failed to delete preference.');
            }
        });

        li.appendChild(deleteBtn);
        return li;
    }

    private async fetchReviews(): Promise<void> {
        const reviewList = document.querySelector<HTMLDivElement>('.reviewList');
        if (!reviewList) throw new Error('Review list container not found');

        const res = await this.httpClient.get<ReviewResponse>('/review/get-user-reviews');

        if (res.isErr()) {
            console.error('Failed to fetch reviews.');
            return;
        }

        const { result } = res.unwrap();
        reviewList.innerHTML = '';
        console.log(result);
        result.forEach(review => {
            const card = this.createReviewCard(review);
            reviewList.appendChild(card);
        });
    }

    private createReviewCard(review: Review): HTMLDivElement {
        const card = document.createElement('div');
        card.className = 'reviewCard';

        const starsDiv = document.createElement('div');
        starsDiv.className = 'stars';
        starsDiv.textContent = '⭐'.repeat(review.rating);

        const reviewTextDiv = document.createElement('div');
        reviewTextDiv.className = 'reviewText';
        reviewTextDiv.innerHTML = `
        <strong>${review.gameTitle}</strong>
        <p>${review.comment}</p>
        <small>${new Date(review.createdAt).toLocaleDateString()}</small>
    `;

        const actionsDiv = document.createElement('div');
        actionsDiv.className = 'reviewActions';
        actionsDiv.innerHTML = `
        <img src="assets/delete.svg" alt="Delete" />
    `;

        card.appendChild(starsDiv);
        card.appendChild(reviewTextDiv);
        card.appendChild(actionsDiv);

        return card;
    }

    init(): void {
        Promise.all([
            this.fetchPreferences(),
            this.fetchReviews()
        ]).catch(err => console.error('Error in HomeManager:', err))

    }
}
