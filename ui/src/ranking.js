import RankingManager from "./RankingManager";
window.addEventListener('DOMContentLoaded', () => {
    const menuIcon = document.querySelector('.menuIcon');
    const hamburgerMenu = document.getElementById('hamburgerMenu');
    const overlay = document.getElementById('menuOverlay');
    if (!menuIcon || !hamburgerMenu || !overlay)
        return;
    const toggleMenu = () => {
        hamburgerMenu.classList.toggle('open');
        overlay.classList.toggle('active');
    };
    menuIcon.addEventListener('click', toggleMenu);
    overlay.addEventListener('click', toggleMenu);
    new RankingManager().init();
});
