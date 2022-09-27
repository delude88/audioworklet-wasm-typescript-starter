cmake_minimum_required(VERSION 3.21)
project(wasm)

if(NOT CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
    message(FATAL_ERROR "You need to use emscripten for this")
endif ()

set(CMAKE_CXX_STANDARD 17)
set(OPTIMIZATION_FLAGS "-Wno-warn-absolute-paths -O3 -flto -std=c++17 --profiling")
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
        "${OPTIMIZATION_FLAGS} \
        -s WASM=1 \
        -s ALLOW_MEMORY_GROWTH=1 \
        -s BINARYEN_ASYNC_COMPILATION=0 \
        -s ERROR_ON_UNDEFINED_SYMBOLS=1 \
        -s AUTO_JS_LIBRARIES=0 \
        -s FILESYSTEM=0 \
        -s ASSERTIONS=0 \
        -s SINGLE_FILE=1 \
        -O1 \
        --post-js ${CMAKE_SOURCE_DIR}/em-es6-module.js"
        )
# Safari needs still -O1 --post-js ${CMAKE_SOURCE_DIR}/em-es6-module.js flags