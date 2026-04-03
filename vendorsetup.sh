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
# Branch: OrangeFox 14.1
#
# All values confirmed from:
#   fastboot getvar all, adb shell getprop, /proc/bootconfig
#   adb shell /odm vintf manifests
#

export LC_ALL="C"

# ─── A/B with dedicated recovery partition ────────────────────────────────────
# Confirmed: has-slot:recovery=yes, partition-size:recovery_a=0x6400000 (fastboot)
# Confirmed: is-logical:recovery_a=no → raw dedicated partition, NOT in super
export FOX_AB_DEVICE=1
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
export FOX_VIRTUAL_AB_DEVICE=1

# ─── API prebuilts ────────────────────────────────────────────────────────────
# fox_14.1 base SDK = 34; first_api_level=35 (device shipped with SDK 35, but OFox builds at SDK 34)
# fox_14.1 supports SDK 35 prebuilts
# SDK 34 prebuilts (fox_14.1 base)
export FOX_ADD_API_V34_PREBUILTS=1

# ─── dmsetup (required for virtual A/B + dynamic partitions) ─────────────────
export FOX_USE_DMSETUP=1

# ─── Compression / binaries ──────────────────────────────────────────────────
# OF_USE_LZ4_COMPRESSION matches BOARD_RAMDISK_USE_LZ4 := true (BoardConfig)
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
# FOX_VANILLA_BUILD=1 intentionally removed — enables full OFox feature set

# ─── Partition tools ─────────────────────────────────────────────────────────
# NOTE: TW_INCLUDE_LPTOOLS, TW_ENABLE_ALL_PARTITION_TOOLS, TW_ENABLE_FS_COMPRESSION
# declared in BoardConfig.mk — NOT redeclared here to avoid conflict
# OF_DYNAMIC_FULL_SIZE = BOARD_SUPER_PARTITION_SIZE = 0x360000000 (fastboot confirmed)
export OF_DYNAMIC_FULL_SIZE=14495514624
export OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO=1
# Confirmed: BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE=f2fs (BoardConfig + getprop)
export OF_FORCE_DATA_FORMAT_F2FS=1
export OF_WIPE_METADATA_AFTER_DATAFORMAT=1
# OF_UNBIND_SDCARD_F2FS removed — conflicts with RECOVERY_SDCARD_ON_DATA=true
export OF_WORKAROUND_BACKUP_BUG=1

# ─── Kernel ───────────────────────────────────────────────────────────────────
export OF_FORCE_PREBUILT_KERNEL=1

# ─── Settings ────────────────────────────────────────────────────────────────
# /persist confirmed: partition-size:persist=0x2E00000 (fastboot)
export FOX_SETTINGS_ROOT_DIRECTORY=/persist
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1

# ─── Boot control / USB ──────────────────────────────────────────────────────
# Confirmed: AIDL boot control (kernel 6.12, Android 16)
export OF_USE_AIDL_BOOT_CONTROL=1
export OF_USE_DMCTL=1

# ─── KernelSU support ────────────────────────────────────────────────────────
export FOX_ENABLE_KERNELSU_SUPPORT=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1

# ─── Display ─────────────────────────────────────────────────────────────────
# Confirmed: 1200x2608 (variant-script.sh), y_offset=111 (bootconfig/BoardConfig)
# OF_STATUS_INDENT: 48px indent for notch on 1200px-wide screen
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
export OF_MAINTAINER="hackpupg001-a11y"

# ─── Magisk ───────────────────────────────────────────────────────────────────
# Download Magisk APK (rename to .zip — OFox expects zip format)
MAGISK_VERSION="v29.0"
MAGISK_PATH="/tmp/misc/Magisk-${MAGISK_VERSION}.zip"
export OF_MAGISK="$MAGISK_PATH"
export FOX_USE_SPECIFIC_MAGISK_ZIP="$MAGISK_PATH"

if [ -f "$MAGISK_PATH" ]; then
    echo "-- Magisk zip found at $MAGISK_PATH"
else
    echo "-- Magisk zip not found, downloading..."
    mkdir -p /tmp/misc
    wget -q --show-progress \
        -O "$MAGISK_PATH" \
        "https://github.com/topjohnwu/Magisk/releases/download/${MAGISK_VERSION}/Magisk-${MAGISK_VERSION}.apk" \
    && echo "-- Magisk downloaded OK" \
    || echo "-- Magisk download FAILED (non-fatal, OFox will skip Magisk embed)"
fi

# ─── Splash: set black background ────────────────────────────────────────────
F=$(find "device" -maxdepth 2 -name "myron" 2>/dev/null)
if [ -n "$F" ] && [ -f "$F/recovery/root/twres/splash.xml" ]; then
    sed -i 's/value="#D34E38"/value="#000000"/g' "$F/recovery/root/twres/splash.xml"
    sed -i 's/value="#FF8038"/value="#000000"/g' "$F/recovery/root/twres/splash.xml"
fi
