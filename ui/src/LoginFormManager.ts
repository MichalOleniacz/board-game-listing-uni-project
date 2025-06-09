import { HttpClient } from './HttpClient/HttpClient';

type AuthResponse = {
    success: Boolean,
    redirectUrl: string
}

export default class LoginFormManager {
    private httpClient: HttpClient;
    private emailField = document.querySelector<HTMLInputElement>('#emailInput');
    private passwordField = document.querySelector<HTMLInputElement>('#passwordInput');
    private submitBtn = document.querySelector<HTMLButtonElement>('#submit');
    private eyeIcon = document.querySelector<HTMLImageElement>('#makePasswordVisibleEyeIcon');
    private becomeMemberBtn = document.querySelector<HTMLImageElement>('#becomeMemberBtn');
    private passwordVisibilityStates = ['password', 'text'];
    private passwordPlaceholderStates = ['*********', 'Password!'];
    private currentPasswordVisibility = 0;

    constructor() {
        this.httpClient = new HttpClient();
    }

    private submitForm = async (event: Event): Promise<void> => {
        if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
            throw new Error("Login | Form failed to load correctly");

        event.preventDefault();

        const emailValue = this.emailField.value;
        const passwordValue = this.passwordField.value;

        const res = await this.httpClient.post<AuthResponse>( '/auth/login', {
            'email': emailValue,
            'password': passwordValue
        });

        console.log(res);

        if (res.isErr()) {
            res.mapErr(r => alert(r.message));
        }

        const redirectUrl = res.unwrap().redirectUrl;
        window.location.assign(redirectUrl);
    }

    private togglePasswordVisibility = (): void => {
        this.currentPasswordVisibility++;
        this.passwordField!.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
        this.passwordField!.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
    }

    private handleBecomeMemberClick = (): void => {
        window.location.assign('/register');
    }

    init(): void {
        if (!this.emailField || !this.passwordField || !this.submitBtn)
            throw new Error("Login | Form failed to load correctly");

        if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
            throw new Error("Login | Form failed to load correctly");

        if (!(this.eyeIcon instanceof HTMLImageElement) || !(this.submitBtn instanceof HTMLButtonElement))
            throw new Error("Login | Form failed to load correctly");

        if (!(this.becomeMemberBtn instanceof HTMLButtonElement))
            throw new Error("Login | Form failed to load correctly");

        this.submitBtn.addEventListener('click', this.submitForm);
        this.eyeIcon.addEventListener('click', this.togglePasswordVisibility);
        this.becomeMemberBtn.addEventListener('click', this.handleBecomeMemberClick);

        console.log(this.emailField.value)
    }
}
