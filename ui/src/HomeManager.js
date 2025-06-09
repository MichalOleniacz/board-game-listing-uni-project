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
export default class HomeManager {
    constructor() {
        this.preferenceList = document.querySelector('#userPreferenceList');
        this.httpClient = new HttpClient();
    }
    fetchPreferences() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.preferenceList)
                throw new Error('Preference list container not found');
            const res = yield this.httpClient.get('/preference/get-user-preferences');
            if (res.isErr()) {
                console.error('Failed to fetch preferences.');
                return;
            }
            const body = res.unwrap();
            this.preferenceList.innerHTML = ''; // clear any existing content
            body.preferences.forEach(pref => {
                const li = this.createPreferenceItem(pref);
                this.preferenceList.appendChild(li);
            });
        });
    }
    createPreferenceItem(pref) {
        const li = document.createElement('li');
        li.className = 'preferenceItem';
        li.textContent = pref.name;
        const deleteBtn = document.createElement('img');
        deleteBtn.src = 'assets/delete.svg';
        deleteBtn.alt = 'Delete';
        deleteBtn.className = 'deleteIcon';
        deleteBtn.style.cursor = 'pointer';
        deleteBtn.style.marginLeft = '8px';
        deleteBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const delRes = yield this.httpClient.post('/preference/delete-user-preference', { preferenceId: pref.id });
            if (delRes.isOk()) {
                li.remove();
            }
            else {
                alert('Failed to delete preference.');
            }
        }));
        li.appendChild(deleteBtn);
        return li;
    }
    fetchReviews() {
        return __awaiter(this, void 0, void 0, function* () {
            const reviewList = document.querySelector('.reviewList');
            if (!reviewList)
                throw new Error('Review list container not found');
            const res = yield this.httpClient.get('/review/get-user-reviews');
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
        });
    }
    createReviewCard(review) {
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
    init() {
        Promise.all([
            this.fetchPreferences(),
            this.fetchReviews()
        ]).catch(err => console.error('Error in HomeManager:', err));
    }
}
