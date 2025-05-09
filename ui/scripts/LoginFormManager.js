export default class LoginFormManager {
    constructor(navigationManager) {
        this.emailField = document.querySelector('#emailInput');
        this.passwordField = document.querySelector('#passwordInput');
        this.submitBtn = document.querySelector('#submit');
        this.eyeIcon = document.querySelector('#makePasswordVisibleEyeIcon');
        this.passwordVisibilityStates = ['password', 'text'];
        this.passwordPlaceholderStates = ['*********', 'Password!'];
        this.currentPasswordVisibility = 0;
        this.submitForm = (event) => {
            if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
                throw new Error("Login | Form failed to load correctly");
            event.preventDefault();
            const emailValue = this.emailField.value;
            const passwordValue = this.passwordField.value;
            console.log(emailValue, passwordValue);
        };
        this.togglePasswordVisibility = () => {
            this.currentPasswordVisibility++;
            this.passwordField.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
            this.passwordField.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
        };
        this.navigationMgr = navigationManager;
    }
    init() {
        if (!this.emailField || !this.passwordField || !this.submitBtn)
            throw new Error("Login | Form failed to load correctly");
        if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
            throw new Error("Login | Form failed to load correctly");
        if (!(this.eyeIcon instanceof HTMLImageElement) || !(this.submitBtn instanceof HTMLButtonElement))
            throw new Error("Login | Form failed to load correctly");
        this.submitBtn.addEventListener('click', this.submitForm);
        this.eyeIcon.addEventListener('click', this.togglePasswordVisibility);
        console.log(this.emailField.value);
    }
}
