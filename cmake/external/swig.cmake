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

# Look for system swig
# FIND_PACKAGE(SWIG)

#IF(NOT ${SWIG_FOUND})
    # build swig as an external project
    INCLUDE(ExternalProject)
    SET(SWIG_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/swig)
    SET(SWIG_INSTALL_DIR ${PROJECT_BINARY_DIR}/swig)
    SET(SWIG_TARGET_VERSION "3.0.2")
    SET(SWIG_DOWNLOAD_SRC_MD5 "62f9b0d010cef36a13a010dc530d0d41")
    SET(SWIG_DOWNLOAD_WIN_MD5 "3f18de4fc09ab9abb0d3be37c11fbc8f")

    IF(WIN32)
        # swig.exe available as pre-built binary on Windows:
        ExternalProject_Add(swig
            URL http://prdownloads.sourceforge.net/swig/swigwin-${SWIG_TARGET_VERSION}.zip
            URL_MD5 ${SWIG_DOWNLOAD_WIN_MD5}
            SOURCE_DIR ${SWIG_SOURCES_DIR}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
        )
        SET(SWIG_DIR ${SWIG_SOURCES_DIR} CACHE FILEPATH "SWIG Directory" FORCE)
        SET(SWIG_EXECUTABLE ${SWIG_SOURCES_DIR}/swig.exe  CACHE FILEPATH "SWIG Executable" FORCE)

    ELSE(WIN32)
        # From PCRE configure
        ExternalProject_Add(pcre
            URL http://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.gz
            URL_MD5 ff7b4bb14e355f04885cf18ff4125c98
            PREFIX ${SWIG_SOURCES_DIR}/pcre
            CONFIGURE_COMMAND
            env
                "CC=${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1}"
                "CFLAGS=${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}"
                "LDFLAGS=$ENV{LDFLAGS}"
                "LIBS=$ENV{LIBS}"
                "CPPFLAGS=$ENV{CPPFLAGS}"
                "CXX=${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}"
                "CXXFLAGS=${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}"
                "CPP=$ENV{CPP}"
                "CXXPP=$ENV{CXXPP}"
            ../pcre/configure
            --prefix=${SWIG_INSTALL_DIR}/pcre
            --enable-shared=no
        )

        # swig uses bison find it by cmake and pass it down
        FIND_PACKAGE(BISON)

        # From SWIG configure
        ExternalProject_Add(swig
            URL http://prdownloads.sourceforge.net/swig/swig-${SWIG_TARGET_VERSION}.tar.gz
            URL_MD5 ${SWIG_DOWNLOAD_SRC_MD5}
            PREFIX ${SWIG_SOURCES_DIR}
            CONFIGURE_COMMAND
            env
                "CC=${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1}"
                "CFLAGS=${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}"
                "LDFLAGS=$ENV{LDFLAGS}"
                "LIBS=$ENV{LIBS}"
                "CPPFLAGS=$ENV{CPPFLAGS}"
                "CXX=${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}"
                "CXXFLAGS=${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}"
                "CPP=$ENV{CPP}"
                "YACC=${BISON_EXECUTABLE}"
                "YFLAGS=${BISON_FLAGS}"
            ../swig/configure
                --prefix=${SWIG_INSTALL_DIR}
                --with-pcre-prefix=${SWIG_INSTALL_DIR}/pcre
            DEPENDS pcre
        )

        set(SWIG_DIR ${SWIG_INSTALL_DIR}/share/swig/${SWIG_TARGET_VERSION} CACHE FILEPATH "SWIG Directory" FORCE)
        set(SWIG_EXECUTABLE ${SWIG_INSTALL_DIR}/bin/swig CACHE FILEPATH "SWIG Executable" FORCE)
    ENDIF(WIN32)
#ENDIF()

