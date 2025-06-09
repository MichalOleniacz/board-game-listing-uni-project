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
export default class LoginFormManager {
    constructor() {
        this.emailField = document.querySelector('#emailInput');
        this.passwordField = document.querySelector('#passwordInput');
        this.submitBtn = document.querySelector('#submit');
        this.eyeIcon = document.querySelector('#makePasswordVisibleEyeIcon');
        this.becomeMemberBtn = document.querySelector('#becomeMemberBtn');
        this.passwordVisibilityStates = ['password', 'text'];
        this.passwordPlaceholderStates = ['*********', 'Password!'];
        this.currentPasswordVisibility = 0;
        this.submitForm = (event) => __awaiter(this, void 0, void 0, function* () {
            if (!(this.emailField instanceof HTMLInputElement) || !(this.passwordField instanceof HTMLInputElement))
                throw new Error("Login | Form failed to load correctly");
            event.preventDefault();
            const emailValue = this.emailField.value;
            const passwordValue = this.passwordField.value;
            const res = yield this.httpClient.post('/auth/login', {
                'email': emailValue,
                'password': passwordValue
            });
            console.log(res);
            if (res.isErr()) {
                res.mapErr(r => alert(r.message));
            }
            const redirectUrl = res.unwrap().redirectUrl;
            window.location.assign(redirectUrl);
        });
        this.togglePasswordVisibility = () => {
            this.currentPasswordVisibility++;
            this.passwordField.type = this.passwordVisibilityStates[this.currentPasswordVisibility % 2];
            this.passwordField.placeholder = this.passwordPlaceholderStates[this.currentPasswordVisibility % 2];
        };
        this.handleBecomeMemberClick = () => {
            window.location.assign('/register');
        };
        this.httpClient = new HttpClient();
    }
    init() {
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
        console.log(this.emailField.value);
    }
}
