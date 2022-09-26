#!/bin/bash

# Make sure we have a 'build' folder.
if [ ! -d "build" ]; then
    mkdir build
fi

# Build using emscripten shipped by brew and cmake
EMSCRIPTEN=$(brew --prefix emscripten)
EMSCRIPTEN_CMAKE_PATH=${EMSCRIPTEN}/libexec/cmake/Modules/Platform/Emscripten.cmake
pushd build || exit
  echo "Emscripten CMake path: ${EMSCRIPTEN_CMAKE_PATH}"
  cmake -DCMAKE_TOOLCHAIN_FILE=${EMSCRIPTEN_CMAKE_PATH} ..
  echo "Building project ..."
  make
popd || exit