// ui/vite.config.js
import { defineConfig } from 'vite'
import { resolve } from 'path'

export default defineConfig({
    build: {
        rollupOptions: {
            input: {
                index: resolve(__dirname, 'index.html'),
                login: resolve(__dirname, 'login.html'),
                register: resolve(__dirname, 'register.html'),
                home: resolve(__dirname, 'home.html'),
                ranking: resolve(__dirname, 'ranking.html'),
                logout: resolve(__dirname, 'logout.html'),
                'admin-panel': resolve(__dirname, 'admin-panel.html'),
                'my-reviews': resolve(__dirname, 'my-reviews.html'),
                'find-game': resolve(__dirname, 'find-game.html'),
                'game-details': resolve(__dirname, 'game-details.html'),
            }
        }
    }
})
