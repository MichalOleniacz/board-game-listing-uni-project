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
export default class RegisterFormManager {
    constructor() {
        this.usernameField = document.querySelector('#usernameInput');
        this.emailField = document.querySelector('#emailInput');
        this.passwordField = document.querySelector('#passwordInput');
        this.submitBtn = document.querySelector('#submitBtn');
        this.eyeIcon = document.querySelector('#makePasswordVisibleEyeIcon');
        this.passwordVisibilityStates = ['password', 'text'];
        this.passwordPlaceholderStates = ['*********', 'Password!'];
        this.currentPasswordVisibility = 0;
        this.submitForm = (event) => __awaiter(this, void 0, void 0, function* () {
            event.preventDefault();
            if (!this.usernameField ||
                !this.emailField ||
                !this.passwordField) {
                throw new Error('Register | Form failed to load correctly');
            }
            const res = yield this.httpClient.post('/auth/register', {
                username: this.usernameField.value,
                email: this.emailField.value,
                password: this.passwordField.value,
            });
            if (res.isOk()) {
                alert('Account created! Redirecting...');
                window.location.assign('/home');
            }
            else {
                res.mapErr(err => alert(err.message));
            }
        });
        this.togglePasswordVisibility = () => {
            this.currentPasswordVisibility++;
            if (this.passwordField) {
                this.passwordField.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
                this.passwordField.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
            }
        };
        this.httpClient = new HttpClient();
    }
    init() {
        if (!this.submitBtn ||
            !(this.submitBtn instanceof HTMLButtonElement) ||
            !this.eyeIcon ||
            !(this.eyeIcon instanceof HTMLImageElement)) {
            throw new Error('Register | Form failed to load correctly');
        }
        this.submitBtn.addEventListener('click', this.submitForm);
        this.eyeIcon.addEventListener('click', this.togglePasswordVisibility);
    }
}
