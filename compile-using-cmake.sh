#!/bin/bash

# Make sure we have a 'build' folder.
if [ ! -d ".wasm" ]; then
    mkdir .wasm
fi

# Build using emscripten shipped by brew and cmake
EMSCRIPTEN=$(brew --prefix emscripten)
EMSCRIPTEN_CMAKE_PATH=${EMSCRIPTEN}/libexec/cmake/Modules/Platform/Emscripten.cmake
pushd .wasm || exit
  echo "Emscripten CMake path: ${EMSCRIPTEN_CMAKE_PATH}"
  cmake -DCMAKE_TOOLCHAIN_FILE=${EMSCRIPTEN_CMAKE_PATH} ..
  echo "Building project ..."
  make
popd || exit