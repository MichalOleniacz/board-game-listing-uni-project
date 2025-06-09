import { HttpClient } from './HttpClient/HttpClient';

export default class RegisterFormManager {
    private httpClient: HttpClient;

    private usernameField = document.querySelector<HTMLInputElement>('#usernameInput');
    private emailField = document.querySelector<HTMLInputElement>('#emailInput');
    private passwordField = document.querySelector<HTMLInputElement>('#passwordInput');
    private submitBtn = document.querySelector<HTMLButtonElement>('#submitBtn');
    private eyeIcon = document.querySelector<HTMLImageElement>('#makePasswordVisibleEyeIcon');

    private passwordVisibilityStates = ['password', 'text'];
    private passwordPlaceholderStates = ['*********', 'Password!'];
    private currentPasswordVisibility = 0;

    constructor() {
        this.httpClient = new HttpClient();
    }

    private submitForm = async (event: Event): Promise<void> => {
        event.preventDefault();

        if (
            !this.usernameField ||
            !this.emailField ||
            !this.passwordField
        ) {
            throw new Error('Register | Form failed to load correctly');
        }

        const res = await this.httpClient.post('/auth/register', {
            username: this.usernameField.value,
            email: this.emailField.value,
            password: this.passwordField.value,
        });

        if (res.isOk()) {
            alert('Account created! Redirecting...');
            window.location.assign('/home');
        } else {
            res.mapErr(err => alert(err.message));
        }
    };

    private togglePasswordVisibility = (): void => {
        this.currentPasswordVisibility++;
        if (this.passwordField) {
            this.passwordField.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
            this.passwordField.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
        }
    };

    init(): void {
        if (
            !this.submitBtn ||
            !(this.submitBtn instanceof HTMLButtonElement) ||
            !this.eyeIcon ||
            !(this.eyeIcon instanceof HTMLImageElement)
        ) {
            throw new Error('Register | Form failed to load correctly');
        }

        this.submitBtn.addEventListener('click', this.submitForm);
        this.eyeIcon.addEventListener('click', this.togglePasswordVisibility);
    }
}
