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

SET(PYTHON_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/python)
SET(PYTHON_INSTALL_DIR ${PROJECT_BINARY_DIR}/third_party/python)

set(PYTHON_CONFIGURE_CMD ./configure --prefix=${PYTHON_INSTALL_DIR} --enable-shared --with-threads --without-pymalloc)

if(APPLE)
    # See http://bugs.python.org/issue21381
    # The interpreter crashes when MACOSX_DEPLOYMENT_TARGET=10.7 due to the increased stack size.
    set(PYTHON_PATCH_CMD sed -i".bak" "9271,9271d" <SOURCE_DIR>/configure)
    # OS X 10.11 removed OpenSSL. Brew now refuses to link so we need to manually tell Python's build system
    # to use the right linker flags.
    set(PYTHON_CONFIGURE_CMD CPPFLAGS=-I/usr/local/opt/openssl/include LDFLAGS=-L/usr/local/opt/openssl/lib ${PYTHON_CONFIGURE_CMD})
endif()

if(UNIX)
    # Set a proper RPATH so everything depending on Python does not need LD_LIBRARY_PATH
    set(PYTHON_CONFIGURE_CMD LDFLAG=-rpath=${PYTHON_INSTALL_DIR}/lib ${PYTHON_CONFIGURE_CMD})
endif()

ExternalProject_Add(
    python
    URL https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
    PREFIX ${PYTHON_SOURCES_DIR}
    PATCH_COMMAND ${PYTHON_PATCH_CMD}
    CONFIGURE_COMMAND ${PYTHON_CONFIGURE_CMD}
)
