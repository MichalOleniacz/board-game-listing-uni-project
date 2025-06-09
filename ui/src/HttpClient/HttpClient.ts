import {Result} from "./Result";

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';

interface RequestOptions {
    headers?: Record<string, string>;
    body?: any;
    credentials?: RequestCredentials;
}

export class HttpClient {
    constructor(private readonly baseUrl : string = 'http://localhost:8000/api') {}

    private buildUrl(path: string): string {
        return `${this.baseUrl}${path}`;
    }

    private async request<T>(
        method: HttpMethod,
        path: string,
        options: RequestOptions = {}
    ): Promise<Result<T, Error>> {
        try {
            const { body, headers = {}, credentials = 'same-origin' } = options;

            const response = await fetch(this.buildUrl(path), {
                method,
                headers: {
                    Accept: 'application/json',
                    ...(body ? { 'Content-Type': 'application/json' } : {}),
                    ...headers,
                },
                redirect: 'follow',
                credentials,
                body: body ? JSON.stringify(body) : undefined,
            });

            if (!response.ok) {
                return Result.err(new Error(`HTTP ${response.status}: ${response.statusText}`));
            }

            const contentType = response.headers.get('content-type') || '';
            if (contentType.includes('application/json')) {
                const data = await response.json();
                return Result.ok(data as T);
            } else {
                return Result.ok(null as unknown as T);
            }
        } catch (e) {
            return Result.err(e instanceof Error ? e : new Error('Unknown error'));
        }
    }

    async get<T>(path: string, headers?: Record<string, string>): Promise<Result<T, Error>> {
        return this.request<T>('GET', path, { headers });
    }

    async post<T>(
        path: string,
        body: any,
        headers?: Record<string, string>
    ): Promise<Result<T, Error>> {
        return this.request<T>('POST', path, { body, headers });
    }

    async put<T>(
        path: string,
        body: any,
        headers?: Record<string, string>
    ): Promise<Result<T, Error>> {
        return this.request<T>('PUT', path, { body, headers });
    }

    async patch<T>(
        path: string,
        body: any,
        headers?: Record<string, string>
    ): Promise<Result<T, Error>> {
        return this.request<T>('PATCH', path, { body, headers });
    }

    async delete<T>(path: string, headers?: Record<string, string>): Promise<Result<T, Error>> {
        return this.request<T>('DELETE', path, { headers });
    }
}
