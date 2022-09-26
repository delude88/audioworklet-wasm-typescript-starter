class MyClass {
    private readonly instance: any;

    constructor(module: EmscriptenModule) {
        // @ts-ignore
        this.instance = new module.MyClass();
    }

    multiply(a: number, b: number): number {
        return this.instance.multiply(a, b);
    }

    sayHello(): string {
        return this.instance._sayHello();
    }

    getDefaultRubberbandEngineVersion(): number {
        return this.instance.getDefaultRubberbandEngineVersion();
    }
}
export {MyClass}