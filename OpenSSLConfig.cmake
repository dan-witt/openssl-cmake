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
	set(OPENSSL_ARCH ${CMAKE_SYSTEM_PROCESSOR})
endif()

# Set the include and library paths.
set(OPENSSL_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(OPENSSL_LIBRARIES "${CMAKE_CURRENT_LIST_DIR}/lib/${OPENSSL_ARCH}/libssl.a")
set(OPENSSL_CRYPTO_LIBRARIES "${CMAKE_CURRENT_LIST_DIR}/lib/${OPENSSL_ARCH}/libcrypto.a")

# Define an IMPORTED library target.
add_library(OpenSSL::SSL  STATIC IMPORTED)
set_target_properties(OpenSSL::SSL  PROPERTIES IMPORTED_LOCATION "${OPENSSL_LIBRARIES}")
target_include_directories(OpenSSL::SSL  INTERFACE ${OPENSSL_INCLUDE_DIRS})

add_library(OpenSSL::Crypto STATIC IMPORTED)
set_target_properties(OpenSSL::Crypto PROPERTIES IMPORTED_LOCATION "${OPENSSL_CRYPTO_LIBRARIES}")
target_include_directories(iOpenSSL::Crypto INTERFACE ${OPENSSL_INCLUDE_DIRS})


