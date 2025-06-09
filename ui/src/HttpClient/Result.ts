export abstract class Result<T, E> {
    abstract isOk(): this is Ok<T, E>;
    abstract isErr(): this is Err<T, E>;

    abstract map<U>(fn: (value: T) => U): Result<U, E>;
    abstract mapErr<F>(fn: (err: E) => F): Result<T, F>;
    abstract flatMap<U>(fn: (value: T) => Result<U, E>): Result<U, E>;

    abstract unwrap(): T;
    abstract unwrapOr(defaultValue: T): T;

    static ok<T, E>(value: T): Result<T, E> {
        return new Ok<T, E>(value);
    }

    static err<T, E>(error: E): Result<T, E> {
        return new Err<T, E>(error);
    }
}

export class Ok<T, E> extends Result<T, E> {
    constructor(private readonly val: T) {
        super();
    }

    isOk(): this is Ok<T, E> {
        return true;
    }

    isErr(): this is Err<T, E> {
        return false;
    }

    map<U>(fn: (value: T) => U): Result<U, E> {
        return Result.ok(fn(this.val));
    }

    mapErr<F>(_fn: (err: E) => F): Result<T, F> {
        return Result.ok(this.val);
    }

    flatMap<U>(fn: (value: T) => Result<U, E>): Result<U, E> {
        return fn(this.val);
    }

    unwrap(): T {
        return this.val;
    }

    unwrapOr(_defaultValue: T): T {
        return this.val;
    }
}

export class Err<T, E> extends Result<T, E> {
    constructor(private readonly err: E) {
        super();
    }

    isOk(): this is Ok<T, E> {
        return false;
    }

    isErr(): this is Err<T, E> {
        return true;
    }

    map<U>(_fn: (value: T) => U): Result<U, E> {
        return Result.err(this.err);
    }

    mapErr<F>(fn: (err: E) => F): Result<T, F> {
        return Result.err(fn(this.err));
    }

    flatMap<U>(_fn: (value: T) => Result<U, E>): Result<U, E> {
        return Result.err(this.err);
    }

    unwrap(): T {
        throw new Error(`Tried to unwrap Err: ${this.err}`);
    }

    unwrapOr(defaultValue: T): T {
        return defaultValue;
    }
}
