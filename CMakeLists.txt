cmake_minimum_required(VERSION 3.21)
project(audioworklet_wasm_typescript_starter)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -fexceptions")

set(THIRD_PARTY_DIR "lib/third-party")
set(MAIN_SOURCE_DIR "src/cpp")

file(GLOB_RECURSE CPP_HEADERS ${MAIN_SOURCE_DIR}/*.hpp)
file(GLOB_RECURSE CPP_SOURCES ${MAIN_SOURCE_DIR}/*.cpp)

add_library(mylib
        src/cpp/MyClass.cpp
        src/cpp/MyClass.h
        )

add_executable(mywasm
        src/wasm/main.cc
        )

target_link_libraries(
        mywasm
        PUBLIC
        mylib
)

set_target_properties(
        mywasm
        PROPERTIES
        LINK_FLAGS
        "-O2"
)