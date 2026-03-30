#
# OrangeFox Recovery — Xiaomi myron (sm8850_thales)
# Source: working TWRP 3.7.1_16 ramdisk + log analysis
# SPDX-License-Identifier: GPL-3.0-or-later
#

# ─────────────────────────────────────────────────────────
# Maintainer
# ─────────────────────────────────────────────────────────
OF_MAINTAINER := YourName

# ─────────────────────────────────────────────────────────
# Display
# Confirmed: width=1200, height=2608 from TWRP log
# ─────────────────────────────────────────────────────────
OF_SCREEN_H            := 2608
OF_STATUS_H            := 100
OF_HIDE_NOTCH          := 0
OF_STATUS_INDENT_LEFT  := 48
OF_STATUS_INDENT_RIGHT := 48
OF_OPTIONS_LIST_NUM    := 6

# ─────────────────────────────────────────────────────────
# LED
# ─────────────────────────────────────────────────────────
OF_USE_GREEN_LED := 0

# ─────────────────────────────────────────────────────────
# Partition tools
# ─────────────────────────────────────────────────────────
OF_ENABLE_ALL_PARTITION_TOOLS := 1
OF_DYNAMIC_FULL_SIZE          := 11274289152

# ─────────────────────────────────────────────────────────
# A/B with dedicated recovery partition
# Confirmed: /dev/block/bootdevice/by-name/recovery_a exists
# ─────────────────────────────────────────────────────────
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_USE_AIDL_BOOT_CONTROL             := 1

# ─────────────────────────────────────────────────────────
# Decryption — FBE v2 + prepdecrypt.sh
# Confirmed: keymint-strongbox, weaver-service, ese_weaver_thales.so
# ─────────────────────────────────────────────────────────
OF_NO_RELOAD_AFTER_DECRYPTION  := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_FORCE_DATA_FORMAT_F2FS      := 1
OF_UNBIND_SDCARD_F2FS          := 1

# ─────────────────────────────────────────────────────────
# Backup
# ─────────────────────────────────────────────────────────
OF_WORKAROUND_BACKUP_BUG := 1

# ─────────────────────────────────────────────────────────
# Compression — LZ4 confirmed from ramdisk
# ─────────────────────────────────────────────────────────
OF_USE_LZ4_COMPRESSION  := 1
OF_ENABLE_FS_COMPRESSION := 1

# ─────────────────────────────────────────────────────────
# Kernel
# ─────────────────────────────────────────────────────────
OF_FORCE_PREBUILT_KERNEL := 1

# ─────────────────────────────────────────────────────────
# FRP / Misc
# ─────────────────────────────────────────────────────────
OF_ENABLE_FRP_ADDON                      := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK         := 1
OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
