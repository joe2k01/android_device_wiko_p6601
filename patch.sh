#!/bin/bash
COMMAND=$(basename $0)
TREE=$(realpath ./../../../)
DEVICE=$(realpath ./)
PATCHES=$DEVICE/patches

PATCH_ARGS='-p1 '
case $1 in
	"-h" | "--help")
		echo "Usage: $COMMAND [--reverse]"
		echo "Applies the patches necessary to build LineageOS for R1 HD."
		echo "When you are done, use --reverse to unapply the patches to keep your tree clean."
		exit 0;
		;;
	"-R" | "--reverse")
		echo "Reversing patches..."
		PATCH_ARGS+='-R'
		;;
	*)
		echo "Applying patches..."
		;;
esac

pushd $TREE/system/core
patch $PATCH_ARGS < $PATCHES/system_core/remove-CAP_SYS_NICE-from-surfaceflinger-and-cln-logger-service.patch
popd

pushd $TREE/bionic
patch $PATCH_ARGS < $PATCHES/bionic/Temporary-apply-LIBC-version-to-__pthread_gettid.patch
popd

pushd $TREE/frameworks/av
patch $PATCH_ARGS < $PATCHES/frameworks_av/mtk-audio-fix.patch
patch $PATCH_ARGS < $PATCHES/frameworks_av/fix-access-wvm-to-ReadOptions.patch
patch $PATCH_ARGS < $PATCHES/frameworks_av/Add-missing-MediaBufferGroup__acquire_buffer_symbols.patch
popd
