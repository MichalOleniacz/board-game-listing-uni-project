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
    fetchUserDetails() {
        return __awaiter(this, void 0, void 0, function* () {
            const firstName = document.getElementById('firstName');
            const lastName = document.getElementById('lastName');
            const city = document.getElementById('city');
            const res = yield this.httpClient.get('/user/get-user-details');
            if (res.isOk()) {
                const user = res.unwrap();
                firstName.value = user.firstName;
                lastName.value = user.lastName;
                city.value = user.city;
            }
            else {
                console.warn('No user details found.');
            }
        });
    }
    setupUserDetailsForm() {
        const form = document.querySelector('form');
        if (!form)
            return;
        form.addEventListener('submit', (event) => __awaiter(this, void 0, void 0, function* () {
            event.preventDefault();
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const city = document.getElementById('city').value;
            const res = yield this.httpClient.post('/user/update-user-details', {
                firstName,
                lastName,
                city
            });
            alert(res.isOk() ? 'Details updated!' : 'Failed to update details');
        }));
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
            result
                .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
                .forEach(review => {
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
    setupAddPreferenceModal() {
        const openBtn = document.querySelector('.addPreferenceBtn');
        const modal = document.getElementById('preferenceModal');
        const select = document.getElementById('preferenceSelect');
        const save = document.getElementById('savePreferenceBtn');
        const cancel = document.getElementById('cancelPreferenceBtn');
        openBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            modal.classList.remove('hidden');
            select.innerHTML = '<option value="">Select category...</option>';
            const res = yield this.httpClient.get('/preference/get-all');
            if (res.isOk()) {
                res.unwrap().preferences.forEach(pref => {
                    const option = document.createElement('option');
                    option.value = pref.id.toString();
                    option.textContent = pref.name;
                    select.appendChild(option);
                });
            }
            else {
                alert('Failed to load preference options.');
            }
        }));
        cancel.addEventListener('click', () => {
            modal.classList.add('hidden');
            select.selectedIndex = 0;
        });
        save.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const selected = select.value;
            if (!selected) {
                alert('Please select a category');
                return;
            }
            const res = yield this.httpClient.post(`/preference/add-user-preference?id=${encodeURIComponent(selected)}`, {});
            if (res.isOk()) {
                alert('Preference added!');
                modal.classList.add('hidden');
                this.fetchPreferences();
            }
            else {
                alert('Failed to add preference.');
            }
        }));
    }
    init() {
        Promise.all([
            this.fetchUserDetails(),
            this.fetchPreferences(),
            this.fetchReviews()
        ]).catch(err => console.error('Error in HomeManager:', err));
        this.setupUserDetailsForm();
        this.setupAddPreferenceModal();
    }
}
