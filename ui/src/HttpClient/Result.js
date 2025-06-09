export class Result {
    static ok(value) {
        return new Ok(value);
    }
    static err(error) {
        return new Err(error);
    }
}
export class Ok extends Result {
    constructor(val) {
        super();
        this.val = val;
    }
    isOk() {
        return true;
    }
    isErr() {
        return false;
    }
    map(fn) {
        return Result.ok(fn(this.val));
    }
    mapErr(_fn) {
        return Result.ok(this.val);
    }
    flatMap(fn) {
        return fn(this.val);
    }
    unwrap() {
        return this.val;
    }
    unwrapOr(_defaultValue) {
        return this.val;
    }
}
export class Err extends Result {
    constructor(err) {
        super();
        this.err = err;
    }
    isOk() {
        return false;
    }
    isErr() {
        return true;
    }
    map(_fn) {
        return Result.err(this.err);
    }
    mapErr(fn) {
        return Result.err(fn(this.err));
    }
    flatMap(_fn) {
        return Result.err(this.err);
    }
    unwrap() {
        throw new Error(`Tried to unwrap Err: ${this.err}`);
    }
    unwrapOr(defaultValue) {
        return defaultValue;
    }
}
