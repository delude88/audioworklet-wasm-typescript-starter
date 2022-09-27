#!/bin/bash

# Make sure we have a 'build' folder.
if [ ! -d ".wasm" ]; then
    mkdir .wasm
fi

CXXFLAGS="-O3 -std=c++17 -msimd128 -flto"
# One can also add -fno-rtti to reduce the image size about 10KB

# Compile third-party rubberband library
echo "(1/4) Compiling third-party rubberband library"
emcc ${CXXFLAGS} -c lib/third-party/rubberband/single/RubberBandSingle.cpp -o .wasm/librubberband.o
CXXFLAGS="${CXXFLAGS} -Ilib/third-party/rubberband/rubberband"

# Compile MyClass as own library
echo "(2/4) Compiling src/cpp/MyClass.*"
emcc ${CXXFLAGS} -c src/cpp/MyClass.cpp -o .wasm/libmyclass.o

# Compile MyClass as own library
echo "(3/4) Compiling src/wasm/*.cc"
emcc ${CXXFLAGS} -c src/wasm/MyClass-binding.cc -o .wasm/main.o


# Compile MyClass as own library
echo "(4/4) Linking objects into wasm binary"
#emcc -O3 -std=c++17 -msimd128 -flto
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
     -o src/wasm/compiled.js
