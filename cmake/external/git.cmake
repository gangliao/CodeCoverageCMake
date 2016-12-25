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

SET(GIT_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/git)
SET(GIT_INSTALL_DIR ${PROJECT_BINARY_DIR}/git)

IF(WIN32)
    ExternalProject_Add(
        git
        URL https://github.com/git-for-windows/git/releases/tag/v2.11.0.windows.1/Git-2.11.0-64-bit.exe
        URL_HASH SHA256=fd1937ea8468461d35d9cabfcdd2daa3a74509dc9213c43c2b9615e8f0b85086
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${GIT_INSTALL_DIR}
        LOG_DOWNLOAD=ON
    )
    SET(GIT_EXECUTABLE ${GIT_INSTALL_DIR}/Git-2.11.0-64-bit.exe)
ELSE(WIN32)
    ExternalProject_Add(
        git
        PREFIX ${GIT_SOURCES_DIR}
        URL https://github.com/git/git/archive/v2.11.0.zip
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${GIT_INSTALL_DIR}
        LOG_DOWNLOAD=ON
    )
    SET(GIT_EXECUTABLE ${GIT_INSTALL_DIR}/bin/git)
ENDIF(WIN32)
