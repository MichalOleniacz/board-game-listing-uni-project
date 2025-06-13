import { HttpClient } from './HttpClient/HttpClient';

async function logout() {
    const http = new HttpClient();

    http.post('/auth/logout', {}).then(() => {
        document.cookie = 'SESSIONID=; Max-Age=0; path=/';
        window.location.assign('/login');
    });
}

logout();
