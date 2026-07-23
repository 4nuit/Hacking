cmake_minimum_required(VERSION 3.10) # Minimum version for C++17 support
project(circle) # Project name

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(SOURCE_FILES src/main.cpp src/circle.cpp)
set(TARGET circle)


# Add the executable target
add_executable(${TARGET} ${SOURCE_FILES})

# Optional: Enable compiler warnings
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(circle PRIVATE -Wall -Wextra -Wpedantic)
elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    target_compile_options(circle PRIVATE /W4)
endif()
