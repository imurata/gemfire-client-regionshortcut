cmake_minimum_required(VERSION 3.10)

project(gemfire-client-sample LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
find_package(VMwareGemFireNative REQUIRED COMPONENTS cpp)

add_executable(gemfire-client-sample main.cpp)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
    VMwareGemFireNative::cpp)
