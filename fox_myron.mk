#
# OrangeFox Recovery — Xiaomi myron (sm8850_thales)
# Analyzed from recovery.img ramdisk
# SPDX-License-Identifier: GPL-3.0-or-later
#

# ─────────────────────────────────────────────────────────
# Maintainer
# ─────────────────────────────────────────────────────────
OF_MAINTAINER := YourName

# ─────────────────────────────────────────────────────────
# Display — confirmed từ twres/ui.xml: 1080x1920
# ─────────────────────────────────────────────────────────
OF_SCREEN_H := 1920
OF_STATUS_H := 96
OF_HIDE_NOTCH := 0
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_OPTIONS_LIST_NUM := 6

# ─────────────────────────────────────────────────────────
# LED / Flashlight
# ─────────────────────────────────────────────────────────
OF_USE_GREEN_LED := 0

# ─────────────────────────────────────────────────────────
# Partition tools
# ─────────────────────────────────────────────────────────
OF_ENABLE_ALL_PARTITION_TOOLS := 1
OF_DYNAMIC_FULL_SIZE := 9126805504

# ─────────────────────────────────────────────────────────
# A-only device với virtual A/B
# Confirmed: prepdecrypt.sh detect có recovery partition
# ─────────────────────────────────────────────────────────
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 0
# Device có recovery partition riêng — KHÔNG phải recovery-in-boot

# Boot control AIDL (Android 14+)
OF_USE_AIDL_BOOT_CONTROL := 1

# ─────────────────────────────────────────────────────────
# Decryption — FBE với prepdecrypt.sh
# Confirmed: keymint-strongbox, weaver-service, ese_weaver_thales.so
# ─────────────────────────────────────────────────────────
OF_NO_RELOAD_AFTER_DECRYPTION := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_FORCE_DATA_FORMAT_F2FS := 1
OF_UNBIND_SDCARD_F2FS := 1

# ─────────────────────────────────────────────────────────
# Backup
# ─────────────────────────────────────────────────────────
OF_WORKAROUND_BACKUP_BUG := 1

# ─────────────────────────────────────────────────────────
# Compression — confirmed: LZ4 trong ramdisk
# ─────────────────────────────────────────────────────────
OF_USE_LZ4_COMPRESSION := 1
OF_ENABLE_FS_COMPRESSION := 1

# ─────────────────────────────────────────────────────────
# Kernel
# ─────────────────────────────────────────────────────────
OF_FORCE_PREBUILT_KERNEL := 1

# ─────────────────────────────────────────────────────────
# FRP
# ─────────────────────────────────────────────────────────
OF_ENABLE_FRP_ADDON := 1

# ─────────────────────────────────────────────────────────
# Misc
# ─────────────────────────────────────────────────────────
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
OF_USE_AIDL_BOOT_CONTROL := 1
