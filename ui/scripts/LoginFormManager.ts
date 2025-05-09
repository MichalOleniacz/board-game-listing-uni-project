import type NavigationManager from "./NavigationManager";

export default class LoginFormManager {
    private navigationMgr: NavigationManager;
    private emailField = document.querySelector<HTMLInputElement>('#emailInput');
    private passwordField = document.querySelector<HTMLInputElement>('#passwordInput');
    private submitBtn = document.querySelector<HTMLButtonElement>('#submit');
    private eyeIcon = document.querySelector<HTMLImageElement>('#makePasswordVisibleEyeIcon');
    private passwordVisibilityStates = ['password', 'text'];
    private passwordPlaceholderStates = ['*********', 'Password!'];
    private currentPasswordVisibility = 0;

    constructor(navigationManager: NavigationManager) {
        this.navigationMgr = navigationManager;
    }

    private submitForm = (event: Event): void => {
        if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
            throw new Error("Login | Form failed to load correctly");

        event.preventDefault();

        const emailValue = this.emailField.value;
        const passwordValue = this.passwordField.value;

        console.log(emailValue, passwordValue);
    }

    private togglePasswordVisibility = (): void => {
        this.currentPasswordVisibility++;
        this.passwordField!.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
        this.passwordField!.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
    }

    init(): void {
        if (!this.emailField || !this.passwordField || !this.submitBtn)
            throw new Error("Login | Form failed to load correctly");

        if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
            throw new Error("Login | Form failed to load correctly");

        if (!(this.eyeIcon instanceof HTMLImageElement) || !(this.submitBtn instanceof HTMLButtonElement))
            throw new Error("Login | Form failed to load correctly");

        this.submitBtn.addEventListener('click', this.submitForm);
        this.eyeIcon.addEventListener('click', this.togglePasswordVisibility)

        console.log(this.emailField.value)
    }
}
