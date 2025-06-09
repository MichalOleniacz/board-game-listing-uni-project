var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { Result } from "./Result";
export class HttpClient {
    constructor(baseUrl = 'http://localhost:8000/api') {
        this.baseUrl = baseUrl;
    }
    buildUrl(path) {
        return `${this.baseUrl}${path}`;
    }
    request(method_1, path_1) {
        return __awaiter(this, arguments, void 0, function* (method, path, options = {}) {
            try {
                const { body, headers = {}, credentials = 'same-origin' } = options;
                const response = yield fetch(this.buildUrl(path), {
                    method,
                    headers: Object.assign(Object.assign({ Accept: 'application/json' }, (body ? { 'Content-Type': 'application/json' } : {})), headers),
                    redirect: 'follow',
                    credentials,
                    body: body ? JSON.stringify(body) : undefined,
                });
                if (!response.ok) {
                    return Result.err(new Error(`HTTP ${response.status}: ${response.statusText}`));
                }
                const contentType = response.headers.get('content-type') || '';
                if (contentType.includes('application/json')) {
                    const data = yield response.json();
                    return Result.ok(data);
                }
                else {
                    return Result.ok(null);
                }
            }
            catch (e) {
                return Result.err(e instanceof Error ? e : new Error('Unknown error'));
            }
        });
    }
    get(path, headers) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.request('GET', path, { headers });
        });
    }
    post(path, body, headers) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.request('POST', path, { body, headers });
        });
    }
    put(path, body, headers) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.request('PUT', path, { body, headers });
        });
    }
    patch(path, body, headers) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.request('PATCH', path, { body, headers });
        });
    }
    delete(path, headers) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.request('DELETE', path, { headers });
        });
    }
}
