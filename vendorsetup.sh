#!/bin/bash
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# SoC   : Snapdragon 8 Elite Gen 5 (SM8850 / sun)
# Branch: OrangeFox 14.1 (Android 16 / SDK 36)
#

export LC_ALL="C"

# ─── A/B with dedicated recovery partition ───────────────────────────────────
export FOX_AB_DEVICE=1
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
export FOX_VIRTUAL_AB_DEVICE=1

# ─── Compression / binaries ──────────────────────────────────────────────────
export OF_USE_LZ4_COMPRESSION=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_LZ4_BINARY=1
export FOX_USE_ZSTD_BINARY=1
export FOX_USE_DATE_BINARY=1
export FOX_USE_GREP_BINARY=1
export FOX_USE_BUSYBOX_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_FSCK_EROFS_BINARY=1
export FOX_USE_PATCHELF_BINARY=1
export FOX_USE_UPDATED_MAGISKBOOT=1
export FOX_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1

# ─── Compatibility & quirks ───────────────────────────────────────────────────
export OF_TWRP_COMPATIBILITY_MODE=1
export OF_NO_RELOAD_AFTER_DECRYPTION=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export FOX_DELETE_AROMAFM=1
export OF_NO_MIUI_PATCH_WARNING=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
export OF_USE_GREEN_LED=0
export FOX_VANILLA_BUILD=1

# ─── Partition tools ─────────────────────────────────────────────────────────
export OF_ENABLE_LPTOOLS=1
export OF_ENABLE_ALL_PARTITION_TOOLS=1
# super = 0x360000000 = 14495514624 (confirmed from fastboot getvar all)
export OF_DYNAMIC_FULL_SIZE=14495514624
export OF_ENABLE_FS_COMPRESSION=1
export OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO=1
export OF_FORCE_DATA_FORMAT_F2FS=1
export OF_WIPE_METADATA_AFTER_DATAFORMAT=1
export OF_UNBIND_SDCARD_F2FS=1

# ─── Kernel ───────────────────────────────────────────────────────────────────
export OF_FORCE_PREBUILT_KERNEL=1

# ─── Settings ────────────────────────────────────────────────────────────────
export FOX_SETTINGS_ROOT_DIRECTORY=/persist
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1

# ─── Boot control / USB ──────────────────────────────────────────────────────
export OF_USE_AIDL_BOOT_CONTROL=1
export OF_USE_DMCTL=1

# ─── KernelSU support ────────────────────────────────────────────────────────
export FOX_ENABLE_KERNELSU_SUPPORT=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1

# ─── Display — 1200x2608, notch offset confirmed from variant-script.sh ──────
export OF_SCREEN_H=2608
export OF_STATUS_H=111
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=0
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_OPTIONS_LIST_NUM=6

# ─── Maintainer / variant ────────────────────────────────────────────────────
export FOX_VARIANT="Xiaomi_myron_POCO_F8_Ultra"
export FOX_MAINTAINER_PATCH_VERSION=$(date +%y%m%d)
export OF_MAINTAINER="YourName"

# ─── Magisk ───────────────────────────────────────────────────────────────────
export OF_MAGISK="/tmp/misc/Magisk-v29.0.zip"
export FOX_USE_SPECIFIC_MAGISK_ZIP=/tmp/misc/Magisk-v29.0.zip

if [ -f "$OF_MAGISK" ]; then
    echo "-- Magisk zip found at $OF_MAGISK"
else
    echo "-- Magisk zip not found, downloading..."
    mkdir -p /tmp/misc
    wget -O /tmp/misc/Magisk-v29.0.zip https://github.com/topjohnwu/Magisk/releases/download/v29.0/Magisk-v29.0.apk && \
        echo "-- Magisk downloaded OK" || echo "-- Magisk download FAILED (non-fatal)"
fi

# ─── Splash: set black background ────────────────────────────────────────────
F=$(find "device" -maxdepth 2 -name "myron" 2>/dev/null)
if [ -n "$F" ] && [ -f "$F/recovery/root/twres/splash.xml" ]; then
    sed -i 's/value="#D34E38"/value="#000000"/g' "$F/recovery/root/twres/splash.xml"
    sed -i 's/value="#FF8038"/value="#000000"/g' "$F/recovery/root/twres/splash.xml"
fi
