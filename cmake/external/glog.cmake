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

SET(GLOG_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/glog)
SET(GLOG_INSTALL_DIR ${PROJECT_BINARY_DIR}/glog)

ExternalProject_Add(
    glog
    GIT_REPOSITORY "https://github.com/google/glog.git"
    PREFIX ${GLOG_SOURCES_DIR}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${GLOG_INSTALL_DIR}
    CMAKE_ARGS -DBUILD_TESTING=OFF
    LOG_DOWNLOAD=ON
    UPDATE_COMMAND ""
)

SET(GLOG_INCLUDE_DIR "${GLOG_INSTALL_DIR}/include")
INCLUDE_DIRECTORIES(${GLOG_INCLUDE_DIR})

IF(WIN32)
    SET(GLOG_LIBRARIES "${GLOG_INSTALL_DIR}/lib/libglog.lib")
ELSE(WIN32)
    SET(GLOG_LIBRARIES "${GLOG_INSTALL_DIR}/lib/libglog.a")
ENDIF(WIN32)

LIST(APPEND external_project_dependencies glog)
