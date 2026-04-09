#
# This file is part of the OrangeFox Recovery Project
# Copyright (C) 2026 The OrangeFox Recovery Project
# Device: Xiaomi myron (POCO F8 Ultra / Redmi K90 Pro Max)
# Branch: OrangeFox 14.1
# SPDX-License-Identifier: GPL-3.0-or-later
#

# ─── Screen geometry ──────────────────────────────────────────────────────────
# Confirmed: 1200x2608, notch height 111px (variant-script.sh + bootconfig)
# OF_SCREEN_H phải là giá trị có theme bundle trong OFox R12:
# Standard heights: 1280,1600,1920,2160,2340,2400,2560,2688,2720,...
# 2608 KHÔNG có → fallback dark theme. 2560 là gần nhất (dưới 48px).
 OF_SCREEN_H             := 2560
 OF_STATUS_H             := 141
 OF_HIDE_NOTCH           := 1
 OF_STATUS_INDENT_LEFT   := 48
 OF_STATUS_INDENT_RIGHT  := 48

# ─── OrangeFox display ────────────────────────────────────────────────────────
 OF_USE_GREEN_LED        := 0
 OF_OPTIONS_LIST_NUM     := 6

# ─── Partition tools ──────────────────────────────────────────────────────────
 OF_ENABLE_ALL_PARTITION_TOOLS := 1

# ─── Data format ──────────────────────────────────────────────────────────────
# Force F2FS format (userdata is f2fs — confirmed from fstab)
# Wipe /metadata after format — required for wrappedkey_v0 re-keying
 OF_FORCE_DATA_FORMAT_F2FS          := 1
 OF_WIPE_METADATA_AFTER_DATAFORMAT  := 1
 OF_UNBIND_SDCARD_F2FS              := 1

# ─── Decryption ───────────────────────────────────────────────────────────────
# Skip UI reload after decrypt — prevents double-init of keymint chain
 OF_NO_RELOAD_AFTER_DECRYPTION := 1

# ─── Boot control ─────────────────────────────────────────────────────────────
 OF_USE_AIDL_BOOT_CONTROL       := 1
 OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
 OF_FORCE_PREBUILT_KERNEL        := 1

# ─── Compression / backup ─────────────────────────────────────────────────────
 OF_USE_LZ4_COMPRESSION  := 1
 OF_ENABLE_FS_COMPRESSION := 1
 OF_WORKAROUND_BACKUP_BUG := 1

# ─── Misc ─────────────────────────────────────────────────────────────────────
 OF_DYNAMIC_FULL_SIZE            := 14495514624
 OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
 OF_ENABLE_FRP_ADDON             := 1
 OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1

# ─── Maintainer ───────────────────────────────────────────────────────────────
 OF_MAINTAINER := myron-dev
