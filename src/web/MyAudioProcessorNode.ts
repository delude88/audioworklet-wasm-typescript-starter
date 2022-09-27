class MyAudioProcessorNode extends AudioWorkletNode {
    constructor(audioContext: AudioContext, options?: AudioWorkletNodeOptions) {
        super(audioContext, "my-audio-processor", options);
        this.port.onmessage = (event) => {
            console.log("Got message from c++: ", event.data)
        }
    }
}

const createMyAudioProcessorNode = async (audioContext: AudioContext, url: string, options?: AudioWorkletNodeOptions) => {
    try {
        return new MyAudioProcessorNode(audioContext, options);
    } catch (_) {
        await audioContext.audioWorklet.addModule(url)
        return new MyAudioProcessorNode(audioContext, options);
    }
}

export {MyAudioProcessorNode, createMyAudioProcessorNode}