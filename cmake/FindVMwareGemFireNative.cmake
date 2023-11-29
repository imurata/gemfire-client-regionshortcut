# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#.rst:
# FindVMwareGemFireNative
# ---------
#
# Find the VMware GemFire Native headers and library.
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``VMwareGemFireNative::cpp``
# ``VMwareGemFireNative::dotnet``
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project:
#
# ``VMwareGemFireNative_FOUND``
#   true if the VMware GemFire Native headers and libraries were found.
#
# ``VMwareGemFireNative_DOTNET_LIBRARY``
#   Path to .NET assembly file.
#

set(_VMwareGemFireNative_ROOT "")
if(VMwareGemFireNative_ROOT AND IS_DIRECTORY "${VMwareGemFireNative_ROOT}")
    set(_VMwareGemFireNative_ROOT "${VMwareGemFireNative_ROOT}")
    set(_VMwareGemFireNative_ROOT_EXPLICIT 1)
else()
    set(_ENV_VMwareGemFireNative_ROOT "")
    if(DEFINED ENV{GEODE_NATIVE_HOME})
        file(TO_CMAKE_PATH "$ENV{GEODE_NATIVE_HOME}" _ENV_VMwareGemFireNative_ROOT)
    endif()
    if(_ENV_VMwareGemFireNative_ROOT AND IS_DIRECTORY "${_ENV_VMwareGemFireNative_ROOT}")
        set(_VMwareGemFireNative_ROOT "${_ENV_VMwareGemFireNative_ROOT}")
        set(_VMwareGemFireNative_ROOT_EXPLICIT 0)
    endif()
    unset(_ENV_VMwareGemFireNative_ROOT)
endif()

set(_VMwareGemFireNative_HINTS)
set(_VMwareGemFireNative_PATHS)

if(_VMwareGemFireNative_ROOT)
    set(_VMwareGemFireNative_HINTS ${_VMwareGemFireNative_ROOT})
else()
    set(_VMwareGemFireNative_PATHS (
        "/opt/local"
        "/usr/local"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../../"
        "C:/program files" ))
endif()

# Begin - component "cpp"
set(_VMwareGemFireNative_CPP_NAMES vmware-gemfire)


find_library(VMwareGemFireNative_CPP_LIBRARY
    NAMES ${_VMwareGemFireNative_CPP_NAMES}
    HINTS ${_VMwareGemFireNative_HINTS}
    PATHS ${_VMwareGemFireNative_PATHS}
    PATH_SUFFIXES vmware-gemfire/lib lib
)

# Look for the header file.
find_path(VMwareGemFireNative_CPP_INCLUDE_DIR NAMES geode/CacheFactory.hpp
    HINTS ${_VMwareGemFireNative_HINTS}
    PATHS ${_VMwareGemFireNative_PATHS}
    PATH_SUFFIXES vmware-gemfire/include include
)
# End - component "cpp"


# Begin - component "dotnet"
set(_VMwareGemFireNative_DOTNET_NAMES VMware.GemFire.dll)

find_file(VMwareGemFireNative_DOTNET_LIBRARY
  NAMES ${_VMwareGemFireNative_DOTNET_NAMES}
  HINTS ${_VMwareGemFireNative_HINTS}
  PATHS ${_VMwareGemFireNative_PATHS}
  PATH_SUFFIXES vmware-gemfire/bin bin
)
# End - component "dotnet"


# TODO find version
set(VMwareGemFireNative_VERSION_STRING 1.0)

if (VMwareGemFireNative_FIND_COMPONENTS)
  set(_VMwareGemFireNative_REQUIRED_VARS)
  foreach (component ${VMwareGemFireNative_FIND_COMPONENTS})
    if (component STREQUAL "cpp")
      list(APPEND _VMwareGemFireNative_REQUIRED_VARS VMwareGemFireNative_CPP_LIBRARY VMwareGemFireNative_CPP_INCLUDE_DIR)
    endif()
    if (component STREQUAL "dotnet")
      list(APPEND _VMwareGemFireNative_REQUIRED_VARS VMwareGemFireNative_DOTNET_LIBRARY)
    endif()
  endforeach()
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(VMwareGemFireNative
                                  REQUIRED_VARS ${_VMwareGemFireNative_REQUIRED_VARS}
                                  VERSION_VAR VMwareGemFireNative_VERSION_STRING)

# Copy the results to the output variables and target.
if(VMwareGemFireNative_FOUND)
  if(NOT TARGET ${VMwareGemFireNative_CPP_TARGET})
    set(VMwareGemFireNative_CPP_TARGET "VMwareGemFireNative::cpp")
    add_library(${VMwareGemFireNative_CPP_TARGET} UNKNOWN IMPORTED)
    set_target_properties(${VMwareGemFireNative_CPP_TARGET} PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
      IMPORTED_LOCATION "${VMwareGemFireNative_CPP_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${VMwareGemFireNative_CPP_INCLUDE_DIR}")
  endif()
  set(VMwareGemFireNative_DOTNET_TARGET "VMwareGemFireNative::dotnet")
  if(NOT TARGET ${VMwareGemFireNative_DOTNET_TARGET})
    add_library(${VMwareGemFireNative_DOTNET_TARGET} UNKNOWN IMPORTED)
    set_target_properties(${VMwareGemFireNative_DOTNET_TARGET} PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES "CSharp"
      IMPORTED_LOCATION "${VMwareGemFireNative_DOTNET_LIBRARY}")
  endif()
else()
  message(STATUS "FOUND var not set")
endif()

mark_as_advanced(VMwareGemFireNative_CPP_INCLUDE_DIR VMwareGemFireNative_CPP_LIBRARY VMwareGemFireNative_DOTNET_LIBRARY)
