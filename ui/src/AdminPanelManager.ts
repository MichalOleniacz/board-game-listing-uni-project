import { HttpClient } from './HttpClient/HttpClient';

type UserDto = {
    id: string;
    username: string;
    city: string;
    role: string;
    email: string;
};

type GameDto = {
    id: string;
    title: string;
    description: string;
    publisher: string;
    yearPublished: number;
    minPlayers: number;
    maxPlayers: number;
    playtimeMinutes: number;
    imageUrl: string;
};

type ReviewDto = {
    id: number;
    user: string;
    gameTitle: string;
    rating: number;
    comment: string;
    createdAt: string;
};

export default class AdminPanelManager {
    private httpClient = new HttpClient();

    init(): void {
        this.bindUserSection();
        this.bindGameSection();
        this.bindAddGameSection();
        this.bindReviewSection();
    }

    private bindUserSection(): void {
        const emailInput = document.getElementById('userSearchEmail') as HTMLInputElement;
        const searchBtn = document.getElementById('searchUserBtn')!;
        const container = document.getElementById('userFormContainer')!;
        const username = document.getElementById('userUsername') as HTMLInputElement;
        const city = document.getElementById('userCity') as HTMLInputElement;
        const role = document.getElementById('userRole') as HTMLInputElement;
        const saveBtn = document.getElementById('saveUserBtn')!;
        const deleteBtn = document.getElementById('deleteUserBtn')!;
        let userId: string;

        searchBtn.addEventListener('click', async () => {
            const res = await this.httpClient.get<UserDto>(`/admin/user/get-user-by-email?email=${emailInput.value}`);
            if (res.isOk()) {
                const user = res.unwrap();
                userId = user.id;
                username.value = user.username;
                city.value = user.city;
                role.value = user.role;
                container.classList.remove('hidden');
            } else {
                alert('User not found');
            }
        });

        saveBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post('/admin/user/update-user', {
                id: userId,
                username: username.value,
                city: city.value,
                role: role.value
            });

            alert(res.isOk() ? 'User updated' : 'Failed to update user');
        });

        deleteBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post('/admin/user/delete-user', { id: userId });
            alert(res.isOk() ? 'User deleted' : 'Failed to delete user');
            container.classList.add('hidden');
        });
    }

    private bindGameSection(): void {
        const titleInput = document.getElementById('gameSearchTitle') as HTMLInputElement;
        const searchBtn = document.getElementById('searchGameBtn')!;
        const container = document.getElementById('gameFormContainer')!;
        const title = document.getElementById('gameTitle') as HTMLInputElement;
        const desc = document.getElementById('gameDescription') as HTMLTextAreaElement;
        const publisher = document.getElementById('gamePublisher') as HTMLInputElement;
        const year = document.getElementById('gameYear') as HTMLInputElement;
        const minPlayers = document.getElementById('gameMinPlayers') as HTMLInputElement;
        const maxPlayers = document.getElementById('gameMaxPlayers') as HTMLInputElement;
        const playtime = document.getElementById('gamePlaytime') as HTMLInputElement;
        const imageUrl = document.getElementById('gameImageUrl') as HTMLInputElement;
        const saveBtn = document.getElementById('saveGameBtn')!;
        const deleteBtn = document.getElementById('deleteGameBtn')!;
        let gameId: string;

        searchBtn.addEventListener('click', async () => {
            const res = await this.httpClient.get<GameDto>(`/admin/game/get-game-by-title?title=${encodeURIComponent(titleInput.value)}`);
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
            } else {
                alert('Game not found');
            }
        });

        saveBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post('/admin/update-game', {
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
        });

        deleteBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post('/admin/delete-game', { id: gameId });
            alert(res.isOk() ? 'Game deleted' : 'Failed to delete game');
            container.classList.add('hidden');
        });
    }

    private bindAddGameSection(): void {
        const title = document.getElementById('newGameTitle') as HTMLInputElement;
        const desc = document.getElementById('newGameDescription') as HTMLTextAreaElement;
        const publisher = document.getElementById('newGamePublisher') as HTMLInputElement;
        const year = document.getElementById('newGameYear') as HTMLInputElement;
        const minPlayers = document.getElementById('newGameMinPlayers') as HTMLInputElement;
        const maxPlayers = document.getElementById('newGameMaxPlayers') as HTMLInputElement;
        const playtime = document.getElementById('newGamePlaytime') as HTMLInputElement;
        const imageUrl = document.getElementById('newGameImageUrl') as HTMLInputElement;
        const addBtn = document.getElementById('addGameBtn')!;

        addBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post('/admin/add-game', {
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
        });
    }

    private bindReviewSection(): void {
        const userEmail = document.getElementById('reviewUserEmail') as HTMLInputElement;
        const gameTitle = document.getElementById('reviewGameTitle') as HTMLInputElement;
        const searchBtn = document.getElementById('searchReviewsBtn')!;
        const resultList = document.getElementById('reviewResults')!;

        searchBtn.addEventListener('click', async () => {
            const res = await this.httpClient.post<ReviewDto[]>('/admin/find-reviews', {
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

                li.querySelector('button')!.addEventListener('click', async () => {
                    const delRes = await this.httpClient.post('/admin/delete-review', { id: review.id });
                    if (delRes.isOk()) {
                        li.remove();
                    } else {
                        alert('Failed to delete review');
                    }
                });

                resultList.appendChild(li);
            });
        });
    }
}
