cmake_minimum_required(VERSION 3.21)
project(audioworklet_wasm_typescript_starter)

if(NOT CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
    message(FATAL_ERROR "You need to use emscripten for this")
endif ()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-warn-absolute-paths -O3 -std=c++17 -fexceptions")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-warn-absolute-paths -O3 -std=c++17 -fexceptions")

set(THIRD_PARTY_DIR "lib/third-party")
set(MAIN_SOURCE_DIR "src/cpp")

file(GLOB_RECURSE CPP_HEADERS ${MAIN_SOURCE_DIR}/*.hpp)
file(GLOB_RECURSE CPP_SOURCES ${MAIN_SOURCE_DIR}/*.cpp)

add_library(rubberband
        lib/third-party/rubberband/single/RubberBandSingle.cpp
        )

target_include_directories(rubberband
        PUBLIC
        lib/third-party/rubberband/rubberband)

add_library(mylib
        src/cpp/MyClass.cpp
        src/cpp/MyClass.h
        )

target_include_directories(mylib
        PUBLIC
        lib/third-party/rubberband/rubberband
        )

add_executable(mywasm
        src/wasm/MyClass-binding.cc
        )

target_link_libraries(mywasm
        PUBLIC
        mylib
        rubberband
        embind
        )

set_target_properties(mywasm
        PROPERTIES
        LINK_FLAGS
        "-O3 -s ALLOW_MEMORY_GROWTH=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -s WASM=1"
        )