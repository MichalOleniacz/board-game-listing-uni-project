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
export default class AdminPanelManager {
    constructor() {
        this.httpClient = new HttpClient();
    }
    init() {
        this.bindUserSection();
        this.bindGameSection();
        this.bindAddGameSection();
        this.bindReviewSection();
    }
    bindUserSection() {
        const emailInput = document.getElementById('userSearchEmail');
        const searchBtn = document.getElementById('searchUserBtn');
        const container = document.getElementById('userFormContainer');
        const username = document.getElementById('userUsername');
        const city = document.getElementById('userCity');
        const role = document.getElementById('userRole');
        const saveBtn = document.getElementById('saveUserBtn');
        const deleteBtn = document.getElementById('deleteUserBtn');
        let userId;
        searchBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.get(`/admin/user/get-user-by-email?email=${emailInput.value}`);
            if (res.isOk()) {
                const user = res.unwrap();
                userId = user.id;
                username.value = user.username;
                city.value = user.city;
                role.value = user.role;
                container.classList.remove('hidden');
            }
            else {
                alert('User not found');
            }
        }));
        saveBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/user/update-user', {
                id: userId,
                username: username.value,
                city: city.value,
                role: role.value
            });
            alert(res.isOk() ? 'User updated' : 'Failed to update user');
        }));
        deleteBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/user/delete-user', { id: userId });
            alert(res.isOk() ? 'User deleted' : 'Failed to delete user');
            container.classList.add('hidden');
        }));
    }
    bindGameSection() {
        const titleInput = document.getElementById('gameSearchTitle');
        const searchBtn = document.getElementById('searchGameBtn');
        const container = document.getElementById('gameFormContainer');
        const title = document.getElementById('gameTitle');
        const desc = document.getElementById('gameDescription');
        const publisher = document.getElementById('gamePublisher');
        const year = document.getElementById('gameYear');
        const minPlayers = document.getElementById('gameMinPlayers');
        const maxPlayers = document.getElementById('gameMaxPlayers');
        const playtime = document.getElementById('gamePlaytime');
        const imageUrl = document.getElementById('gameImageUrl');
        const saveBtn = document.getElementById('saveGameBtn');
        const deleteBtn = document.getElementById('deleteGameBtn');
        let gameId;
        searchBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.get(`/admin/game/get-game-by-title?title=${encodeURIComponent(titleInput.value)}`);
            if (res.isOk()) {
                const game = res.unwrap();
                gameId = game.id;
                title.value = game.title;
                desc.value = game.description;
                publisher.value = game.publisher;
                year.value = game.yearPublished.toString();
                minPlayers.value = game.minPlayers.toString();
                maxPlayers.value = game.maxPlayers.toString();
                playtime.value = game.playtimeMinutes.toString();
                imageUrl.value = game.imageUrl;
                container.classList.remove('hidden');
            }
            else {
                alert('Game not found');
            }
        }));
        saveBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/update-game', {
                id: gameId,
                title: title.value,
                description: desc.value,
                publisher: publisher.value,
                yearPublished: parseInt(year.value),
                minPlayers: parseInt(minPlayers.value),
                maxPlayers: parseInt(maxPlayers.value),
                playtimeMinutes: parseInt(playtime.value),
                imageUrl: imageUrl.value
            });
            alert(res.isOk() ? 'Game updated' : 'Failed to update game');
        }));
        deleteBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/delete-game', { id: gameId });
            alert(res.isOk() ? 'Game deleted' : 'Failed to delete game');
            container.classList.add('hidden');
        }));
    }
    bindAddGameSection() {
        const title = document.getElementById('newGameTitle');
        const desc = document.getElementById('newGameDescription');
        const publisher = document.getElementById('newGamePublisher');
        const year = document.getElementById('newGameYear');
        const minPlayers = document.getElementById('newGameMinPlayers');
        const maxPlayers = document.getElementById('newGameMaxPlayers');
        const playtime = document.getElementById('newGamePlaytime');
        const imageUrl = document.getElementById('newGameImageUrl');
        const addBtn = document.getElementById('addGameBtn');
        addBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/add-game', {
                title: title.value,
                description: desc.value,
                publisher: publisher.value,
                yearPublished: parseInt(year.value),
                minPlayers: parseInt(minPlayers.value),
                maxPlayers: parseInt(maxPlayers.value),
                playtimeMinutes: parseInt(playtime.value),
                imageUrl: imageUrl.value
            });
            alert(res.isOk() ? 'Game added' : 'Failed to add game');
        }));
    }
    bindReviewSection() {
        const userEmail = document.getElementById('reviewUserEmail');
        const gameTitle = document.getElementById('reviewGameTitle');
        const searchBtn = document.getElementById('searchReviewsBtn');
        const resultList = document.getElementById('reviewResults');
        searchBtn.addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.httpClient.post('/admin/find-reviews', {
                email: userEmail.value,
                title: gameTitle.value
            });
            resultList.innerHTML = '';
            if (res.isErr()) {
                alert('Failed to fetch reviews');
                return;
            }
            const reviews = res.unwrap();
            reviews.forEach(review => {
                const li = document.createElement('li');
                li.innerHTML = `
          <span><strong>${review.gameTitle}</strong>: ${review.comment}</span>
          <button data-id="${review.id}">Delete</button>
        `;
                li.querySelector('button').addEventListener('click', () => __awaiter(this, void 0, void 0, function* () {
                    const delRes = yield this.httpClient.post('/admin/delete-review', { id: review.id });
                    if (delRes.isOk()) {
                        li.remove();
                    }
                    else {
                        alert('Failed to delete review');
                    }
                }));
                resultList.appendChild(li);
            });
        }));
    }
}
