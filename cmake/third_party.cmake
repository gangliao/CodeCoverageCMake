# Copyright 2016 PaddlePaddle Authors
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

INCLUDE(ExternalProject)

add_compile_options(-Wno-deprecated-declarations)

############################### GLOG ####################################
ExternalProject_Add(
    glog
    GIT_REPOSITORY "https://github.com/google/glog.git"
    PREFIX ${PROJECT_BINARY_DIR}/glog
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
    CMAKE_ARGS -DWITH_GFLAGS=OFF
    CMAKE_ARGS -DBUILD_TESTING=OFF
    LOG_DOWNLOAD=ON
)

SET(GLOG_INCLUDE "${PROJECT_BINARY_DIR}/include")
IF(WIN32)
    SET(GLOG_LIBRARIES "${PROJECT_BINARY_DIR}/lib/libglog.lib")
ELSE(WIN32)
    SET(GLOG_LIBRARIES "${PROJECT_BINARY_DIR}/lib/libglog.a")
ENDIF(WIN32)

include_directories(${GLOG_INCLUDE})
LIST(APPEND external_project_dependencies glog)
#########################################################################

############################### GTEST ###################################
ExternalProject_Add(
    gtest
    GIT_REPOSITORY "https://github.com/google/googletest.git"
    PREFIX ${PROJECT_BINARY_DIR}/gtest
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
    CMAKE_ARGS -Dgtest_disable_pthreads=ON
    LOG_DOWNLOAD=ON
)

SET(GTEST_INCLUDE "${PROJECT_BINARY_DIR}/include")
IF(WIN32)
    set(GTEST_LIBRARIES
        "${PROJECT_BINARY_DIR}/lib/gtest.lib"
        "${PROJECT_BINARY_DIR}/lib/gtest_main.lib")
ELSE(WIN32)
    set(GTEST_LIBRARIES
        "${PROJECT_BINARY_DIR}/lib/libgtest.a"
        "${PROJECT_BINARY_DIR}/lib/libgtest_main.a")
ENDIF(WIN32)

include_directories(${GTEST_INCLUDE})
LIST(APPEND external_project_dependencies gtest)
#########################################################################

############################### GFLAGS ##################################
ExternalProject_Add(
    gflags
    GIT_REPOSITORY "https://github.com/gflags/gflags.git"
    PREFIX ${PROJECT_BINARY_DIR}/gflags
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
    CMAKE_ARGS -DBUILD_TESTING=OFF
    LOG_DOWNLOAD=ON
)

SET(GFLAGS_INCLUDE "${PROJECT_BINARY_DIR}/include")
IF(WIN32)
    set(GFLAGS_LIBRARIES "${PROJECT_BINARY_DIR}/lib/gflags.lib")
ELSE(WIN32)
    set(GFLAGS_LIBRARIES "${PROJECT_BINARY_DIR}/lib/libgflags.a")
ENDIF(WIN32)

include_directories(${GFLAGS_INCLUDE})
LIST(APPEND external_project_dependencies gflags)
#########################################################################

################################# ZLIB ##################################

ExternalProject_Add(
    zlib
    GIT_REPOSITORY "https://github.com/madler/zlib.git"
    GIT_TAG "v1.2.8"
    PREFIX ${PROJECT_BINARY_DIR}/zlib
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=OFF
    CMAKE_ARGS -DCMAKE_MACOSX_RPATH=ON
    LOG_DOWNLOAD=ON
)

SET(ZLIB_INCLUDE "${PROJECT_BINARY_DIR}/include")
IF(WIN32)
  SET(ZLIB_LIBRARIES "${PROJECT_BINARY_DIR}/lib/zlibstatic.lib")
ELSE()
  set(ZLIB_LIBRARIES "${PROJECT_BINARY_DIR}/lib/libz.a")
ENDIF()

include_directories(${ZLIB_INCLUDE})
LIST(APPEND external_project_dependencies zlib)
#########################################################################

############################### Protobuf ################################
ExternalProject_Add(
    protobuf
    PREFIX ${PROJECT_BINARY_DIR}/protobuf
    DEPENDS zlib
    GIT_REPOSITORY "https://github.com/google/protobuf.git"
    GIT_TAG "v3.0.0"
    CONFIGURE_COMMAND ${CMAKE_COMMAND}
        ${PROJECT_BINARY_DIR}/protobuf/src/protobuf/cmake/
        -Dprotobuf_BUILD_TESTS=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
)

SET(PROTOBUF_INCLUDE "${PROJECT_BINARY_DIR}/include")
IF(WIN32)
  SET(PROTOBUF_LIBRARIES
        "${PROJECT_BINARY_DIR}/lib/libprotobuf.lib"
        "${PROJECT_BINARY_DIR}/lib/libprotoc.lib")
ELSE()
  SET(PROTOBUF_LIBRARIES
        "${PROJECT_BINARY_DIR}/lib/libprotobuf.a"
        "${PROJECT_BINARY_DIR}/lib/libprotoc.a")
ENDIF()
include_directories(${ZLIB_INCLUDE})
LIST(APPEND external_project_dependencies protobuf)
#########################################################################
