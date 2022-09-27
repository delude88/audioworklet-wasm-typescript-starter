import Module from "../wasm/build/main.js"
import {MyClass} from "./MyClass"

class MyAudioProcessor extends AudioWorkletProcessor implements AudioWorkletProcessorImpl {
    private readonly module: any;
    private readonly myClass: MyClass;
    private counter: number = 0;

    constructor() {
        super();
        this.module = Module;
        this.myClass = new MyClass(this.module);
        this.port.postMessage(this.myClass.sayHello("Thomas"));
        console.log("MyAudioProcessor: This will not be printed on WebKit")
    }

    process(inputs: Float32Array[][], outputs: Float32Array[][], parameters: Record<string, Float32Array>): boolean {
        if (inputs && outputs) {
            const inputChannels = inputs[0]
            const outputChannels = outputs[0]

            for (let channel = 0; channel < inputChannels.length; channel++) {
                const inputChannel = inputChannels[channel]
                const outputChannel = outputChannels[channel]
                for (let sample = 0; sample < inputChannels.length; sample++) {
                    const source = inputChannel[sample]
                    outputChannel[sample] = this.myClass.multiply(source, source)
                }
            }
        }
        if (this.counter % sampleRate === 0) {
            this.port.postMessage(`In: ${inputs ? inputs[0].length : 0} Out: ${outputs ? outputs[0].length : 0} @ ${sampleRate}`)
        }
        this.counter += 128;
        return true;
    }
}

registerProcessor("my-audio-processor", MyAudioProcessor)