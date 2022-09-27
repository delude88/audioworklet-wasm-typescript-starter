#!/bin/bash

# Make sure we have a 'build' folder.
mkdir -p build

# -msimd128 is not working in Safari
CXXFLAGS="-Wno-warn-absolute-paths -O3 -flto -std=c++17 --profiling"
# -msimd128 -flto
# One can also add -fno-rtti to reduce the image size about 10KB

# Compile third-party rubberband library
echo "(1/4) Compiling third-party rubberband library"
emcc ${CXXFLAGS} -c lib/third-party/rubberband-3.0.0/single/RubberBandSingle.cpp -o build/librubberband.o
CXXFLAGS="${CXXFLAGS} -Ilib/third-party/rubberband-3.0.0/rubberband"

# Compile MyClass as own library
echo "(2/4) Compiling src/MyClass.cpp"
emcc ${CXXFLAGS} -c src/MyClass.cpp -o build/libmyclass.o

# Compile MyClass as own library
echo "(3/4) Compiling src/main.cc"
emcc ${CXXFLAGS} -c src/main.cc -o build/main.o

# Compile MyClass as own library
echo "(4/4) Linking objects into wasm binary"
emcc ${CXXFLAGS} \
     -lembind \
     -O1 \
     -s WASM=1 \
     -s ALLOW_MEMORY_GROWTH=1 \
     -s BINARYEN_ASYNC_COMPILATION=0 \
     -s ERROR_ON_UNDEFINED_SYMBOLS=1 \
     -s AUTO_JS_LIBRARIES=0 \
     -s FILESYSTEM=0 \
     -s ASSERTIONS=0 \
     -s SINGLE_FILE=1 \
     build/librubberband.o \
     build/libmyclass.o \
     build/main.o \
     -o build/main.js \
     --post-js ./em-es6-module.js
#     -s MODULARIZE=1 \