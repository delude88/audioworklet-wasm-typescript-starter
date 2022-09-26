#!/bin/bash

# Make sure we have a 'build' folder.
if [ ! -d ".wasm" ]; then
    mkdir .wasm
fi

CXXFLAGS="-O3 -std=c++17 -msimd128 -flto"
# One can also add -fno-rtti to reduce the image size about 10KB

# Compile third-party rubberband library
echo "(1/5) Compiling third-party rubberband library"
emcc ${CXXFLAGS} -c lib/third-party/rubberband/single/RubberBandSingle.cpp -o .wasm/librubberband.o
CXXFLAGS="${CXXFLAGS} -Ilib/third-party/rubberband/rubberband"

# Compile MyClass as own library
echo "(2/5) Compiling src/cpp/MyClass.*"
emcc ${CXXFLAGS} -c src/cpp/MyClass.cpp -o .wasm/libmyclass.o

# Compile MyClass as own library
echo "(3/5) Compiling src/wasm/*.cc"
emcc ${CXXFLAGS} -c src/wasm/*.cc -o .wasm/main.o


# Compile MyClass as own library
echo "(4/5) Linking objects into wasm binary"
emcc ${CXXFLAGS} \
     -lembind \
     -s WASM=1 \
     -s ALLOW_MEMORY_GROWTH=1 \
     -s WASM_ASYNC_COMPILATION=0 \
     -s SINGLE_FILE=1 \
     -s MODULARIZE=1 \
     .wasm/librubberband.o \
     .wasm/libmyclass.o \
     .wasm/main.o \
     -o .wasm/main.js

echo "(5/5) Merging wasm binary and audio worklet"
#emcc src/cpp
cat /main.js src/js/worklets/synth.js > public/worklets/synth.js
