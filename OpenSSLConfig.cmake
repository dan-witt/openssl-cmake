# OpenSSLConfig.cmake
# Configuration file for the OpenSSL library, providing paths for includes and pre-built binaries.

cmake_minimum_required(VERSION 3.22)

# Determine the architecture, especially for Android builds.
if(DEFINED ANDROID_ABI)
  if(ANDROID_ABI STREQUAL "x86")
	  set(OPENSSL_ARCH "android-x86")
  elseif(ANDROID_ABI STREQUAL "x86_64")
	  set(OPENSSL_ARCH "android-x86_64")
  else()
	  set(OPENSSL_ARCH ${ANDROID_ABI})
  endif()
else()
    execute_process(
      COMMAND ${CMAKE_C_COMPILER} -dumpmachine
      OUTPUT_VARIABLE OPENSSL_ARCH
      OUTPUT_STRIP_TRAILING_WHITESPACE
      RESULT_VARIABLE RESULT
    )
    if(RESULT)
      message(FATAL_ERROR "Failed to determine the target triplet using -dumpmachine!")
    endif()      
endif()

# Set the include and library paths.
set(OPENSSL_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(OPENSSL_SSL_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/lib/${OPENSSL_ARCH}/libssl.a")
set(OPENSSL_CRYPTO_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/lib/${OPENSSL_ARCH}/libcrypto.a")

# Define an IMPORTED library target.
add_library(OpenSSL::SSL  STATIC IMPORTED)
set_target_properties(OpenSSL::SSL  PROPERTIES IMPORTED_LOCATION "${OPENSSL_SSL_LIBRARY}")
target_include_directories(OpenSSL::SSL  INTERFACE ${OPENSSL_INCLUDE_DIRS})
if(DEFINED ANDROID_ABI)
    message(STATUS "linking against android libraries")
    set_property(TARGET OpenSSL::SSL APPEND_STRING PROPERTY INTERFACE_LINK_LIBRARIES log android c)
endif()

add_library(OpenSSL::Crypto STATIC IMPORTED)
set_target_properties(OpenSSL::Crypto PROPERTIES IMPORTED_LOCATION "${OPENSSL_CRYPTO_LIBRARY}")
target_include_directories(OpenSSL::Crypto INTERFACE ${OPENSSL_INCLUDE_DIRS})
if(DEFINED ANDROID_ABI)
    set_property(TARGET OpenSSL::Crypto APPEND_STRING PROPERTY INTERFACE_LINK_LIBRARIES log android c)
endif()

set(OpenSSL_FOUND TRUE)
