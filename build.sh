#!/bin/bash
set -e

#if ANDROID_NDK not set look in ANDROID_NDK search paths and set it to the highest version

if [ "$ANDROID_NDK" == "" ]; then
    ANDROID_NDK_SEARCH_PATHS=("$HOME/Android/Sdk/ndk" "/srv")
    
    for search_path in "${ANDROID_NDK_SEARCH_PATHS[@]}"; do
        if [ -d "$search_path" ]; then
            highest_version=$(ls "$search_path" | sort | tail -1)
            ANDROID_NDK="$search_path/$highest_version"
            echo "Found NDK at $ANDROID_NDK"
            export ANDROID_NDK 
            break
        fi
    done
fi
if [ "$ANDROID_NDK" == "" ]; then
    echo "Error: ANDROID_NDK not set and not found in search paths."
    exit 1
fi

archs=('android-arm' 'android-arm64' 'android-x86_64' 'android-x86' 'linux')

for arch in "${archs[@]}"; do
    cmake --preset $arch
    cmake --build --preset $arch --verbose
done

(
  cd build/linux
  cmake --build . --target create_archive
)

