cmake_minimum_required(VERSION 2.8)
project(coveralls)

option(COVERALLS "Turn on coveralls support" OFF)
option(COVERALLS_UPLOAD "Upload the generated coveralls json" ON)

LIST(APPEND CMAKE_CXX_FLAGS "-std=c++11 -fPIC")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} 
    ${PROJECT_SOURCE_DIR}/cmake)

set(THIRD_PARTY_PATH ${PROJECT_BINARY_DIR})

include(gtest)
include(gflags)
include(glog)

if (COVERALLS)
    include(Coveralls)
endif()

set(LIB_SRC ${PROJECT_SOURCE_DIR}/src/base.cc)
add_library(base ${LIB_SRC})

include_directories(${PROJECT_SOURCE_DIR}/src)

# Add a test for the library.
enable_testing()

add_executable(base_regress
               ${PROJECT_SOURCE_DIR}/test/TEST_base.cc)

target_link_libraries(base_regress
    glog
    gflags
    gtest
    base)

add_dependencies(base_regress ${external_project_dependencies} base)

add_test(base ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/base_regress)
