class MyClass {
    private readonly instance: any;

    constructor(module: any) {
        // @ts-ignore
        this.instance = new module.MyClass();
    }

    multiply(a: number, b: number): number {
        return this.instance.multiply(a, b);
    }

    sayHello(name: string): string {
        return this.instance.sayHello(name);
    }

    getDefaultRubberbandEngineVersion(): number {
        return this.instance.getDefaultRubberbandEngineVersion();
    }
}
export {MyClass}