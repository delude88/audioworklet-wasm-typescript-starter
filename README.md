# audioworklet-wasm-typescript-starter

Starter for developing C(++) powered audio worklets using typescript

## Motivation

Goal was to create a boilerplate that respects all necessary workarounds for the common three big browser engines (
WebKit, Gecko, Chromium).

## Tutorial
[Here](TUTORIAL.md) is a tutorial which results in this boilerplate.

## How to use this boilerplate

Check out this project and specify the _package.json_ to your needs.
Afterwards put all the C/C++ related code into _wasm/src_ folder.
Use the existing _[wasm/src/main.cc](wasm/src/main.cc)_ to specify the bindings between C++ and javascript.
You can find [here](https://web.dev/embind/) a quick introduction into [embind](https://emscripten.org/docs/porting/connecting_cpp_and_javascript/embind.html).
 
Then modify _[src/my-audio-procesor.ts](src/my-audio-processor.ts)_ and _[src/another-audio-procesor.ts](src/another-audio-processor.ts)_ or use them as a reference for implementing your own typescript based audio processor nodes.

When renaming or creating new audio processor nodes inside the _src_ folder, you'll have to adapt the worker array inside _[webpack.config.js](webpack.config.js)_ too:
```javascript
const worklets = [
    'src/my-renamed-audio-processor.ts',
    'src/newly-created-audio-processor.ts'
]
```

Finally you can use the following scripts:
```shell
# build everything
npm run build
# only build the wasm module
npm run build:wasm
# only build the the worklets
npm run build:worklets
# or use live compiling while developing in typescript
npm run dev
```
or extend/modify them inside the _[package.json](package.json)_ to your needs.