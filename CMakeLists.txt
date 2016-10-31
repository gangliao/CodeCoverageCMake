cmake_minimum_required(VERSION 2.8)
project(coveralls)

option(COVERALLS "Turn on coveralls support" OFF)
option(COVERALLS_UPLOAD "Upload the generated coveralls json" ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} 
	${PROJECT_SOURCE_DIR}/cmake)

if (COVERALLS)
	include(Coveralls)
endif()

set(LIB_SRC ${PROJECT_SOURCE_DIR}/src/base.c)
add_library(base ${LIB_SRC})
include_directories(${PROJECT_SOURCE_DIR}/src)

# Add a test for the library.
enable_testing()

add_executable(base_regress
               ${PROJECT_SOURCE_DIR}/test/TEST_base.c)

target_link_libraries(base_regress base)

add_test(base ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/base_regress)