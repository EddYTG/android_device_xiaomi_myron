#
# OrangeFox Recovery — Xiaomi myron (POCO F8 Ultra)
# Branch: 14.1 (Android 16)
# Verified from TWRP 3.7.1_16 ramdisk
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

OF_MAINTAINER := YourName

# Display — 1200x2608, y_offset/h_offset from variant-script.sh
OF_SCREEN_H            := 2608
OF_STATUS_H            := 100
OF_HIDE_NOTCH          := 0
OF_STATUS_INDENT_LEFT  := 48
OF_STATUS_INDENT_RIGHT := 48
OF_OPTIONS_LIST_NUM    := 6

OF_USE_GREEN_LED := 0

# Partitions
OF_ENABLE_ALL_PARTITION_TOOLS := 1
# Confirmed from fastboot: super = 0x360000000 = 14495514624
OF_DYNAMIC_FULL_SIZE := 14495514624

# A/B with dedicated recovery partition
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_USE_AIDL_BOOT_CONTROL             := 1

# AVB unsigned
OF_PATCH_AVB20 := 1

# Decryption — FBE v2, Thales Keymint Strongbox + Weaver
OF_NO_RELOAD_AFTER_DECRYPTION     := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_FORCE_DATA_FORMAT_F2FS         := 1
OF_UNBIND_SDCARD_F2FS             := 1
OF_WORKAROUND_BACKUP_BUG          := 1

# LZ4 confirmed from ramdisk
OF_USE_LZ4_COMPRESSION   := 1
OF_ENABLE_FS_COMPRESSION := 1

OF_FORCE_PREBUILT_KERNEL := 1

OF_ENABLE_FRP_ADDON              := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1

# Virtual A/B — export trong workflow: export FOX_VIRTUAL_AB_DEVICE=1
# OF_VIRTUAL_AB_DEVICE đã bị xóa trong OFox 12.1+
