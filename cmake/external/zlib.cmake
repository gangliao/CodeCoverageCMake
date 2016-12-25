# Copyright (c) 2016 PaddlePaddle Authors. All Rights Reserve.
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

SET(ZLIB_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/zlib)
SET(ZLIB_INSTALL_DIR ${PROJECT_BINARY_DIR}/zlib)

ExternalProject_Add(
    zlib
    GIT_REPOSITORY "https://github.com/madler/zlib.git"
    GIT_TAG "v1.2.8"
    PREFIX ${ZLIB_SOURCES_DIR}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ZLIB_INSTALL_DIR}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=OFF
    CMAKE_ARGS -DCMAKE_MACOSX_RPATH=ON
    LOG_DOWNLOAD=ON
    UPDATE_COMMAND ""
)

SET(ZLIB_INCLUDE_DIR "${ZLIB_INSTALL_DIR}/include")
INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIR})

IF(WIN32)
  SET(ZLIB_LIBRARIES "${ZLIB_INSTALL_DIR}/lib/zlibstatic.lib")
ELSE(WIN32)
  set(ZLIB_LIBRARIES "${ZLIB_INSTALL_DIR}/lib/libz.a")
ENDIF(WIN32)

LIST(APPEND external_project_dependencies zlib)