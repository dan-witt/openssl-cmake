# FindOpenSSL.cmake
# Locate built version of OpenSSL based on provided OpenSSLConfig.cmake.

# Use the user-specified hint if provided
if(OPENSSL_DIR)
    list(APPEND CMAKE_PREFIX_PATH "${OPENSSL_DIR}")
endif()

# Check if OpenSSLConfig.cmake is present in the provided path
find_package(OpenSSL CONFIG)

if(NOT OpenSSL_FOUND)
    message(FATAL_ERROR "Could not find built version of OpenSSL. Please set OPENSSL_DIR or provide OpenSSLConfig.cmake.")
else()
	set( OpenSSL_DIR ${CMAKE_CURRENT_LIST_DIR} PARENT_SCOPE)
    # If found, the imported targets OpenSSL::SSL and OpenSSL::Crypto would be available for use.
endif()

