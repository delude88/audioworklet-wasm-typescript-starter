#!/bin/bash

fetch_brew_dependency() {
    FORMULA_NAME=$1

    echo "Fetching Brew dependency: '$FORMULA_NAME'."

    if brew ls --versions $FORMULA_NAME > /dev/null; then
        echo "Dependency '$FORMULA_NAME' is already installed, continuing ..."
    else
        echo "Dependency '$FORMULA_NAME' is not installed, installing via Homebrew ..."
        brew install $FORMULA_NAME
    fi
}

# Install required toolset
fetch_brew_dependency "cmake"
fetch_brew_dependency "emscripten"

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