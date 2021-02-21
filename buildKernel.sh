#!/bin/bash

# Check if have toolchain folder
if [ ! -d "$(pwd)/toolchain/" ]; then
   git clone https://github.com/a2XX-dev/toolchains.git toolchain -b gcc
fi

# Export KBUILD flags
export KBUILD_BUILD_USER="yukosky"
export KBUILD_BUILD_HOST="a2XX-Team"

# Export ARCH/SUBARCH flags
export ARCH="arm64"
export SUBARCH="arm64"

# Export ANDROID VERSION
export ANDROID_MAJOR_VERSION="q"

# Export CCACHE
export CCACHE="$(which ccache)"

# Export toolchain/cross flags
export TOOLCHAIN="aarch64-linux-android-"
export CROSS_COMPILE="$(pwd)/toolchain/bin/${TOOLCHAIN}"

# Export DTC_EXT
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc"

# Export if/else outdir var
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ -d "$(pwd)/out" ]; then
      rm -rf out
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/out" ]; then
      mkdir out
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O=out $KERNEL_MAKE_ENV KCFLAGS=-mno-android a20s_defconfig
   "${CCACHE}" make -j18 O=out $KERNEL_MAKE_ENV KCFLAGS=-mno-android
fi