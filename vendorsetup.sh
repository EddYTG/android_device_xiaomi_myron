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

export LC_ALL="C"

# ─── A/B with dedicated recovery partition ────────────────────────────────────
export FOX_AB_DEVICE=1
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
export FOX_VIRTUAL_AB_DEVICE=1

# ─── API prebuilts ────────────────────────────────────────────────────────────
export FOX_ADD_API_V34_PREBUILTS=1

# ─── dmctl ────────────────────────────────────────────────────────────────────
export OF_USE_DMCTL=1

# ─── Boot control ─────────────────────────────────────────────────────────────
export OF_USE_AIDL_BOOT_CONTROL=1

# ─── Compression / binaries ───────────────────────────────────────────────────
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

# ─── Partition tools ──────────────────────────────────────────────────────────
export OF_DYNAMIC_FULL_SIZE=14495514624
export OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO=1
export OF_FORCE_DATA_FORMAT_F2FS=1
export OF_WIPE_METADATA_AFTER_DATAFORMAT=1
export OF_WORKAROUND_BACKUP_BUG=1

# ─── Kernel ───────────────────────────────────────────────────────────────────
export OF_FORCE_PREBUILT_KERNEL=1

# ─── Settings ─────────────────────────────────────────────────────────────────
export FOX_SETTINGS_ROOT_DIRECTORY=/persist
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1

# ─── KernelSU support ─────────────────────────────────────────────────────────
export FOX_ENABLE_KERNELSU_SUPPORT=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1

# ─── Display ──────────────────────────────────────────────────────────────────
# Resolution: 1200x2340 (confirmed), status bar height: 141
export OF_SCREEN_H=2340
export OF_STATUS_H=141
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=0
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_OPTIONS_LIST_NUM=6

# ─── OrangeFox Theme / Accent Color ──────────────────────────────────────────
# FIX: Đặt về màu cam OrangeFox gốc. Không set → source fox_14.1 mặc định tím.
export FOX_USE_DEFAULT_THEME=1

# ─── Maintainer / variant ─────────────────────────────────────────────────────
export FOX_BUILD_DEVICE="myron"
export FOX_VARIANT="Xiaomi_myron_POCO_F8_Ultra"
export FOX_MAINTAINER_PATCH_VERSION=$(date +%y%m%d)
export OF_MAINTAINER="Antuna"

# ─── Magisk ───────────────────────────────────────────────────────────────────
export OF_MAGISK="/tmp/misc/Magisk.zip"
export FOX_USE_SPECIFIC_MAGISK_ZIP="/tmp/misc/Magisk.zip"
