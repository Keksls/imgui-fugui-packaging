#!/usr/bin/env bash

set -e

scriptPath="$(cd "$(dirname "$0")" && pwd)"
cimguiPath="$scriptPath/cimgui"

_CMakeBuildType=Debug
_CMakeOsxArchitectures=
_CMakeSystemName=
_CMakeOsxSysroot=
_CMakeDeploymentTarget=
_CMakeAndroidNdk=
_CMakeAndroidAbi=
_CMakeAndroidApi=
_BuildSubdir=
__UnprocessedBuildArgs=

while :; do
    if [ $# -le 0 ]; then
        break
    fi

    lowerI="$(echo "$1" | awk '{print tolower($0)}')"
    case $lowerI in
        debug|-debug)
            _CMakeBuildType=Debug
            ;;
        release|-release)
            _CMakeBuildType=Release
            ;;
        -osx-architectures)
            _CMakeOsxArchitectures=$2
            shift
            ;;
        -ios)
            _CMakeSystemName=iOS
            ;;
        -ios-platform)
            _CMakeOsxSysroot=$2
            shift
            ;;
        -ios-deployment-target)
            _CMakeDeploymentTarget=$2
            shift
            ;;
        -android)
            _CMakeSystemName=Android
            ;;
        -android-ndk)
            _CMakeAndroidNdk=$2
            shift
            ;;
        -android-abi)
            _CMakeAndroidAbi=$2
            shift
            ;;
        -android-api)
            _CMakeAndroidApi=$2
            shift
            ;;
        -build-subdir)
            _BuildSubdir=$2
            shift
            ;;
        *)
            __UnprocessedBuildArgs="$__UnprocessedBuildArgs $1"
            ;;
    esac

    shift
done

if [ -n "$_BuildSubdir" ]; then
    buildDir="$cimguiPath/build/$_BuildSubdir/$_CMakeBuildType"
else
    buildDir="$cimguiPath/build/$_CMakeBuildType"
fi

mkdir -p "$buildDir"
pushd "$buildDir"

CMAKE_ARGS=("$cimguiPath")
CMAKE_ARGS+=("-DCMAKE_BUILD_TYPE=$_CMakeBuildType")

if [ -n "$_CMakeOsxArchitectures" ]; then
    CMAKE_ARGS+=("-DCMAKE_OSX_ARCHITECTURES=$_CMakeOsxArchitectures")
fi

if [ -n "$_CMakeSystemName" ]; then
    CMAKE_ARGS+=("-DCMAKE_SYSTEM_NAME=$_CMakeSystemName")
fi

if [ -n "$_CMakeOsxSysroot" ]; then
    CMAKE_ARGS+=("-DCMAKE_OSX_SYSROOT=$_CMakeOsxSysroot")
fi

if [ -n "$_CMakeDeploymentTarget" ]; then
    CMAKE_ARGS+=("-DCMAKE_OSX_DEPLOYMENT_TARGET=$_CMakeDeploymentTarget")
elif [[ "$_CMakeSystemName" == "iOS" ]]; then
    CMAKE_ARGS+=("-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0")
elif [[ "$_CMakeSystemName" != "Android" ]]; then
    CMAKE_ARGS+=("-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13")
fi

if [[ "$_CMakeSystemName" == "Android" ]]; then
    CMAKE_ARGS+=("-DCMAKE_ANDROID_NDK=$_CMakeAndroidNdk")
    CMAKE_ARGS+=("-DCMAKE_ANDROID_ARCH_ABI=$_CMakeAndroidAbi")
    CMAKE_ARGS+=("-DCMAKE_ANDROID_API=$_CMakeAndroidApi")
fi

if [ -n "$__UnprocessedBuildArgs" ]; then
    # shellcheck disable=SC2206
    EXTRA_ARGS=( $__UnprocessedBuildArgs )
    CMAKE_ARGS+=("${EXTRA_ARGS[@]}")
fi

cmake "${CMAKE_ARGS[@]}"
cmake --build . --config "$_CMakeBuildType"

popd