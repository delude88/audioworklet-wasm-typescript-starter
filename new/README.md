# audioworklet-wasm-typescript-starter

Starter for developing C(++) based audio worklets using typescript

# Motivation

Goal was to create a boilerplate that respects all necessary workarounds for the common three big browser engines (
WebKit, Gecko, Chromium).

# Tutorial

In this tutorial we want to implement a basic C++ class, wrap it inside an
javascript [audio worklet processor](https://developer.mozilla.org/en-US/docs/Web/API/AudioWorkletProcessor) and load
and run it inside a web-browser.

## Depencencies

For this tutorial we'll need a POSIX system (Linux, macOS, etc.) and:

- [node](https://nodejs.org)
- [cmake](https://cmake.org)
- [emscripten](https://emscripten.org)

I don't describe here how to install these packages on different operating systems, since there are many good concurrent
tutorials out there for this.

### macOS

Just to note for macOS you may install everything using the [_brew package manager_](https://brew.sh):

````shell
brew install node cmake emscripten
````

But for at least _node_ there are different other install methods out there (_nvm_, _pnpm_, etc.).

## Setup project

Start by creating a folder for our project:

```shell
mkdir myproject && cd myproject
```

### Setup typescript environment

And create a containing _package.json_ file by answering the questions of:

```shell
npm init
# or
yarn init
# or
pnpm init
```

Finaly create a basic folder structure by adding a _src_ folder for our typescript code (coming later):

```shell
mkdir src
```

We want to have ready-to-use bundled audio worklet processors in raw javascript later. To compile typescript we'll use _
tsc_ and _babel_ and for bundling we'll use _webpack_. Install these dependencies:

````shell
npm install -D @babel/core @babel/preset-env babel-loader typescript webpack
# or
yarn add -D @babel/core @babel/preset-env babel-loader typescript webpack
# or
pnpm add -D @babel/core @babel/preset-env babel-loader typescript webpack
````

Also add optional typescript definitions for audio worklet and emscripten modules:

````shell
npm install -D @types/audioworklet @types/emscripten
# or
yarn add -D @types/audioworklet @types/emscripten
# or
pnpm add -D @types/audioworklet @types/emscripten
````

#### Setup webpack
Next we have to setup our webpack to compile and bundle our tyescript code later.
Create a new file _webpack.config.js_ inside our project root directory and add the following content:
```javascript
const path = require('path');

const worklets = [
]

const getFilename = (filepath) => path.parse(filepath).name

const bundle = (worklet) => {
    return {
        entry: path.resolve(__dirname, worklet),
        module: {
            rules: [
                {
                    test: /\.(js|jsx|tsx|ts)$/,
                    exclude: /node_modules/,
                    loader: 'babel-loader'
                }
            ],
        },
        resolve: {
            extensions: ['.ts', '.js'],
        },
        performance: {
            maxAssetSize: 600000,
            maxEntrypointSize: 600000
        },
        output: {
            filename: `${getFilename(worklet)}.js`,
            path: path.resolve(__dirname, 'public'),
        },
    }
}

module.exports = worklets.map(worklet => bundle(worklet));
```
Let's go quickly over this file:
````javascript
const worklets = [
]
````
This defines our entry points. Here we will specify typescript files paths, that will be compiled and bundles in standalone audio worklet processors later.

````javascript
module.exports = worklets.map(worklet => bundle(worklet));
````
We want to handle each audio processor worklet as own webpack entry resulting in a totally separate bundle.
For this we iterate over _worklets_ using the _map_ iterator and call bundle for each of the worklet paths.
Inside the _bundle_ method we resolve the filename without extension using _getFilename_ and use this to generate the correlating output filename. For example  _src/my_audio_processor.ts_ would result in the bundle _public/my_audio_processor.js_.

In this configuration we further use _babel_ to compile and transpile typescript to javascript.
This and the rest of the configuration should look familiar to experienced webpack users, except one block:
````javascript
performance: {
    maxAssetSize: 600000,
    maxEntrypointSize: 600000
},
````
Here we are increasing the asset and entrypoint size to avoid later warnings, since we are bundling also our resulting _wasm_ binary later and this might exceed the default values clearly.

#### Add tsconfig.json
Under the hood webpack is just ignoring all tyescript related stuff and stripes javascript out of it before transpiling it.

But we want also have the benefits of type-checking and validations that typescript provides us.

For this create a _tsconfig.json_ with the following content: 
````json
{
  "compilerOptions": {
    "target": "esnext",
    "lib": [
      "dom",
      "esnext"
    ],
    "module": "esnext",
    "moduleResolution": "node",
    "baseUrl": "./",
    "allowJs": true,
    "noEmit": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": [
    "src/**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
````
I don't go in details here, but let's go through some steps:
```json
    "allowJs": true,
```
We want to import our _wasm_ js bundle inside our typescript files later, so we need to allow javascript.
```json
"noEmit": true,
```
We don't want _tsc_ to emit javascript or declaration files.
So we disable any emit here.

#### Add package.json scripts

Now we want to add _check-types_, _dev_ and _build_ commands to our _package.json_. To do so, open and add the following _scripts_
section to your _package.json_:

```json
"scripts": {
    "type-check": "tsc",
    "dev": "webpack --mode=development --watch",
    "build": "webpack --mode=production"
},
```

Now we are able to use:
````shell
npm run dev
# or
yarn dev
# or
pnpm dev
````
to start a demon watching for file changes and compile it live during the development.

Or we can use:
````shell
npm run build
# or
yarn build
# or
pnpm build
````
to build minified bundles for production use.


### Setup the c++ environment

We want to structure our folders in way, that separates c++ from javascript.
To satisfy this requirement, create a new _wasm_ folder and basic subdirectories:

```shell
mkdir wasm
mkdir wasm/lib
mkdir wasm/src
```

To be able to compile C++ to _WebAssembly_ on different hosts, we are going to use _cmake_.

But before creating the corresponding _CMakeLists.txt_, let's just discuss requirements first:
To demonstrate how to use third-party libraries we are going to include an open-source library called _Rubber Band_, written by Chris Cannam and distributed under the GNU General Public License (GPL). 
But you can use any other C/C++ library, as long as the codebase is portable. You can find more information about porting existing code or libraries [here](
).

#### Download third-party library
Create a _third-party_ folder inside the _wasm/lib_:
````shell
mkdir wasm/lib/third-party
````
Download and extract the Rubberband library into the newly created _wasm/lib/third_party_ folder:
```shell
wget -C https://breakfastquay.com/files/releases/rubberband-3.0.0.tar.bz2 -O - | tar -xz -C wasm/lib/third-party
# or using curl
curl https://breakfastquay.com/files/releases/rubberband-3.0.0.tar.bz2 | tar -xz -C wasm/lib/third-party
```
That's it.
Let's create the _CMakeLists.txt_ now!

#### Create CMakeLists.txt

Create a new file _wasm/CMakeLists.txt_ with the following content:

```CMake
cmake_minimum_required(VERSION 3.21)
project(wasm)

if(NOT CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
    message(FATAL_ERROR "You need to use emscripten for this")
endif ()

set(CMAKE_CXX_STANDARD 17)
set(OPTIMIZATION_FLAGS "-Wno-warn-absolute-paths -O3 -msimd128 -flto -std=c++17 -fexceptions")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OPTIMIZATION_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OPTIMIZATION_FLAGS}")

# Build rubberband (third-party) library
add_library(rubberband
        lib/third-party/rubberband-3.0.0/single/RubberBandSingle.cpp
        )

target_include_directories(rubberband
        PUBLIC
        lib/third-party/rubberband-3.0.0/rubberband)

# Build own library containing MyClass
add_library(mylib
        src/MyClass.cpp
        src//MyClass.h
        )

target_include_directories(mylib
        PUBLIC
        lib/third-party/rubberband-3.0.0/rubberband
        )

# Build final wasm executable
add_executable(main
        src/main.cc
        )

target_link_libraries(main
        PUBLIC
        mylib
        rubberband
        embind
        )

set_target_properties(main
        PROPERTIES
        LINK_FLAGS
        "${OPTIMIZATION_FLAGS} -s ALLOW_MEMORY_GROWTH=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -s MODULARIZE=1 -s WASM=1"
        )
```
Most of this file consists of basic CMake commands. If you are unfamiliar with Cmake, read [this basic introduction](https://cmake.org/cmake/help/latest/guide/tutorial/A%20Basic%20Starting%20Point.html#step-1-a-basic-starting-point). 
When targeting full-grown cross-platform projects using cmake, I highly recommend the [a-simple-triangle](https://marcelbraghetto.github.io/a-simple-triangle/2019/03/02/part-01/) tutorial.

This _CMakeLists.txt_ defines three artifacts:
- **rubberband** - linkable library containing the Rubber Band code
- **mylib** - shareable library containing the MyClass we will create later
- **main** - our target executable that we will import into our typescript code at the end of the day

The latter will result into a single javascript file with the whole compiled WebAssembly module encapsulated.

> **_Note:_**  The emscripten team recommends maintaining the optimization flags (e.g. _-O3_) across the whole build chain.

Even if the CMakeLists.txt is written, we are not ready yet.
We need to specify the tool chain everytime we call CMake.
Otherwise, the default C++ compiler of the system will be used and fail when trying to compile or link using special emscripten parameters.

To make life easier, let's create the file _wasm/build.sh_ with the following content:

````shell
#!/bin/bash

# Make sure we have a 'build' folder.
mkdir -p build

# Build using emscripten
EMSCRIPTEN=# TODO: Specify the path to your emscripten root folder here, e.g. EMSCRIPTEN=$(brew --prefix emscripten) on macOS
EMSCRIPTEN_CMAKE_PATH=${EMSCRIPTEN}/libexec/cmake/Modules/Platform/Emscripten.cmake
pushd build || exit
  echo "Emscripten CMake path: ${EMSCRIPTEN_CMAKE_PATH}"
  cmake -DCMAKE_TOOLCHAIN_FILE=${EMSCRIPTEN_CMAKE_PATH} ..
  echo "Building project ..."
  make
popd || exit
````
Make the _build.sh_ script executable by:
````shell
chmod a+x wasm/build.sh
````
Now we can simply run the build script inside the wasm folder to compile our WebAssembly module:
````shell
cd wasm && ./build.sh
````

Let's add this to our _package.json_ by modifying the _scripts_ block of our _package.json_ to:
````json
"scripts": {
    "type-check": "tsc",
    "dev": "webpack --mode=development --watch",
    "build": "npm run build:wasm && npm run type-check && webpack --mode=production",
    "build:wasm": "cd wasm && ./build.sh"
},
````
Puh! This was a lot. But since we finished the setup we can finally start coding.

## Write our C++ class

## Write our typescripted audio worklet processor

### Adding browser

Let's bundle our audio worklet processor to raw javascript now using:
````shell
npm run build
# or 
yarn build
# or 
pnpm build
````
You should now see an error message, similar to this:
```shell
ERROR in ./wasm/build/main.js
Module not found: Error: Can't resolve 'path' in (...)
(...)
BREAKING CHANGE: webpack < 5 used to include polyfills for node.js core modules by default.
This is no longer the case. Verify if you need this module and configure a polyfill for it.
(...)
```
Seems like our standalone javascript WASM module is producing some error here.
Luckily webpack tells us, what is happening and what we can do.
Sure we could tell WASM to generate only browser related code, but this comes with a larger workload.
Since we are targeting only browser here, let's opt-out all node.js core modules for browser targets by adding the following block to our _package.json_:

````json
"browser": {
    "fs": false,
    "path": false,
    "os": false,
    "crypto": false
},
````
Now try again using:
````shell
npm run build
# or 
yarn build
# or 
pnpm build
````
resulting in:
```shell
webpack 5.74.0 compiled successfully in 3828 ms
✨  Done in 11.51s.
```
This time webpack was able to build!
Now have a look inside the _public_ folder.
You can see now:
- another-audio-processor.js
- my-audio-processor.js

## Example usage
The resulting files inside the _public_ folder can now be added via [Worklet.addModule()](https://developer.mozilla.org/en-US/docs/Web/API/Worklet/addModule) inside javascript.
Here is a short example:
````javascript
const audioContext = new AudioContext();
const audioWorklet = audioContext.audioWorklet;

// Add modules and wait for the promises to resolve:
await audioWorklet.addModule('public/another-audio-processor.js');
await audioWorklet.addModule('public/my-audio-processor.js');

// Now we are able to create audio worklet nodes for them:
const anotherAudioNode = new AudioWorkletNode(audioContext, "another-audio-processor");
const myAudioNode = new AudioWorkletNode(audioContext, "my-audio-processor");

````

## Final words

This guide is not only a tutorial - it's also the result of a long research journey.
The result also respects some limitation by browsers at the time of writing. For example Firefox did not support import's inside audio worklet processors.
Safari did support import inside audio worklet processors, but killed the whole worklet with a short _user aborted_ message when trying to import WebAssembly.

I hope this tutorial could help you on your way mastering WebAssembly and Audio Worklets 🤞