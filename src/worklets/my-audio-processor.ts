import {MyClass} from "./MyClass";

class MyAudioProcessor extends AudioWorkletProcessor implements AudioWorkletProcessorImpl {
    private readonly module: EmscriptenModule;
    private readonly myClass: MyClass;

    constructor() {
        super();
        // @ts-ignore
        this.module = Module();
        this.myClass = new MyClass(this.module)

        console.log(this.myClass.sayHello());
    }

    process(inputs: Float32Array[][], outputs: Float32Array[][], parameters: Record<string, Float32Array>): boolean {
        return true;
    }
}

registerProcessor("my-audio-processor", MyAudioProcessor)