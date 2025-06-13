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

type UserDetailsDto = {
    firstName: string;
    lastName: string;
    city: string;
};

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

    private async fetchUserDetails(): Promise<void> {
        const firstName = document.getElementById('firstName') as HTMLInputElement;
        const lastName = document.getElementById('lastName') as HTMLInputElement;
        const city = document.getElementById('city') as HTMLInputElement;

        const res = await this.httpClient.get<UserDetailsDto>('/user/get-user-details');
        if (res.isOk()) {
            const user = res.unwrap();
            firstName.value = user.firstName;
            lastName.value = user.lastName;
            city.value = user.city;
        } else {
            console.warn('No user details found.');
        }
    }

    private setupUserDetailsForm(): void {
        const form = document.querySelector<HTMLFormElement>('form');
        if (!form) return;

        form.addEventListener('submit', async (event) => {
            event.preventDefault();

            const firstName = (document.getElementById('firstName') as HTMLInputElement).value;
            const lastName = (document.getElementById('lastName') as HTMLInputElement).value;
            const city = (document.getElementById('city') as HTMLInputElement).value;

            const res = await this.httpClient.post('/user/update-user-details', {
                firstName,
                lastName,
                city
            });

            alert(res.isOk() ? 'Details updated!' : 'Failed to update details');
        });
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
        result
            .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
            .forEach(review => {
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

    private setupAddPreferenceModal(): void {
        const openBtn = document.querySelector<HTMLButtonElement>('.addPreferenceBtn')!;
        const modal = document.getElementById('preferenceModal')!;
        const select = document.getElementById('preferenceSelect') as HTMLSelectElement;
        const save = document.getElementById('savePreferenceBtn')!;
        const cancel = document.getElementById('cancelPreferenceBtn')!;

        openBtn.addEventListener('click', async () => {
            modal.classList.remove('hidden');
            select.innerHTML = '<option value="">Select category...</option>';

            const res = await this.httpClient.get<{ preferences: Preference[] }>('/preference/get-all');
            if (res.isOk()) {
                res.unwrap().preferences.forEach(pref => {
                    const option = document.createElement('option');
                    option.value = pref.id.toString();
                    option.textContent = pref.name;
                    select.appendChild(option);
                });
            } else {
                alert('Failed to load preference options.');
            }
        });

        cancel.addEventListener('click', () => {
            modal.classList.add('hidden');
            select.selectedIndex = 0;
        });

        save.addEventListener('click', async () => {
            const selected = select.value;
            if (!selected) {
                alert('Please select a category');
                return;
            }

            const res = await this.httpClient.post(`/preference/add-user-preference?id=${encodeURIComponent(selected)}`, {});
            if (res.isOk()) {
                alert('Preference added!');
                modal.classList.add('hidden');
                this.fetchPreferences();
            } else {
                alert('Failed to add preference.');
            }
        });
    }

    init(): void {
        Promise.all([
            this.fetchUserDetails(),
            this.fetchPreferences(),
            this.fetchReviews()
        ]).catch(err => console.error('Error in HomeManager:', err));

        this.setupUserDetailsForm();
        this.setupAddPreferenceModal();
    }
}
